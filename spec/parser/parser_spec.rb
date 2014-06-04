require_relative "../../lib/parser/parser"
require_relative "../../lib/lexer/token_type"

describe Parser do
  context ".match" do
    before do
      lookahead = double(:type => TokenType::ARROW)
      @lexer = double(:lookahead_token => lookahead).as_null_object
    end

    it "raises DotSyntaxException when does not match expected token" do
      expect do
        parser = Parser.new(@lexer)
        parser.match(TokenType::ID)
      end.to raise_error(DotSyntaxException)
    end

    it "advances the token when matches the expected token" do
      parser = Parser.new(@lexer)
      @lexer.should_receive(:advance_token)
      parser.match(TokenType::ARROW)
    end
  end

  context ".parse_attr_list" do
    context "single list within attr list" do
      it "matches based on attr_list grammer rule" do
        a_list = "[weight=8]"
        lexer = Lexer.new(a_list)
        parse_attr_list(lexer)
        there_should_be_no_more_token(lexer)
      end

      it "raises SyntaxException when missing right bracket" do
        a_list = "[shape=box"
        lexer = Lexer.new(a_list)
        expect do
          parse_attr_list(lexer)
        end.to raise_error(DotSyntaxException)
      end
    end

    context "multiple a_list within attr list" do
      it "matches based on attr_list grammer rule" do
        attr_list = %Q{[style=bold,label="100 times"]}
        lexer = Lexer.new(attr_list)
        parse_attr_list(lexer)
        there_should_be_no_more_token(lexer)
      end

      it "raises SyntaxException when missing value in a_list" do
        attr_list = %Q{[style=bold,label=]}
        lexer = Lexer.new(attr_list)
        expect do
          parse_attr_list(lexer)
        end.to raise_error
      end
    end

    def parse_attr_list(lexer)
      Parser.new(lexer).parse_attr_list
    end
  end
  
  context ".parse_node_statement" do
    it "parses node_statement grammer rule - including attr_list" do
      node_statement = "parse [weight=8];"
      lexer = Lexer.new(node_statement)
      parse_node_statement(lexer)
      there_should_be_no_more_token(lexer)
    end

    it "parses node_statement grammer rule - NOT including attr_list" do
      node_statement = "execute;"
      lexer = Lexer.new(node_statement)
      parse_node_statement(lexer)
      there_should_be_no_more_token(lexer)
    end

    it "raises SyntaxException when missing node_id" do
      node_statement = "[style=bold];"
      lexer = Lexer.new(node_statement)
      expect do
        parse_node_statement(lexer)
      end.to raise_error(DotSyntaxException)
    end

    def parse_node_statement(lexer)
      Parser.new(lexer).parse_node_statement
    end
  end

  context ".parse_edgeRHS" do
    it "looks for edge operator and a node id based on grammer" do
      edgeRHS = "-> cleanup"
      lexer = Lexer.new(edgeRHS)
      parse_edgeRHS(lexer)
      there_should_be_no_more_token(lexer)
    end

    it "raises SyntaxException when missing edgeRHS operator" do
      edgeRHS = "cleanup"
      lexer = Lexer.new(edgeRHS)
      expect do
        parse_edgeRHS(lexer)
      end.to raise_error(DotSyntaxException)
    end

    def parse_edgeRHS(lexer)
      Parser.new(lexer).parse_edgeRHS
    end
  end

  context ".parse_edge_statement" do
    it "parses the edge statement grammer rule" do
      edge_statement = %Q{main -> printf [style=bold,label="100 times"];}
      lexer = Lexer.new(edge_statement)
      parse_edge_statement(lexer)
      there_should_be_no_more_token(lexer)
    end

    it "raises SyntaxException when missing a value in edge statement" do
      edge_statement = %Q{main -> printf [style=,label="100 times"];}
      lexer = Lexer.new(edge_statement)
      expect do
        parse_edge_statement(lexer)
      end.to raise_error(DotSyntaxException)
    end

    def parse_edge_statement(lexer)
      Parser.new(lexer).parse_edge_statement
    end
  end

  context ".parse_attr_statement" do
    it "starts with 'node' keyword and ends with attr_list" do
      attr_statement = "node [shape=box];"
      lexer = Lexer.new(attr_statement)
      parse_attr_statement(lexer)
      lexer.lookahead_token.should be_nil
    end

    it "raises SyntaxException when missing 'node' keyword" do
      attr_statement = "[shape=box];"
      lexer = Lexer.new(attr_statement)
      expect do
        parse_attr_statement(lexer)
      end.to raise_error(DotSyntaxException)
    end

    def parse_attr_statement(lexer)
      Parser.new(lexer).parse_attr_statement
    end
  end

  context ".parse_statement_list" do
    it "parses statement list - including edge statement" do
      statement_list = "digraph G { main -> execute; }"
      lexer = Lexer.new(statement_list)
      parse_statement_list(lexer)
      lexer.lookahead_token.should be_nil
    end

    it "parses statement list - including node statement" do
      statement_list = "digraph G { main [shape=box]; }"
      lexer = Lexer.new(statement_list)
      parse_statement_list(lexer)
      lexer.lookahead_token.should be_nil
    end

    def parse_statement_list(lexer)
      Parser.new(lexer).parse_statement_list
    end
  end

  def there_should_be_no_more_token(lexer)
    lexer.lookahead_token.should be_nil
  end
end

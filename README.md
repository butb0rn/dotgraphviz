dotgraphviz
===========

Write a lexer for dot. dot is a part of the graphviz graph visualization software suite.
It is designed to support directed graphs. It is a fairly sophisticated DSL, but we will consider only a subpart of it. 
You can find full information at www.graphviz.org. In particular, check out the dot documentation and the grammar.
    digraph G {
        main [shape=box]; /* this is a comment */
        main -> parse [weight=8];
        parse -> execute;
        main -> init [style=dotted];
        main -> cleanup;
        execute -> make_string;
        init -> make_string;
        main -> printf [style=bold,label="100 times"];
        make_string [label="make a\nstring"];
        node [shape=box,style=filled,color=".7 .3 1.0"];
        execute -> compare;
     }
     
a parser for dot. You can find the grammar at http://www.graphviz.org/content/dot-language.

As input, your parser should accept the input. At this point in time, your parser should simply indicate if there 
is a syntax error or not.
It also creates  an abstract syntax tree for the given input.

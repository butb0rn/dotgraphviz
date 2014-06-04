class AST

  def initialize(token)
    @token = token
    @children = []
  end

  def add_child(t)
    @children.append(t)
  end

  def showChild
    return print(@token)
  end

  def to_string_tree
    if @children.length == 0
      return showChild
    end
    buf = "(%s " % print(@token)
    for i in Range.new(0,@children.length)
      t = @children[i]
      if i > 0
        buf += " "
        buf += t.to_string_tree()
      end
    end
    buf += ")"
    return buf
  end

end

class AST

  def initialize(token)
    @token = token
    @children = []
  end

  def add_child(child)
    @children << child
  end

  def toShow(token)
    return token.to_s
  end


  def to_string_tree
    if @children.length == 0
      return toShow(@token)
    end
    buf = "(%s " % toShow(@token)
    for i in Range.new(0,@children.length - 1)
      child = @children[i]
      if i > 0
        buf += " "
      end
      buf += child.to_string_tree()
    end
    buf += ")"
    return buf
  end

end

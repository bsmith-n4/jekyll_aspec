module Context
  def self.form(attributes, target, url, label)
    block = false
    block = true if attributes.key? "block"

    if target[0] == "\:"
      block = true
      target[0] = ""
    end

    if block
      html = "<div style=\"float:right;padding-left:0.1em;\"><a href=\"#{url}\"><span class=\"label label-#{label}\">#{target}</span></a></div>"
    else
      html = "<a href=\"#{url}\"><span class=\"label label-#{label}\">#{target}</span></a>"
    end
    return html
  end
end

# Helper methods handling whether to output inline content or a block.
# Will read the attributes of the current macro and output a HTML string that is either
# inline or a block (float-right).
module Context
  # @param attributes [Array] attributes passed by the inline macro
  # @param target [String] the target text
  # @param url [String] the target url
  # @param label [String] an optional status label, used to display if a task/issue is open or closed
  # @return [String] the raw HTML to be included in the target document 
  def self.format(attributes, target, url, label)
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

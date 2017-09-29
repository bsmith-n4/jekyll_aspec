require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'
require_relative 'utils/labels'
require_relative 'utils/block'

include ::Asciidoctor

# @example Basic Usage
#   See task:101[] for details
# @example Block Use
#   Already completed. task::101[]
Extensions.register do
  inline_macro do
    named :task

    process do |parent, target, attrs|
      pattern = parent.document.attr 'task-pattern'
      if pattern.nil?
        warn "asciidoctor: WARNING: Attribue 'task-pattern' for inline task macro not defined"
        pattern = 'unknown'
      end
      url = pattern % target

      label = Labels.getstatus(attrs)
      html = Context.format(attrs, target, url, label)
      (create_pass_block parent, html, attrs).render
    end
  end
end

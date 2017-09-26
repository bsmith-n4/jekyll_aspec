require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'
require_relative 'utils/labels'
require_relative 'utils/block'

include ::Asciidoctor

# @example Basic Usage
#   See cwiki:topic[] for details
# @example Block Use
#   Already documented. cwiki::topic[]
Extensions.register do
  inline_macro do
    named :cwiki

    process do |parent, target, attrs|
      pattern = parent.document.attr 'cwiki-pattern'
      url = pattern % target

      label = Labels.getstatus(attrs)
      html = Context.format(attrs, target, url, label)
      (create_pass_block parent, html, attrs).render
    end
  end
end

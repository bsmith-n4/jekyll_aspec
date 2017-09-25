require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'
require_relative 'utils/labels'
require_relative 'utils/block'

include ::Asciidoctor

Extensions.register do
  inline_macro do
    named :cwiki

    process do |parent, target, attrs|
      pattern =
        (parent.document.attr 'cwiki-pattern') ||
        'https://confluence.numberfour.eu/display/%s'
      url = pattern % target

      label = Labels.getstatus(attrs)
      html = Context.form(attrs, target, url, label)
      (create_pass_block parent, html, attrs).render
    end
  end
end

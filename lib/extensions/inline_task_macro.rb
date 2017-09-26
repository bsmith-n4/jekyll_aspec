require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'
require_relative 'utils/labels'
require_relative 'utils/block'

include ::Asciidoctor

Extensions.register do
  inline_macro do
    named :task

    process do |parent, target, attrs|
      pattern = parent.document.attr 'task-pattern'
      url = pattern % target
      
      # TODO add some smart handling of multiple target repos
      
      label = Labels.getstatus(attrs)
      html = Context.form(attrs, target, url, label)
      (create_pass_block parent, html, attrs).render
    end
  end
end

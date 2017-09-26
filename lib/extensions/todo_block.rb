require "asciidoctor/extensions" unless RUBY_ENGINE == "opal"

include ::Asciidoctor

# @example A delimited TODO block
#   [TODO]
#   --
#   Don't Forget!
#   --
class TodoBlock < Extensions::BlockProcessor
  use_dsl
  named :TODO
  on_contexts :open, :paragraph, :example, :listing, :sidebar, :pass

  # Read the parent attributes and create a TODO 
  # admonition block
  def process parent, reader, attrs
    attrs['name'] = 'todo'
    attrs['caption'] = 'Todo'
    create_block parent, :admonition, reader.lines, attrs, content_model: :compound
  end
end

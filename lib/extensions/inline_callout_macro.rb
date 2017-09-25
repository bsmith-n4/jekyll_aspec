require 'asciidoctor/extensions'

include ::Asciidoctor

Extensions.register do
  block do
    named :sample
    on_context :open

    process do |parent, reader, attrs|
      create_paragraph parent, reader.lines, attrs
    end
  end
end

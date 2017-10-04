require 'asciidoctor/extensions'

include ::Asciidoctor

Targets = [/&lt;&lt;/, /&gt;&gt;/, /<\/p>/].freeze
Subtitutes = ['', '', ''].freeze

Extensions.register do
  postprocessor do
    process do |_document, output|
      Targets.zip(Subtitutes).each do |target, subtitute|
        output.gsub! target, subtitute
      end
      output
    end
  end
end

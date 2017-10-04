require 'asciidoctor/extensions'

include ::Asciidoctor

Targets = [/&lt;&lt;/, /&gt;&gt;/, /<\/p>/]
Subtitutes = ['', '', '']

Extensions.register do
  postprocessor do
    process do |document, output|
      Targets.zip(Subtitutes).each do |target, subtitute|
        output.gsub! target, subtitute
      end
      output
    end
  end
end

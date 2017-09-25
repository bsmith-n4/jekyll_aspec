require 'asciidoctor/extensions'

include ::Asciidoctor
# Preprocessor that strips the << tags
# FIXME: may break conversion if line ends with >>

req = '<<req-'
brackets = /<<|>>/
repl = ''

Extensions.register do
  preprocessor do
    process do |_document, reader|
      return reader if reader.eof?
      replacement_lines = reader.read_lines.map do |line|
        (line.include? req) ? (line.grepl brackets, repl) : line
      end
      reader.unshift_lines replacement_lines
      reader
    end
  end
end

require 'asciidoctor/extensions'

include ::Asciidoctor

Extensions.register {
  postprocessor {
    process do |document, output|
      if document.basebackend? 'html'
        output = output.gsub(/<\/p>/, '')
      end
      output
    end 
  }
}


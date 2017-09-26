require 'asciidoctor'
require 'test/unit'
require_relative "../lib/extensions/html_postprocessor"

class TestHtmlPostprocessor < Test::Unit::TestCase
	
	def test_single
		input = "A single test para"

	assert_equal("<div class=\"paragraph\">\n<p>A single test para\n</div>", 
		Asciidoctor::Document.new(input).render)
	end
end

require 'test/unit'
require 'asciidoctor'
require_relative '../lib/extensions/requirement_block_macro'

include ::Asciidoctor

# Register the Requirement block macro 
Extensions.register do
	block_macro RequirementBlockMacro
end

class TestRequirementBlock < Test::Unit::TestCase
	def test_simple
		input = "requirements::[]"
  # @todo find better way to test this, perhaps by running directly on test documents
	assert_equal("<h2 id=\"requirements\"><a class=\"anchor\" href=\"#requirements\"></a><a class=\"link\" href=\"#requirements\">Requirements</a></h2>\n    <div class=\"panel panel-default\"> <div class=\"panel-heading\"><h4>Requirements</h4></div>\n      <table class=\"table\"> <thead> <tr>\n        <th>#</th> <th>ID</th><th>Version</th> <th>Title</th> <th>Document</th>\n      </tr> </thead>\n      <tbody>\n        [req,id=123,version=1]test/samples/document1Requirement 123 Title\n[req,id=456,version=1]test/samples/subdir/document2Requirement 456 Title\n\n      </tbody>\n      </table> </div>", 
		Asciidoctor::Document.new(input).render)
	end
end
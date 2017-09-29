require 'test/unit'
require 'asciidoctor'
require_relative '../lib/extensions/requirement_block_macro'

include ::Asciidoctor

class TestRequirementBlock < Test::Unit::TestCase
	def test_simple
		input = "requirements::[]"
  # @todo find better way to test this, perhaps by running directly on test documents
	assert_equal("<h2 id=\"requirements\"><a class=\"anchor\" href=\"#requirements\"></a><a class=\"link\" href=\"#requirements\">Requirements</a></h2>\n<div class=\"panel panel-default\"> <div class=\"panel-heading\"><h4>Requirements</h4></div> <table class=\"table\"><thead><tr><th>#</th>\n<th>ID</th> <th>Version</th> <th>Title</th> <th>Document</th>\n</tr></thead>\n<tbody>\n<tr> <th scope=\"row\">1</th> <td>123</td><td>1</td> <td><a class=\"link\" href=\"test/samples/document1/index#123\"><emphasis role=\"strong\">Requirement 123 Title\n</emphasis>  </a></td> <td><a href=\"test/samples/document1\">Index / </a></td> </tr><tr> <th scope=\"row\">2</th> <td>123</td><td>1</td> <td><a class=\"link\" href=\"test/samples/document3/index#123\"><emphasis role=\"strong\">Requirement 123 Title\n</emphasis>  </a></td> <td><a href=\"test/samples/document3\">Index / </a></td> </tr><tr> <th scope=\"row\">3</th> <td>456</td><td>1</td> <td><a class=\"link\" href=\"test/samples/subdir/document2/index#456\"><emphasis role=\"strong\">Requirement 456 Title\n</emphasis>  </a></td> <td><a href=\"test/samples/subdir/document2\">subdir / Document Two</a></td> </tr>\n</tbody></table></div>", 
		Asciidoctor::Document.new(input).render)
	end
end
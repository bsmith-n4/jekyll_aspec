require 'asciidoctor'
require 'test/unit'
require_relative "../lib/extensions/inline_repo_macro"

class TestInlineRepoMacroProcessor < Test::Unit::TestCase
	
	def test_without_pattern
		input = "repo:test[]"

		# @todo assert warning here
	assert_equal("<div class=\"paragraph\">\n<p><a href=\"\" style=\"padding-right:2px;\">\n                  <span class=\"label label-info\" style=\"font-weight: 400;\n                  font-size:smaller;\">\n                    <i class=\"fa fa-github fa-lg\"></i>\n\n                  </span>\n                </a></p>\n</div>", 
		Asciidoctor::Document.new(input).render)
	end

	def test_with_pattern
		input = ":repo-pattern: example.com \nrepo:test[]"

	assert_equal("<div class=\"paragraph\">\n<p><a href=\"\" style=\"padding-right:2px;\">\n                  <span class=\"label label-info\" style=\"font-weight: 400;\n                  font-size:smaller;\">\n                    <i class=\"fa fa-github fa-lg\"></i>\n\n                  </span>\n                </a></p>\n</div>", 
		Asciidoctor::Document.new(input).render)
	end

	def test_block
		input = ":repo-pattern: example.com \nrepo::test[]"

	assert_equal("<div class=\"paragraph\">\n<p><a href=\"\" style=\"padding-right:2px;\">\n                  <span class=\"label label-info\" style=\"font-weight: 400;\n                  font-size:smaller;\">\n                    <i class=\"fa fa-github fa-lg\"></i>\n                    test\n                  </span>\n                </a></p>\n</div>", 
		Asciidoctor::Document.new(input).render)
	end
end

require 'asciidoctor'
require 'test/unit'
require_relative "../lib/extensions/inline_task_macro"

class TestInlineCalloutMacroProcessor < Test::Unit::TestCase
	
	def test_simple
		input = "task:123[]"

		# @todo assert warning here
	assert_equal("<div class=\"paragraph\">\n<p><a href=\"unknown\"><span class=\"label label-default\">123</span></a></p>\n</div>", 
		Asciidoctor::Document.new(input).render)
	end

	def test_with_status
		input = ":task-pattern: example.com \ntask:123[]"

	assert_equal("<div class=\"paragraph\">\n<p><a href=\"example.com\"><span class=\"label label-default\">123</span></a></p>\n</div>", 
		Asciidoctor::Document.new(input).render)
	end
end

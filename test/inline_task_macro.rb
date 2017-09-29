require 'asciidoctor'
require 'test/unit'
require_relative '../lib/extensions/inline_task_macro'

class TestInlineTaskMacroProcessor < Test::Unit::TestCase
  def test_without_pattern
    input = 'task:123[]'

    # @todo assert warning here
    assert_equal("<div class=\"paragraph\">\n<p><span class=\"label label-default\" data-toggle=\"tooltip\" title=\"Missing config\">123</span></p>\n</div>",
                 Asciidoctor::Document.new(input).render)
  end

  def test_with_pattern
    input = ":task-pattern: example.com \ntask:123[]"

    assert_equal("<div class=\"paragraph\">\n<p><a href=\"example.com/123\"><span class=\"label label-default\">123</span></a></p>\n</div>",
                 Asciidoctor::Document.new(input).render)
  end

  def test_block_without_pattern
    input = 'task::123[]'

    assert_equal("<div class=\"paragraph\">\n<p><div style=\"float:right;padding-left:0.1em;\"><span class=\"label label-default\" data-toggle=\"tooltip\" title=\"Missing config\">123</span></div></p>\n</div>",
                 Asciidoctor::Document.new(input).render)
  end

  def test_block_with_pattern
    input = ":task-pattern: example.com \ntask::123[]"

    assert_equal("<div class=\"paragraph\">\n<p><div style=\"float:right;padding-left:0.1em;\"><a href=\"example.com/123\"><span class=\"label label-default\">123</span></a></div></p>\n</div>",
                 Asciidoctor::Document.new(input).render)
  end
end

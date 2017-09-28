require 'asciidoctor'
require 'test/unit'
require_relative "../lib/extensions/inline_cwiki_macro"

class TestInlineCwikiMacroProcessor < Test::Unit::TestCase
	
	def test_missing_config
		input = "cwiki:topic[]"

  	assert_equal("<div class=\"paragraph\">\n<p><span class=\"label label-warning\" data-toggle=\"tooltip\" title=\"Missing config\">cwiki-pattern missing</span></p>\n</div>", 
  		Asciidoctor::Document.new(input).render)
	end

  def test_simple_block
    input = ":cwiki-pattern: http://www.example.org\ncwiki::topic[]"

    assert_equal("<div class=\"paragraph\">\n<p><div style=\"float:"\
      "right;padding-left:0.1em;\"><a href=\"http://www.example.org/"\
      "topic\"><span class=\"label label-default\">topic</span></a></div></p>\n</div>", 
      Asciidoctor::Document.new(input).render)
  end

  def test_simple
    input = ":cwiki-pattern: http://www.example.org\ncwiki:topic[]"

    assert_equal("<div class=\"paragraph\">\n<p><a href=\"http://www."\
      "example.org/topic\"><span class=\"label label-default\">topic</span></a></p>\n</div>", 
      Asciidoctor::Document.new(input).render)
  end

  def test_single_open_label
    input = ":cwiki-pattern: http://www.example.org\ncwiki:topic[status=\"open\"]"

    assert_equal("<div class=\"paragraph\">\n<p><a href=\"http://www.example"\
      ".org/topic\"><span class=\"label label-warning\">topic</span></a></p>\n</div>", 
      Asciidoctor::Document.new(input).render)
  end

  def test_single_done_label
    input = ":cwiki-pattern: http://www.example.org\ncwiki:topic[status=\"done\"]"

    assert_equal("<div class=\"paragraph\">\n<p><a href=\"http://www.example"\
      ".org/topic\"><span class=\"label label-success\">topic</span></a></p>\n</div>", 
      Asciidoctor::Document.new(input).render)
  end
end

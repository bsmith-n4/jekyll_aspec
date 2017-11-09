require 'test/unit'
require 'asciidoctor'
require_relative '../lib/extensions/requirement_block'

class TestDefintionBlock < Test::Unit::TestCase
  def test_delimited_with_title
    input = "\n.Roundness\n[def]\n--\nRoundness is the measure of how closely the shape of an object approaches that of a mathematically perfect circle.\n--\n"

    assert_equal("<div class=\"openblock def\">\n<div class=\"title\">Roundness</div>\n<div class=\"content\">\n<div class=\"paragraph\">\n<p>Roundness is the measure of how closely the shape of an object approaches that of a mathematically perfect circle.</p>\n</div>\n</div>\n</div>",
                 Asciidoctor::Document.new(input).render)
  end
end

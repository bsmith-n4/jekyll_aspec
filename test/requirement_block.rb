require 'test/unit'
require 'asciidoctor'
require_relative '../lib/extensions/requirement_block'

# Register the Requirement block processor
Extensions.register do
	block RequirementBlock
end

class TestRequirementBlock < Test::Unit::TestCase
	def test_delimited_with_title
		input = "\n.A Beautiful Title\n[req,id=RCD-39,version=1]\n--\nTests should be automated.\n--\n"

	assert_equal("<div id=\"RCD-39\" class=\"admonitionblock requirement\">\n<table>\n"\
		"<tr>\n<td class=\"icon\">\n<div class=\"title\"></div>\n</td>\n<td class=\"content"\
		"\">\n<div class=\"title\">A Beautiful Title</div>\n<div class=\"paragraph\">\n<p>\n\n"\
		"    <div class=\"panel panel-primary\">\n      <div class=\"panel-heading\">\n       "\
		" <h3 class=\"panel-title\">\n          <a class=\"anchor\" href=\"#RCD-39\"></a>\n    "\
		"      <a class=\"link\" href=\"#RCD-39\"><emphasis role=\"strong\">Requirement: RCD-39:</emphasis>"\
		" A Beautiful Title </a> (ver. 1)\n        </h3>\n      </div>\n      <div class=\"panel-body\">\n</p>"\
		"\n</div>\n<div class=\"paragraph\">\n<p>Tests should be automated.</p>\n</div>\n<div class=\"paragraph\">"\
		"\n<p>\n</div></div>\n</p>\n</div>\n</td>\n</tr>\n</table>\n</div>", 
		Asciidoctor::Document.new(input).render)
	end

	def test_with_title
		input = 
		"\n.A Beautiful Title\n[req,id=RCD-39,version=1]\nTests should be automated.\n"

	assert_equal("<div id=\"RCD-39\" class=\"admonitionblock requirement\">\n<table>\n<tr>\n<td"\
		" class=\"icon\">\n<div class=\"title\"></div>\n</td>\n<td class=\"content\">\n<div class="\
		"\"title\">A Beautiful Title</div>\n<div class=\"paragraph\">\n<p>\n\n    <div class=\"panel "\
		"panel-primary\">\n      <div class=\"panel-heading\">\n        <h3 class=\"panel-title\">\n  "\
		"        <a class=\"anchor\" href=\"#RCD-39\"></a>\n          <a class=\"link\" href=\"#RCD-39\">"\
		"<emphasis role=\"strong\">Requirement: RCD-39:</emphasis> A Beautiful Title </a> (ver. 1)\n  "\
		"      </h3>\n      </div>\n      <div class=\"panel-body\">\n</p>\n</div>\n<div class=\"paragraph\">"\
		"\n<p>Tests should be automated.</p>\n</div>\n<div class=\"paragraph\">\n<p>\n</div></div>\n</p>\n</div>"\
		"\n</td>\n</tr>\n</table>\n</div>", 
		Asciidoctor::Document.new(input).render)
	end

	def test_delimited_no_title
		input = 
		"\nprevious content\n\n[req,id=RCD-39,version=1]\n--\nTests should be automated.\n--\n"

	assert_equal("<div class=\"paragraph\">\n<p>previous content</p>\n</div>\n<div id=\"RCD-39\""\
		" class=\"admonitionblock requirement\">\n<table>\n<tr>\n<td class=\"icon\">\n<div class=\"title"\
		"\"></div>\n</td>\n<td class=\"content\">\n<div class=\"paragraph\">\n<p>\n\n    <div class=\"panel"\
		" panel-primary\">\n      <div class=\"panel-heading\">\n        <h3 class=\"panel-title\">\n      "\
		"    <a class=\"anchor\" href=\"#RCD-39\"></a>\n          <a class=\"link\" href=\"#RCD-39\"><emphasis"\
		" role=\"strong\">Requirement: RCD-39:</emphasis>  </a> (ver. 1)\n        </h3>\n      </div>\n      "\
		"<div class=\"panel-body\">\n</p>\n</div>\n<div class=\"paragraph\">\n<p>Tests should be automated.</p>"\
		"\n</div>\n<div class=\"paragraph\">\n<p>\n</div></div>\n</p>\n</div>\n</td>\n</tr>\n</table>\n</div>", 
		Asciidoctor::Document.new(input).render)
	end
end
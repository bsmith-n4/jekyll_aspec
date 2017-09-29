require 'test/unit'
require 'asciidoctor'
require_relative '../lib/jekyll_aspec'

class TestSampleFile < Test::Unit::TestCase
	def test_convert_sample_file
  sample = "test/samples/document1.adoc"
  Asciidoctor.convert_file(sample)
  html = File.read('test/samples/document1.html')

  assert_equal("<!DOCTYPE html>\n<html lang=\"en\">\n<head>\n<meta charset=\"UTF-8\">\n<!--[if IE]><meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\"><![endif]-->\n<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n<meta name=\"generator\" content=\"Asciidoctor 1.5.6.1\">\n<title>Document One</title>\n<link rel=\"stylesheet\" href=\"https://fonts.googleapis.com/css?family=Open+Sans:300,300italic,400,400italic,600,600italic%7CNoto+Serif:400,400italic,700,700italic%7CDroid+Sans+Mono:400,700\">\n<link rel=\"stylesheet\" href=\"./asciidoctor.css\">\n</head>\n<body class=\"article\">\n<div id=\"header\">\n<h1>Document One</h1>\n</div>\n<div id=\"content\">\n<div class=\"paragraph\">\n<p>content\n</div>\n<div id=\"123\" class=\"admonitionblock requirement\">\n<table>\n<tr>\n<td class=\"icon\">\n<div class=\"title\"></div>\n</td>\n<td class=\"content\">\n<div class=\"title\">Requirement 123 Title</div>\n<div class=\"paragraph\">\n<p>\n\n    <div class=\"panel panel-primary\">\n      <div class=\"panel-heading\">\n        <h3 class=\"panel-title\">\n          <a class=\"anchor\" href=\"#123\"></a>\n          <a class=\"link\" href=\"#123\"><emphasis role=\"strong\">Requirement: 123:</emphasis> Requirement 123 Title </a> (ver. 1)\n        </h3>\n      </div>\n      <div class=\"panel-body\">\n\n</div>\n<div class=\"paragraph\">\n<p>Content of the requirement\n</div>\n<div class=\"paragraph\">\n<p>\n</div></div>\n\n</div>\n</td>\n</tr>\n</table>\n</div>\n<div class=\"paragraph\">\n<p><a href=\"#Document One\">[Document One]</a>\n</div>\n<h2 id=\"requirements\"><a class=\"anchor\" href=\"#requirements\"></a><a class=\"link\" href=\"#requirements\">Requirements</a></h2>\n    <div class=\"panel panel-default\"> <div class=\"panel-heading\"><h4>Requirements</h4></div>\n      <table class=\"table\"> <thead> <tr>\n        <th>#</th> <th>ID</th><th>Version</th> <th>Title</th> <th>Document</th>\n      </tr> </thead>\n      <tbody>\n        [req,id=123,version=1]test/samples/document1Requirement 123 Title\n[req,id=456,version=1]test/samples/subdir/document2Requirement 456 Title\nsubdirDocument Two\n      </tbody>\n      </table> </div>\n</div>\n<div id=\"footer\">\n<div id=\"footer-text\">\nLast updated 2017-09-28 16:15:49 CEST\n</div>\n</div>\n</body>\n</html>", 
		html)
	end
end

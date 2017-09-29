require 'asciidoctor'
require 'test/unit'
require_relative '../lib/extensions/inline_repo_macro'

class TestInlineRepoMacro < Test::Unit::TestCase
  def test_without_pattern
    input = "\nrepo:test[]"

    # @todo assert warning here
    assert_equal("<div class=\"paragraph\">\n<p><a href=\"#\" style=\"padding-right:2px;\">\n<span class=\"label label-warning\" style=\"font-weight: 400;\nfont-size:smaller;\">\n<i class=\"fa fa-github fa-lg\"></i>\nMissing repo config for 'test'\n</span>\n</a></p>\n</div>",
                 Asciidoctor::Document.new(input).render)
  end

  def test_non_matching_pattern
    input = ":repo_dockerfiles: www.github.com/exampleuser/dockerfiles\n\nsee repo:test[]"

    assert_equal("<div class=\"paragraph\">\n<p>see <a href=\"#\" style=\"padding-right:2px;\">\n<span class=\"label label-warning\" style=\"font-weight: 400;\nfont-size:smaller;\">\n<i class=\"fa fa-github fa-lg\"></i>\nMissing repo config for 'test'\n</span>\n</a></p>\n</div>",
                 Asciidoctor::Document.new(input).render)
  end

  def test_simple
    input = ":repo_dockerfiles: www.github.com/exampleuser/dockerfiles\n\nsee repo:dockerfiles:ansible/Dockerfile_template[]"

    assert_equal("<div class=\"paragraph\">\n<p>see <a href=\"www.github.com/exampleuser/dockerfiles/blob/master/ansible/Dockerfile_template\" style=\"padding-right:2px;\">\n<span class=\"label label-info\" style=\"font-weight: 400;\nfont-size:smaller;\">\n<i class=\"fa fa-github fa-lg\"></i>\nansible/Dockerfile_template\n</span>\n</a></p>\n</div>",
                 Asciidoctor::Document.new(input).render)
  end

  def test_simple_with_line_number
    input = ":repo_dockerfiles: www.github.com/exampleuser/dockerfiles\n\nsee repo:dockerfiles:ansible/Dockerfile_template:2[]"

    assert_equal("<div class=\"paragraph\">\n<p>see <a href=\"www.github.com/exampleuser/dockerfiles/blob/master/ansible/Dockerfile_template#L2\" style=\"padding-right:2px;\">\n<span class=\"label label-info\" style=\"font-weight: 400;\nfont-size:smaller;\">\n<i class=\"fa fa-github fa-lg\"></i>\nansible/Dockerfile_template line 2\n</span>\n</a></p>\n</div>",
                 Asciidoctor::Document.new(input).render)
  end

  def test_line_number_branch
    input = ":repo_dockerfiles: www.github.com/exampleuser/dockerfiles\n\nsee repo:dockerfiles:ansible/Dockerfile_template:5[branch=\"AS_v0.0.10\"]"

    assert_equal("<div class=\"paragraph\">\n<p>see <a href=\"www.github.com/exampleuser/dockerfiles/tree/AS_v0.0.10/ansible/Dockerfile_template#L5\" style=\"padding-right:2px;\">\n<span class=\"label label-warning\" style=\"font-weight: 400;\nfont-size:smaller;\">\n<i class=\"fa fa-github fa-lg\"></i>\nansible/Dockerfile_template:5 (tree/AS_v0.0.10)\n</span>\n</a></p>\n</div>",
                 Asciidoctor::Document.new(input).render)
  end

  def test_block_long_format
    input = ":repo_dockerfiles: www.github.com/exampleuser/dockerfiles\n\nsee repo:dockerfiles:ansible/Dockerfile_template[line=\"5\",branch=\"AS_v0.0.10\"]"

    assert_equal("<div class=\"paragraph\">\n<p>see <a href=\"www.github.com/exampleuser/dockerfiles/tree/AS_v0.0.10/ansible/Dockerfile_template#L5\" style=\"padding-right:2px;\">\n<span class=\"label label-warning\" style=\"font-weight: 400;\nfont-size:smaller;\">\n<i class=\"fa fa-github fa-lg\"></i>\nansible/Dockerfile_template (tree/AS_v0.0.10)\n</span>\n</a></p>\n</div>",
                 Asciidoctor::Document.new(input).render)
  end
end

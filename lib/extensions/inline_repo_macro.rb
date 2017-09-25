require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

include ::Asciidoctor

# Link to a file on GitHub.
#
# repo:<repository>:<file>:<line>[]
#
#   Examples:
#
#   repo:dockerfiles:ansible/Dockerfile_template[]
#   repo:dockerfiles:ansible/Dockerfile_template:2[]
#   repo:dockerfiles:ansible/Dockerfile_template:5[branch="AS_v0.0.10"]
#   repo:dockerfiles:ansible/Dockerfile_template[line="5",branch="AS_v0.0.10"]
#

url = ''
file = ''
line = ''
formattedurl = ''
text = ''

Extensions.register do
  inline_macro do
    named :repo

    process do |parent, target, attrs|
      if parent.context.to_s == 'cell'
        warn %([Hell in a cell] cell with repo link must have 'asciidoc format')
      end

      repo = target.match(/^.+?(?=:)/).to_s
      file = target.match(/(?<=:).+/).to_s

      text = file
      text = file.gsub(%r{/.+\//}, '') if file[%r{/\//}]

      if target[/(?<=:)\d+$/]
        line = "#L#{target.match(/(?<=:)\d+?$/)}"
        file = file.sub(/:\d+$/, '')
      elsif attrs['line']
        line = "#L#{attrs['line']}"
      else
        line = ''
      end

      if attrs['branch']
        branch = "tree/#{attrs['branch']}"
        text = "#{text} (#{branch})"
        label = 'warning'
      else
        branch = 'blob/master'
        label = 'info'
      end

      text = attrs['title'].to_s if attrs['title']
      text.gsub!(/:(?=\d+$)/, ' line ') if text[/(?<=:)\d+$/]

      parent.document.attributes.each do |key, value|
        next unless key[/^repo_/]
        pattern = key.sub(/^repo_/, '')
        if repo == pattern
          formattedurl = "#{value}/#{branch}/#{file}#{line}"
        else
          url = ''
        end
      end

      html = %(<a href=\"#{formattedurl}\" style=\"padding-right:2px;\">
                  <span class=\"label label-#{label}\" style=\"font-weight: 400;
                  font-size:smaller;\">
                    <i class=\"fa fa-github fa-lg\"></i>
                    #{text}
                  </span>
                </a>)

      (create_pass_block parent, html, attrs).render
    end
  end
end

require 'asciidoctor/extensions'
require 'pathname'

include ::Asciidoctor

# Find all Adoc Files
adoc_files = Dir.glob('**/*.adoc')
invoc = Dir.pwd

titles, xrefs, mismatches = [], [], []
replacement = ''

def trim(s)
  s = s.gsub(/^_docs\//, '')
  s = s.gsub(/(\.adoc|\.md|\.html)/, '')
end

def targetify(t)
  t.downcase.gsub(/(\s|-)/, '_')
end

def underscorify(t)
  t = t.downcase.gsub(/(\s|-)/, '_')
  t = t.prepend('_') unless t.match(/^_/)
  t = t.gsub(/___/, '_').delete('`')
end

def titleify(t)
  t = t.gsub(/\_/, ' ')
  t = t.lstrip
  t = t.split.map(&:capitalize).join(' ')
end

adoc_files.each do |file_name|
  lc = 0

  File.read(file_name).each_line do |li|
    h1 = false
    lc += 1
    path = trim(file_name)

    # Match all <<xrefs>> (Excluding Requirements! - handled separately)
    if li[/\<\<(?!Req)(.+?)\>\>/]

      num_refs = li.scan(/(?=\<\<(?!Req)(.+?)\>\>)/).count
      
      li.scan(/(?=\<\<(?!Req)(.+?)\>\>)/) {|xref| 
        xref = xref[0].to_s
        text, target = '', ''
        #xref = xref.chop.match(/\<\<(?!Req)(\S.+?)\>\>/i).captures[0].to_s
        if xref[/,/]
          target = xref.gsub(/,.+/, '').gsub(/\s/, '-')
          text = xref.gsub(/.+,/, '').lstrip
          xref = xref.sub(/,.+/, '')
        else
          target = xref.gsub(/\s/, '-')
          text = xref
        end
        item = [xref, path, file_name, text, target]
        xrefs.push item
      }

    # Match Block .Titles and = Section Titles
    elsif li[/(^(\.\S\w+)|^(\=+\s+?\S+.+))/]

      h1 = true if li[/^(\=+\s+?\S+.+)/]
      title = li.chop.match(/(?!=+\s)(\S+.+?)$/i).captures[0]
      title.sub!(/\.(?=\w+?)/, '') if title[/\.(?=\w+?)/]
      title = title.strip   
      item = [title, path, file_name, underscorify(title).strip, h1]
      titles.push item

    # Match [[anchors]]
    elsif li[/\[\[(?:|([\w+?_:][\w+?:.-]*)(?:, *(.+))?)\]\]/]

      # Add check if none found (captures nil)
      anchor = li.chop.match(/(?<=\[\[).+?(?=\]\])/).to_s

      if anchor[/,/]
        anchor = anchor.match(/(?<=\[\[)(?:|[\w+?_:][\w+?:.-]*)(?=,.+?\]\])/).to_s
        text = anchor.sub(/.+?,/, '')
        text = text.sub(/\]\]$/, '')
      end
      item = [anchor, path, file_name, text]
      titles.push item

    end
  end
end

# Run through each xref and check for matching titles
xrefs.each do |xref, xpath, xfile, xtext, xtarget|
  # check xrefs against titles
  titles.each do |ttext, tpath, tfile, alt, h1|

    # IMPORTANT - If unnecessary matches are made here, there are exponentially large performance knocks
    # xrefs / alt / title text must be handled properly
    next unless ttext == xtext || ttext == xref || alt == xref || alt == xtarget
    next unless tpath != xpath
    tpath = 'index' if tpath.to_s.empty?
    xtform = underscorify(xtarget) if h1
    xfile = trim(xfile)
    detail = [xref, xtarget, xtext, xpath, xfile, ttext, tpath, tfile, xtform, alt, h1]
    mismatches.push detail

  end
end

Extensions.register do
  preprocessor do
    process do |document, reader|
      fixes = []
      
      mismatches.each do |_xref, _xtarget, xtext, _xpath, xfile, _ttext, _tpath, tfile, xtform, alt, h1|
        docfile = document.attributes['docfile'].sub(/^#{invoc}\//, '')
        trim(docfile)
        next unless docfile.to_s == xfile
        # calculate the relative path between source and target
        # TODO - abstract the following
        first = Pathname.new xfile.to_s
        second = Pathname.new tfile.to_s
        relpath = second.relative_path_from first
        relpath = relpath.sub(/^\.\.\//, '') if docfile == 'index'
        xtform = _xref if xtform.to_s.empty?
        xtform = underscorify(xtform) if xtform[/\s/] || h1
        xtext = titleify(xtext) if xtext[/\_/]
        fix = "#{relpath}/index##{xtform},#{xtext}"
        fixes.push fix
      end

      Reader.new reader.readlines.map { |li|
        # If the line contains an xref (not to requirements)
        if li[/\<\<(?!Req)(.+?)\>\>/]
          num_refs = li.scan(/(?=\<\<(?!Req)(.+?)\>\>)/).count
          num_refs.times do
            mismatches.each do |xref, xtarget, xtext, _xpath, _xfile, _ttext, _tpath, _tfile, _relpath, alt, h1|
              # check if the line contains the original xref
              next unless li[/\<\<#{xref}(,.+)?\>\>/]      
              alt = xref if alt.to_s.empty?
              fixes.each do |x|
                next unless x[/(#{xtarget}|#{alt})/]
                t = xref if xtext.to_s.empty?
                x = x.gsub(/_docs\//, '')
                x = x.gsub(/(\.adoc|\.md|\.html)/, '')
                #x = x.sub(/(?!=index.html#).+/, '') if h1
                li = li.sub(/\<\<#{xref}(,.+)?\>\>/, "icon:expand[] <<#{x}#{t}>> ")
                replacement = li
              end
            end
          end
        else
          replacement = ''
        end
        if replacement.to_s.empty?
          li
        else
          replacement
        end
      }
    end # each document
  end
end

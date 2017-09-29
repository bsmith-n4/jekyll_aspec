require 'asciidoctor/extensions'
require 'pathname'

include ::Asciidoctor

# Find all Adoc Files
adoc_files = Dir.glob("**/*.adoc")
invoc = Dir.pwd

# Make some arrays available
titles = []
anchors = []
xrefs = []
mismatches = []

replacement = ""

def trim(s)
  s.gsub!(/_docs\//, '')
  s.gsub!(/(\.adoc|\.md|\.html)/, '')
end

def targetify(t)
  # make all chars lowercase and substitute spaces with hyphens
  t.downcase.gsub(/\s/,'-')
end

adoc_files.each do |file_name|
  lc = 0 

  File.read(file_name).each_line do |li|
    lc += 1

    # Match all <<xrefs>> exluding Requirements
    if (li[/\<\<(?!Req)(.+?)\>\>/])

      text = ""
      target = ""
      path = trim(file_name)
      xref = li.chop.match(/\<\<(?!Req)(\S.+?)\>\>/i).captures[0].to_s
      
      if xref[/,/]
        target = xref.downcase.gsub(/,.+/,'').gsub(/\s/,'-')
        text = xref.gsub(/.+,/,'').lstrip!
        xref = xref.sub(/,.+/,'')
        path = file_name
      else
        target = xref.downcase.gsub(/\s/,'-')
        text = xref
      end
      
      item = [xref, path, file_name, text, target]
      xrefs.push item
      
      # Match .Titles and = Section Titles    
    elsif (li[/(^(\.\S\w+)|^(\=+\s+?\S+.+))/])

      # Add check if none found (captures nil)
      title = li.chop.match(/(?!=+\s)(\S+.+?)$/i).captures[0]
      if title[/\.(?=\w+?)/]
        title.sub!(/\.(?=\w+?)/,'')
      end
      path = trim(file_name)
      item = [title, path, file_name]
      titles.push item

    # Match [[anchors]]
    elsif (li[/\[\[(?:|([\w+?_:][\w+?:.-]*)(?:, *(.+))?)\]\]/])

      # Add check if none found (captures nil)
      anchor = li.chop.match(/(?<=\[\[).+?(?=\]\])/).to_s

      if anchor[/,/]
        anchor = anchor.match(/(?<=\[\[)(?:|[\w+?_:][\w+?:.-]*)(?=,.+?\]\])/).to_s
        text = anchor.sub(/.+?,/,'')
        text = text.sub(/\]\]$/,'')
      end
      path = trim(file_name)
      item = [anchor, path, file_name, text]
      titles.push item
  
    end
  
  end
end

# Run through each xref and check for matching titles
xrefs.each do |xref, xpath, xfile, xtext, xtarget|

  # check xrefs against titles
  titles.each do |ttext, tpath, tfile, tdisp|
    
    #puts "checking #{ttext} against #{xref}"
    if ttext == xref
      # puts "MATCHED #{ttext} with #{xref}"

      # If the paths are not the same (xref and title not the same document) do the following     
      if tpath != xpath
        if "#{tpath}".empty?
          tpath = "index"
        end
        # puts "Title \"#{ttext}\" in #{tfile} - mismatched xref \"#{xref}\" to different doc - #{xpath}"
              
        xtform = targetify(xtarget)
        detail = [xref, xtarget, xtext, xpath, xfile, ttext, tpath, tfile, xtform]
        mismatches.push detail
      end
    end 
  end 
end

Extensions.register do
  preprocessor do

    process do |document, reader|
      fixes = []
      i = 0

      # Block is loaded once per document!!!
      # for each malformed xref
      mismatches.each do |xref, xtarget, xtext, xpath, xfile, ttext, tpath, tfile, xtform|

        # FIXME This directory is empty in POSTS - breaks conversion
        docfile = document.attributes['docfile'].sub(/^#{invoc}\//, '')
        trim(docfile)

        if "#{docfile}" == xfile

          # calculate the relative path between source and target
          first = Pathname.new "#{xfile}"
          second = Pathname.new "#{tfile}"
          relpath = second.relative_path_from first

          if docfile == "index"
            relpath = relpath.sub(/^\.\.\//,'')
          end
          fix = "#{relpath}/index##{xtform},#{xtext}"
          fixes.push fix
        end
      end

      Reader.new reader.readlines.map { |li|

        # If the line contains an xref (not to requirements)
        if (li[/\<\<(?!Req)(.+?)\>\>/])

          mismatches.each do |xref, xtarget, xtext, xpath, xfile, ttext, tpath, tfile, relpath|

            # check if the line contains the original xref

            if (li[/\<\<#{xref}(,.+)?\>\>/])
              fixes.each do |x|

                if (x[/#{xtarget}/])
                  if "#{xtext}".empty?
                    t = xref
                  end
                  replacement = li.sub(/\<\<#{xref}(,.+)?\>\>/,"icon:expand[] <<#{x}#{t}>> ")
                end
              end
              i += 1
            end
          end

        else 
          replacement = ""
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

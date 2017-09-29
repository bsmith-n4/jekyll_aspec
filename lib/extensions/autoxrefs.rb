require 'asciidoctor/extensions'
require 'pathname'
require_relative 'utils/xref_helper'

include ::Asciidoctor

invoc = Dir.pwd

# @todo Maybe don't do this. Find a better way to process
    # all .adoc files before extensions are loaded.
    adoc_files = Dir.glob('**/*.adoc')

    # Make some arrays available
    titles = []
    anchors = []
    xrefs = []
    mismatches = []

    replacement = ''

    adoc_files.each do |file_name|
      lc = 0

      File.read(file_name).each_line do |li|
        lc += 1

        # @note Matches all <<xrefs>> except Requirements
        if li[/\<\<(?!Req)(.+?)\>\>/]

          text = ''
          target = ''
          path = Xrefs.trim(file_name)
          xref = li.chop.match(/\<\<(?!Req)(\S.+?)\>\>/i).captures[0].to_s

          # @note Checks if the xref has display text, i.e. '<<title-1,Lovely Display Text>>'
          if xref[/,/]
            # @todo Use helper methods.
            target = xref.downcase.gsub(/,.+/, '').gsub(/\s/, '-')
            text = xref.gsub(/.+,/, '').lstrip!
            xref = xref.sub(/,.+/, '')
            path = file_name
          else
            # @todo Use helper methods.
            target = xref.downcase.gsub(/\s/, '-')
            text = xref
          end

          item = [xref, path, file_name, text, target]
          xrefs.push item

        # Match .Titles and = Section Titles
        elsif li[/(^(\.\S\w+)|^(\=+\s+?\S+.+))/]

          # Add check if none found (captures nil)
          title = li.chop.match(/(?!=+\s)(\S+.+?)$/i).captures[0]
          title.sub(/\.(?=\w+?)/, '') if title[/\.(?=\w+?)/]
          path = Xrefs.trim(file_name)
          item = [title, path, file_name]
          titles.push item

        # Match [[anchors]]
        elsif li[/\[\[.+?\]\]/]

          # Add check if none found (captures nil)
          anchor = li.chop.match(/(?<=\[\[).+?(?=\]\])/).to_s

          if anchor[/,/]
            anchor = anchor.match(/(?<=\[\[)(?:|[\w+?_:][\w+?:.-]*)(?=,.+?\]\])/).to_s
            text = anchor.sub(/.+?,/, '')
            text = text.sub(/\]\]$/, '')
          end

          path = Xrefs.trim(file_name)
          item = [anchor, path, file_name, text]
          # for the moment, just handle anchors similar to titles
          titles.push item

        end
      end
    end

    # Run through each xref and check for matching titles
    xrefs.each do |xref, xpath, xfile, xtext, xtarget|
      # check xrefs against titles
      titles.each do |ttext, tpath, tfile, _tdisp|

        next unless ttext == xref
        tpath = 'index' if tpath.to_s.empty?
        # If the paths are not the same (xref and title not the same document) do the following
        next unless tpath != xpath

        xtform = Xrefs.targetify(xtarget)
        detail = [xref, xtarget, xtext, xpath, xfile, ttext, tpath, tfile, xtform]
        mismatches.push detail
      end
    end

Extensions.register do
  preprocessor do
    process do |document, reader|
      fixes = []
      i = 0

      # TODO - remove unused elements (prepended with _) from the helper method in utils/xref_helper
      mismatches.each do |_xref, _xtarget, xtext, _xpath, xfile, _ttext, _tpath, tfile, xtform|
        docfile = document.attributes['docfile'].sub(/^#{invoc}\//, '')
        Xrefs.trim(docfile)
        
        next unless docfile.to_s == xfile

        # calculate the relative path between source and target
        first = Pathname.new xfile.to_s
        second = Pathname.new tfile.to_s
        relpath = second.relative_path_from first

        relpath = relpath.sub(/^\.\.\//, '') if docfile == 'index'
        fix = "#{relpath}/index##{xtform},#{xtext}"
        fixes.push fix
      end

      Reader.new reader.readlines.map { |li|
        # If the line contains an xref (not to requirements)
        if li[/\<\<(?!Req)(.+?)\>\>/]

          mismatches.each do |xref, xtarget, xtext, _xpath, _xfile, _ttext, _tpath, _tfile, _relpath|
            next unless li[/\<\<#{xref}(,.+)?\>\>/]
            fixes.each do |x|
              if x[/#{xtarget}/]
                t = xref if xtext.to_s.empty?
                replacement = li.sub(/\<\<#{xref}(,.+)?\>\>/, "icon:expand[] <<#{x}#{t}>> ")
              end
            end
            i += 1
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

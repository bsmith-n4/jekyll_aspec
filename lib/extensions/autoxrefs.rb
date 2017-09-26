require 'asciidoctor/extensions'
require 'pathname'
require_relative 'utils/xref_helper'

include ::Asciidoctor

mismatches = Xrefs.list_xrefs
invoc = Dir.pwd

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

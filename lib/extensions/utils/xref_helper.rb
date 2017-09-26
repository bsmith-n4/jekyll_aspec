module Xrefs

  def self.trim(s)
    trimmed = s.gsub(/_docs\//, '')
    trimmed.gsub(/(\.adoc|\.md|\.html)/, '')
  end

  def self.targetify(t)
    # make all chars lowercase and substitute spaces with hyphens
    t.downcase.gsub(/\s/, '-')
  end

  def self.list_xrefs

    # Find all Adoc Files
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

        # Match all <<xrefs>> exluding Requirements
        if li[/\<\<(?!Req)(.+?)\>\>/]

          text = ''
          target = ''
          path = trim(file_name)
          xref = li.chop.match(/\<\<(?!Req)(\S.+?)\>\>/i).captures[0].to_s

          if xref[/,/]
            target = xref.downcase.gsub(/,.+/, '').gsub(/\s/, '-')
            text = xref.gsub(/.+,/, '').lstrip!
            xref = xref.sub(/,.+/, '')
            path = file_name
          else
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
          path = trim(file_name)
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

          path = trim(file_name)
          item = [anchor, path, file_name, text]
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

        xtform = targetify(xtarget)
        detail = [xref, xtarget, xtext, xpath, xfile, ttext, tpath, tfile, xtform]
        mismatches.push detail
      end
    end
  end
end
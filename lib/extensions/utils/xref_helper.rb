# Helper methods for common xref processing.
#
module Xrefs
  # Trims a path of a given source document to exclude the docs directory
  # and file extension. This is used to calculate the target directory 
  # of generated HTML files given default permalink settings.
  #
  # @param path [String] the path of the source document relative to the project root
  # @return [String] the formatted path
  def self.trim(path)
    trimmed = path.gsub(/_docs\//, '')
    trimmed.gsub(/(\.adoc|\.md|\.html)/, '')
  end

  # Formats a string to be permalink-friendly. This simply
  # downcases the string an substitutes spaces with hyphens. This is
  # typically used for section titles and document titles to generate
  # a cross-reference to an anchor.
  #
  # @param path [String] the path of the source document relative to the project root
  # @return [String] the formatted path
  def self.targetify(path)
    path.downcase.gsub(/\s/, '-')
  end

  # Recursively globs all files with the .adoc extension and matches cross-references, 
  # section titles and anchors. Cross-references to Requirements are excluded and handled 
  # in their own processor as they are a special case (i.e., there is no built-in support).
  #
  # @return [String] the formatted path
  def self.list_xrefs

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
          path = trim(file_name)
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

        xtform = targetify(xtarget)
        detail = [xref, xtarget, xtext, xpath, xfile, ttext, tpath, tfile, xtform]
        mismatches.push detail
      end
    end
  end
end
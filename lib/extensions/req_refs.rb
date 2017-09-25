require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

include ::Asciidoctor

adoc_files = Dir.glob('**/*.adoc')
exts = '(\.adoc|\.md|\.html)'

rpath = nil
rtext = nil
reqs = []
inc_reqs = []
com_reqs = []
incs = []
xrefs = []
xref_base = ''

blockrx = %r(^\/{4,}$)
linerx = %r{^//(?=[^/]|$)}

orphan = false

# Retrieve this via document attribute
docsdir = '_docs'

def trim(s)
  s.gsub!(/_docs\//, '')
  s.gsub!(/(\.adoc|\.md|\.html)/, '')
end

adoc_files.each do |file_name|
  lc = 0
  inc = false

  File.read(file_name).each_line do |li|
    lc += 1

    incommentblock ^= true if li[blockrx]
    commented = true if li[linerx]
    inc = true if li[/published: false/]

    # Match Requirement Blocks [req,ABC-123,version=n]
    if li[/\[\s*req\s*,\s*id\s*=\s*(\w+-?[0-9]+)\s*,.*/]

      rid = li.chop.match(/id\s*=\s*\w+-?([0-9]+)/i).captures[0]
      path = file_name.sub(/^#{docsdir}\//, '')
      path = path.sub!(/#{exts}/, '')
      item = [rid, li.chop, path, file_name, lc]

      if commented || incommentblock
        com_reqs.push item
      elsif inc
        inc_reqs.push item
      else
        reqs.push item
      end

    # Match all <<xrefs>>
    elsif li[/\<\<\S.+?(\,\S)?\>\>/]

      xref = li.chop.match(/\<\<(\S.+?)(\,\S)?\>\>/i).captures[0]
      path = file_name.sub(/^#{docsdir}\//, '')
      path = path.sub!(/#{exts}/, '')
      item = [xref, path, file_name, lc]
      xrefs.push item

    # Collect all includes
    elsif li[/^include::.+.adoc\[\]/]

      inc_file = li.chop.match(/(?<=^include::).+.adoc(?=\[\])/i).to_s
      path = inc_file.sub(/^#{docsdir}\//, '')
      path = path.sub(/#{exts}/, '')
      parent = file_name
      item = [inc_file, path, parent, lc]
      incs.push item

    end
  end
end

# Sort included reqs and correct the path to the include parent
inc_reqs.each do |rid, rli, rpath, _rfile, _rline|
  incs.each do |incfile, incpath, parent, lc|
    next unless rpath == incpath
    trim(parent)
    item = [rid, rli, parent, incfile, lc]
    reqs.push item
  end
end

# Sort (in-place) by numberic ID
reqs.sort_by!(&:first)

Extensions.register do
  inline_macro do
    named :requirement_autoxref

    # Regex-based, will match "See Req-ROPR-123 for..."
    match /(Req-\w+-?\d+)/

    # match id with  Req-\w+-?(\d+)
    process do |parent, target|
      t = target.sub(/^Req-\w+-?/, '')

      orphan = true if reqs.empty?

      reqs.each do |id, text, path, _file_name, _line|
        orphan = false

        if id == t
          rpath = path
          rtext = text.gsub(/\A\[req,id=/, '')
          rtext = rtext.gsub(/,version=\d\]$/, '')
          break
        else
          orphan = true
        end
      end

      link = target.sub(/^Req-/, '')
      xref_base = (parent.document.attr 'xref-base')
      uri = "#{xref_base}/#{rpath}/index.html##{link}"
      o = ' <span class=\"label label-info\">'
      c = ' </span>'

      if orphan
        # docfile = parent.document.attr 'docname'
        # warn %(asciidoctor: WARNING: #{name || node.node_name} orphaned #{target} in #{docfile})
        (create_pass_block parent, %(<strong>#{target}</strong>), {},
                           content_model: :raw).convert
      else
        (create_anchor parent, %(#{o} Req. #{rtext} #{c}),
                       type: :link, target: uri).convert
      end
    end
  end
end

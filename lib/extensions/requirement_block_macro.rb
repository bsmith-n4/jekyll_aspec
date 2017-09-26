require 'asciidoctor'
require 'asciidoctor/extensions'
require_relative 'utils/req_macro_walker'

include ::Asciidoctor

# @example Requirement Block Macro Use
#   requirements::[]
class RequirementsBlockMacro < Extensions::BlockMacroProcessor
  use_dsl
  named :requirements

  # Read the parent attributes and create a list of requirements in an appendix style
  def process(parent, target, attrs)
    rows = Reqs.list_reqs
    content = %(<h2 id="requirements"><a class="anchor" href="#requirements"></a><a class="link" href="#requirements">Requirements</a></h2>
    <div class="panel panel-default"> <div class="panel-heading"><h4>Requirements</h4></div>
      <table class="table"> <thead> <tr>
        <th>#</th> <th>ID</th><th>Version</th> <th>Title</th> <th>Document</th>
      </tr> </thead>
      <tbody>
        #{rows.join}
      </tbody>
      </table> </div>)

    create_pass_block parent, content, {}
  end
end

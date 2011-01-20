module NodesHelper
  include MilestonesHelper
  
  def synopsis(node)
    # TODO there's probably a more canonical way to get this
    type = node.class.name
    # And these
    render :partial => "#{type.pluralize.downcase}/synopsis", :locals => {:"#{type.downcase}" => node}
  end
end
module XmlHelper
  def directed_relationships_xml(directed_rel_array)
    directed_rel_array.collect do |directed_rel|
      directed_rel.to_xml(:skip_instruct => true)
    end.join("\n")
  end
end
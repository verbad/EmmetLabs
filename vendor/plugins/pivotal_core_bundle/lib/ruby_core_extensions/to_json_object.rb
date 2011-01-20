module JsonToJsonObject
  def to_json_object(*)
    JSON.parse(to_json)
  end
end
class Object
  include JsonToJsonObject
end
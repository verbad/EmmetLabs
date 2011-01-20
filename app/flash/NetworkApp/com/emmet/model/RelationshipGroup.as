package com.emmet.model {
  import com.emmet.util.PeopleXmlParser;

  public class RelationshipGroup {

    private var _category:String;
    private var _directedRelationships:Array;

    public function RelationshipGroup(groupXML:XML, personTypeAndIdToPerson:Object) {
      _category = groupXML.@category_name;
      var directedRelationshipsXML:XMLList = groupXML.directed_relationship;
      _directedRelationships = new Array();
      for each (var directedRelationshipXML:XML in directedRelationshipsXML) {
        _directedRelationships.push(DirectedRelationship.fromXml(directedRelationshipXML, personTypeAndIdToPerson));
      }
    }

    public function get category():String { return _category; }
    public function get directedRelationships():Array { return _directedRelationships; }
    public function get descendantCount():Number { return directedRelationships.length;}
  }
}
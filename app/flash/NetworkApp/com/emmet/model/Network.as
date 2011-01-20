package com.emmet.model {
  import com.emmet.util.PeopleXmlParser;

  public class Network {
    private var _target:Person;
    private var _relationshipGroups:Array;
    private var _rootLevelGroups:Array;

    public function Network(networkXML:XML) {
      var personTypeAndIdToPerson:Object = new PeopleXmlParser().parse(networkXML);
      _target = personTypeAndIdToPerson[networkXML.target.@type + "_" + networkXML.target.@id];

      _rootLevelGroups = new Array();
      for each (var childXML:XML in networkXML.children()) {
        if (childXML.name() == "relationship_supergroup") {
          _rootLevelGroups.push(new RelationshipSupergroup(childXML, personTypeAndIdToPerson));
        } else if (childXML.name() == "relationship_group") {
          _rootLevelGroups.push(new RelationshipGroup(childXML, personTypeAndIdToPerson));
        }
      }

      _relationshipGroups = new Array();
      for each (var groupXML:XML in networkXML..relationship_group) {
        _relationshipGroups.push(new RelationshipGroup(groupXML, personTypeAndIdToPerson));
      }
    }

    public function get target():Person { return _target; }
    public function get relationshipGroups():Array { return _relationshipGroups; }
    public function get rootLevelGroups():Array { return _rootLevelGroups; }

    public function get descendantCount():Number {
      var total:Number = 0;
      for (var i:String in rootLevelGroups) {
        total += rootLevelGroups[i].descendantCount;
      }
      return total;
    }

    public function getRelationshipGroup(categoryName:String):RelationshipGroup {
      for (var i:int=0; i<_relationshipGroups.length; ++i) {
        if (_relationshipGroups[i].category == categoryName) {
          return _relationshipGroups[i];
        }
      }
      return null;
    }

    public function getRelationshipSupergroup(supercategoryName:String):RelationshipSupergroup {
      for (var i:int=0; i<_rootLevelGroups.length; ++i) {
        if (_rootLevelGroups[i] is RelationshipSupergroup && _rootLevelGroups[i].supercategory == supercategoryName) {
          return _rootLevelGroups[i];
        }
      }
      return null;
    }

  }
}
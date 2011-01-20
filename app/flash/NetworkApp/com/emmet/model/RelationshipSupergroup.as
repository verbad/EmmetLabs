package com.emmet.model {

  public class RelationshipSupergroup {

    private var _supercategory:String;
    private var _groups:Array;
    private var _supergroupXML:XML;

    public function RelationshipSupergroup(supergroupXML:XML, personTypeAndIdToPerson:Object) {
      _supergroupXML = supergroupXML;
      _supercategory = supergroupXML.@metacategory_name;
      _groups = new Array();
      for each (var groupXML:XML in supergroupXML.relationship_group) {
        _groups.push(new RelationshipGroup(groupXML, personTypeAndIdToPerson));
      }
    }

    public function get supercategory():String { return _supercategory; }
    public function get groups():Array { return _groups; }
    public function get descendantCount():Number {
      var total:Number = 0;
      for (var i:String in groups) {
        total += groups[i].descendantCount;
      }
      return total;
    }
  }
}
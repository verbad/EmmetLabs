package com.emmet.util {
  import com.emmet.model.DirectedRelationship;
  import com.emmet.model.GraphElement;
  import com.emmet.model.StubEvent;
  
  import flash.events.Event;

  public class WanderXmlParser {

    public static var XML_COMPLETE_EVENT:String = "XMLLoadComplete";

    public function parse(xml:XML):DirectedRelationship {
      var peopleParser:PeopleXmlParser = new PeopleXmlParser();
      var completedStubs:Array = new Array();

      var listener:Function = function (e:StubEvent):void {
        completedStubs.push(e.actee);
      }

      GraphElement.stubDispatcher.addEventListener(GraphElement.STUB_EVENT, listener);

      var personTypeAndIdToPerson:Object = peopleParser.parse(xml);

      var relationshipIdToRelationship:Object = {}
      for each (var directedRelationshipXml:XML in xml.directed_relationships.directed_relationship) {
        var relationship:DirectedRelationship = DirectedRelationship.fromXml(directedRelationshipXml, personTypeAndIdToPerson);
        relationshipIdToRelationship[relationship.id] = relationship;
      }
      var selectedId:int = xml.selected_directed_relationship.@id;
      var selected:DirectedRelationship = relationshipIdToRelationship[selectedId];
      selected.fetched();

      GraphElement.stubDispatcher.removeEventListener(GraphElement.STUB_EVENT, listener);

      for (var i:int = 0 ; i < completedStubs.length ; i++) {
          completedStubs[i].dispatchEvent(new Event(XML_COMPLETE_EVENT));
      }
      
      return selected;
    }
  }
}
package com.emmet.util {
  import com.emmet.model.DirectedRelationship;
  import com.emmet.model.Person;

  public class PeopleXmlParser {

    public function parse(xml:XML):Object {
      var personTypeAndIdToPerson:Object = {};
      for each (var personXml:XML in xml.nodes.children()) {
        var person:Person = Person.fromXml(personXml);
        personTypeAndIdToPerson[person.node_id] = person;
      }
      return personTypeAndIdToPerson;
    }
  }
}
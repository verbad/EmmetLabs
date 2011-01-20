package test.model {
  import asunit.framework.TestCase;
  import flash.display.*;
  import flash.geom.Rectangle;
  import com.emmet.model.Network;
  import com.emmet.model.RelationshipSupergroup;
  import com.emmet.model.RelationshipGroup;
  import com.emmet.model.DirectedRelationship;
  import com.emmet.model.Person;
  import test.FlashAppTestCase;
  import com.emmet.util.WanderXmlParser;

  public class DirectedRelationshipTest extends FlashAppTestCase {

    private var _directedRelationshipXML:XML;
    private var _directedRelationship:DirectedRelationship;

    protected override function setUp():void {
      _directedRelationshipXML = josephineToGraceExampleXML();
      _directedRelationship = new WanderXmlParser().parse(_directedRelationshipXML);
    }

    public function testFromDirectedRelationshipXML():void {
      assertEquals("/pair/Josephine-Baker/Grace-Kelly", _directedRelationship.url);

      var from:Person = _directedRelationship.from;
      assertEquals("Josephine Baker", from.name);

      var to:Person = _directedRelationship.to;
      assertEquals("Grace Kelly", to.name);
    }

    public function testLoadInboundRelationships():void {
      var relationship:DirectedRelationship = _directedRelationship.from.directedRelationships[2];
      assertNotNull(relationship);
      assertEquals("Ernest Hemingway", relationship.to.name);

      assertEquals(1, relationship.to.directedRelationships.length);
    }

    public function testInverseRelationship():void {
      var josephine:Person = new Person(1, "Josephine Baker", "http://www.example.com/1.jpg", "http://foo/bar1.html");
      var grace:Person = new Person(2, "Grace Kelly", "http://www.example.com/2.jpg", "http://foo/bar2.html");

      var josephineToGrace:DirectedRelationship = new DirectedRelationship(1, josephine, grace);
      var graceToJosephine:DirectedRelationship = new DirectedRelationship(2, grace, josephine);

      assertEquals(graceToJosephine, josephineToGrace.inverse());
    }

  }
}
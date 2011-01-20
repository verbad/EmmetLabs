package test.model {
  import asunit.framework.TestCase;
  import flash.display.*;
  import flash.geom.Rectangle;
  import com.emmet.model.Network;
  import com.emmet.model.RelationshipGroup;
  import flash.net.URLRequest;
  import test.FlashAppTestCase;
  import com.emmet.util.PeopleXmlParser;

  public class RelationshipGroupTest extends FlashAppTestCase {

    private var _groupXML:XML;
    private var _group:RelationshipGroup;

    protected override function setUp():void {
      _groupXML = josephineExampleXML()..relationship_group[0];
      _group = new RelationshipGroup(_groupXML, personTypeAndIdToPerson(josephineExampleXML()));
    }

    public function testCategory():void {
      assertEquals("Parent", _groupXML.@category_name);
      assertEquals("Parent", _group.category);
    }

    public function testDirectedRelationships():void {
      assertEquals(2, _group.directedRelationships.length);
      assertEquals("/pair/Josephine-Baker/Carrie-McDonald", _group.directedRelationships[0].url);
      assertEquals("Carrie McDonald", _group.directedRelationships[0].to.name);
      assertEquals("Eddie Carson", _group.directedRelationships[1].to.name);
    }
  }
}
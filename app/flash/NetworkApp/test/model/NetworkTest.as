package test.model {
  import asunit.framework.TestCase;
  import flash.display.*;
  import flash.geom.Rectangle;
  import com.emmet.model.Network;
  import com.emmet.model.RelationshipSupergroup;
  import com.emmet.model.RelationshipGroup;
  import test.FlashAppTestCase;

  public class NetworkTest extends FlashAppTestCase {

    private var _josephineXML:XML;
    private var _network:Network;

    protected override function setUp():void {
      _josephineXML = josephineExampleXML();
      _network = new Network(_josephineXML);
    }

    public function testRelationshipGroups():void {
      var list:XMLList = _josephineXML..relationship_group;
      assertEquals(5, list.length());
      assertEquals(5, _network.relationshipGroups.length);
    }

    public function testRootLevelGroups():void {
      var groups:Array = _network.rootLevelGroups;
      assertEquals(3, groups.length);
      assertTrue(groups[0] is RelationshipSupergroup);
      assertTrue(groups[1] is RelationshipGroup);
      assertTrue(groups[2] is RelationshipGroup);
    }

    public function testFrom():void {
      assertEquals("Josephine Baker", _network.target.name);
      assertEquals(7, _network.target.id);
      assertEquals("/network/Josephine-Baker", _network.target.networkUrl);
    }

    public function testGetRelationshipGroup():void {
      assertEquals("Parent", _network.getRelationshipGroup("Parent").category);
    }

    public function testGetRelationshipSupergroup():void {
      assertEquals("Family", _network.getRelationshipSupergroup("Family").supercategory);
    }
  }
}
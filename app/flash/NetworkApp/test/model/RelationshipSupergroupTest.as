package test.model {
  import asunit.framework.TestCase;
  import flash.display.*;
  import flash.geom.Rectangle;
  import com.emmet.model.Network;
  import com.emmet.model.RelationshipSupergroup;
  import test.FlashAppTestCase;

  public class RelationshipSupergroupTest extends FlashAppTestCase {

    private var _supergroupXML:XML;
    private var _supergroup:RelationshipSupergroup;

    protected override function setUp():void {
      _supergroupXML = josephineExampleXML()..relationship_supergroup[0];
      _supergroup = new RelationshipSupergroup(_supergroupXML, personTypeAndIdToPerson(josephineExampleXML()));
    }

    public function testSupercategory():void {
      assertEquals("Family", _supergroupXML.@metacategory_name);
      assertEquals("Family", _supergroup.supercategory);
    }

    public function testGroups():void {
      assertEquals(3, _supergroup.groups.length);
      assertEquals("Parent", _supergroup.groups[0].category);
      assertEquals("Child", _supergroup.groups[1].category);
      assertEquals("Partner", _supergroup.groups[2].category);
    }

  }
}
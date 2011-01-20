package test.network {
  import com.emmet.network.NetworkView;
  import com.emmet.model.Network;
  import com.emmet.network.World;
  import com.emmet.network.RelationshipSupergroupView;
  import test.FlashAppTestCase;
  import com.emmet.network.NetworkWorld;

  public class TreeViewTest extends FlashAppTestCase {

    protected var _network:Network;
    protected var _networkView:NetworkView;
    protected var _world:NetworkWorld;
    protected var _josephineFamilyView:RelationshipSupergroupView;

    protected override function setUp():void {
      _world = new NetworkWorld();
      _world.visible = false;
      addChild(_world);
      _network = new Network(josephineExampleXML());
      _networkView = new NetworkView(_network, _world);
      _josephineFamilyView = _networkView.childViews[0] as RelationshipSupergroupView;
    }

    protected override function tearDown():void {
      _world.disablePhysics();
      removeChild(_world);
    }

    public function testNumDescendants():void {
      assertNotNull(_josephineFamilyView);
      assertEquals(41, _josephineFamilyView.numDescendantTreeViews);
    }

  }
}
package test.wander {
  import test.FlashAppTestCase;
  import com.emmet.wander.Attractor;
  import com.emmet.network.Node;
  import com.emmet.util.DrawableView;
  import com.emmet.wander.WanderWorld;

  public class WanderWorldTest extends FlashAppTestCase {

    private var _world:WanderWorld;
    private var _node:Node;

    protected override function setUp():void {
      _world = new WanderWorld();
      _node = exampleNode();
    }

    protected override function tearDown():void {
      _world.disablePhysics();
    }

    public function testAddNodeAtSite():void {
      var site:Attractor = _world.leftPortraitSite;
      _world.addNodeAtSite(_node, site);

      assertXY(site.x, site.y, _node);
      assertTrue(site.targets.length == 0);
    }

  }
}
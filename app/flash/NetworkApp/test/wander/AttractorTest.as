package test.wander {
  import test.FlashAppTestCase;
  import com.emmet.wander.Attractor;
  import com.emmet.network.Node;
  import com.emmet.util.DrawableView;
  import com.emmet.wander.WanderWorld;

  public class AttractorTest extends FlashAppTestCase {
    private var _world:WanderWorld;
    private var _attractor:Attractor;
    private var _node1:Node;
    private var _node2:Node;

    protected override function setUp():void {
      _world = new WanderWorld();
      addChild(_world);

      _node1 = exampleNode();
      _world.addNode(_node1);
      _node2 = exampleNode();
      _world.addNode(_node2);

      _attractor = new Attractor();
      _world.addAttractor(_attractor);
      _attractor.x = 50;
      _attractor.y = 50;

      _attractor.attract(_node1);
      _attractor.attract(_node2);
    }

    protected override function tearDown():void {
      _world.disablePhysics();
      removeChild(_world);
    }

    public function testDetach():void {
      assertEquals(2, _attractor.targets.length);
      _attractor.detach(_node1);
      assertEquals(1, _attractor.targets.length);
    }

    public function testPosition():void {
      _attractor.position(_node1);
      assertXY(_attractor.x, _attractor.y, _node1);
    }

    public function testDistance2():void {
      assertRoughlyEquals(50 * 50 + 50 * 50, _attractor.distance2(_node1));
    }
  }
}
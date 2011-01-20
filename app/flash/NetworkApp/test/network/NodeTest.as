package test.network {
  import asunit.framework.TestCase;
  import com.emmet.network.Node;
  import test.FlashAppTestCase;
  import com.emmet.util.Vector;
  import flash.display.Sprite;
  import com.emmet.util.DrawableView;
  import com.emmet.network.World;
  import com.emmet.network.BoundingBox;
  import com.emmet.network.ColoredBall;

  public class NodeTest extends FlashAppTestCase {
    public var _node1:Node;
    public var _view1:DrawableView;
    public var _node2:Node;
    public var _world:World;

    protected override function setUp():void {
      _world = new World();
      _world.visible = false;
      addChild(_world);

      _view1 = new DrawableView();
      _view1.graphics.beginFill(0);
      _view1.graphics.drawRect(-5, -5, 10, 10);

      _node1 = new Node(_view1, 1, 1);
      _node1.x = 10;
      _node1.y = 0;
      _node1._velocity = new Vector(5, 0);
      _node2 = new Node(new DrawableView(), 1, 1);
      _node2.x = -5;
      _node2.y = 0;

      _world.addNode(_node1);
      _world.addNode(_node2);
    }

    protected override function tearDown():void {
      _world.disablePhysics();
      removeChild(_world);
    }

    public function testInfluence():void {
      assertAtPoint(Vector.ZERO, _node1.force);
      assertAtPoint(Vector.ZERO, _node2.force);
      _node1.influence(_node2);
      _node2.influence(_node1);
      assertAtPoint(_node1.force.scaleBy(-1), _node2.force);
      assertAtPoint(_node1.force, _node1.acceleration);
    }

    public function testBoundingBox():void {
      var box:BoundingBox = _node1.boundingBox;

      assertEquals(5, _view1.getBounds(_world).x);
      assertEquals(-5, _view1.getBounds(_world).y);
      assertEquals(10, _view1.getBounds(_world).width);
      assertEquals(10, _view1.getBounds(_world).height);

      assertEquals(_view1.getBounds(_world).x, box.x);
      assertEquals(_view1.getBounds(_world).y, box.y);
      assertEquals(_view1.getBounds(_world).width, box.width);
      assertEquals(_view1.getBounds(_world).height, box.height);
    }
  }
}
package test.network {
  import asunit.framework.TestCase;
  import com.emmet.network.Tether;
  import test.FlashAppTestCase;
  import com.emmet.network.Node;
  import com.emmet.util.Vector;
  import com.emmet.util.DrawableView;
  import com.emmet.network.ColoredBall;
  import flash.display.Sprite;
  import flash.profiler.heapDump;
  import flash.geom.Rectangle;
  import flash.display.DisplayObject;

  public class TetherTest extends FlashAppTestCase {
    public var _node1:Node;
    public var _node2:Node;
    public var _tether:Tether;

    protected override function setUp():void {
      _node1 = exampleNode();
      _node1.x = 10;
      _node1.y = 0;
      _node1._velocity = new Vector(5, 0);
      _node2 = new Node(new ColoredBall(), 1, 1);
      _node2.x = -5;
      _node2.y = 0;

      _tether = new Tether(_node1, _node2, 1, 100, 0.05, true);
    }

    public function testInfluence():void {
      assertAtPoint(Vector.ZERO, _node1.force);
      assertAtPoint(Vector.ZERO, _node2.force);

      _tether.influenceNodes();

      assertAtPoint(_node1.force.scaleBy(-1), _node2.force);
    }

    public function testDrawStopsShortOfColoredBallRadius():void {
      var ballRadius:Number = (_node2.view as ColoredBall).radius;
      assertXY(-5 + ballRadius, 0, _tether.drawTo);
    }
  }
}
package test.util {
  import asunit.framework.TestCase;
  import flash.display.Shape;
  import flash.display.DisplayObject;
  import flash.geom.Rectangle;
  import com.emmet.model.RelationshipGroup;
  import com.emmet.model.Network;
  import flash.geom.Point;
  import com.emmet.util.Vector;
  import test.FlashAppTestCase;

  public class VectorTest extends FlashAppTestCase {

    private var _up:Vector;
    private var _down:Vector;
    private var _right:Vector;
    private var _left:Vector;

    protected override function setUp():void {
      _up = Vector.fromPolar(-Math.PI/2, 250);
      _right = Vector.fromPolar(0, 100);
      _left = Vector.fromPolar(-Math.PI, 250);
      _down = Vector.fromPolar(Math.PI / 2, 250);
    }

    public function testFromPolar():void {
      assertXY(0, -250, _up);
      assertXY(100, 0, _right);

      var diagonal:Vector = Vector.fromPolar(Math.PI/3, 100);
      assertXY(50, 50*Math.sqrt(3), diagonal);
    }

    public function testFromCartesian():void {
      var cartesian:Vector = Vector.fromCartesian(29, 51);
      assertXY(29, 51, cartesian);
    }

    public function testScaleBy():void {
      var cartesian:Vector = Vector.fromCartesian(30, 60);
      assertXY(30, 60, cartesian);
      assertXY(15, 30, cartesian.scaleBy(0.5));
    }

    public function testSubtract():void {
      var cartesian1:Vector = Vector.fromCartesian(30, 60);
      var cartesian2:Vector = Vector.fromCartesian(70, 70);
      assertXY(40, 10, cartesian2.subtract(cartesian1));
    }

    public function testAngle():void {
      assertRoughlyEquals(-Math.PI/2, _up.angle);
      assertRoughlyEquals(0, _right.angle);
      assertRoughlyEquals(-Math.PI, _left.angle);
      assertRoughlyEquals(Math.PI/2, _down.angle);
    }

    public function testDirections():void {
      assertEquals(Vector.UPWARD, _up.primaryDirection);
      assertEquals(Vector.DOWNWARD, _down.primaryDirection);
      assertEquals(Vector.RIGHTWARD, _right.primaryDirection);
      assertEquals(Vector.LEFTWARD, _left.primaryDirection);
    }

    public function testMagnitude():void {
      assertEquals(100, _right.magnitude);
    }

    public function testNormalize(): void {
      assertEquals(1, _right.normalize().magnitude);
      var v:Vector = Vector.fromPolar(Math.PI / 3, 52).normalize();
      assertEquals(Math.PI / 3, v.angle);
      assertEquals(1, v.magnitude);
    }

  }
}
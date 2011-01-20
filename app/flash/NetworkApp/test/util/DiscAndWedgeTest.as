package test.util {
  import test.FlashAppTestCase;
  import com.emmet.util.Disc;
  import com.emmet.util.Wedge;
  import test.FlashAppTestCase;
  import com.emmet.util.Vector;
  import test.mocks.MockDescendantCountable;

  public class DiscAndWedgeTest extends FlashAppTestCase {

    private var _disc:Disc;

    protected override function setUp():void {
      _disc = new Disc(5);
    }

    public function testNew():void {
      assertEquals(5, _disc.numWedges);
      assertEquals((2*Math.PI) / 5, _disc.wedgeSize);
      assertEquals((-Math.PI/2) + _disc.wedgeSize/2, _disc.currentAngle);
    }

    public function testNextWedge():void {
       var wedge:Wedge = _disc.nextWedge();
       assertWedge(-Math.PI/2 + _disc.wedgeSize/2, -Math.PI/2 + 3*_disc.wedgeSize/2, wedge);
       assertEquals(wedge.maxAngle, _disc.currentAngle);

       var secondWedge:Wedge = _disc.nextWedge(2);
       assertWedge(wedge.maxAngle, wedge.maxAngle + _disc.wedgeSize * 2, secondWedge);
       assertEquals(secondWedge.maxAngle, _disc.currentAngle);
    }

    public function testMidpoint():void {
      var wedge:Wedge = new Wedge(-Math.PI / 2, Math.PI / 2);
      assertEquals(0, wedge.midpoint);
    }

    public function testBisectingVector():void {
      var wedge:Wedge = new Wedge(-Math.PI / 2, Math.PI / 2);
      var vector:Vector = wedge.bisectingVector(100);
      assertEquals(wedge.midpoint, vector.angle);
      assertEquals(100, vector.magnitude);
    }

    public function testSubwedges():void {
      var wedge:Wedge = new Wedge(0, 10);
      var expectedRemainder:Number = 4-Math.PI;
      var expectedRemainderEach:Number = expectedRemainder / 3;
      wedge.allocateSubwedges([new MockDescendantCountable(3), new MockDescendantCountable(4), new MockDescendantCountable(1), new MockDescendantCountable(2)]);
      assertWedge(0, 3 + expectedRemainderEach, wedge.nextSubwedge());
      assertWedge(3 + expectedRemainderEach, 3 + Math.PI + expectedRemainderEach, wedge.nextSubwedge());
      assertWedge(3 + Math.PI + expectedRemainderEach, 4 + Math.PI + expectedRemainderEach*2, wedge.nextSubwedge());
      assertWedge(4 + Math.PI + expectedRemainderEach*2, 10, wedge.nextSubwedge());
    }
  }
}
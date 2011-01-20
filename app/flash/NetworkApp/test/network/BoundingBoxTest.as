package test.network {
  import com.emmet.network.BoundingBox;
  import flash.geom.Rectangle;
  import test.FlashAppTestCase;

  public class BoundingBoxTest extends FlashAppTestCase {
    public var _box1:BoundingBox;
    public var _box2:BoundingBox;

    protected override function setUp():void {
      _box1 = new BoundingBox(new Rectangle(-5, -5 , 10, 10));
      _box2 = new BoundingBox(new Rectangle(10, -10, 10, 10));
    }

    public function testMinDistanceOverlapping():void {
      var otherBox:BoundingBox = new BoundingBox(new Rectangle(0, 0, 10, 10));
      assertEquals(BoundingBox.MIN_DISTANCE, _box1.minDistance(otherBox));

      var northEast:BoundingBox = new BoundingBox(new Rectangle(5, -10, 5, 5));
      assertEquals(BoundingBox.MIN_DISTANCE, _box1.minDistance(northEast));
    }

    public function testCorners():void {
      assertXY(5, -5, _box1.northEast);
      assertXY(5, 5, _box1.southEast);
      assertXY(-5, 5, _box1.southWest);
      assertXY(-5, -5, _box1.northWest);
    }

    public function testMinDistanceOrthoganol():void {
      var northOf1:BoundingBox = new BoundingBox(new Rectangle(-10, -1000, 7, 7));
      assertEquals(988, _box1.minDistance(northOf1));

      var eastOf1:BoundingBox = new BoundingBox(new Rectangle(100, -20, 5, 30));
      assertEquals(95, _box1.minDistance(eastOf1));

      var southOf1:BoundingBox = new BoundingBox(new Rectangle(0, 500, 10, 10));
      assertEquals(495, _box1.minDistance(southOf1));

      var westOf1:BoundingBox = new BoundingBox(new Rectangle(-505, 0, 5, 5));
      assertEquals(495, _box1.minDistance(westOf1));

      var northOf2:BoundingBox = new BoundingBox(new Rectangle(5, -30, 20, 10));
      assertEquals(10, _box2.minDistance(northOf2));
      var eastOf2:BoundingBox = new BoundingBox(new Rectangle(30, -5, 10, 10));
      assertEquals(10, _box2.minDistance(eastOf2));

      var southOf2:BoundingBox = new BoundingBox(new Rectangle(0, 500, 20, 10));
      assertEquals(500, _box2.minDistance(southOf2));

      var westOf2:BoundingBox = new BoundingBox(new Rectangle(-5, -5, 10, 10));
      assertEquals(5, _box2.minDistance(westOf2));
    }

    public function testMinDistanceDiagonal():void {
      var northEast:BoundingBox = new BoundingBox(new Rectangle(10, -15, 5, 5));
      assertRoughlyEquals(Math.sqrt(50), _box1.minDistance(northEast));

      var southEast:BoundingBox = new BoundingBox(new Rectangle(10, 10, 5, 5));
      assertRoughlyEquals(Math.sqrt(50), _box1.minDistance(southEast));

      var southWest:BoundingBox = new BoundingBox(new Rectangle(-15, 10, 5, 5));
      assertRoughlyEquals(Math.sqrt(50), _box1.minDistance(southWest));
      var northWest:BoundingBox = new BoundingBox(new Rectangle(-15, -15, 5, 5));
      assertRoughlyEquals(Math.sqrt(50), _box1.minDistance(northWest));
    }

 }
}
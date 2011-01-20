package com.emmet.network {
  import flash.geom.Rectangle;
  import flash.geom.Point;

  public class BoundingBox extends Rectangle {

    public static const MIN_DISTANCE:Number = 1;
    public static const MAX_DISTANCE:Number = 150000;

    public static const MAX:Rectangle = new Rectangle(-MAX_DISTANCE, -MAX_DISTANCE, 2 * MAX_DISTANCE, 2 * MAX_DISTANCE);

    protected var _northRegion:Rectangle;
    protected var _eastRegion:Rectangle;
    protected var _southRegion:Rectangle;
    protected var _westRegion:Rectangle;

    protected var _northEastRegion:Rectangle;
    protected var _southEastRegion:Rectangle;
    protected var _southWestRegion:Rectangle;
    protected var _northWestRegion:Rectangle;
    public function BoundingBox(rectangle:Rectangle) {
      super(rectangle.x, rectangle.y, rectangle.width, rectangle.height);

      _northRegion = new Rectangle(left, -MAX_DISTANCE, width, top + MAX_DISTANCE);
      _eastRegion = new Rectangle(right, top, MAX_DISTANCE - right, height);
      _southRegion = new Rectangle(left, bottom, width, MAX_DISTANCE - bottom);
      _westRegion = new Rectangle(-MAX_DISTANCE, top, right + MAX_DISTANCE, height);

      _northEastRegion = new Rectangle(_northRegion.right, _northRegion.top, _eastRegion.width, _northRegion.height);
      _southEastRegion = new Rectangle(_southRegion.right, _southRegion.top, _eastRegion.width, _southRegion.height);
      _southWestRegion = new Rectangle(_westRegion.left, _westRegion.bottom, _westRegion.width, _southRegion.height);
      _northWestRegion = new Rectangle(_westRegion.left, _northRegion.top, _westRegion.width, _northRegion.height);
    }

    public function get northEast():Point { return new Point(right, top); }
    public function get southEast():Point { return bottomRight; }
    public function get southWest():Point { return new Point(left, bottom); }
    public function get northWest():Point { return topLeft; }

    public function minDistance(otherBox:BoundingBox):Number {
      var actualMinDistance:Number = actualMinDistance(otherBox);
      if (actualMinDistance == 0) return MIN_DISTANCE;
      return actualMinDistance;
    }

    protected function actualMinDistance(otherBox:BoundingBox):Number {
      if (!MAX.containsRect(otherBox)) {
        throw "Bounding box is out of distance calculation region.";
      }

      if (intersects(otherBox)) {
        return MIN_DISTANCE;
      }

      if (_northRegion.intersects(otherBox)) {
        return top - otherBox.bottom;
      }

      if (_eastRegion.intersects(otherBox)) {
        return otherBox.left - right;
      }

      if (_southRegion.intersects(otherBox)) {
        return otherBox.top - bottom;
      }

      if (_westRegion.intersects(otherBox)) {
        return left - otherBox.right;
      }

      if (_northEastRegion.intersects(otherBox)) {
        return Point.distance(otherBox.southWest, northEast);
      }

      if (_southEastRegion.intersects(otherBox)) {
        return Point.distance(otherBox.northWest, southEast);
      }

      if (_southWestRegion.intersects(otherBox)) {
        return Point.distance(otherBox.northEast, southWest);
      }

      if (_northWestRegion.intersects(otherBox)) {
        return Point.distance(otherBox.southEast, northWest);
      }

      return MIN_DISTANCE;
    }

  }
}
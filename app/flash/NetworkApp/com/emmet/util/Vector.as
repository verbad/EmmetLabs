package com.emmet.util {
  import flash.display.DisplayObject;

  public class Vector {
    private var _x:Number;
    private var _y:Number;
    private var _angle:Number;
    private var _radius:Number;

    public static const UPWARD:int = 1;
    public static const DOWNWARD:int = 2;
    public static const RIGHTWARD:int = 3;
    public static const LEFTWARD:int = 4;

    public static const ZERO:Vector = new Vector(0, 0);

    public function Vector(x:Number, y:Number) {
      _x = x;
      _y = y;
    }

    public function get x():Number { return _x; }
    public function get y():Number { return _y; }
    public function get angle():Number { return Math.atan2(_y, _x); }
    public function get radius():Number { return Math.sqrt(x*x + y*y); }
    public function get magnitude():Number { return radius; }
    public function get magnitude2():Number { return x*x + y*y; }
    public static function fromCartesian(x:Number, y:Number):Vector {
      return new Vector(x, y);
    }

    public static function fromPositionOf(thingWithXY:Object):Vector {
      return Vector.fromCartesian(thingWithXY.x, thingWithXY.y);
    }

    public static function fromPolar(angle:Number, radius:Number):Vector {
      return new Vector(radius * Math.cos(angle), radius * Math.sin(angle));
    }

    public function position(object:DisplayObject):void {
      object.x = x;
      object.y = y;
    }

    public function scaleBy(scalingFactor:Number):Vector {
      return Vector.fromCartesian(x * scalingFactor, y * scalingFactor);
    }

    public function normalize():Vector {
      return new Vector(x / magnitude, y / magnitude);
    }

    public function add(addedVector:Vector):Vector {
      return Vector.fromCartesian(x + addedVector.x, y + addedVector.y);
    }

    public function subtract(subtractedVector:Vector):Vector {
      return Vector.fromCartesian(x - subtractedVector.x, y - subtractedVector.y);
    }

    public function get primaryDirection():int {
      if (angle < (- 3*Math.PI / 4)) {
        return Vector.LEFTWARD;
      } else if (angle < -Math.PI / 4) {
        return Vector.UPWARD;
      } else if (angle < Math.PI / 4) {
        return Vector.RIGHTWARD;
      } else if (angle < 3*Math.PI / 4) {
        return Vector.DOWNWARD;
      } else {
        return Vector.LEFTWARD;
      }
    }
  }
}
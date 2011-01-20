package com.emmet.util {
  public class Disc {
    private var _numWedges:int;
    private var _currentAngle:Number;
    private var _wedgeSize:Number;

    public function Disc(numWedges:int) {
      _numWedges = numWedges;
      _wedgeSize = (2 * Math.PI) / numWedges;
      _currentAngle = (-Math.PI / 2) + (_wedgeSize / 2);
    }

    public function get numWedges():int { return _numWedges; }
    public function get currentAngle():Number { return _currentAngle; }
    public function get wedgeSize():Number { return _wedgeSize; }

    public function nextWedge(span:int = 1):Wedge {
      var wedge:Wedge =  new Wedge(currentAngle, currentAngle + wedgeSize * span);
      _currentAngle += wedgeSize * span;
      return wedge;
    }
  }
}
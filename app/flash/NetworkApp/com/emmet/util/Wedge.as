package com.emmet.util {
  import com.emmet.network.TreeView;

  public class Wedge {
    private var _minAngle:Number;
    private var _maxAngle:Number;
    private var _currentSubwedgeAngle:Number;
    private var _subwedgeIndex:Number = 0;
    private var _subwedgeSizes:Array = [];

    public function Wedge(minAngle:Number, maxAngle:Number) {
      _minAngle = minAngle;
      _maxAngle = maxAngle;
    }

    public function get minAngle():Number { return _minAngle; }
    public function get maxAngle():Number { return _maxAngle; }

    public function get midpoint():Number {
      return (minAngle + maxAngle) / 2;
    }

    public function get angleSpan():Number {
      return (maxAngle - minAngle);
    }

    public function allocateSubwedges(children:Array):void {
      _currentSubwedgeAngle = minAngle;
      var numSubwedges:Number = children.length;
      var totalDescendentCount:Number = 0;
      for (var i:String in children) {
        totalDescendentCount += children[i].descendantCount;
      }

      var remainder:Number = 0;
      var indexWithRemainder:Number = -1;
      for (var j:Number = 0; j < children.length; j++) {
        var angle:Number = angleSpan * children[j].descendantCount / totalDescendentCount;
        if (angle> Math.PI) {
          remainder = angle - Math.PI;
          indexWithRemainder = j;
          angle = Math.PI;
        }
        _subwedgeSizes[j] = angle;
      }

      if (indexWithRemainder >= 0 && children.length > 1) {
        var remainderEach:Number = remainder/(children.length - 1);
        for (var k:Number = 0; k < children.length; k++) {
          if (k != indexWithRemainder) {
            _subwedgeSizes[k] += remainderEach;
          }
        }
      }
    }

    public function nextSubwedge():Wedge {
      var subwedge:Wedge = new Wedge(_currentSubwedgeAngle, _currentSubwedgeAngle + _subwedgeSizes[_subwedgeIndex]);
      _currentSubwedgeAngle += _subwedgeSizes[_subwedgeIndex++];
      return subwedge;
    }

    public function bisectingVector(magnitude:Number):Vector {
      return Vector.fromPolar(midpoint, magnitude);
    }
  }
}
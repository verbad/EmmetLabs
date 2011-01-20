package com.emmet.network {
  import flash.display.Sprite;
  import com.emmet.util.Vector;
  import flash.geom.Rectangle;

  public class Tether extends Sprite {
    public static const COLOR:Number = 0x666666;
    public static const THICKNESS:Number = 0.25;

    public static const HIGHLIGHT_THICKNESS:Number = 3;
    public static const HIGHLIGHT_COLOR:Number = 0x0099CC;

    private var _from:Node;
    private var _to:Node;
    private var _numNodesSupporting:Number;
    private var _length:Number;
    private var _drawsItself:Boolean;
    private var _spring:Number;
    private var _highlighted:Boolean;

    public function Tether(from:Node, to:Node, numNodesSupporting:Number, length:Number, spring:Number, drawsItself:Boolean) {
      _from = from;
      _to = to;
      _numNodesSupporting = numNodesSupporting;
      _length = length;
      _spring = spring;
      _drawsItself = drawsItself;

      draw();
    }

    public function get from():Node { return _from; }
    public function get to():Node { return _to; }
    public function get drawsItself():Boolean { return _drawsItself; }

    public function influenceNodes():void {
      var delta:Vector = to.delta(from);
      var distance:Number = to.distance(from);
      var force:Vector = Vector.fromPolar(delta.angle, springForce(distance));

      if (!from.ghostly && to.ghostly) {
        to.applyForce(force.scaleBy(-1));
      } else if (!to.ghostly && from.ghostly) {
        from.applyForce(force);
      } else {
        to.applyForce(force.scaleBy(-1));
        from.applyForce(force);
      }
    }

    protected function springForce(distance:Number):Number {
      return _spring * _numNodesSupporting * (distance - _length);
    }

    public function draw():void {
      if (!drawsItself) return;
      graphics.clear();
      if (_highlighted) {
        graphics.lineStyle(HIGHLIGHT_THICKNESS, HIGHLIGHT_COLOR);
      } else {
        graphics.lineStyle(THICKNESS, COLOR);
      }
      graphics.moveTo(from.x, from.y);
      var terminusVector:Vector = terminusVector;
      graphics.lineTo(drawTo.x, drawTo.y);
    }

    public function get drawTo():Vector {
      var toVector:Vector = Vector.fromPositionOf(to);
      if (to.view is ColoredBall) {
        var directionVector:Vector = toVector.subtract(Vector.fromPositionOf(from));
        return toVector.subtract(Vector.fromPolar(directionVector.angle, (to.view as ColoredBall).radius));
      } else {
        return toVector;
      }
    }

    public function highlight():void {
      _highlighted = true;
      draw();
    }

    public function unhighlight():void {
      _highlighted = false;
      draw();
    }

  }
}
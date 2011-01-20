package com.emmet.wander {
  import flash.display.Sprite;
  import com.emmet.network.Portrait;
  import com.emmet.util.Vector;
  import com.emmet.network.Node;
  import com.emmet.util.ArrayUtils;
  import flash.events.Event;

  public class Attractor extends Sprite {

    private static const ATTRACTION:Number = 1;

    private var _targets:Array;
    public var world:WanderWorld;

    public function Attractor() {
      _targets = [];
    }
    public function get targets():Array { return _targets; }

    private function get location():Vector {
      return Vector.fromPositionOf(this);
    }
    public function position(node:Node):void {
      node.x = x;
      node.y = y;
    }

    public function attach(node:Node):void {
      position(node);
      attract(node);
    }

    public function attract(node:Node):void {
      _targets.push(node);
    }

    public function detach(node:Node):void {
      _targets = ArrayUtils.removeFromArray(_targets, node);
    }

    public function influenceTargets():void {
      for (var i:String in _targets) {
        influenceTarget(_targets[i] as Node);
      }
    }

    public function distance2(node:Node):Number {
      return (Vector.fromPositionOf(this).subtract(Vector.fromPositionOf(node))).magnitude2;
    }

    private function influenceTarget(target:Node):void {
      var delta:Vector = Vector.fromPositionOf(target).subtract(location);
      var distance:Number = delta.magnitude;

      var force:Vector = Vector.fromPolar(delta.angle, attractiveForce(distance)).scaleBy(-1);
      target.applyForce(force);
    }

    private function attractiveForce(distance:Number):Number {
      return distance * ATTRACTION;
    }
  }
}
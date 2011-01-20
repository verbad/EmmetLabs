package com.emmet.network {
  import flash.display.Sprite;
  import com.emmet.util.Vector;
  import flash.display.BlendMode;
  import flash.geom.Point;
  import com.emmet.wander.Attractor;

  public class Node extends Sprite {
    public static const DEFAULT_REPULSION:Number= 13000;

    protected var _view:Sprite;
    protected var _mass:Number;
    protected var _force:Vector;
    public var _velocity:Vector;
    protected var _repulsion:Number;
    private var _attractor:Attractor;
    private var _world:World;
    private var _stationary:Boolean;

    public function Node(view:Sprite, mass:Number, repulsion:Number, stationary:Boolean = false) {
      _mass = mass;
      _force = Vector.ZERO;
      _velocity = Vector.ZERO;
      _view = view;
      _repulsion = repulsion;
      _stationary = stationary;
    }

    public function get mass():Number { return _mass; }
    public function get force():Vector { return _force; }
    public function get acceleration():Vector { return _force; }
    public function get velocity():Vector { return _velocity; }
    public function get stationary():Boolean { return _stationary; }
    public function get displacement():Vector { return new Vector(x, y); }
    public function get attractor():Attractor { return _attractor; }
    public function get world():World { return _world; }
    public function set world(theWorld:World):void {
      _world = theWorld;
      if (_view != null) addChild(_view);
    }

    public function get ghostly():Boolean {
      return mass < 1;
    }

    public function applyForce(force:Vector):void {
      if (stationary) { return; }

      _force = _force.add(force);
    }

    public function get view():Sprite { return _view; }

    public function set view(view:Sprite):void {
      if (view != null) {
        removeChild(_view);
        _view = view;
        addChild(_view);
      }
    }

    public function attachAttractor(attractor:Attractor):void {
      _attractor = attractor;
      addChild(attractor);
    }

    public function updatePosition():void {
      _velocity = _velocity.add(acceleration);
      _velocity = _velocity.scaleBy(1 - _world.friction);
      x += velocity.x;
      y += velocity.y;
    }

    public function delta(otherNode:Node):Vector {
      var delta:Vector = displacement.subtract(otherNode.displacement);
      if (delta.x == 0 && delta.y == 0) return Vector.fromCartesian(0.00001, 0.00001);
      return delta;
    }

    public function resetForce():void {
      _force = Vector.ZERO;
    }

    public function get boundingBox():BoundingBox {
      return new BoundingBox(_view.getBounds(parent));
    }

    public function distance(otherNode:Node):Number {
      return delta(otherNode).magnitude;
    }

    public function influence(otherNode:Node):void {
      var delta:Vector = delta(otherNode);
      var distance:Number = distance(otherNode);
      var force:Vector = Vector.fromPolar(delta.angle, -_repulsion / (distance * distance + 1));
      if (ghostly) {
        if (otherNode.ghostly) {
          otherNode.applyForce(force);
        }
      } else {
        otherNode.applyForce(force);
      }
    }

    public function highlight():void {
      if (view is Highlightable) {
        (view as Highlightable).highlight();
      }
    }

    public function unhighlight():void {
      if (view is Highlightable) {
        (view as Highlightable).unhighlight();
      }
    }
  }
}
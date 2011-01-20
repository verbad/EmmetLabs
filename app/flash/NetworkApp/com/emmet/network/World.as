package com.emmet.network {
  import com.emmet.util.DrawableView;
  import flash.events.Event;
  import com.emmet.util.ArrayUtils;

  public class World extends DrawableView {

    public static const EXTRA_HIGHLIGHT_COLOR:Number = 0xB9532E;

    private var _nodes:Array;

    public function World() {
      enablePhysics();

      _nodes = [];
    }
    public function get friction():Number { throw "Implement in subclass"; }
    public function get velocityCutoff():Number { throw "Implement in subclass"; }
    public function get stopPhysicsAfterStabilize():Boolean { return false; }
    public function get nodes():Array { return _nodes; }

    public function addNode(node:Node):void {
      nodes.push(node);
      node.world = this;
      addChild(node);
    }

    public function enablePhysics():void {
      if (!hasEventListener(Event.ENTER_FRAME)) {
        addEventListener(Event.ENTER_FRAME, updatePhysics);
      }
    }

    public function removeNode(node:Node):void {
      _nodes = ArrayUtils.removeFromArray(_nodes, node);
      removeChild(node);
    }

    protected function updatePhysics(event:Event):void {
      resetForces();
      calculateInfluences();
      updatePositions();
    }

    protected function resetForces():void {
      for (var i:String in nodes) {
        nodes[i].resetForce();
      }
    }

    protected function calculateInfluences():void {
    }

    public function disablePhysics():void {
      removeEventListener(Event.ENTER_FRAME, updatePhysics);
    }

    public function advance(frames:int):void {
      for (var i:int = 0; i < frames; i++) {
        dispatchEvent(new Event(Event.ENTER_FRAME));
      }
    }
    public function isNodePresent(node:Node):Boolean {
      return _nodes.indexOf(node) != -1;
    }
    protected function updatePositions():void {
      var totalVelocity:Number = 0;
      for (var i:String in nodes) {
        nodes[i].updatePosition();
        totalVelocity += nodes[i].velocity.magnitude2;
      }
      if (stopPhysicsAfterStabilize && totalVelocity < velocityCutoff) {
        disablePhysics();
      }
    }
  }
}
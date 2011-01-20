package com.emmet.wander {
  import com.emmet.model.Person;
  import com.emmet.model.DirectedRelationship;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.external.ExternalInterface;
  import com.emmet.util.Vector;

  public class ExtendedRelationshipController {
    private var _world:WanderWorld;
    private var _directedRelationship:DirectedRelationship;
    private var _relationshipSite:Attractor;
    private var _fromNode:PersonNode;
    private var _toNode:PersonNode;
    private var _line:Line;
    private var _directedRelationshipController:DirectedRelationshipController;
    private var _offstageExit:Attractor;

    public function ExtendedRelationshipController(world:WanderWorld, directedRelationship:DirectedRelationship, fromNode:PersonNode, toNode:PersonNode, line:Line, relationshipSite:Attractor, directedRelationshipController:DirectedRelationshipController) {
      _world = world;
      _directedRelationship = directedRelationship;
      _fromNode = fromNode;
      _toNode = toNode;
      _relationshipSite = relationshipSite;
      _line = line;
      _directedRelationshipController = directedRelationshipController;

      relationshipSite.attract(extendedNode);
      addEventListeners();
    }

    public function get directedRelationship():DirectedRelationship { return _directedRelationship; }
    public function get fromNode():PersonNode { return _fromNode; }
    public function get toNode():PersonNode { return _toNode; }
    public function get line():Line { return _line; }
    public function get relationshipSite():Attractor { return _relationshipSite; }
    public function get world():WanderWorld { return _world; }
    public function get extendedNode():PersonNode { throw "Implement in subclass"; }
    public function get portraitNode():PersonNode { throw "Implement in subclass"; }
    public function get offstageWing():Attractor { throw "Implement in subclass"; }
    public function get directedRelationshipController():DirectedRelationshipController { return _directedRelationshipController; }

    public function set relationshipSite(newSite:Attractor):void {
      _relationshipSite.detach(extendedNode);
      _relationshipSite = newSite;
      _relationshipSite.attract(extendedNode);
    }
    public function loadExtendedRelationships(onComplete:Function):void {
      directedRelationship.loadExtendedRelationships(onComplete);
    }

    public function exitWorldToWing():void {
      line.visible = false;
      exitWorld(offstageWing);
    }

    public function exitWorld(offstage:Attractor):void {
      _offstageExit = offstage;
      world.addEventListener(Event.ENTER_FRAME, exitWorldOnCollision);
      relationshipSite = _offstageExit;
      fadeOut();
    }

    private function exitWorldOnCollision(event:Event):void {
      if (_offstageExit.distance2(extendedNode) < 1) {
        world.removeEventListener(Event.ENTER_FRAME, exitWorldOnCollision);
        world.removeLine(line);
        world.removeNode(extendedNode);
        _offstageExit = null;
      }
    }

    public function fadeOut():void {
      new FadeEffect(line, FadeEffect.OUT);
      new FadeEffect(extendedNode, FadeEffect.OUT);
    }

    public function fadeIn():void {
      new FadeEffect(line, FadeEffect.IN);
      new FadeEffect(extendedNode, FadeEffect.IN);
    }

    private function addEventListeners():void {
      addEventListener(MouseEvent.CLICK, onClick);
      addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
      addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
    }

    public function removeEventListeners():void {
      removeEventListener(MouseEvent.CLICK, onClick);
      removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
      removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
    }

    protected function addEventListener(eventType:String, fn:Function):void {
      if (extendedNode.hasEventListener(eventType)) throw "There is already an event listener of type " + eventType;
      if (line.hasEventListener(eventType)) throw "There is already an event listener of type " + eventType;
      extendedNode.addEventListener(eventType, fn);
      line.addEventListener(eventType, fn);
    }

    protected function removeEventListener(eventType:String, fn:Function):void {
      if (!extendedNode.hasEventListener(eventType)) {
        throw "There is no event listener of type " + eventType;
      }

      if (!line.hasEventListener(eventType)) {
        throw "There is no event listener of type " + eventType;
      }

      extendedNode.removeEventListener(eventType, fn);
      line.removeEventListener(eventType, fn);
    }

    protected function onClick(event:Event):void {
      ExternalInterface.call('ajaxRequest', directedRelationship.url);
      extendedNode.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT));
    }

    protected function onMouseOver(event:Event):void {
      highlight();
    }

    protected function onMouseOut(event:Event):void {
      unhighlight();
    }

    protected function highlight():void {
      line.highlight();
      extendedNode.highlight();
      portraitNode.highlight();
    }

    protected function unhighlight():void {
      line.unhighlight();
      extendedNode.unhighlight();
      portraitNode.unhighlight();
    }

    protected function extraHighlight():void {
      line.extraHighlight();
      extendedNode.extraHighlight();
      portraitNode.extraHighlight();
    }

    public function startBlinking():void {
      extraHighlight();
    }

    public function stopBlinking():void {
      unhighlight();
    }
  }
}
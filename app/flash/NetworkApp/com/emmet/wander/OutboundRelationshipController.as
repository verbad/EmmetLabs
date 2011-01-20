package com.emmet.wander {
  import com.emmet.model.DirectedRelationship;
  import flash.events.Event;

  public class OutboundRelationshipController extends ExtendedRelationshipController {
    public static function buildFromDirectedRelationship(world:WanderWorld, directedRelationship:DirectedRelationship, fromNode:PersonNode, relationshipSite:Attractor, directedRelationshipController:DirectedRelationshipController, startSite:Attractor):OutboundRelationshipController {
      var toNode:PersonNode = new PersonNode(directedRelationship.to, PersonNode.LABEL, false);
      var line:Line = new Line(fromNode, toNode);
      world.addLine(line);
      world.addNodeAtSite(toNode, startSite);
      world.moveToBack(toNode);
      world.moveToBack(line);
      var outboundRelationshipController:OutboundRelationshipController = new OutboundRelationshipController(world, directedRelationship, fromNode, toNode, line, relationshipSite, directedRelationshipController);
      outboundRelationshipController.fadeIn();
      return outboundRelationshipController;
    }

    public function OutboundRelationshipController(world:WanderWorld, directedRelationship:DirectedRelationship, fromNode:PersonNode, toNode:PersonNode, line:Line, relationshipSite:Attractor, directedRelationshipController:DirectedRelationshipController) {
      super(world, directedRelationship, fromNode, toNode, line, relationshipSite, directedRelationshipController);
    }

    public override function get extendedNode():PersonNode { return toNode; }
    public override function get portraitNode():PersonNode { return fromNode; }
    public override function get offstageWing():Attractor { return world.offstageRight; }

    public function detachToNode():void {
      relationshipSite.detach(toNode);
    }

    protected override function onClick(event:Event):void {
      super.onClick(event);
      directedRelationshipController.transitionToLeft(this);
    }
  }
}
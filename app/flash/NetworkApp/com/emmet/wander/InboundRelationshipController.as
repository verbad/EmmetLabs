package com.emmet.wander {
  import com.emmet.model.DirectedRelationship;
  import com.emmet.network.Node;
  import com.emmet.network.FuzzyLabel;
  import flash.events.Event;
  import flash.events.MouseEvent;

  public class InboundRelationshipController extends ExtendedRelationshipController {
    public static function buildFromDirectedRelationship(world:WanderWorld, directedRelationship:DirectedRelationship, toNode:PersonNode, relationshipSite:Attractor, directedRelationshipController:DirectedRelationshipController, startSite:Attractor):InboundRelationshipController {
      directedRelationship = directedRelationship.inverse();
      var fromNode:PersonNode = new PersonNode(directedRelationship.from, PersonNode.LABEL, true);
      var line:Line = new Line(fromNode, toNode);

      world.addLine(line);
      world.addNodeAtSite(fromNode, startSite);
      world.moveToBack(fromNode);
      world.moveToBack(line);

      var inboundRelationshipController:InboundRelationshipController = new InboundRelationshipController(world, directedRelationship, fromNode, toNode, line, relationshipSite, directedRelationshipController);
      inboundRelationshipController.fadeIn();
      return inboundRelationshipController;
    }

    public function InboundRelationshipController(world:WanderWorld, directedRelationship:DirectedRelationship, fromNode:PersonNode, toNode:PersonNode, line:Line, relationshipSite:Attractor, directedRelationshipController:DirectedRelationshipController) {
      super(world, directedRelationship, fromNode, toNode, line, relationshipSite, directedRelationshipController);
    }

    public override function get extendedNode():PersonNode { return fromNode; }
    public override function get portraitNode():PersonNode { return toNode; }
    public override function get offstageWing():Attractor { return world.offstageLeft; }

    public function detachFromNode():void {
      relationshipSite.detach(fromNode);
    }

    protected override function onClick(event:Event):void {
      super.onClick(event);
      directedRelationshipController.transitionToRight(this);
    }

  }
}
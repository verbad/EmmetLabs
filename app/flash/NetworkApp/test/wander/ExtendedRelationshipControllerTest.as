package test.wander {
  import test.FlashAppTestCase;
  import com.emmet.wander.InboundRelationshipController;
  import com.emmet.wander.OutboundRelationshipController;
  import flash.events.MouseEvent;
  import com.emmet.model.DirectedRelationship;
  import com.emmet.wander.DirectedRelationshipController;
  import com.emmet.wander.WanderWorld;

  public class ExtendedRelationshipControllerTest extends FlashAppTestCase {
    private var _world:WanderWorld;
    private var _directedRelationship:DirectedRelationship;
    private var _directedRelationshipController:DirectedRelationshipController;
    private var _inboundRelationshipController:InboundRelationshipController;
    private var _outboundRelationshipController:OutboundRelationshipController;

    protected override function setUp():void {
      _world = new WanderWorld();
      _directedRelationship = josephineToGraceDirectedRelationship();
      _directedRelationshipController = DirectedRelationshipController.fromModel(_world, _directedRelationship);
      _inboundRelationshipController = _directedRelationshipController.inboundRelationshipControllers[0];
      _outboundRelationshipController = _directedRelationshipController.outboundRelationshipControllers[0];
    }

    protected override function tearDown():void {
      _world.disablePhysics();
    }

    public function testRemoveClickEventListener():void {
      assertTrue(_inboundRelationshipController.fromNode.hasEventListener(MouseEvent.CLICK));
      assertTrue(_outboundRelationshipController.toNode.hasEventListener(MouseEvent.CLICK));
      _inboundRelationshipController.removeEventListeners();
      _outboundRelationshipController.removeEventListeners();
      assertFalse(_inboundRelationshipController.fromNode.hasEventListener(MouseEvent.CLICK));
      assertFalse(_outboundRelationshipController.toNode.hasEventListener(MouseEvent.CLICK));
    }

  }

}
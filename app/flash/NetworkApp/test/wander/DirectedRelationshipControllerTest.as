package test.wander {
  import test.FlashAppTestCase;
  import com.emmet.wander.Attractor;
  import com.emmet.network.Node;
  import com.emmet.util.DrawableView;
  import com.emmet.wander.WanderWorld;
  import com.emmet.wander.PersonNode;
  import com.emmet.wander.Line;
  import flash.events.Event;
  import flash.utils.Timer;
  import flash.events.TimerEvent;
  import com.emmet.wander.XMLLoader;
  import com.emmet.wander.DirectedRelationshipController;
  import com.emmet.model.DirectedRelationship;
  import com.emmet.wander.InboundRelationshipController;
  import com.emmet.wander.ExtendedRelationshipController;
  import com.emmet.wander.OutboundRelationshipController;
  import flash.events.MouseEvent;
  import com.emmet.util.UrlNavigation;
  import test.mocks.MockUrlNavigation;

  public class DirectedRelationshipControllerTest extends FlashAppTestCase {
    private var _world:WanderWorld;
    private var _directedRelationship:DirectedRelationship;
    private var _directedRelationshipController:DirectedRelationshipController;
    private var _lastTransitionTarget:ExtendedRelationshipController;

    protected override function setUp():void {
      _world = new WanderWorld();
      _directedRelationship = josephineToGraceDirectedRelationship();
      _directedRelationshipController = DirectedRelationshipController.fromModel(_world, _directedRelationship);

      _world.advance(60);
    }

    protected override function tearDown():void {
      _world.disablePhysics();
    }

    public function testRemoveEventListeners():void {

      for (var i:String in _directedRelationshipController.extendedRelationshipControllers) {
        var extendedRelController:ExtendedRelationshipController = _directedRelationshipController.extendedRelationshipControllers[i];
        assertTrue(extendedRelController.extendedNode.hasEventListener(MouseEvent.CLICK));
        assertTrue(extendedRelController.line.hasEventListener(MouseEvent.CLICK));
      }

      assertFalse(_directedRelationshipController.leftPortrait.hasEventListener(MouseEvent.CLICK));
      assertFalse(_directedRelationshipController.rightPortrait.hasEventListener(MouseEvent.CLICK));
      _directedRelationshipController.removeEventListeners();

      for (i in _directedRelationshipController.extendedRelationshipControllers) {
        extendedRelController = _directedRelationshipController.extendedRelationshipControllers[i];
        assertFalse(extendedRelController.extendedNode.hasEventListener(MouseEvent.CLICK));
        assertFalse(extendedRelController.line.hasEventListener(MouseEvent.CLICK));
      }

      assertFalse(_directedRelationshipController.leftPortrait.hasEventListener(MouseEvent.CLICK));
      assertFalse(_directedRelationshipController.rightPortrait.hasEventListener(MouseEvent.CLICK));
    }

    public function testInitialLayout():void {
      assertNoRelationshipSiteHasPotraitLabel();

      // Josephine node in portrait mode is at left portrait site
      var josephineNode:PersonNode = findPersonNode("Josephine Baker");
      assertNotNull(josephineNode);
      assertEquals(PersonNode.PORTRAIT, josephineNode.mode);
      assertAttached(_world.leftPortraitSite, josephineNode);

      // Grace node in portrait mode is at right portrait site
      var graceNode:PersonNode = findPersonNode("Grace Kelly");
      assertNotNull(graceNode);
      assertEquals(PersonNode.PORTRAIT, graceNode.mode);
      assertAttached(_world.rightPortraitSite, graceNode);
      assertNotNull(findLineBetween(josephineNode, graceNode));

      // Langston node in name mode exists at a left relationship site
      var langstonNode:PersonNode = findPersonNode("Langston Hughes");
      assertNotNull(langstonNode);
      assertEquals(PersonNode.LABEL, langstonNode.mode);
      assertRoughlyEquals(_world.leftRelationshipSites[0].x, langstonNode.x, 0.5);

      assertNotNull(findLineBetween(langstonNode, josephineNode));

      // Ernest node in name mode exists at a left relationship site
      var ernestNode:PersonNode = findPersonNode("Ernest Hemingway");
      assertNotNull(ernestNode);
      assertEquals(PersonNode.LABEL, ernestNode.mode);
      assertRoughlyEquals(_world.leftRelationshipSites[0].x, ernestNode.x, 0.5);
      assertNotNull(findLineBetween(ernestNode, josephineNode));
      //  Angela Martin node in name mode exists at a right relationship site
      var angelaNode:PersonNode = findPersonNode("Angela Martin");
      assertNotNull(angelaNode);
      assertEquals(PersonNode.LABEL, angelaNode.mode);
      assertRoughlyEquals(_world.rightRelationshipSites[0].x, angelaNode.x, 0.5);
      assertNotNull(findLineBetween(graceNode, angelaNode));
    }

    public function testInitialControllerReferences():void {
      assertNoRelationshipSiteHasPotraitLabel();

      assertEquals(_directedRelationship, _directedRelationshipController.directedRelationship);
      assertEquals("Josephine Baker", _directedRelationshipController.leftPortrait.person.name);
      assertEquals("Grace Kelly", _directedRelationshipController.rightPortrait.person.name);

      var line:Line = _directedRelationshipController.portraitToPortraitLine;
      assertEquals(_directedRelationshipController.leftPortrait, line.from);
      assertEquals(_directedRelationshipController.rightPortrait, line.to);
    }

    public function testLayoutAfterTransitionToRight():void {
      transitionToRight();

      // Langston node in portrait mode is at left portrait site
      var langstonNode:PersonNode = findPersonNode("Langston Hughes");
      assertNotNull(langstonNode);
      assertEquals(PersonNode.PORTRAIT, langstonNode.mode);
      assertAttached(_world.leftPortraitSite, langstonNode);
      assertEquals(langstonNode, _directedRelationshipController.leftPortrait);

      // Josephine node in portrait mode is at right portrait site
      var josephineNode:PersonNode = findPersonNode("Josephine Baker");
      assertNotNull(josephineNode);
      assertEquals(PersonNode.PORTRAIT, josephineNode.mode);
      assertAttached(_world.rightPortraitSite, josephineNode);
      assertEquals(josephineNode, _directedRelationshipController.rightPortrait);

      assertNotNull(findLineBetween(langstonNode, josephineNode));

      // Marcus Garvey node in name mode exists at a left relationship site
      var marcusNode:PersonNode = findPersonNode("Marcus Garvey");
      assertNotNull(marcusNode);
      assertEquals(PersonNode.LABEL, marcusNode.mode);
      assertRoughlyEquals(_world.leftRelationshipSites[0].x, marcusNode.x, 0.5);
      assertNotNull(findLineBetween(marcusNode, langstonNode));

      //  Grace node in name mode exists at a right relationship site
      var graceNode:PersonNode = findPersonNode("Grace Kelly");
      assertNotNull(graceNode);
      assertEquals(PersonNode.LABEL, graceNode.mode);
      assertRoughlyEquals(_world.rightRelationshipSites[0].x, graceNode.x, 0.5);
      assertNotNull(findLineBetween(josephineNode, graceNode));

      // Ernest node in name mode exists at a right relationship site
      var ernestNode:PersonNode = findPersonNode("Ernest Hemingway");
      assertNotNull(ernestNode);
      assertEquals(PersonNode.LABEL, ernestNode.mode);
      assertRoughlyEquals(_world.rightRelationshipSites[0].x, ernestNode.x, 0.5);
      assertNotNull(findLineBetween(ernestNode, josephineNode));

      // Angela martin is no longer present
      assertNull(findPersonNode("Angela Martin"));
    }

    public function testControllerReferencesAfterTransitionToRight():void {
      transitionToRight();
      assertNoRelationshipSiteHasPotraitLabel();

      assertEquals(_lastTransitionTarget.directedRelationship, _directedRelationshipController.directedRelationship);
      assertEquals("Langston Hughes", _directedRelationshipController.leftPortrait.person.name);
      assertEquals("Josephine Baker", _directedRelationshipController.rightPortrait.person.name);

      var line:Line = _directedRelationshipController.portraitToPortraitLine;
      assertEquals(_directedRelationshipController.leftPortrait, line.from);
      assertEquals(_directedRelationshipController.rightPortrait, line.to);

      assertNotNull(_directedRelationshipController.outboundRelationshipControllers[0].directedRelationship);
    }

    public function testEventListenersAfterTransitionToRight():void {
      transitionToRight();
      for (var i:String in _directedRelationshipController.extendedRelationshipControllers) {
        var extendedRelController:ExtendedRelationshipController = _directedRelationshipController.extendedRelationshipControllers[i];
        assertTrue(extendedRelController.extendedNode.hasEventListener(MouseEvent.CLICK));
        assertTrue(extendedRelController.line.hasEventListener(MouseEvent.CLICK));
      }

      assertFalse(_directedRelationshipController.leftPortrait.hasEventListener(MouseEvent.CLICK));
      assertFalse(_directedRelationshipController.rightPortrait.hasEventListener(MouseEvent.CLICK));
    }

    public function testLayoutAfterTransitionToLeft():void {
      transitionToLeft();
      assertNoRelationshipSiteHasPotraitLabel();

      // Grace node in portrait mode is at left portrait site
      var graceNode:PersonNode = findPersonNode("Grace Kelly");
      assertNotNull(graceNode);
      assertEquals(PersonNode.PORTRAIT, graceNode.mode);
      assertAttached(_world.leftPortraitSite, graceNode);
      assertEquals(graceNode, _directedRelationshipController.leftPortrait);

      // Rainier node in portrait mode is at right portrait site
      var rainierNode:PersonNode = findPersonNode("Prince Rainier of Monaco");
      assertNotNull(rainierNode);
      assertEquals(PersonNode.PORTRAIT, rainierNode.mode);
      assertAttached(_world.rightPortraitSite, rainierNode);
      assertEquals(rainierNode, _directedRelationshipController.rightPortrait);

      assertNotNull(findLineBetween(graceNode, rainierNode));

      // Josephine node in name mode exists at a left relationship site
      var josephineNode:PersonNode = findPersonNode("Josephine Baker");
      assertNotNull(josephineNode);
      assertEquals(PersonNode.LABEL, josephineNode.mode);
      assertRoughlyEquals(_world.leftRelationshipSites[0].x, josephineNode.x, 0.5);
      assertNotNull(findLineBetween(josephineNode, graceNode));

      // Rock node in name mode exists at a left relationship site
      var rockNode:PersonNode = findPersonNode("Rock Hudson");
      assertNotNull(rockNode);
      assertEquals(PersonNode.LABEL, rockNode.mode);
      assertRoughlyEquals(_world.leftRelationshipSites[0].x, rockNode.x, 0.5);
      assertNotNull(findLineBetween(graceNode, rockNode));

      //  Albert node in name mode exists at a right relationship site
      var albertNode:PersonNode = findPersonNode("Prince Albert of Monaco");
      assertNotNull(albertNode);
      assertEquals(PersonNode.LABEL, albertNode.mode);
      assertRoughlyEquals(_world.rightRelationshipSites[0].x, albertNode.x, 0.5);
      assertNotNull(findLineBetween(rainierNode, albertNode));

      // Ernest is no longer present
      assertNull(findPersonNode("Ernest Hemingway"));
    }

    public function testControllerReferencesAfterTransitionToLeft():void {
      transitionToLeft();
      assertNoRelationshipSiteHasPotraitLabel();

      assertEquals(_lastTransitionTarget.directedRelationship, _directedRelationshipController.directedRelationship);
      assertEquals("Grace Kelly", _directedRelationshipController.leftPortrait.person.name);
      assertEquals("Prince Rainier of Monaco", _directedRelationshipController.rightPortrait.person.name);

      var line:Line = _directedRelationshipController.portraitToPortraitLine;
      assertEquals(_directedRelationshipController.leftPortrait, line.from);
      assertEquals(_directedRelationshipController.rightPortrait, line.to);

    }

    private function assertNoRelationshipSiteHasPotraitLabel():void {
      var currentRelationship:DirectedRelationship = _directedRelationshipController.directedRelationship;
      var portraitLeftLabel:String = currentRelationship.from.name;
      var portraitRightLabel:String = currentRelationship.to.name;

      for (var i:String in _directedRelationshipController.inboundRelationshipControllers) {
        var controller:ExtendedRelationshipController = _directedRelationshipController.inboundRelationshipControllers[i];
        assertNotEqual(controller.directedRelationship.from.name, portraitLeftLabel);
        assertNotEqual(controller.directedRelationship.from.name, portraitRightLabel);
      }
      for (i in _directedRelationshipController.outboundRelationshipControllers) {
        controller = _directedRelationshipController.outboundRelationshipControllers[i] as OutboundRelationshipController;
        assertNotEqual(controller.directedRelationship.to.name, portraitLeftLabel);
        assertNotEqual(controller.directedRelationship.to.name, portraitRightLabel);
      }
    }

    public function testNavigateToNetwork():void {
      UrlNavigation.instance = new MockUrlNavigation();
      _directedRelationshipController.leftPortrait.view.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
      assertEquals("/network/Josephine-Baker", (UrlNavigation.instance as MockUrlNavigation).lastUrlVisited)
    }

    private function transitionToRight():void {
      _lastTransitionTarget = _directedRelationshipController.inboundRelationshipControllers[2];
      _directedRelationshipController.transitionToRight(_lastTransitionTarget as InboundRelationshipController);
      _world.advance(60);
    }

    private function transitionToLeft():void {
      _lastTransitionTarget = _directedRelationshipController.outboundRelationshipControllers[0];
      _directedRelationshipController.transitionToLeft(_lastTransitionTarget as OutboundRelationshipController);
      _world.advance(60);
    }

    private function findPersonNode(name:String):PersonNode {
      for (var i:String in _world.nodes) {
        var node:* = _world.nodes[i];
        if (node is PersonNode && node.person.name == name) return node;
      }
      return null;
    }

    private function findLineBetween(from:PersonNode, to:PersonNode):Line {
      for (var i:String in _world.lines) {
        var line:Line = _world.lines[i];
        if (line.from == from && line.to == to) {
          return line;
        }
      }
      return null;
    }

    private function assertAttracting(attractor:Attractor, node:Node):void {
      assertTrue("Attractor " + attractor.toString() + " is not attracting " + node.toString(), attractor.targets.indexOf(node) != -1);
    }

    private function assertAttached(attractor:Attractor, node:Node):void {
      assertAttracting(attractor, node);
      assertXY(attractor.x, attractor.y, node, 0.5);
    }
  }

}
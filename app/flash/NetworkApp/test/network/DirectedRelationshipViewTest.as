package test.network {
  import com.emmet.network.NetworkView;
  import com.emmet.model.Network;
  import com.emmet.network.World;
  import com.emmet.network.RelationshipSupergroupView;
  import test.FlashAppTestCase;
  import com.emmet.model.Person;
  import com.emmet.network.PersonView;
  import com.emmet.network.Node;
  import com.emmet.util.Wedge;
  import com.emmet.util.DrawableView;
  import com.emmet.network.ColoredBall;
  import com.emmet.network.DirectedRelationshipView;
  import com.emmet.model.DirectedRelationship;
  import com.emmet.util.UrlNavigation;
  import test.mocks.MockUrlNavigation;
  import flash.events.MouseEvent;
  import flash.display.DisplayObject;
  import com.emmet.network.NetworkWorld;

  public class DirectedRelationshipViewTest extends FlashAppTestCase {

    protected var _network:Network;
    protected var _networkView:NetworkView;
    protected var _world:NetworkWorld;
    protected var _directedRelationship:DirectedRelationship;
    protected var _directedRelationshipView:DirectedRelationshipView;
    protected var _childPersonView:PersonView;

    protected override function setUp():void {
      _world = new NetworkWorld();
      _world.visible = false;
      addChild(_world);
      _network = new Network(josephineExampleXML());
      _directedRelationship = _network.relationshipGroups[0].directedRelationships[0];
      assertNotNull(_directedRelationship);
      _directedRelationshipView = new DirectedRelationshipView(_directedRelationship, _world, null, exampleNode(), exampleWedge());
      _childPersonView = _directedRelationshipView.childViews[0];
    }

    protected override function tearDown():void {
      _world.disablePhysics();
      removeChild(_world);
    }

    public function testNavigationUponClickOfView():void {
      var mockUrlNavigation:MockUrlNavigation = new MockUrlNavigation();
      UrlNavigation.instance = mockUrlNavigation;

      var url:String = "/pair/Josephine-Baker/Carrie-McDonald";

      assertEquals(url, _directedRelationship.url);
      clickOn(_childPersonView.node.view);
      assertEquals(url, mockUrlNavigation.lastUrlVisited);

      mockUrlNavigation.clearLastUrlVisited();
      clickOn(_childPersonView.tether);
      assertEquals(url, mockUrlNavigation.lastUrlVisited);

      mockUrlNavigation.clearLastUrlVisited();
      clickOn(_directedRelationshipView.node.view);
      assertEquals(url, mockUrlNavigation.lastUrlVisited);

      mockUrlNavigation.clearLastUrlVisited();
      clickOn(_directedRelationshipView.tether);
      assertEquals(url, mockUrlNavigation.lastUrlVisited);
    }

    protected function clickOn(object:DisplayObject):void {
      object.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
    }

    protected function exampleWedge():Wedge {
      return new Wedge(0,1);
    }
  }
}
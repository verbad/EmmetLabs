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
  import com.emmet.network.NetworkWorld;

  public class PersonViewTest extends FlashAppTestCase {

    protected var _network:Network;
    protected var _networkView:NetworkView;
    protected var _world:NetworkWorld;
    protected var _josephineFamilyView:RelationshipSupergroupView;
    protected var _person:Person;
    protected var _personView:PersonView;

    protected override function setUp():void {
      _world = new NetworkWorld();
      _world.visible = false;
      addChild(_world);
      _network = new Network(josephineExampleXML());
      _person = _network.relationshipGroups[0].directedRelationships[0].to
      assertNotNull(_person);

      _personView = new PersonView(_person, _world, null, new Node(new ColoredBall, 1, 1), new Wedge(0, 1));
    }

    protected override function tearDown():void {
      _world.disablePhysics();
      removeChild(_world);
    }

    public function testTetherDrawsItself():void {
      assertTrue(_personView.tether.drawsItself == false);
    }

  }
}
package test.network {
  import asunit.framework.TestCase;
  import com.emmet.model.Network;
  import test.FlashAppTestCase;
  import com.emmet.network.NetworkView;
  import com.emmet.network.World;
  import com.emmet.network.RelationshipSupergroupView;
  import com.emmet.network.RelationshipGroupView;
  import com.emmet.network.Node;
  import com.emmet.network.FuzzyLabel;
  import com.emmet.network.Tether;
  import flash.errors.StackOverflowError;
  import com.emmet.network.EmmetLabel;
  import com.emmet.network.NetworkWorld;

  public class NetworkViewTest extends FlashAppTestCase {

    protected var _network:Network;
    protected var _networkView:NetworkView;
    protected var _world:NetworkWorld;

    protected override function setUp():void {
      _world = new NetworkWorld();
      _world.visible = false;
      addChild(_world);
      _network = new Network(josephineExampleXML());
      _networkView = new NetworkView(_network, _world);
    }

    protected override function tearDown():void {
      _world.disablePhysics();
      removeChild(_world);
    }

    public function testSubviews():void {
      //assertTrue(_networkView.childViews[0] is RelationshipSupergroupView);
      //assertEquals(_network.rootLevelGroups.length, _networkView.childViews.length);
      //assertTrue(_networkView.childViews[1] is RelationshipGroupView);
      //assertTrue(_networkView.childViews[2] is RelationshipGroupView);
    }

    public function xtestFromPersonLabel():void {
      var labelNode:Node = findNodeLabeled(/Josephine/);
      assertNotNull(labelNode);
      assertTethered(_networkView.node, labelNode);
    }

    public function xtestStateOfWorld():void {
      assertEquals("Family", _network.rootLevelGroups[0].supercategory);
      assertLabeledNodeInWorld(/Family/);

      assertEquals("Parent", _network.rootLevelGroups[0].groups[0].category);
      assertLabeledNodesAreTethered(/Family/, /Parent/);

      assertTetheredToGrandparent(/Parent/, /Carrie McDonald/);
      assertTetheredToGrandparent(/Parent/, /Eddie Carson/);

      assertEquals("Child", _network.rootLevelGroups[0].groups[1].category);
      assertLabeledNodesAreTethered(/Family/, /Child/);

      assertEquals("Partner", _network.rootLevelGroups[0].groups[2].category);
      assertLabeledNodesAreTethered(/Family/, /Partner/);
    }

    private function assertLabeledNodeInWorld(label:RegExp):void {
      if (findNodeLabeled(label) == null) {
        assertTrue("Node labelled" + label.toString() + " is not found in world", false);
      }
    }

    private function findNodeLabeled(label:RegExp):Node {
      for (var i:String in _world.nodes) {
        var node:Node = _world.nodes[i];
        if (node.view is EmmetLabel && (node.view as EmmetLabel).text.match(label)) {
          return node;
        }
      }
      return null;
    }
    private function assertLabeledNodesAreTethered(fromLabel:RegExp, toLabel:RegExp):void {
      var fromNode:Node = findNodeLabeled(fromLabel);
      var toNode:Node = findNodeLabeled(toLabel);
      assertTethered(fromNode, toNode);
    }

    public function assertTethered(fromNode:Node, toNode:Node):void {
      if (fromNode != null && toNode != null) {
        for (var i:String in _world.tethers) {
          var tether:Tether = _world.tethers[i];
          if (tether.from == fromNode && tether.to == toNode) {
            return;
          }
        }
      }
      assertTrue("Tether connecting " + fromNode.toString() + " to " + toNode.toString() + " not found in the world", false);
    }

    private function assertTetheredToGrandparent(grandparentLabel:RegExp, grandchildLabel:RegExp):void {
      var grandparent:Node = findNodeLabeled(grandparentLabel);
      var grandchild:Node = findNodeLabeled(grandchildLabel);
      var tethersFromGrandparent:Array = findTethersFrom(grandparent);
      var toGrandchild:Tether = findTetherTo(grandchild);
      for (var i:String in tethersFromGrandparent) {
        if (tethersFromGrandparent[i].to == toGrandchild.from) { return; }
      }
      assertTrue("Tether linking grandparent " + grandparentLabel.toString() + " and grandchild " + grandchildLabel.toString() + " not found in the world", false);
    }

    private function findTethersFrom(from:Node):Array {
      var tethers:Array = [];
      for (var i:String in _world.tethers) {
        var tether:Tether = _world.tethers[i];
        if (tether.from == from) {
          tethers.push(tether);
        }
      }
      return tethers;
    }

    private function findTetherTo(to:Node):Tether {
      for (var i:String in _world.tethers) {
        var tether:Tether = _world.tethers[i];
        if (tether.to == to) {
          return tether;
        }
      }
      return null;
    }
  }
}
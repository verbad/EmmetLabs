package com.emmet.network {
  import com.emmet.model.Network;
  import com.emmet.model.RelationshipGroup;
  import com.emmet.util.Wedge;
  import com.emmet.util.Disc;
  import com.emmet.util.DrawableView;
  import flash.events.Event;

  public class NetworkView extends TreeView {
    public static var __rootNodeRepulsion:Number = 10000;

    protected var _labelView:FromPersonLabelView;
    protected var _network:Network;
    private var _world:NetworkWorld;

    public function NetworkView(network:Network, world:NetworkWorld) {
      _network = network;
      _world = world;
      var startAngle:Number;
      var endAngle:Number;

      if (network.descendantCount == 1 ) {
        startAngle = -3*Math.PI/2;
        endAngle = -Math.PI/2;
        world.aboveFold = true;
      } else if (network.rootLevelGroups.length <= 2 && network.descendantCount < 11 ) {
        startAngle = -7 * Math.PI/6;
        endAngle = -5*Math.PI/6;
        world.aboveFold = true;
      } else {
        startAngle = 0;
        endAngle = 2 * Math.PI;
      }

      super(world, null, null, new Wedge(startAngle, endAngle));
      _labelView = new FromPersonLabelView(network.target, world, this, node, new Wedge(-Math.PI / 6, Math.PI / 6));
    }

    public function get network():Network { return _network; }

    protected override function instantiateChildView(child:*, world:NetworkWorld, parentTreeView:TreeView, parent:Node, wedge:Wedge):TreeView {
      if (child is RelationshipGroup) {
        return new RelationshipGroupView(child, world, parentTreeView, node, wedge);
      } else {
        return new RelationshipSupergroupView(child, world, parentTreeView, node, wedge);
      }
    }

    protected override function get placementRadius():Number {
      return 0;
    }

    protected override function get children():Array {
      return network.rootLevelGroups;
    }

    protected override function instantiateNode():Node {
      return new Node(new Portrait(network.target), 1, __rootNodeRepulsion, true);
    }
  }
}
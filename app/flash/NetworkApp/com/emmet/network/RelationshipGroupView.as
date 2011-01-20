package com.emmet.network {
  import com.emmet.model.RelationshipGroup;
  import com.emmet.network.Tether;
  import com.emmet.util.BasicLabel;
  import com.emmet.model.DirectedRelationship;
  import com.emmet.util.Wedge;
  import flash.display.Sprite;

  public class RelationshipGroupView extends TreeView {
    public static var __nodeRepulsion:Number = 10000;
    public static var __tetherLength:Number = 70;
    public static var __tetherSpring:Number = 0.03;
    public static var __placementRadius:Number = 100;

    private var _relationshipGroup:RelationshipGroup;

    public function RelationshipGroupView(relationshipGroup:RelationshipGroup, world:NetworkWorld, parentTreeView:TreeView, parent:Node, wedge:Wedge) {
      _relationshipGroup = relationshipGroup;
      super(world, parentTreeView, parent, wedge);
    }

    protected override function instantiateNode():Node {
      return new Node(new FuzzyLabel(_relationshipGroup.category, 0x333333), 1, __nodeRepulsion);
    }

    protected override function instantiateChildView(child:*, world:NetworkWorld, parentTreeView:TreeView, parent:Node, wedge:Wedge):TreeView {
      return new DirectedRelationshipView(child, world, parentTreeView, _node, wedge);
    }

    protected override function get tetherLength():Number {
      return __tetherLength;
    }

    protected override function get tetherSpring():Number {
      return __tetherSpring;
    }

    protected override function get placementRadius():Number {
      return __placementRadius;
    }

    protected override function get children():Array {
      return _relationshipGroup.directedRelationships;
    }
  }
}
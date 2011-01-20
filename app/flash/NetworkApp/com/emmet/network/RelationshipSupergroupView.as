package com.emmet.network {
  import com.emmet.model.RelationshipSupergroup;
  import com.emmet.util.Wedge;
  import com.emmet.model.RelationshipGroup;
  import flash.display.Sprite;

  public class RelationshipSupergroupView extends TreeView {

    public static var __nodeRepulsion:Number = 10000;
    public static var __tetherLength:Number = 70;
    public static var __tetherSpring:Number = 0.03;
    public static var __placementRadius:Number = 50;

    private var _relationshipSupergroup:RelationshipSupergroup;

    public function RelationshipSupergroupView(relationshipSupergroup:RelationshipSupergroup, world:NetworkWorld, parentTreeView:TreeView, parent:Node, wedge:Wedge) {
      _relationshipSupergroup = relationshipSupergroup;
      super(world, parentTreeView, parent, wedge);
    }

    protected override function instantiateNode():Node {
      var label:String = hasSingleGroup() ?
      _relationshipSupergroup.supercategory + "/\n" + _relationshipSupergroup.groups[0].category :
      _relationshipSupergroup.supercategory;
      return new Node(new FuzzyLabel(label, 0x333333), 1, __nodeRepulsion);
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
      return hasSingleGroup() ? _relationshipSupergroup.groups[0].directedRelationships : _relationshipSupergroup.groups;
    }

    protected override function instantiateChildView(child:*, world:NetworkWorld, parentTreeView:TreeView, parent:Node, wedge:Wedge):TreeView {
      return hasSingleGroup() ? new DirectedRelationshipView(child, world, parentTreeView, _node, wedge) : new RelationshipGroupView(child, world, parentTreeView, _node, wedge);
    }

    private function hasSingleGroup():Boolean {
      return _relationshipSupergroup.groups.length == 1;
    }
  }
}
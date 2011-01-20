package com.emmet.network {
  import com.emmet.model.DirectedRelationship;
  import com.emmet.util.Wedge;
  import flash.events.Event;
  import com.emmet.util.UrlNavigation;
  import flash.events.MouseEvent;
  import flash.display.Sprite;

  public class DirectedRelationshipView extends TreeView {
    public static var __nodeRepulsion:Number = 1000;
    public static var __tetherLength:Number = 100;
    public static var __tetherSpring:Number = 0.05;
    public static var __placementRadius:Number = 150;

    public static var PLACEMENT_RADIUS_FACTOR:Number = 1.2;

    protected var _directedRelationship:DirectedRelationship;
    protected var _originalChildIndex:Number;

    private var _world:NetworkWorld;

    public function DirectedRelationshipView(directedRelationship:DirectedRelationship, world:NetworkWorld, parentTreeView:TreeView, parent:Node, wedge:Wedge) {
      _directedRelationship = directedRelationship;
      super(world, parentTreeView, parent, wedge);
      _world = world;

      _world.setChildIndex(node, _world.getChildIndex(childViews[0].node));

      addEventListenerToTree(MouseEvent.CLICK, navigateToDirectedRelationship);
      addEventListenerToTree(MouseEvent.MOUSE_OVER, highlightPath);
      addEventListenerToTree(MouseEvent.MOUSE_OUT, unhighlightPath);
    }

    protected override function instantiateNode():Node {
      return new Node(new ColoredBall(), 1, __nodeRepulsion);
    }

    protected override function get children():Array {
      return [_directedRelationship.to];
    }

    protected override function instantiateChildView(child:*, world:NetworkWorld, parentTreeView:TreeView, parent:Node, wedge:Wedge):TreeView {
      return new PersonView(child, world, parentTreeView, parent, wedge);
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
    public function navigateToDirectedRelationship(event:Event):void {
      _world.disablePhysics();
      UrlNavigation.instance.go(_directedRelationship.url);
    }

    protected function highlightPath(event:Event):void {
      highlight();
      _originalChildIndex = _world.getChildIndex(childViews[0].node);
      _world.setChildIndex(childViews[0].node, _world.numChildren - 1);
      childViews[0].highlight();
    }

    protected function unhighlightPath(event:Event):void {
      unhighlight();
      _world.setChildIndex(childViews[0].node, _originalChildIndex);
      childViews[0].unhighlight();
    }
  }
}
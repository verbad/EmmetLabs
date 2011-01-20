package com.emmet.network {
  import com.emmet.model.DirectedRelationship;
  import com.emmet.util.Wedge;
  import com.emmet.model.Person;
  import flash.events.MouseEvent;
  import flash.events.Event;
  import com.emmet.util.UrlNavigation;
  import flash.display.Sprite;

  public class PersonView extends TreeView {
    public static var __nodeRepulsion:Number = 0.15;
    public static var __tetherLength:Number = -40;
    public static var __tetherSpring:Number = 0.05;
    public static var __placementRadius:Number = 160;
    protected var _person:Person;
    protected var _parent:Node;

    public function PersonView(person:Person, world:NetworkWorld, parentTreeView:TreeView, parent:Node, wedge:Wedge) {
      _person = person;
      _parent = parent;
      super(world, parentTreeView, parent, wedge);
    }

    protected override function instantiateNode():Node {
      return new Node(new OutlineLabel(_person.name.replace(/ /, "\n")), .1, __nodeRepulsion);
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
    protected override function get tetherVisible():Boolean {
      return false;
    }
  }
}
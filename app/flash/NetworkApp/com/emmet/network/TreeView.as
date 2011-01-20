package com.emmet.network {
  import com.emmet.util.Wedge;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.display.Sprite;

  public class TreeView {
    protected var _parentTreeView:TreeView;
    protected var _node:Node;
    protected var _tether:Tether;
    protected var _childViews:Array;

    public function TreeView(world:NetworkWorld, parentTreeView:TreeView, parent:Node, wedge:Wedge) {
      _parentTreeView = parentTreeView;
      _node = instantiateNode();
      wedge.bisectingVector(placementRadius).position(_node);

      _childViews = [];
      wedge.allocateSubwedges(children);

      for (var i:String in children) {
        _childViews.push(instantiateChildView(children[i], world, this, _node, wedge.nextSubwedge()));
      }
      if (parent != null) {
        _tether = new Tether(parent, _node, numDescendantTreeViews + 1, tetherLength, tetherSpring, tetherVisible);
        world.addTether(_tether);
      }
      world.addNode(_node);
    }

    public function get node():Node { return _node; }
    public function get tether():Tether { return _tether; }
    public function get childViews():Array { return _childViews; }
    public function get parentTreeView():TreeView { return _parentTreeView; }
    public function addEventListenerToTree(event:String, listener:Function):void {
      _node.addEventListener(event, listener);
      _tether.addEventListener(event, listener);

      for (var i:String in childViews) {
        childViews[i].addEventListenerToTree(event, listener);
      }
    }

    protected function instantiateNode():Node {
      throw "Implement in subclass";
    }

    protected function get numChildren():Number {
      return children.length;
    }

    public function get numDescendantTreeViews():Number {
      var numDescendants:Number = _childViews.length;
      for (var i:String in _childViews) {
        numDescendants += _childViews[i].numDescendantTreeViews;
      }
      return numDescendants;
    }

    protected function get children():Array {
      return [];
    }

    protected function get nodeMass():Number {
      return 1;
    }

    protected function get tetherLength():Number {
      throw "Implement in subclass";
    }

    protected function get tetherSpring():Number {
      throw "Implement in subclass";
    }

    protected function get tetherVisible():Boolean {
      return true;
    }

    protected function get placementRadius():Number {
      throw "Implement in subclass";
    }

    protected function instantiateChildView(child:*, world:NetworkWorld, parentTreeView:TreeView, parent:Node, wedge:Wedge):TreeView {
      throw "Implement in subclass";
    }

    public function highlight():void {
      if (tether != null) tether.highlight();
      node.highlight();
      if (parentTreeView != null) parentTreeView.highlight();
    }

    public function unhighlight():void {
      if (tether != null) tether.unhighlight();
      node.unhighlight();
      if (parentTreeView != null) parentTreeView.unhighlight();
    }

  }

}
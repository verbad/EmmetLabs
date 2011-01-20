package com.emmet.util {
  import flash.display.Sprite;
  import com.emmet.network.Node;
  import com.emmet.util.Vector;
  import flash.events.Event;
  import com.emmet.network.ColoredBall;

  public class AbstractSegmentNode extends Node {

    protected var _topLeftNode:Node
    protected var _bottomRightNode:Node;

    public function AbstractSegmentNode(view:Sprite, topLeft:Vector, bottomRight:Vector, mass:Number, repulsion:Number):void {
      super(view, mass, repulsion, true);
      _topLeftNode = new Node(new ColoredBall(), mass, repulsion, stationary);
      topLeft.position(_topLeftNode);
      _bottomRightNode = new Node(new ColoredBall(), mass, repulsion, stationary);
      bottomRight.position(_bottomRightNode);
    }

   }
}
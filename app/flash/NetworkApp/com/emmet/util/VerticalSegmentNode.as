package com.emmet.util {
  import flash.display.Sprite;
  import com.emmet.network.Node;
  import com.emmet.util.Vector;

  public class VerticalSegmentNode extends AbstractSegmentNode {

    public function VerticalSegmentNode(view:Sprite, topLeft:Vector, bottomRight:Vector, mass:Number, repulsion:Number) {
      super(view, topLeft, bottomRight, mass, repulsion);
    }

    public override function delta(otherNode:Node):Vector {
      var result:Vector = Vector.ZERO;
      if (otherNode is AbstractSegmentNode)
        return result;
      if (otherNode.y < _topLeftNode.y) {
        result = _topLeftNode.delta(otherNode);
      } else if (otherNode.y > _bottomRightNode.y) {
        result = _bottomRightNode.delta(otherNode);
      } else {
        var oldPosition:Vector = Vector.fromPositionOf(this);
        Vector.fromCartesian(_topLeftNode.x, otherNode.y).position(this);
        result = otherNode.delta(this).scaleBy(-1);
        oldPosition.position(this);
      }

      return result;
    }
  }
}
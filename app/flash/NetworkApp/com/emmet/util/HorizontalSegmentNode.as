package com.emmet.util {
  import flash.display.Sprite;
  import com.emmet.network.Node;
  import com.emmet.util.Vector;
  import com.emmet.network.EmmetLabel;
  import flash.geom.Point;
  import com.emmet.network.ColoredBall;

  public class HorizontalSegmentNode extends AbstractSegmentNode {

    public function HorizontalSegmentNode(view:Sprite, topLeft:Vector, bottomRight:Vector, mass:Number, repulsion:Number) {
      super(view, topLeft, bottomRight, mass, repulsion);
    }

    public override function delta(otherNode:Node):Vector {
      var result:Vector = Vector.ZERO;

      if (otherNode is AbstractSegmentNode)
        return result;

      if (otherNode.x < _topLeftNode.x) {
        result = _topLeftNode.delta(otherNode);
      } else if (otherNode.x > _bottomRightNode.x) {
        result = _bottomRightNode.delta(otherNode);
      } else {
        otherNode.y
        var oldPosition:Vector = Vector.fromPositionOf(this);
        Vector.fromCartesian(otherNode.x, _topLeftNode.y).position(this);
        result = otherNode.delta(this).scaleBy(-1);
        oldPosition.position(this);
      }

      return result;
    }
  }
}
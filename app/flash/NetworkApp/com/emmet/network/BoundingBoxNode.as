package com.emmet.network {
  import flash.display.Sprite;

  public class BoundingBoxNode extends Node {

    public function BoundingBoxNode(view:Sprite, mass:Number, repulsion:Number, stationary:Boolean = false) {
      super(view, mass, repulsion, stationary);
    }

    public override function distance(otherNode:Node):Number {
      return otherNode.view == null ? Number.MAX_VALUE : boundingBox.minDistance(otherNode.boundingBox);
    }
  }
}
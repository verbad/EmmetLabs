package com.emmet.wander {
  import flash.events.MouseEvent;
  import com.emmet.util.DrawableView;
  import flash.display.Bitmap;

  public class Arrow extends DrawableView {

    private var _handler:DirectedRelationshipController;

    public function Arrow(x:int, y:int) {
      super();
      this.x = x;
      this.y = y;
      this.buttonMode = true;
      addChild(arrowImage());
    }

    protected function arrowImage() : Bitmap {
      return null;
    }

  }
}
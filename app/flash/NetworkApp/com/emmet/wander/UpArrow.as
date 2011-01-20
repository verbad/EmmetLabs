package com.emmet.wander {
  import flash.events.MouseEvent;
  import flash.display.Bitmap;

  public class UpArrow extends Arrow {

    [Embed(source='up_arrow.png')]
    private var UpArrowImage:Class;

    public function UpArrow(x:int, y:int) {
      super(x, y);
    }

    override protected function arrowImage() : Bitmap {
      return new UpArrowImage();
    }
  }
}
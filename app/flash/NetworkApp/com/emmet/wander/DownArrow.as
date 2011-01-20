package com.emmet.wander {
  import flash.events.MouseEvent;
  import flash.display.Bitmap;

  public class DownArrow extends Arrow {

    [Embed(source='down_arrow.png')]
    private var DownArrowImage:Class;

    public function DownArrow(x:int, y:int) {
      super(x, y);
    }

    override protected function arrowImage() : Bitmap {
      return new DownArrowImage();
    }

  }
}
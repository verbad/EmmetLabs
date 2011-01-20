package com.emmet.timeline {
  import flash.display.Sprite;

  public class LineView extends Sprite {
    public function LineView(x1:int, x2:int, y1:int, y2:int):void {
      graphics.lineStyle(4, 0x778D90);
      graphics.moveTo(x1, y1);
      graphics.lineTo(x2, y2);
    }

  }
}
package com.emmet.timeline {
  import flash.display.Sprite;

  public class NotchView extends Sprite {
    public function NotchView():void {
      draw();
    }

    private function draw():void {
      graphics.lineStyle(4, 0x778D90);
      graphics.moveTo(x, 5);
      graphics.lineTo(x, -5);
    }

  }
}
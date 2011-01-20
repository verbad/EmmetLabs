package com.emmet.network {
  import flash.display.Sprite;

  public class ColoredBall extends Sprite implements Highlightable {
    public static const MIN_RADIUS:Number = 10;
    public static const MAX_RADIUS:Number = 25;
    public static const LARGER_RADIUS_THRESHOLD:Number = .9;

    public static const OUTLINE_COLOR:Number = 0x333333;
    public static const HIGHLIGHT_OUTLINE_THICKNESS:Number = 3;
    public static const HIGHLIGHT_OUTLINE_COLOR:Number = 0x0099CC;
    public static const BACKGROUND_COLOR:Number = 0x77A5B3;
    public static const BACKGROUND_ALPHA:Number = 0.65;

    protected var _radius:Number;

    public function ColoredBall():void {
      _radius = 15;
      draw();
    }

    public function get radius():Number { return _radius; }

    private function draw():void {
      graphics.lineStyle(1, OUTLINE_COLOR);
      graphics.beginFill(BACKGROUND_COLOR, BACKGROUND_ALPHA);
      graphics.drawCircle(0, 0, radius);
    }

    public function highlight():void {
      graphics.clear();
      graphics.lineStyle(HIGHLIGHT_OUTLINE_THICKNESS, HIGHLIGHT_OUTLINE_COLOR);
      graphics.beginFill(BACKGROUND_COLOR, BACKGROUND_ALPHA);
      graphics.drawCircle(0, 0, radius);
    }

    public function unhighlight():void {
      graphics.clear();
      draw();
    }
  }
}
package com.emmet.wander {
  import flash.events.Event;
  import flash.display.Sprite;

  public class FadeEffect {

    public static const IN:int = 0;
    public static const OUT:int = 1;
    private static const FADE_RATE:Number = 0.1;
    private var _sprite:Sprite;

    public function FadeEffect(sprite:Sprite, direction:int) {
      _sprite = sprite;

      if (direction == IN) {
        _sprite.alpha = 0;
        _sprite.addEventListener(Event.ENTER_FRAME, fadeIn);
      } else {
        _sprite.alpha = 1;
        _sprite.addEventListener(Event.ENTER_FRAME, fadeOut);
      }
    }

    private function fadeOut(event:Event):void {
      if (_sprite.alpha > 0) {
        _sprite.alpha -= FADE_RATE;
      } else {
         _sprite.removeEventListener(Event.ENTER_FRAME, fadeOut);
      }
    }

    private function fadeIn(event:Event):void {
      if (_sprite.alpha < 1) {
        _sprite.alpha += FADE_RATE;
      } else {
         _sprite.removeEventListener(Event.ENTER_FRAME, fadeIn);
      }
    }
  }
}
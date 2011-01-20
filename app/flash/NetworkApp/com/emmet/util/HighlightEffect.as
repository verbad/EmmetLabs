package com.emmet.util {
  import flash.display.DisplayObject;
  import flash.filters.GlowFilter;

  public class HighlightEffect {
    public static function apply(object:DisplayObject, isOn:Boolean = true):void {
      if (isOn) {
        object.filters = [new GlowFilter()];
      } else {
        object.filters = [];
      }
    }
  }
}
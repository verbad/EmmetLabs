package com.emmet.util {
  public class ArrayUtils {
    public static function removeFromArray(array:Array, object:Object):Array {
      return array.filter(function (elt:*, index:*, array:*):Boolean { return elt != object; });
    }
  }
}
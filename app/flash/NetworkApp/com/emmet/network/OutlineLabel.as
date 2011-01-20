package com.emmet.network {
  import flash.text.TextField;
  import flash.display.Sprite;
  import flash.system.ApplicationDomain;
  import flash.filters.GradientGlowFilter;
  import flash.text.TextFieldAutoSize;
  import flash.text.TextFormat;
  import flash.filters.GlowFilter;
  import com.emmet.wander.ExtendedRelationshipController;
  import flash.events.Event;

  public class OutlineLabel extends EmmetHighlightableLabel {
    public function OutlineLabel(text:String, textColor:Number = DEFAULT_COLOR, fontSize:Number = DEFAULT_FONT_SIZE) {
      super(text, textColor, fontSize);
      _textField.filters = [new GlowFilter(0xffffff, 1, 5, 5, 10, 1, false, false)];
      buttonMode = true;
      mouseChildren = false;
    }
  }
}
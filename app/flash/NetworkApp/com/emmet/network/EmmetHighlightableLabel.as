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

  public class EmmetHighlightableLabel extends EmmetLabel implements Highlightable {
    public static const HIGHLIGHT_COLOR:Number = 0x0099CC;
    public static const EXTRA_HIGHLIGHT_COLOR:Number = World.EXTRA_HIGHLIGHT_COLOR;

    private var _offColor:Number;

    public function EmmetHighlightableLabel(text:String, textColor:Number = DEFAULT_COLOR, fontSize:Number = DEFAULT_FONT_SIZE) {
      _offColor = textColor;
      super(text, textColor, fontSize);
    }

    public function highlight():void {
      _textField.textColor = HIGHLIGHT_COLOR;
      recenter();
    }

    public function set fontSize(size:Number):void {
      var textFormat:TextFormat = new TextFormat(font, size);
      _textField.setTextFormat(textFormat);
      recenter();
    }

    public function extraHighlight():void {
      _textField.textColor = EXTRA_HIGHLIGHT_COLOR;
      recenter();
    }

    public function unhighlight():void {
      _textField.textColor = _offColor;
      recenter();
    }
  }
}
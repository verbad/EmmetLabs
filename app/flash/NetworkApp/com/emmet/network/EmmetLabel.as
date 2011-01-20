package com.emmet.network {
  import flash.text.TextField;
  import flash.display.Sprite;
  import flash.system.ApplicationDomain;
  import flash.filters.GradientGlowFilter;
  import flash.text.TextFieldAutoSize;
  import flash.text.TextFormat;
  import flash.filters.GlowFilter;
  import flash.text.TextFormatAlign;

  public class EmmetLabel extends Sprite {
    public static const DEFAULT_FONT_SIZE:Number = 12;
    public static const DEFAULT_FONT:String = "_helvetica";
    public static const DEFAULT_COLOR:Number = 0;
    protected var _textField:TextField;
    protected var _font:String;

    public function get text():String { return _textField.text;}
    public function get font():String { return _font; }

    public function EmmetLabel(text:String, textColor:Number = DEFAULT_COLOR, fontSize:Number=DEFAULT_FONT_SIZE, font:String = DEFAULT_FONT) {
      _textField = new TextField();
      _textField.embedFonts = true;
      _textField.text = text;

      var textFormat:TextFormat = new TextFormat(font, fontSize);
      _textField.setTextFormat(textFormat);
      _textField.autoSize = TextFieldAutoSize.LEFT;
      _textField.textColor = textColor;
      _textField.selectable = false;
      _textField.alpha = 1;
      recenter();
      addChild(_textField);
    }

    protected function recenter():void {
      _textField.x = -(_textField.width/2);
      _textField.y = -(_textField.height/2);
    }
  }
}
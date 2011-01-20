package com.emmet.network {
  import flash.events.MouseEvent;
  import flash.text.TextFormat;

  public class HighlightableEmmetLabel extends EmmetLabel {
    public static const DEFAULT_HIGHLIGHT_COLOR:Number = 0x0099CC;
    private var _highlightColor:Number;
    private var _textColor:Number;

    public function HighlightableEmmetLabel(text:String, textColor:Number = DEFAULT_COLOR, fontSize:Number=DEFAULT_FONT_SIZE, highlightColor:Number = DEFAULT_HIGHLIGHT_COLOR, font:String = EmmetLabel.DEFAULT_FONT) {
      super(text, textColor, fontSize, font);
      _textColor = textColor;
      _highlightColor = highlightColor;
      addEventListener(MouseEvent.MOUSE_OVER, highlight);
      addEventListener(MouseEvent.MOUSE_OUT, unhighlight);
      buttonMode = true;
      mouseChildren = false;
    }

    public function highlight(e:MouseEvent):void {
      _textField.textColor = _highlightColor;
      var format:TextFormat = _textField.getTextFormat();
      format.underline = true;
      _textField.setTextFormat(format);
    }

    public function unhighlight(e:MouseEvent):void {
      _textField.textColor = _textColor;
      var format:TextFormat = _textField.getTextFormat();
      format.underline = false;
      _textField.setTextFormat(format);
    }

  }
}
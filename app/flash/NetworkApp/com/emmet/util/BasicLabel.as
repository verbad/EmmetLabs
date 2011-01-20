package com.emmet.util {
  import flash.text.TextField;
  import flash.text.TextFormat;
  import flash.text.TextFieldAutoSize;
  import flash.display.Sprite;

  public class BasicLabel extends DrawableView {
    private var _textField:TextField;
    private var _registrationPoint:String;

    /* Registration point constants */
    public static const CENTER:String = "center";
    public static const LEFT:String = "left";
    public static const RIGHT:String = "right";
    public static const TOP:String = "top";
    public static const BOTTOM:String = "bottom";

    public function BasicLabel(text:String, fontSize:int, registrationPoint:String = CENTER) {

      _textField = new TextField();
      _textField.text = text;
      var textFormat:TextFormat = new TextFormat("Helvetica", fontSize);
      _textField.setTextFormat(textFormat);
      _textField.autoSize = TextFieldAutoSize.LEFT;
      _registrationPoint = registrationPoint;
      adjustRegistration(_registrationPoint);
      addChild(_textField);
    }

    private function adjustRegistration(registrationPoint:String):void {
      switch (registrationPoint) {
        case CENTER:
        case TOP:
        case BOTTOM:
          _textField.x = -(_textField.width/2);
          break;
        case LEFT:
          _textField.x = 0;
          break;
        case RIGHT:
          _textField.x = -_textField.width;
          break;
      }
      switch (registrationPoint) {
        case CENTER:
        case LEFT:
        case RIGHT:
          _textField.y = -(_textField.height/2);
          break;
        case TOP:
          _textField.y = 0;
          break;
        case BOTTOM:
          _textField.y = -_textField.height;
          break;
      }
    }

    public function get textField():TextField { return _textField; }
    public function get registrationPoint():String { return _registrationPoint; }
    public function get text():String { return _textField.text; }
    public function get backgroundColor():Number { return _textField.backgroundColor; }
    public function get background():Boolean { return _textField.background; }
    public function set backgroundColor( color:Number ):void { _textField.backgroundColor = color; }
    public function set background( boolean:Boolean ):void { _textField.background = boolean; }
    public function centerAt(x:int, y:int):void {
      this.x = x;
      this.y = y;
    }
  }
}
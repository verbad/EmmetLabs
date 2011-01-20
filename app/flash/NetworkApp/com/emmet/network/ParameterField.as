package com.emmet.network {
  import flash.display.Sprite;
  import flash.text.TextField;
  import flash.text.TextFieldType;
  import flash.text.TextFieldAutoSize;

  public class ParameterField extends Sprite {
    private var _field:TextField;

    public function ParameterField(label:String, value:Number) {
      var fieldLabel:TextField = new TextField();
      fieldLabel.text = label;
      fieldLabel.textColor = 0xFFFFFF;
      fieldLabel.autoSize = TextFieldAutoSize.LEFT;
      addChild(fieldLabel);

      _field = new TextField();
      _field.type = TextFieldType.INPUT;
      _field.border = true;
      _field.background = true;
      _field.text = value.toString();
//      _field.restrict = "0-9\\.\-";
      _field.height = 20;
      _field.width = 50;
      _field.x = 150;
      addChild(_field);
    }

    public function get value():Number {
      return Number(_field.text);
    }
  }
}
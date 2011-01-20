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

  public class FuzzyLabel extends EmmetHighlightableLabel {
    private var _background:Sprite;

    public function FuzzyLabel(text:String, textColor:Number = DEFAULT_COLOR, fontSize:Number = DEFAULT_FONT_SIZE) {
      super(text, textColor, fontSize);

      addEventListener(Event.ADDED_TO_STAGE, drawBackgroundOnAddedToStage);
    }

    private function drawBackground():void {
      if (root == null) return;
      var specifiedBackgroundColor:String = root.loaderInfo.parameters.bgcolor;
      var backgroundColor:uint = specifiedBackgroundColor != null ? uint(specifiedBackgroundColor): 0xFFFFFF;
      if (_background == null) {
        _background = new Sprite();
        _background.filters = [ new GlowFilter(backgroundColor, .9, 20, 20, 2.5) ];
        addChildAt(_background, 0);
      }
      _background.graphics.clear();
      _background.graphics.beginFill(backgroundColor);
      _background.graphics.drawRoundRect(_textField.x + 2, _textField.y + 2, _textField.width - 4, _textField.height - 4, 8, 8);
    }

    private function drawBackgroundOnAddedToStage(e:Event):void {
      drawBackground();
    }

    protected override function recenter():void {
      super.recenter();
      drawBackground();
    }
  }
}
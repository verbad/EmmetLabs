package com.emmet.wander {
  import com.emmet.model.Person;
  import com.emmet.network.EmmetLabel;
  import com.emmet.network.FuzzyLabel;
  import com.emmet.network.Highlightable;
  import com.emmet.network.Portrait;
  import com.emmet.util.UrlNavigation;
  import com.emmet.util.WanderXmlParser;
  
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.MouseEvent;

  public class PersonView extends Sprite implements Highlightable {
    [Embed(source='orange_dots_left.gif')]
    public var OrangeDotsLeft:Class;

    [Embed(source='orange_dots_right.gif')]
    public var OrangeDotsRight:Class;

    [Embed(source='stub.gif')]
    public var Stub:Class;

    private var _person:Person;
    private var _label:FuzzyLabel;
    private var _portrait:Portrait;
    private var _orangeDots:Sprite;
    private var _orangeDotsLeft:Sprite;
    private var _orangeDotsRight:Sprite;
    private var _stub:Sprite;
    private var _stubL:int;
    private var _stubR:int;

    public function get portrait():Portrait {return _portrait;}
    public function get orangeDots():Sprite {return _orangeDots;}

    public function PersonView(person:Person, left:Boolean) {
      _person = person;
      _label = new FuzzyLabel(_person.name, _person.stub ? 0x666666 : EmmetLabel.DEFAULT_COLOR);

      if (_person.stub) {
        _person.addEventListener(WanderXmlParser.XML_COMPLETE_EVENT, stubLoaded);
      }

      _portrait = new Portrait(_person);
      // _orangeDotsLeft = new OrangeDotsLeft();
      _orangeDotsLeft = new Sprite();
      _orangeDotsLeft.addChild(new OrangeDotsLeft());

      _orangeDotsLeft.x -= (_label.width/2 + _orangeDotsLeft.width + 5);
      _orangeDotsLeft.y -= 4;

      //_orangeDotsRight = new OrangeDotsRight();
      _orangeDotsRight = new Sprite();
      _orangeDotsRight.addChild(new OrangeDotsRight());

      _orangeDotsRight.x += (_label.width/2 + 5);
      _orangeDotsRight.y -= 4;

      _orangeDots = left ? _orangeDotsLeft : _orangeDotsRight;

      if (_person.stub) {
        _stub = new Sprite();
        _stub.addChild(new Stub());
        _stubL = _stub.x - (_label.width / 2 + _stub.width + 3);
        _stubR = _stub.x +  (_label.width / 2 + 3);
        if (left) {
          _stub.x = _stubL;
        } else {
          _stub.x = _stubR;
        }
        _stub.y -= 4;
        addChild(_stub);
      }

      addChild(_portrait);
      addChild(_label);
      addChild(_orangeDots);


      determineSateliteVisibility(false);

    }

    public function stubLoaded(event:Event):void {
      removeChild(_label);
      var y:int = _label.y;
      _label = new FuzzyLabel(_person.name);
      _label.y = y;
      addChild(_label);
      if (_portrait.visible) {return;}

      determineSateliteVisibility(true);
    }

    protected function determineSateliteVisibility(fade:Boolean = true):void {
      if (!_person.stub) {
        if (fade) {
          if (_stub != null) {new FadeEffect(_stub, FadeEffect.OUT);}
          _orangeDotsLeft.visible = _orangeDotsRight.visible = false;
          if (_person.directedRelationships.length > 1) {
            _orangeDotsLeft.visible = _orangeDotsRight.visible = true;
            new FadeEffect(_orangeDotsLeft, FadeEffect.IN);
            new FadeEffect(_orangeDotsRight, FadeEffect.IN);
          }
        } else {
          if (_stub != null) { _stub.visible = false;}
          _orangeDotsLeft.visible = _orangeDotsRight.visible = _person.directedRelationships.length > 1;
        }
      } else {
        if (fade) {
          new FadeEffect(_stub, FadeEffect.IN);
          // These are wasteful & unnecessary
          new FadeEffect(_orangeDotsLeft, FadeEffect.OUT);
          new FadeEffect(_orangeDotsRight, FadeEffect.OUT);
        } else {
          _orangeDotsLeft.visible = false;
          _orangeDotsRight.visible = false;
          _stub.visible = true;
        }
      }

      // Let's see if this makes it appear
      removeChild(_orangeDots);
      addChild(_orangeDots);
    }

    public function becomeLabel(fade:Boolean = true):void {
      if (fade) {
        _portrait.visible = true;
        new FadeEffect(_portrait, FadeEffect.OUT);
      } else {
        _portrait.visible = false;
      }

      determineSateliteVisibility(fade);

      _label.y = 0;
      removeEventListeners();
    }

    public function becomePortrait(fade:Boolean = true):void {
      _portrait.visible = true;
      if (fade) {
        new FadeEffect(_portrait, FadeEffect.IN);
      }
      _orangeDotsLeft.visible = false;
      _orangeDotsRight.visible = false;
      if (_stub != null) {
        _stub.visible = false;
      }
      _label.y = (_portrait.height / 2) + 10;
      setChildIndex(_label, 0);

      addEventListeners();
    }

    public function becomeLeft():void {
      removeChild(_orangeDots);
      _orangeDots = _orangeDotsLeft;
      addChild(_orangeDots);
      if (_stub != null) {
        //removeChild(_stub);
        _stub.x = _stubL;
        //addChild(_stub);
      }
    }

    public function becomeRight():void {
      removeChild(_orangeDots);
      _orangeDots = _orangeDotsRight;
      addChild(_orangeDots);
      if (_stub != null) {
       // removeChild(_stub);
        _stub.x = _stubR;
        // addChild(_stub);
      }
    }

    public function highlight():void {
      _label.highlight();
      _portrait.highlight();
    }

    public function unhighlight():void {
      _label.unhighlight();
      _portrait.unhighlight();
    }

    public function extraHighlight():void {
      _label.extraHighlight();
      _portrait.extraHighlight();
    }

    private function addEventListeners():void {
      addEventListener(MouseEvent.CLICK, onClick);
      addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
      addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
    }

    private function removeEventListeners():void {
      removeEventListener(MouseEvent.CLICK, onClick);
      removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
      removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
    }

    private function onClick(event:Event):void {
      UrlNavigation.instance.go(_person.networkUrl);
    }

    private function onMouseOut(event:Event):void {
      unhighlight();
    }

    private function onMouseOver(event:Event):void {
      highlight();
    }
  }
}
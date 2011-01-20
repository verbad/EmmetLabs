package com.emmet.wander {
  import com.emmet.network.Node;
  import com.emmet.model.Person;
  import com.emmet.network.Portrait;
  import flash.display.Sprite;
  import com.emmet.network.FuzzyLabel;

  public class PersonNode extends Node {
    public static const PORTRAIT:int = 0;
    public static const LABEL:int = 1;

    private var _person:Person;
    private var _personView:PersonView;
    private var _mode:int;

    public function PersonNode(person:Person, mode:int, left:Boolean) {
      _person = person;
      _personView = new PersonView(_person, left);
      this.buttonMode = true;

      if (mode == PORTRAIT) {
        becomePortrait(false);
      } else {
        becomeLabel(false);
      }

       _mode = mode;
       super(_personView, 1, 0);
    }

    public function get person():Person { return _person; }
    public function get mode():int { return _mode; }

    public function becomePortrait(fade:Boolean = true):void {
      _mode = PORTRAIT;
      _personView.becomePortrait(fade);
    }

    public function becomeLabel(fade:Boolean = true):void {
      _mode = LABEL;
      _personView.becomeLabel(fade);
    }

    public function becomeLeft(): void {
      _personView.becomeLeft();
    }

    public function becomeRight(): void {
      _personView.becomeRight();
    }

    public function extraHighlight():void {
      _personView.extraHighlight();
    }

    public override function toString():String {
      return person.toString() + " node";
    }
  }
}
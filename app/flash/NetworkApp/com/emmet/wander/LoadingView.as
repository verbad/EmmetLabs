package com.emmet.wander {
  import com.emmet.network.EmmetLabel;

  import flash.display.Sprite;

  public class LoadingView extends Sprite {
    private var _label:EmmetLabel;

    public function LoadingView() {
      super();
      _label = new EmmetLabel("Loading...", 0xb9532e);
    }

  }
}
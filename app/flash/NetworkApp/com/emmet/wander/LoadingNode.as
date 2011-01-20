package com.emmet.wander {
  import com.emmet.network.Node;

  import flash.display.Sprite;

  public class LoadingNode extends Node {
    private var _loadingView:LoadingView

    public function LoadingNode() {
      _loadingView = new LoadingView();
      super(_loadingView, 1, 0);
    }

  }
}
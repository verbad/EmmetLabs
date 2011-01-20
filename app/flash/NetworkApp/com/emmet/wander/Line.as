package com.emmet.wander {
  import com.emmet.util.DrawableView;
  import com.emmet.model.Person;
  import com.emmet.network.World;

  public class Line extends DrawableView {
    public static const COLOR:Number = 0x666666;
    public static const THICKNESS:Number = 0.25

    public static const HIGHLIGHT_COLOR:Number = 0x0099CC;
    public static const EXTRA_HIGHLIGHT_COLOR:Number = World.EXTRA_HIGHLIGHT_COLOR;
    public static const HIGHLIGHT_THICKNESS:Number = 3;

    private var _from:PersonNode;
    private var _to:PersonNode;

    private var _color:Number;
    private var _thickness:Number;

    public function Line(from:PersonNode, to:PersonNode) {
      _from = from;
      _to = to;
      unhighlight();
    }

    public function get from():PersonNode { return _from; }
    public function get to():PersonNode { return _to; }

    public override function draw():void {
      graphics.clear();
      graphics.lineStyle(_thickness, _color);
      graphics.moveTo(_from.x, _from.y);
      graphics.lineTo(_to.x, _to.y);
    }

    public function highlight():void {
      _color = HIGHLIGHT_COLOR;
      _thickness = HIGHLIGHT_THICKNESS;
      draw();
    }

    public function extraHighlight():void {
      _color = EXTRA_HIGHLIGHT_COLOR;
      _thickness = HIGHLIGHT_THICKNESS;
      draw();
    }

    public function unhighlight():void {
      _color = COLOR;
      _thickness = THICKNESS;
      draw();
    }

  }
}
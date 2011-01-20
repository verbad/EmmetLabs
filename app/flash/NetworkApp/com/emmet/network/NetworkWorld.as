package com.emmet.network {
  import flash.events.Event;
  import flash.display.DisplayObject;
  import com.emmet.util.DrawableView;
  import flash.text.TextField;
  import flash.geom.Rectangle;
  import com.emmet.util.Vector;
  import com.emmet.util.HorizontalSegmentNode;
  import com.emmet.util.VerticalSegmentNode;

  public class NetworkWorld extends World {
    private var _tethers:Array;
    public static var __friction:Number = .35;
    private var _aboveFold:Boolean;

    public function NetworkWorld() {
      _tethers = [];
      _aboveFold = false;
      addEventListener(Event.ADDED_TO_STAGE, addedToStage);
    }

    public override function get friction():Number { return __friction; }
    public override function get stopPhysicsAfterStabilize():Boolean { return true; }
    public override function get velocityCutoff():Number { return nodes.length/ (_aboveFold ? 5 : 10); }
    public function get tethers():Array { return _tethers; }

    public function set aboveFold(above:Boolean):void { _aboveFold = above; }
    public function get aboveFold():Boolean { return _aboveFold; }

    public function addTether(tether:Tether):void {
      tethers.push(tether);
      addChild(tether);
    }

    protected override function calculateInfluences():void {
      for (var i:String in nodes) {
        var node:Node = nodes[i];
        for (var j:String in nodes) {
          var otherNode:Node = nodes[j];
          if (node != otherNode) {
            node.influence(otherNode);
          }
        }
      }

      for (var s:String in tethers) {
        tethers[s].influenceNodes();
      }
    }

    private function addedToStage(e:Event):void {
      var yOffset:int = 0;
      if (_aboveFold) {
        yOffset = stage.stageHeight / 4;
        y = yOffset;
      }

      var screenLeft:Number = -stage.stageWidth/2;
      var screenRight:Number = stage.stageWidth/2;
      var screenTop:Number = -stage.stageHeight/2 + 20 + yOffset;
      var screenBottom:Number = stage.stageHeight/2 - 20 + yOffset;

      var topLine:HorizontalSegmentNode = new HorizontalSegmentNode(null, Vector.fromCartesian(screenLeft, screenTop), Vector.fromCartesian(screenRight, screenTop), 1, 10);
      addNode(topLine);

      var bottomLine:HorizontalSegmentNode = new HorizontalSegmentNode(null, Vector.fromCartesian(screenLeft, screenBottom), Vector.fromCartesian(screenRight, screenBottom), 1, 10);
      addNode(bottomLine);

      var leftLine:VerticalSegmentNode = new VerticalSegmentNode(null, Vector.fromCartesian(screenLeft, screenTop), Vector.fromCartesian(screenLeft, screenBottom), 1, 10);
      addNode(leftLine);

      var rightLine:VerticalSegmentNode = new VerticalSegmentNode(null, Vector.fromCartesian(screenRight, screenTop), Vector.fromCartesian(screenRight, screenBottom), 1, 10);
      addNode(rightLine);
    }

    protected override function updatePositions():void {
      super.updatePositions();
      for (var i:String in tethers) {
        tethers[i].draw();
      }
    }
  }
}
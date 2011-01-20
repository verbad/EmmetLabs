package com.emmet.timeline {
  import com.emmet.util.DrawableView;
  import com.emmet.network.Portrait;
  import com.emmet.util.Vector;
  import com.emmet.network.Node;
  import flash.events.Event;
  import flash.display.Sprite;
  import com.emmet.network.World;
  import flash.errors.StackOverflowError;
  import com.emmet.util.ArrayUtils;
  import flash.display.Bitmap;
  import com.emmet.model.Timeline;
  import com.emmet.model.Milestone;
  import com.emmet.network.BoundingBoxNode;
  import com.emmet.network.FuzzyLabel;
  import com.emmet.network.Tether;
  import com.emmet.wander.Line;
  import com.emmet.util.HorizontalSegmentNode;

  public class TimelineWorld extends World {
    private var WIDTH:int = 400;
    private var _tethers:Array = new Array();
    private var _timeline:Timeline;

    public function TimelineWorld(timeline:Timeline) {
      super();
      _timeline = timeline;
      graphics.clear();
      drawLine();
      addMilestones();
    }

    public override function get stopPhysicsAfterStabilize():Boolean { return true; }

    public override function get velocityCutoff():Number { return 0.1 * _timeline.milestones.length; }

    public override function get friction():Number { return 0.4; }

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

      for (var k:String in _tethers) {
        _tethers[k].influenceNodes();
      }
    }
    private function addMilestones():void {
      for (var i:int = 0; i< _timeline.milestones.length; i++) {
        var milestone:Milestone = _timeline.milestones[i];
        var x:int = lineLeft() + (WIDTH - 100) * _timeline.proportionFor(milestone);

        var notchNode:Node = new Node(new NotchView(), 1, 0, true);
        notchNode.x = x;

        var label:FuzzyLabel = new FuzzyLabel(milestone.displayLabel());
        var boundingBoxNode:BoundingBoxNode = new BoundingBoxNode(label, 1, 200);
        boundingBoxNode.x = x;
        boundingBoxNode.y = 25 * (i%2 == 0 ? 1 : -1 );

        var tether:Tether = new Tether(notchNode, boundingBoxNode, 1, 10, 0.06, true);
        _tethers.push(tether);
        addChild(tether);

        addNode(notchNode);
        addNode(boundingBoxNode);
      }
    }

    protected override function updatePositions():void {
      super.updatePositions();
      for (var i:String in _tethers) {
        _tethers[i].draw();
      }
    }

    private function drawLine():void {
      addNode(new HorizontalSegmentNode(new LineView(lineLeft(), lineRight(), 0, 0), Vector.fromCartesian(lineLeft(), 0), Vector.fromCartesian(lineRight(), 0), 1, 400));
    }

    private function lineLeft():int {
      return -lineRight();
    }

    private function lineRight():int {
      return WIDTH / 2 - 50;
    }
  }
}
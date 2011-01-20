package com.emmet.wander {
  import com.emmet.network.Node;
  import com.emmet.network.World;
  import com.emmet.util.ArrayUtils;

  import flash.display.Sprite;

  public class WanderWorld extends World {
    public static const VELOCITY_CUTOFF:Number = .1;
    private static const __friction:Number = .8;
    private var _leftPortraitSite:Attractor;
    private var _leftRelationshipSites:Array;

    private var _rightPortraitSite:Attractor;
    private var _rightRelationshipSites:Array;

    private var _offstageLeft:Attractor;
    private var _offstageRight:Attractor;
    private var _leftAddRelationshipSite:Attractor;
    private var _rightAddRelationshipSite:Attractor;
    private var _leftLoadingSite:Attractor;
    private var _rightLoadingSite:Attractor;

    private var _carouselLeftTopOffstageSite:Attractor;
    private var _carouselLeftBottomOffstageSite:Attractor;
    private var _carouselRightTopOffstageSite:Attractor;
    private var _carouselRightBottomOffstageSite:Attractor;

    private var _lines:Array;
    private var _attractors:Array;

    private var _upArrowLeft:UpArrow;
    private var _upArrowRight:UpArrow;
    private var _downArrowLeft:DownArrow;
    private var _downArrowRight:DownArrow;

    public function WanderWorld() {
      _lines = [];
      _leftRelationshipSites = [];
      _rightRelationshipSites = [];
      _attractors = [];

      buildArrows();

      buildLeftAndRightRelationshipSites();
      buildPortraitSites();
      buildOffstageSites();
      super();
    }

    public override function get friction():Number { return __friction; }
    public override function get velocityCutoff():Number { return VELOCITY_CUTOFF; }

    private function buildLeftAndRightRelationshipSites():void {
      for (var i:Number = 0; i < 5; i++) {
        leftRelationshipSites.push(buildRelationshipSite(i, -1));
        rightRelationshipSites.push(buildRelationshipSite(i, 1));
      }
    }

    private function buildRelationshipSite(index:int, side:int):Attractor {
      var relationshipSite:Attractor = new Attractor();
      relationshipSite.x = 250 * side;
      relationshipSite.y = -80 + 40 * index;
      addAttractor(relationshipSite);
      return relationshipSite;
    }

    private function buildPortraitSites():void {
      _leftPortraitSite = new Attractor();
      _leftPortraitSite.x = -70;
      addAttractor(_leftPortraitSite);

      _rightPortraitSite = new Attractor();
      _rightPortraitSite.x = 70;
      addAttractor(_rightPortraitSite);
    }

    private function buildArrows():void {
      _upArrowLeft = new UpArrow(-250, -118 + 12);
      addChild(_upArrowLeft);

      _upArrowRight = new UpArrow(250, -118 + 12);
      addChild(_upArrowRight);

      _downArrowLeft = new DownArrow(-250, 115 - 12);
      addChild(_downArrowLeft);

      _downArrowRight = new DownArrow(250, 115 - 12);
      addChild(_downArrowRight);
    }

    public function showInboundArrows():void {
      _upArrowLeft.visible = true;
      _downArrowLeft.visible = true;
    }

    public function getUpArrowLeft():Arrow {return _upArrowLeft;}
    public function getDownArrowLeft():Arrow {return _downArrowLeft;}
    public function getUpArrowRight():Arrow {return _upArrowRight;}
    public function getDownArrowRight():Arrow {return _downArrowRight;}

    public function showOutboundArrows():void {
      _upArrowRight.visible = true;
      _downArrowRight.visible = true;
    }

    public function hideInboundArrows():void {
      _upArrowLeft.visible = false;
      _downArrowLeft.visible = false;
    }

    public function hideOutboundArrows():void {
      _upArrowRight.visible = false;
      _downArrowRight.visible = false;
    }

    private function buildOffstageSites():void {
      _offstageLeft = new Attractor();
      _offstageLeft.x = -500;
      addAttractor(_offstageLeft);

      _leftAddRelationshipSite = new Attractor();
      _leftAddRelationshipSite.x = -175;
      addAttractor(_leftAddRelationshipSite);

      _rightAddRelationshipSite = new Attractor();
      _rightAddRelationshipSite.x = 175;
      addAttractor(_rightAddRelationshipSite);

      _leftLoadingSite = new Attractor();
      _leftLoadingSite.x = -175;
      addAttractor(_leftLoadingSite);

      _rightLoadingSite = new Attractor();
      _rightLoadingSite.x = 175;
      addAttractor(_rightLoadingSite);

      _offstageRight = new Attractor();
      _offstageRight.x = 500;
      addAttractor(_offstageRight);

      _carouselLeftTopOffstageSite = new Attractor();
      _carouselLeftTopOffstageSite.x = -200;
      _carouselLeftTopOffstageSite.y = -180;
      addAttractor(_carouselLeftTopOffstageSite);

      _carouselLeftBottomOffstageSite = new Attractor();
      _carouselLeftBottomOffstageSite.x = -200;
      _carouselLeftBottomOffstageSite.y = 180;
      addAttractor(_carouselLeftBottomOffstageSite);

      _carouselRightTopOffstageSite = new Attractor();
      _carouselRightTopOffstageSite.x = 200;
      _carouselRightTopOffstageSite.y = -180;
      addAttractor(_carouselRightTopOffstageSite);

      _carouselRightBottomOffstageSite = new Attractor();
      _carouselRightBottomOffstageSite.x = 200;
      _carouselRightBottomOffstageSite.y = 180;
      addAttractor(_carouselRightBottomOffstageSite);
    }

    public function get leftRelationshipSites():Array { return _leftRelationshipSites; }
    public function get rightRelationshipSites():Array { return _rightRelationshipSites; }
    public function get offstageLeft():Attractor { return _offstageLeft; }
    public function get offstageRight():Attractor { return _offstageRight; }
    public function get  leftAddRelationshipSite():Attractor { return _leftAddRelationshipSite; }
    public function get rightAddRelationshipSite():Attractor { return _rightAddRelationshipSite; }
    public function get  leftLoadingSite():Attractor {return _leftLoadingSite; }
    public function get rightLoadingSite():Attractor {return _rightLoadingSite; }

    public function get lines():Array { return _lines; }

    public function get carouselLeftTopOffstageSite():Attractor { return _carouselLeftTopOffstageSite; }
    public function get carouselLeftBottomOffstageSite():Attractor { return _carouselLeftBottomOffstageSite; }
    public function get carouselRightTopOffstageSite():Attractor { return _carouselRightTopOffstageSite; }
    public function get carouselRightBottomOffstageSite():Attractor { return _carouselRightBottomOffstageSite; }

    public function addNodeAtSite(node:Node, startSite:Attractor):void {
      super.addNode(node);
      startSite.position(node);
    }

    public function addLine(line:Line):void {
      _lines.push(line);
      addChild(line);
    }

    public function removeLine(line:Line):void {
      _lines = ArrayUtils.removeFromArray(_lines, line);
      removeChild(line);
    }

    public function registerAttractor(attractor:Attractor):void {
      attractor.world = this;
      _attractors.push(attractor);
    }

    public function addAttractor(attractor:Attractor):void {
      registerAttractor(attractor);
      addChild(attractor);
    }
    public function get leftPortraitSite():Attractor {
      return _leftPortraitSite;
    }

    public function get rightPortraitSite():Attractor {
      return _rightPortraitSite;
    }

    public function moveToFront(sprite:Sprite):void {
      setChildIndex(sprite, numChildren - 1);
    }

    public function moveToBack(sprite:Sprite):void {
      setChildIndex(sprite, 0);
    }

    protected override function calculateInfluences():void {
      for (var i:String in _attractors) {
        (_attractors[i] as Attractor).influenceTargets();
      }
    }

    protected override function updatePositions():void {
      super.updatePositions();
      for (var i:String in _lines) {
        (_lines[i] as Line).draw();
      }
    }

  }
}
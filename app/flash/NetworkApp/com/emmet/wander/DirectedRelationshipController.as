package com.emmet.wander {
  import com.emmet.model.DirectedRelationship;
  import com.emmet.model.Person;
  import com.emmet.network.EmmetLabel;
  import com.emmet.network.HighlightableEmmetLabel;
  import com.emmet.network.Node;
  import com.emmet.util.UrlNavigation;
  import com.emmet.util.WanderXmlParser;
  
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.utils.Dictionary;

  public class DirectedRelationshipController {
    private var _world:WanderWorld;
    private var _leftPortrait:PersonNode;
    private var _rightPortrait:PersonNode;
    private var _inboundRelationshipControllers:Array;
    private var _outboundRelationshipControllers:Array;
    private var _directedRelationship:DirectedRelationship;
    private var _portraitToPortraitLine:Line;
    private var _inboundRelationshipsCursorPosition:int;
    private var _outboundRelationshipsCursorPosition:int;
    private var _leftAddRelationshipNode: Node;
    private var _rightAddRelationshipNode: Node;
    private var _leftLoadingNode: Node;
    private var _rightLoadingNode: Node;


    private static var __controllerFor:Dictionary = new Dictionary(true);

    public static function fromModel(world:WanderWorld, directedRelationship:DirectedRelationship):DirectedRelationshipController {
      var directedRelationshipController:DirectedRelationshipController = new DirectedRelationshipController().initializeFromModel(world, directedRelationship);
      setControllerFor(directedRelationship, directedRelationshipController);
      return directedRelationshipController;
    }

    public function get leftPortrait():PersonNode { return _leftPortrait; }
    public function get rightPortrait():PersonNode { return _rightPortrait; }
    public function get inboundRelationshipControllers():Array { return _inboundRelationshipControllers; }
    public function get outboundRelationshipControllers():Array { return _outboundRelationshipControllers; }
    public function get directedRelationship():DirectedRelationship { return _directedRelationship; }
    public function get portraitToPortraitLine():Line { return _portraitToPortraitLine; }
    public function get world():WanderWorld { return _world; }

    protected static function controllerFor(directedRelationship:DirectedRelationship):DirectedRelationshipController {
      return __controllerFor[directedRelationship]
    }

    protected static function setControllerFor(directedRelationship:DirectedRelationship, directedRelationshipController:DirectedRelationshipController):void {
      __controllerFor[directedRelationship] = directedRelationshipController
    }

    public function initializeFromModel(world:WanderWorld, directedRelationship:DirectedRelationship):DirectedRelationshipController {
      _world = world;
      _directedRelationship = directedRelationship;

      determineArrowVisibility(_directedRelationship);
      addArrowEventHandlers();

      _leftPortrait = new PersonNode(_directedRelationship.from, PersonNode.PORTRAIT, true);

      world.leftPortraitSite.attach(_leftPortrait);

      _rightPortrait = new PersonNode(_directedRelationship.to, PersonNode.PORTRAIT, false);

      world.rightPortraitSite.attach(_rightPortrait);

      _portraitToPortraitLine = new Line(_leftPortrait, _rightPortrait);

      _inboundRelationshipsCursorPosition = 0;
      _outboundRelationshipsCursorPosition = 0;

      var addLabel:String = 'add a relationship';
      
      if (!FlashApp.LOGGED_IN) {
        addLabel = "log in to\n" + addLabel;
      }

      _leftAddRelationshipNode = new Node(new HighlightableEmmetLabel(addLabel, HighlightableEmmetLabel.DEFAULT_HIGHLIGHT_COLOR, EmmetLabel.DEFAULT_FONT_SIZE, HighlightableEmmetLabel.DEFAULT_HIGHLIGHT_COLOR, '_helvetica_italic'), 0, 0);
      world.addNodeAtSite(_leftAddRelationshipNode, world.leftAddRelationshipSite);
      _rightAddRelationshipNode = new Node(new HighlightableEmmetLabel(addLabel, HighlightableEmmetLabel.DEFAULT_HIGHLIGHT_COLOR, EmmetLabel.DEFAULT_FONT_SIZE, HighlightableEmmetLabel.DEFAULT_HIGHLIGHT_COLOR, '_helvetica_italic'), 0, 0);
      world.addNodeAtSite(_rightAddRelationshipNode, world.rightAddRelationshipSite);
      _leftAddRelationshipNode.addEventListener(MouseEvent.CLICK, leftAddRelationshipNodeClicked);
      _rightAddRelationshipNode.addEventListener(MouseEvent.CLICK, rightAddRelationshipNodeClicked);

      // _leftLoadingNode = new LoadingNode();
      _leftLoadingNode = new Node(new EmmetLabel('Loading…', 0xb9532e, EmmetLabel.DEFAULT_FONT_SIZE, '_helvetica_bold'), 0, 0);
      world.addNodeAtSite(_leftLoadingNode, world.leftLoadingSite);
      // _rightLoadingNode = new LoadingNode();
      _rightLoadingNode = new Node(new EmmetLabel('Loading…', 0xb9532e, EmmetLabel.DEFAULT_FONT_SIZE, '_helvetica_bold'), 0, 0);
      world.addNodeAtSite(_rightLoadingNode, world.rightLoadingSite);
      
      _leftLoadingNode.visible = true;
      _rightLoadingNode.visible = true;
 
      determineAddRelationshipAndLoadingNodesVisibility(_directedRelationship);

      createInboundRelationshipControllers(_directedRelationship.from.directedRelationships, _leftPortrait, world.leftPortraitSite);
      createOutboundRelationshipControllers(_directedRelationship.to.directedRelationships, _rightPortrait, world.rightPortraitSite);

      world.addLine(_portraitToPortraitLine);
      world.addNode(_rightPortrait);
      world.addNode(_leftPortrait);
      return this;
    }

    private static const LEFT:int = 0;
    private static const RIGHT:int = 0;

    private function leftAddRelationshipNodeClicked(e:Event):void {
      navigateToAddConnection(_directedRelationship.from);
    }

    private function rightAddRelationshipNodeClicked(e:Event):void {
      navigateToAddConnection(_directedRelationship.to);
    }

    private function navigateToAddConnection(person:Person):void {
      UrlNavigation.instance.go(person.addConnectionUrl);
    }

    protected function descendantsLoaded():void {
      for each (var fromR:DirectedRelationship in _directedRelationship.from.directedRelationships) {
        fromR.stub = false;
      }

      for each (var toR:DirectedRelationship in _directedRelationship.to.directedRelationships) {
        toR.stub = false;
      }
    }

    public function transitionToRight(selectedInboundRelationshipController:InboundRelationshipController):void {
      world.enablePhysics();
      removeEventListeners();
      selectedInboundRelationshipController.startBlinking();

      selectedInboundRelationshipController.loadExtendedRelationships(
        function():void {
          // 1. Mark descendants as non-stub
          descendantsLoaded()
          // 4. Fire the Listener

        });

      selectedInboundRelationshipController.stopBlinking();
      var newDirectedRelationship:DirectedRelationship = selectedInboundRelationshipController.directedRelationship;
      var newLeftPortrait:PersonNode = selectedInboundRelationshipController.fromNode;
      var newRightPortrait:PersonNode = _leftPortrait;
      newLeftPortrait.becomeLeft();
      newRightPortrait.becomeRight();
      var oldRightPortrait:PersonNode = _rightPortrait;

      moveNewLeftPortraitRight(newLeftPortrait, selectedInboundRelationshipController);
      moveNewRightPortraitRight(newRightPortrait);
      moveCurrentOutboundRelationshipsOffstage();
      moveNewOutboundRelationshipsToRight(selectedInboundRelationshipController, oldRightPortrait, newRightPortrait);
      _directedRelationship = newDirectedRelationship;

      if (!newDirectedRelationship.from.stub) {
        createInboundRelationshipControllers(newDirectedRelationship.from.directedRelationships, newLeftPortrait, world.offstageLeft);
      } else {
        // Note: INVERSE
        newDirectedRelationship.inverse().addEventListener(WanderXmlParser.XML_COMPLETE_EVENT, function (event:Event):void {
          createInboundRelationshipControllers(newDirectedRelationship.from.directedRelationships, newLeftPortrait, world.offstageLeft);
          determineArrowVisibility(newDirectedRelationship);
          determineAddRelationshipAndLoadingNodesVisibility(newDirectedRelationship);
        });
      }

      determineArrowVisibility(newDirectedRelationship);
      determineAddRelationshipAndLoadingNodesVisibility(newDirectedRelationship);

      _portraitToPortraitLine = selectedInboundRelationshipController.line;
      _leftPortrait = newLeftPortrait;
      _rightPortrait = newRightPortrait;
    }

    public function transitionToLeft(selectedOutboundRelationshipController:OutboundRelationshipController):void {
      world.enablePhysics();
      removeEventListeners();
      selectedOutboundRelationshipController.startBlinking();

      selectedOutboundRelationshipController.loadExtendedRelationships(
        function():void {
          // 1. Mark descendants as non-stub
          descendantsLoaded()
          // 4. Fire the Listener

        });
      selectedOutboundRelationshipController.stopBlinking();
      var newDirectedRelationship:DirectedRelationship = selectedOutboundRelationshipController.directedRelationship;
      var newRightPortrait:PersonNode = selectedOutboundRelationshipController.toNode;
      var newLeftPortrait:PersonNode = _rightPortrait;
      newRightPortrait.becomeRight();
      newLeftPortrait.becomeLeft();

      var oldLeftPortrait:PersonNode = _leftPortrait;

      moveNewRightPortraitLeft(newRightPortrait, selectedOutboundRelationshipController);
      moveNewLeftPortraitLeft(newLeftPortrait);
      moveCurrentInboundRelationshipsOffstage();
      moveNewInboundRelationshipsToLeft(selectedOutboundRelationshipController, oldLeftPortrait, newLeftPortrait);
      _directedRelationship = newDirectedRelationship;
      if (!newDirectedRelationship.to.stub) {
        createOutboundRelationshipControllers(newDirectedRelationship.to.directedRelationships, newRightPortrait, world.offstageRight);
      } else {
        newDirectedRelationship.addEventListener(WanderXmlParser.XML_COMPLETE_EVENT, function (event:Event):void {
          createOutboundRelationshipControllers(newDirectedRelationship.to.directedRelationships, newRightPortrait, world.offstageRight);
          determineArrowVisibility(newDirectedRelationship);
          determineAddRelationshipAndLoadingNodesVisibility(newDirectedRelationship);
        });
      }

      determineArrowVisibility(newDirectedRelationship);
      determineAddRelationshipAndLoadingNodesVisibility(newDirectedRelationship);

      _portraitToPortraitLine = selectedOutboundRelationshipController.line;
      _leftPortrait = newLeftPortrait;
      _rightPortrait = newRightPortrait;
    }

    private function determineArrowVisibility(directedRelationship:DirectedRelationship):void {
      if (!directedRelationship.from.stub && directedRelationship.from.directedRelationships.length - 1 > 5) {
        world.showInboundArrows();
      } else {
        world.hideInboundArrows();
      }

      if (!directedRelationship.to.stub && directedRelationship.to.directedRelationships.length - 1 > 5) {
        world.showOutboundArrows();
      } else {
        world.hideOutboundArrows();
      }
    }

    private function determineAddRelationshipAndLoadingNodesVisibility(directedRelationship:DirectedRelationship):void {
      if (directedRelationship.from.stub) {
        _leftLoadingNode.view.visible = true;
        _leftAddRelationshipNode.view.visible = false;
      } else {
        _leftLoadingNode.view.visible = false;
        _leftAddRelationshipNode.view.visible  = directedRelationship.from.directedRelationships.length == 1;
      }
      if (directedRelationship.to.stub) {
        _rightLoadingNode.view.visible = true;
        _rightAddRelationshipNode.view.visible = false;
      } else {
        _rightLoadingNode.view.visible = false;
        _rightAddRelationshipNode.view.visible  = directedRelationship.to.directedRelationships.length == 1;
      }
    }

    public function removeEventListeners():void {
      for (var i:String in extendedRelationshipControllers) {
        (extendedRelationshipControllers[i] as ExtendedRelationshipController).removeEventListeners();
      }
    }

    public function get extendedRelationshipControllers():Array {
      return inboundRelationshipControllers.concat(outboundRelationshipControllers);
    }

    private function moveNewLeftPortraitRight(newLeftPortrait:PersonNode, selectedExtendedRelationshipController:ExtendedRelationshipController):void {
       newLeftPortrait.becomePortrait();
       selectedExtendedRelationshipController.relationshipSite.detach(newLeftPortrait);
       world.leftPortraitSite.attract(newLeftPortrait);
    }

    private function moveNewRightPortraitLeft(newRightPortrait:PersonNode, selectedExtendedRelationshipController:ExtendedRelationshipController):void {
       newRightPortrait.becomePortrait();
       selectedExtendedRelationshipController.relationshipSite.detach(newRightPortrait);
       world.rightPortraitSite.attract(newRightPortrait);
    }

    private function moveNewRightPortraitRight(newRightPortrait:PersonNode):void {
      world.leftPortraitSite.detach(newRightPortrait);
      world.moveToFront(newRightPortrait);
      world.rightPortraitSite.attract(newRightPortrait);
    }

    private function moveNewLeftPortraitLeft(newLeftPortrait:PersonNode):void {
      world.rightPortraitSite.detach(newLeftPortrait);
      world.moveToFront(newLeftPortrait);
      world.leftPortraitSite.attract(newLeftPortrait);
    }

    private function moveCurrentOutboundRelationshipsOffstage():void {
      for (var i:String in outboundRelationshipControllers) {
        var outboundRelationshipController:OutboundRelationshipController = outboundRelationshipControllers[i];
        world.rightRelationshipSites[i].detach(outboundRelationshipController.extendedNode);
        outboundRelationshipController.exitWorldToWing();
      }
      _outboundRelationshipControllers = [];
    }

    private function moveCurrentInboundRelationshipsOffstage():void {
      for (var i:String in inboundRelationshipControllers) {
        var inboundRelationshipController:InboundRelationshipController = inboundRelationshipControllers[i];
        world.leftRelationshipSites[i].detach(inboundRelationshipController.extendedNode);
        inboundRelationshipController.exitWorldToWing();
      }
      _inboundRelationshipControllers = [];
    }

    private function moveNewOutboundRelationshipsToRight(selectedInboundRelationshipController:InboundRelationshipController, oldRightPortrait:PersonNode, newRightPortrait:PersonNode):void {
      for (var i:String in inboundRelationshipControllers) {
        var curInboundRelationshipController:InboundRelationshipController = inboundRelationshipControllers[i];

        if (curInboundRelationshipController == selectedInboundRelationshipController) {
          world.rightPortraitSite.detach(oldRightPortrait);
          oldRightPortrait.becomeLabel();
          oldRightPortrait.becomeRight();
          outboundRelationshipControllers.push(new OutboundRelationshipController(world, directedRelationship, newRightPortrait, oldRightPortrait, _portraitToPortraitLine, world.rightRelationshipSites[i], this));
        } else {
          var outboundRelationship:DirectedRelationship = curInboundRelationshipController.directedRelationship.inverse();
          curInboundRelationshipController.detachFromNode();
          var personNode:PersonNode = curInboundRelationshipController.fromNode;
          personNode.becomeRight();
          outboundRelationshipControllers.push(new OutboundRelationshipController(world, outboundRelationship, newRightPortrait, personNode, curInboundRelationshipController.line, world.rightRelationshipSites[i], this));
        }
        }
        _inboundRelationshipControllers = [];
    }

    private function moveNewInboundRelationshipsToLeft(selectedOutboundRelationshipController:OutboundRelationshipController, oldLeftPortrait:PersonNode, newLeftPortrait:PersonNode):void {
      for (var i:String in outboundRelationshipControllers) {
        var curOutboundRelationshipController:OutboundRelationshipController = outboundRelationshipControllers[i];

        if (curOutboundRelationshipController == selectedOutboundRelationshipController) {
          world.leftPortraitSite.detach(oldLeftPortrait);
          oldLeftPortrait.becomeLabel();
          oldLeftPortrait.becomeLeft();
          inboundRelationshipControllers.push(new InboundRelationshipController(world, directedRelationship, oldLeftPortrait, newLeftPortrait, _portraitToPortraitLine, world.leftRelationshipSites[i], this));
        } else {
          var inboundRelationship:DirectedRelationship = curOutboundRelationshipController.directedRelationship.inverse();
          curOutboundRelationshipController.detachToNode();
          var personNode:PersonNode = curOutboundRelationshipController.toNode;
          personNode.becomeLeft();
          inboundRelationshipControllers.push(new InboundRelationshipController(world, inboundRelationship, curOutboundRelationshipController.toNode, newLeftPortrait, curOutboundRelationshipController.line, world.leftRelationshipSites[i], this));
        }
      }
      _outboundRelationshipControllers = [];
    }

    private function createInboundRelationshipControllers(inboundRelationships:Array, toNode:PersonNode, startSite:Attractor):void {
      _inboundRelationshipControllers = [];
      var counter:int = 0;
      var createdCount:int = 0;
      while (createdCount < 5 && counter < inboundRelationships.length) {
        var inboundRelationship:DirectedRelationship = inboundRelationships[counter];
        if (inboundRelationship != _directedRelationship) {
          var leftRelationshipSite:Attractor = world.leftRelationshipSites[createdCount]
          inboundRelationshipControllers.push(InboundRelationshipController.buildFromDirectedRelationship(world, inboundRelationship, toNode, leftRelationshipSite, this, startSite));
          createdCount++;
        }
        counter++;
      }
    }

    private function createOutboundRelationshipControllers(outboundRelationships:Array, fromNode:PersonNode, startSite:Attractor):void {
      _outboundRelationshipControllers = [];
      var counter:int = 0;
      var createdCount:int = 0;
      while (createdCount< 5 && counter < outboundRelationships.length) {
        var index:int = (_outboundRelationshipsCursorPosition + counter) % outboundRelationships.length;
        var outboundRelationship:DirectedRelationship = outboundRelationships[index];
        if (outboundRelationship != _directedRelationship.inverse()) {
          var rightRelationshipSite:Attractor = world.rightRelationshipSites[createdCount]
          outboundRelationshipControllers.push(OutboundRelationshipController.buildFromDirectedRelationship(world, outboundRelationship, fromNode, rightRelationshipSite, this, startSite));
          createdCount++;
        }
        counter++;
      }
    }

    private function addArrowEventHandlers():void {
      _world.getUpArrowLeft().addEventListener(MouseEvent.CLICK, scrollInboundUp);
      _world.getDownArrowLeft().addEventListener(MouseEvent.CLICK, scrollInboundDown);
      _world.getUpArrowRight().addEventListener(MouseEvent.CLICK, scrollOutboundUp);
      _world.getDownArrowRight().addEventListener(MouseEvent.CLICK, scrollOutboundDown);
    }

    private function moveCurrentInboundRelationshipsUp(): void {
      _inboundRelationshipControllers[0].exitWorld(_world.carouselLeftTopOffstageSite);
      for (var i:int=1; i < 5; i++) {
        var inboundRelationshipController:InboundRelationshipController = _inboundRelationshipControllers[i];
        inboundRelationshipController.relationshipSite = _world.leftRelationshipSites[i - 1];
      }
    }

    private function moveCurrentInboundRelationshipsDown(): void {
       _inboundRelationshipControllers[4].exitWorld(_world.carouselLeftBottomOffstageSite);
      for (var i:int=0; i < 4; i++) {
        var inboundRelationshipController:InboundRelationshipController = _inboundRelationshipControllers[i];
        inboundRelationshipController.relationshipSite = _world.leftRelationshipSites[i + 1];
      }
    }

    private function moveCurrentOutboundRelationshipsUp(): void {
      _outboundRelationshipControllers[0].exitWorld(_world.carouselRightTopOffstageSite);
      for (var i:int=1; i < 5; i++) {
        var outboundRelationshipController:OutboundRelationshipController = _outboundRelationshipControllers[i];
        outboundRelationshipController.relationshipSite = _world.rightRelationshipSites[i - 1];
      }
    }

    private function moveCurrentOutboundRelationshipsDown(): void {
      _outboundRelationshipControllers[4].exitWorld(_world.carouselRightBottomOffstageSite);
      for (var i:int=0; i < 4; i++) {
        var outboundRelationshipController:OutboundRelationshipController = _outboundRelationshipControllers[i];
        outboundRelationshipController.relationshipSite = _world.rightRelationshipSites[i + 1];
      }
    }

    private function scrollInboundUp(event:MouseEvent):void {
      var relationships:Array = _directedRelationship.from.directedRelationships;
      _inboundRelationshipsCursorPosition --;
      if (_inboundRelationshipsCursorPosition < 0) {
        _inboundRelationshipsCursorPosition = relationships.length + _inboundRelationshipsCursorPosition;
      }

      moveCurrentInboundRelationshipsDown();

      _inboundRelationshipControllers.pop();
      var newVisibleRelationship:DirectedRelationship = relationships[_inboundRelationshipsCursorPosition % relationships.length];

      _inboundRelationshipControllers = [InboundRelationshipController.buildFromDirectedRelationship(_world, newVisibleRelationship, _leftPortrait, _world.leftRelationshipSites[0], this, _world.carouselLeftTopOffstageSite)].concat(_inboundRelationshipControllers);
    }

    private function scrollInboundDown(event:MouseEvent):void {
      var relationships:Array = _directedRelationship.from.directedRelationships;
      _inboundRelationshipsCursorPosition ++;
      moveCurrentInboundRelationshipsUp();

      _inboundRelationshipControllers.shift();
      var newVisibleRelationship:DirectedRelationship = relationships[(_inboundRelationshipsCursorPosition + 4) % relationships.length];

      _inboundRelationshipControllers.push(InboundRelationshipController.buildFromDirectedRelationship(_world, newVisibleRelationship, _leftPortrait, _world.leftRelationshipSites[4], this, _world.carouselLeftBottomOffstageSite));
    }

    private function scrollOutboundUp(event:MouseEvent):void {
      var relationships:Array = _directedRelationship.to.directedRelationships;
      _outboundRelationshipsCursorPosition --;
      if (_outboundRelationshipsCursorPosition < 0) {
        _outboundRelationshipsCursorPosition = relationships.length + _outboundRelationshipsCursorPosition;
      }

      moveCurrentOutboundRelationshipsDown();

      _outboundRelationshipControllers.pop();
      var newVisibleRelationship:DirectedRelationship = relationships[_outboundRelationshipsCursorPosition % relationships.length];

      _outboundRelationshipControllers = [OutboundRelationshipController.buildFromDirectedRelationship(_world, newVisibleRelationship, _rightPortrait, _world.rightRelationshipSites[0], this, _world.carouselRightTopOffstageSite)].concat(_outboundRelationshipControllers);
    }

    private function scrollOutboundDown(event:MouseEvent):void {
      var relationships:Array = _directedRelationship.to.directedRelationships;
      _outboundRelationshipsCursorPosition ++;
      moveCurrentOutboundRelationshipsUp();

      _outboundRelationshipControllers.shift();
      var newVisibleRelationship:DirectedRelationship = relationships[(_outboundRelationshipsCursorPosition + 4) % relationships.length];

      _outboundRelationshipControllers.push(OutboundRelationshipController.buildFromDirectedRelationship(_world, newVisibleRelationship, _rightPortrait, _world.rightRelationshipSites[4], this, _world.carouselRightBottomOffstageSite));
    }

  }
}
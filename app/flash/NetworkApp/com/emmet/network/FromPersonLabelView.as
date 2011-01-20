package com.emmet.network {
  import com.emmet.model.Person;
  import com.emmet.util.DrawableView;
  import com.emmet.util.UrlNavigation;
  import com.emmet.util.Wedge;
  
  import flash.display.Bitmap;
  import flash.events.MouseEvent;

  public class FromPersonLabelView extends TreeView {
    public static const NAME_LABEL_COLOR:Number = 0x333333;
    public static const ADD_CONNECTION_LABEL_COLOR:Number = 0xB9532E;

    private var _world:NetworkWorld;
    protected var _fromPerson:Person;
    protected var _nameLabel:HighlightableEmmetLabel;

    [Embed(source='plus_icon.gif')]
    public var PlusIconImage:Class;

    public function FromPersonLabelView(fromPerson:Person, world:NetworkWorld, parentTreeView:TreeView, parent:Node, wedge:Wedge) {
      _fromPerson = fromPerson;
      _world = world;
      super(world, parentTreeView, parent, wedge);
    }

    protected override function instantiateNode():Node {
      var view:DrawableView = new DrawableView();
      _nameLabel = new HighlightableEmmetLabel(_fromPerson.name.replace(/ /, "\n") , NAME_LABEL_COLOR, 20);

      _nameLabel.buttonMode = true;
      _nameLabel.mouseChildren = false;
      _nameLabel.addEventListener(MouseEvent.MOUSE_UP, nameOnClick);

      view.addChild(_nameLabel);

      //if (FlashApp.LOGGED_IN) {
        var addConnectionView:DrawableView = new DrawableView();
        var plusIconImage:Bitmap = new PlusIconImage();
  
        var addLabel:String = "dd a relationship";
        if (FlashApp.LOGGED_IN) {
          addLabel = "A" + addLabel;
        } else {
          addLabel = "Log in to a" + addLabel;
        }
        
        var addConnectionLabel:HighlightableEmmetLabel = new HighlightableEmmetLabel(addLabel, ADD_CONNECTION_LABEL_COLOR, 15, ADD_CONNECTION_LABEL_COLOR);

        addConnectionView.addChild(plusIconImage);
        addConnectionView.addChild(addConnectionLabel);
        addConnectionView.addEventListener(MouseEvent.MOUSE_UP, addConnectionOnClick);
        addConnectionView.addEventListener(MouseEvent.MOUSE_OVER, addConnectionLabel.highlight);
        addConnectionView.addEventListener(MouseEvent.MOUSE_OUT, addConnectionLabel.unhighlight);
        addConnectionView.mouseChildren = false;
        addConnectionView.buttonMode = true;

        view.addChild(addConnectionView);
        addConnectionView.x = -_nameLabel.width / 2;
        addConnectionLabel.x = addConnectionLabel.width / 2 + plusIconImage.width;
        addConnectionLabel.y = 7 + _nameLabel.height / 2;
        plusIconImage.y = _nameLabel.height / 2;

        // make some room
        view.y = -addConnectionLabel.height / 2;
      //}
      
      return new BoundingBoxNode(view, 1, 10, true);
    }

    protected override function get tetherLength():Number {
      return 10;
    }

    protected override function get tetherSpring():Number {
      return 0.05;
    }

    protected override function get placementRadius():Number {
      return _nameLabel.width / 2 + 50;
    }

    protected override function get tetherVisible():Boolean {
      return false;
    }

    protected function addConnectionOnClick(e:MouseEvent):void {
      _world.disablePhysics();
      UrlNavigation.instance.go(_fromPerson.addConnectionUrl);
    }

    protected function nameOnClick(e:MouseEvent):void {
      _world.disablePhysics();
      UrlNavigation.instance.go(_fromPerson.profileUrl);
    }
  }
}
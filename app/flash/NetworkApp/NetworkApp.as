package {
  import com.emmet.network.World;
  import com.emmet.util.DrawableView;
  import com.emmet.model.Network;
  import com.emmet.network.NetworkView;
  import com.emmet.network.NetworkWorld;
  import flash.events.KeyboardEvent;
  import com.emmet.network.AdminInterface;

  public class NetworkApp extends FlashApp {

    [SWF(backgroundColor="0x00ffffff", frameRate="30")]

    private var _adminInterface:AdminInterface;
    private var _world:NetworkWorld;
    private var _network:Network;

    protected override function defaultXMLURL():String {
      //return "http://localhost:3000/network/Joe-Alex.xml"; // 1
      //return "http://localhost:3000/network/Aristotle-Onasis.xml"; // 2
      //return "http://localhost:3000/network/Noel.xml"; // 2 (3)
      //return "http://localhost:3000/network/Judith-Jaegermann.xml"; // 6
      return "http://localhost:3000/network/Josephine-Baker_1.xml";
      //return "http://localhost:3000/network/Jacqueline-Onassis.xml";
    }

    protected override function buildView(xml:XML):DrawableView {
      _network = new Network(xml);
      stage.addEventListener(KeyboardEvent.KEY_UP, revealAdminInterface);
      stage.focus = this;
      return createWorld();
    }

    private function createWorld():NetworkWorld {
      _world = new NetworkWorld();
      new NetworkView(_network, _world);
      return _world;
    }

    public function destroyWorld():void {
      _world.disablePhysics();
      removeChild(_world);
    }

    private function revealAdminInterface(event:KeyboardEvent):void {
      if (_adminInterface == null && event.charCode == 97) {
        _adminInterface = new AdminInterface();
        stage.addChild(_adminInterface);
      } else if (_adminInterface && (event.charCode == 97 || event.keyCode == 13)) {
        _adminInterface.apply();
        stage.removeChild(_adminInterface);
        _adminInterface = null;

        destroyWorld();
        setView(createWorld());
      }
    }
  }
}
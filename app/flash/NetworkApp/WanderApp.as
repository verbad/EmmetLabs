package {
  import com.emmet.util.DrawableView;
  import com.emmet.model.DirectedRelationship;
  import com.emmet.wander.DirectedRelationshipController;
  import com.emmet.wander.WanderWorld;
  import com.emmet.util.WanderXmlParser;
  // not used?
  //[Embed(systemFont="Helvetica", fontName="EmbeddedHelvetica", mimeType="application/x-font")]
  [Embed(systemFont="Helvetica", fontName="_helvetica_bold", fontWeight=BOLD, mimeType="application/x-font")]
  [SWF(backgroundColor="0x00ffffff", frameRate="30")]

  public class WanderApp extends FlashApp {
    protected override function defaultXMLURL():String {
      // return "http://localhost:3000/pair/Josephine-Baker/Grace-Kelly.xml";
      //return "http://localhost:3000/pair/Grace-Jones_62/Janice-Fraser_2.xml";
      return "http://localhost:3000/pair/Spartacus_306/Marcus-Licinius-Crassus_307.xml?first=true";
      // return "/tmp/wander.xml";
    }

    protected override function buildView(xml:XML):DrawableView {
        var parser:WanderXmlParser = new WanderXmlParser();
        var directedRelationship:DirectedRelationship = parser.parse(xml);
        var world:WanderWorld = new WanderWorld();
        var directedRelationshipController:DirectedRelationshipController = DirectedRelationshipController.fromModel(world, directedRelationship);
        return world;
    }
  }
}
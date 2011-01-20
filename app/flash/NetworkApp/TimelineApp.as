package {
  import com.emmet.timeline.TimelineWorld;
  import com.emmet.util.DrawableView;
  import com.emmet.util.TimelineXmlParser;
  import com.emmet.model.Timeline;

  // not used?
  //[Embed(systemFont="Helvetica", fontName="EmbeddedHelvetica", mimeType="application/x-font")]
  [SWF(backgroundColor="0x00ffffff", frameRate="30")]

  public class TimelineApp extends FlashApp {
    protected override function defaultXMLURL():String {
      return "http://localhost:3000/milestones/index/Josephine-Baker_1.xml";
    }

    protected override function buildView(xml:XML):DrawableView {
      var parser:TimelineXmlParser = new TimelineXmlParser();
      var timeline:Timeline = parser.parse(xml);
      return new TimelineWorld(timeline);
    }
  }
}
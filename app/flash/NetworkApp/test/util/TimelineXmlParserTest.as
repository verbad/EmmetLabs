package test.util {
  import asunit.framework.TestCase;
  import test.FlashAppTestCase;
  import com.emmet.util.TimelineXmlParser;
  import com.emmet.model.Milestone;
  import com.emmet.model.Timeline;

  public class TimelineXmlParserTest extends FlashAppTestCase {

    private var _xml:XML;
    private var _parser:TimelineXmlParser;

    protected override function setUp():void {
      _xml =  <timeline person_id="7">
                <milestone>
                  <date>
                    <year>1906</year>
                    <month>6</month>
                    <day>3</day>
                  </date>
                  <name>Born in Missouri</name>
                </milestone>
                <milestone>
                  <date>
                    <year>1975</year>
                    <month>4</month>
                    <day>12</day>
                  </date>

                  <name>Died in Paris</name>
                </milestone>
              </timeline>

      _parser = new TimelineXmlParser();
    }

    public function testParse():void {
      var timeline:Timeline = _parser.parse(_xml);
      var milestones:Array = timeline.milestones;
      assertEquals(2, milestones.length);
      assertMilestone(milestones[0], 5, 3, 1906, "Jun 3, 1906", "Born in Missouri");
      assertMilestone(milestones[1], 3, 12, 1975, "Apr 12, 1975", "Died in Paris");
    }

    private function assertMilestone(milestone:Milestone, expectedMonth:int, expectedDay:int, expectedYear:int, expectedFormattedDate:String, expectedName:String):void {
      var date:Date = milestone.date;
      assertEquals(expectedMonth, date.month);
      assertEquals(expectedDay, date.date);
      assertEquals(expectedYear, date.fullYear);
      assertEquals(expectedFormattedDate, milestone.formattedDate);
      assertEquals(expectedName, milestone.name);
    }

  }
}
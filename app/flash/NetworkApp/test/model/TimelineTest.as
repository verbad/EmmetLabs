package test.model {
  import asunit.framework.TestCase;
  import test.FlashAppTestCase;
  import com.emmet.model.Timeline;
  import com.emmet.model.Milestone;

  public class TimelineTest extends FlashAppTestCase {

    public function testProportions():void {
      var milestones:Array = new Array();
      var milestone1:Milestone = new Milestone("2000", "6", "5", true, "Born");
      var milestone2:Milestone = new Milestone("2021", "6", "5", false, "Graduated");
      var milestone3:Milestone = new Milestone("2030", "6", "5", true, "Gave birth");
      var milestone4:Milestone = new Milestone("2100", "6", "5", false, "Died");
      milestones.push(milestone1);
      milestones.push(milestone4);
      milestones.push(milestone3);
      milestones.push(milestone2);
      var timeline:Timeline = new Timeline(milestones);

      assertEquals(4, timeline.milestones.length);

      assertRoughlyEquals(0, timeline.proportionFor(milestone1));
      assertRoughlyEquals(0.21, timeline.proportionFor(milestone2));
      assertRoughlyEquals(0.3, timeline.proportionFor(milestone3));
      assertRoughlyEquals(1, timeline.proportionFor(milestone4));
    }

  }
}

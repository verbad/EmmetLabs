package test {
  import asunit.framework.TestSuite;
  import test.model.*;
  import test.network.*;
  import test.util.*;
  import test.wander.*;

  public class AllTests extends TestSuite {

    public function AllTests() {
      // model

      addTest(new NetworkTest());
      addTest(new RelationshipGroupTest());
      addTest(new RelationshipSupergroupTest());
      addTest(new DirectedRelationshipTest());

      addTest(new PersonTest());

      addTest(new WanderXmlParserTest());
      addTest(new TimelineXmlParserTest());
      addTest(new MilestoneTest());
      addTest(new TimelineTest());

      // util
      addTest(new BasicLabelTest());
      addTest(new DiscAndWedgeTest());
      addTest(new VectorTest());

      // network view
      addTest(new NodeTest());
      addTest(new TetherTest());

      addTest(new NetworkViewTest());
      addTest(new TreeViewTest());
      addTest(new DirectedRelationshipViewTest());
      addTest(new test.network.PersonViewTest());
      addTest(new BoundingBoxTest());

      // wander view
      addTest(new WanderWorldTest());
      addTest(new AttractorTest());
      addTest(new ExtendedRelationshipControllerTest());
      addTest(new DirectedRelationshipControllerTest());
      addTest(new test.wander.PersonViewTest());
    }
  }
}

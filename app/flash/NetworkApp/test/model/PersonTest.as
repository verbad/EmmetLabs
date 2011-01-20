package test.model {
  import asunit.framework.TestCase;
  import com.emmet.model.Person;
  import com.emmet.model.DirectedRelationship;
  import test.FlashAppTestCase;

  public class PersonTest extends FlashAppTestCase {
    private var _person:Person;

    protected override function setUp():void {
      _person = Person.fromXml(
        <person id="7">
          <name>Some Person</name>
          <primary_photo_url>http://www.example.com/foo.jpg</primary_photo_url>
          <param>Some-Person</param>
        </person>
      );
    }

    public function testId():void {
      assertEquals("7", _person.id);
    }

    public function testName():void {
      assertEquals("Some Person", _person.name);
    }

    public function testNetworkUrl():void {
      assertEquals("/network/Some-Person", _person.networkUrl);
    }
    public function testPortraitUrl():void {
      assertEquals("http://www.example.com/foo.jpg", _person.primaryPhotoUrl);
    }

    public function testAddConnectionUrl():void {
      assertEquals("/people/Some-Person/connections", _person.addConnectionUrl);
    }

    public function testProfileUrl():void {
      assertEquals("/people/Some-Person", _person.profileUrl);
    }

  }
}

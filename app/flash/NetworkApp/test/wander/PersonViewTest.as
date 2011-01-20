package test.wander {
  import com.emmet.model.Person;
  import test.FlashAppTestCase;
  import com.emmet.wander.PersonView;
  import flash.display.DisplayObject;
  import com.emmet.model.DirectedRelationship;

  public class PersonViewTest extends FlashAppTestCase {

    protected var _person:Person;
    protected var _personView:PersonView;

    protected override function setUp():void {
      _person = new Person(10, 'John Smith', 'http://www.example.com/person.gif', 'John-Smith');
      _personView = new PersonView(_person, true);
    }

    public function testOrangeDots_portrait():void {
      _personView.becomePortrait();
      assertFalse(_personView.orangeDots.visible);
      assertOrangeDotsLeft(_personView.orangeDots);
    }

    public function testOrangeDots_label():void {
      _personView.becomeLabel();
      assertFalse(_personView.orangeDots.visible);

      var otherPerson:Person = new Person(40, "Bettie Davis", "http://www.example.com/person2.gif", "Bettie-Davis");
      var otherOtherPerson:Person = new Person(50, "Judy Garland", "http://www.example.com/person3.gif", "Judy-Garland");

      _person.addDirectedRelationship(new DirectedRelationship(20, _person, otherPerson));
      _personView.becomeLabel();
      assertFalse(_personView.orangeDots.visible);

      _person.addDirectedRelationship(new DirectedRelationship(60, _person, otherOtherPerson));
      _personView.becomeLabel();
      assertTrue(_personView.orangeDots.visible);
    }

    public function testBecomeRight():void {
      _personView.becomeRight();
      assertOrangeDotsRight(_personView.orangeDots);
    }

    private function assertOrangeDotsLeft(object:DisplayObject):void {
      assertTrue(object.toString().indexOf("OrangeDotsLeft") !=-1);
    }

    private function assertOrangeDotsRight(object:DisplayObject):void {
      assertTrue(object.toString().indexOf("OrangeDotsRight") !=-1);
    }

  }
}
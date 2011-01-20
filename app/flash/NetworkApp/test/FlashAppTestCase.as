package test {
  import asunit.framework.TestCase;
  import flash.geom.Rectangle;
  import com.emmet.util.Vector;
  import com.emmet.util.Wedge;
  import com.emmet.model.DirectedRelationship;
  import com.emmet.model.Person;
  import test.mocks.MockUrlNavigation;
  import com.emmet.util.UrlNavigation;
  import flash.display.DisplayObject;
  import flash.filters.BitmapFilter;
  import flash.filters.GlowFilter;
  import com.emmet.model.Network;
  import com.emmet.network.Node;
  import com.emmet.util.DrawableView;
  import flash.display.Sprite;
  import com.emmet.util.WanderXmlParser;
  import com.emmet.util.PeopleXmlParser;

  public class FlashAppTestCase extends TestCase {

    protected var _mockUrlNavigation:MockUrlNavigation;

    public function FlashAppTestCase(testMethod:String = null) {
      super(testMethod);
    }

    protected override function setUp():void {
      super.setUp();
       _mockUrlNavigation = new MockUrlNavigation();
      UrlNavigation.instance = _mockUrlNavigation;
    }

    public function assertNotEqual(a:Object, b:Object):void {
      assertTrue(a.toString() + " should not equal " + b.toString(), a != b);
    }

    public function assertAtPoint(thingWithXY:Object, otherThingWithXY:Object):void {
      var expectedVector:Vector = Vector.fromPositionOf(thingWithXY);
      var actualVector:Vector = Vector.fromPositionOf(otherThingWithXY);
      assertXY(expectedVector.x, expectedVector.y, actualVector);
    }

    protected function assertXY(x:Number, y:Number, object:Object, tolerance:Number = 0.05):void {
      assertRoughlyEquals(x, object.x, tolerance);
      assertRoughlyEquals(y, object.y, tolerance);
    }

    protected function assertPolar(expectedAngle:Number, expectedRadius:Number, object:Object):void {
      assertRoughlyEquals(expectedAngle, object.angle, 0.01);
      assertRoughlyEquals(expectedRadius, object.radius, 0.1);
    }

    protected function assertRoughlyEquals(expected:Number, actual:Number, tolerance:Number = 0.01):void {
      assertTrue("Expected " + expected + " but got " + actual, Math.abs(expected - actual) <= tolerance);
    }

    protected function assertDifferentLocations(one:Sprite, two:Sprite):void {
      assertNotEqual(one.x, two.x);
      assertNotEqual(one.y, two.y);
    }

    protected function assertBounds(top:Number, right:Number, bottom:Number, left:Number, bounds:Rectangle):void {
      assertRoughlyEquals(top, bounds.top, 0.01);
      assertRoughlyEquals(right, bounds.right, 0.01);
      assertRoughlyEquals(bottom, bounds.bottom, 0.01);
      assertRoughlyEquals(left, bounds.left, 0.01);
    }

    protected function assertWedge(minAngle:Number, maxAngle:Number, wedge:Wedge):void {
      assertEquals(minAngle, wedge.minAngle);
      assertEquals(maxAngle, wedge.maxAngle);
    }

    public function hasHighlightEffect(object:DisplayObject):Boolean {
      return object.filters.some(function(filter:BitmapFilter, indx:int, array:Array):Boolean {return filter is GlowFilter;});
    }

    protected function josephineToGraceDirectedRelationship():DirectedRelationship {
      return new WanderXmlParser().parse(josephineToGraceExampleXML());
    }

    protected function makeExampleDirectedRelationship():DirectedRelationship {
      var xml:XML = josephineExampleXML();
      return DirectedRelationship.forPair(1, Person.fromXml(xml.from.person[0]), xml..relationship_to[0]);
    }

    protected function exampleNode():Node {
      return new Node(new DrawableView(), 1, 1);
    }

    protected function personTypeAndIdToPerson(xml:XML):Object {
      return new PeopleXmlParser().parse(xml);
    }

    protected function graceToPrinceRainierExampleXML():XML {
      return <directed_relationship url="http://localhost:3000/directed_relationships/71">
              <from>
                <person name="Grace Kelly" network_url="http://localhost:3000/people/12/network" id="12" primary_photo_url="http://localhost:3000/images/5_square.jpg">
                  <relationship_from url="http://localhost:3000/directed_relationships/19">
                    <person name="Josephine Baker" network_url="http://localhost:3000/people/7/network" id="7" primary_photo_url="http://localhost:3000/images/1.jpg?size=square">
                    </person>
                  </relationship_from>
                  <relationship_from url="http://localhost:3000/directed_relationships/74">
                    <person name="Jacqueline Onassis" network_url="http://localhost:3000/people/37/network" id="37" primary_photo_url="http://localhost:3000/images/5_square.jpg">

                    </person>
                  </relationship_from>
                  <relationship_from url="http://localhost:3000/directed_relationships/76">
                    <person name="Angela Martin" network_url="http://localhost:3000/people/36/network" id="36" primary_photo_url="http://localhost:3000/images/5_square.jpg">
                    </person>
                  </relationship_from>
                  <relationship_from url="http://localhost:3000/directed_relationships/78">
                    <person name="Rock Hudson" network_url="http://localhost:3000/people/39/network" id="39" primary_photo_url="http://localhost:3000/images/5_square.jpg">
                    </person>

                  </relationship_from>
                </person>
              </from>
              <to>
                <person name="Prince Rainier of Monaco" network_url="http://localhost:3000/people/38/network" id="38" primary_photo_url="http://localhost:3000/images/5_square.jpg">
                  <relationship_to url="http://localhost:3000/directed_relationships/81">
                    <person name="Prince Albert of Monaco" network_url="http://localhost:3000/people/41/network" id="41" primary_photo_url="http://localhost:3000/images/5_square.jpg">
                    </person>
                  </relationship_to>

                </person>
              </to>
            </directed_relationship>
    }

    protected function langstonToJosephineExampleXML():XML {
      return <wander>
  <nodes>
    <person id="1">
      <name>Janis Joplin</name>
      <network_url>http://localhost:3000/people/1/network</network_url>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>

    <person id="2">
      <name>Jim Morrison</name>
      <network_url>http://localhost:3000/people/2/network</network_url>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="3">
      <name>Elvis Presley</name>

      <network_url>http://localhost:3000/people/3/network</network_url>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="4">
      <name>Marilyn Monroe</name>
      <network_url>http://localhost:3000/people/4/network</network_url>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>

    </person>
    <person id="5">
      <name>John Fitzgerald Kennedy</name>
      <network_url>http://localhost:3000/people/5/network</network_url>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="6">

      <name>Abraham qwdqwdwd Lincoln</name>
      <network_url>http://localhost:3000/people/6/network</network_url>
      <primary_photo_url>/assets//6/original/190px_abraham_lincoln_head_on_shoulders_photo_portrait.jpg</primary_photo_url>
    </person>
    <person id="7">
      <name>Josephine Baker</name>
      <network_url>http://localhost:3000/people/7/network</network_url>

      <primary_photo_url>/assets//8/original/eng2094.jpg</primary_photo_url>
    </person>
    <person id="10">
      <name>Carrie McDonald</name>
      <network_url>http://localhost:3000/people/10/network</network_url>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>

    <person id="11">
      <name>Eddie Carson</name>
      <network_url>http://localhost:3000/people/11/network</network_url>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="12">
      <name>Grace Kelly</name>

      <network_url>http://localhost:3000/people/12/network</network_url>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="13">
      <name>Francis Scott Fitzgerald</name>
      <network_url>http://localhost:3000/people/13/network</network_url>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>

    </person>
    <person id="14">
      <name>Ernest Hemingway</name>
      <network_url>http://localhost:3000/people/14/network</network_url>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="15">

      <name>Langston Hughes</name>
      <network_url>http://localhost:3000/people/15/network</network_url>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="16">
      <name>Pablo Picasso</name>
      <network_url>http://localhost:3000/people/16/network</network_url>

      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="17">
      <name>Joe Alex</name>
      <network_url>http://localhost:3000/people/17/network</network_url>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>

    <person id="18">
      <name>Walter Winchell</name>
      <network_url>http://localhost:3000/people/18/network</network_url>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="19">
      <name>Akio</name>

      <network_url>http://localhost:3000/people/19/network</network_url>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <entity id="20">
      <name>Janot</name>
      <network_url>http://localhost:3000/people/20/network</network_url>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>

    </entity>
    <person id="21">
      <name>Luis</name>
      <network_url>http://localhost:3000/people/21/network</network_url>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="22">

      <name>Jarry</name>
      <network_url>http://localhost:3000/people/22/network</network_url>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="23">
      <name>Jean-Claude</name>
      <network_url>http://localhost:3000/people/23/network</network_url>

      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="24">
      <name>Moise</name>
      <network_url>http://localhost:3000/people/24/network</network_url>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>

    <person id="25">
      <name>Brahim</name>
      <network_url>http://localhost:3000/people/25/network</network_url>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="26">
      <name>Marianne</name>

      <network_url>http://localhost:3000/people/26/network</network_url>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="27">
      <name>Koffi</name>
      <network_url>http://localhost:3000/people/27/network</network_url>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>

    </person>
    <person id="28">
      <name>Mara</name>
      <network_url>http://localhost:3000/people/28/network</network_url>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="29">

      <name>Noel</name>
      <network_url>http://localhost:3000/people/29/network</network_url>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="30">
      <name>Stellina</name>
      <network_url>http://localhost:3000/people/30/network</network_url>

      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="31">
      <name>Robert Brady</name>
      <network_url>http://localhost:3000/people/31/network</network_url>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>

    <person id="32">
      <name>Giuseppe Abatino</name>
      <network_url>http://localhost:3000/people/32/network</network_url>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="33">
      <name>Willie Wells</name>

      <network_url>http://localhost:3000/people/33/network</network_url>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="34">
      <name>Willie Baker</name>
      <network_url>http://localhost:3000/people/34/network</network_url>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>

    </person>
    <person id="35">
      <name>Jo Bouillion</name>
      <network_url>http://localhost:3000/people/35/network</network_url>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="36">

      <name>Angela Martin</name>
      <network_url>http://localhost:3000/people/36/network</network_url>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="37">
      <name>Jacqueline Onassis</name>
      <network_url>http://localhost:3000/people/37/network</network_url>

      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="38">
      <name>Prince Rainier of Monaco</name>
      <network_url>http://localhost:3000/people/38/network</network_url>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>

    <person id="39">
      <name>Rock Hudson</name>
      <network_url>http://localhost:3000/people/39/network</network_url>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="40">
      <name>Marcus Garvey</name>

      <network_url>http://localhost:3000/people/40/network</network_url>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="41">
      <name>Prince Albert of Monaco</name>
      <network_url>http://localhost:3000/people/41/network</network_url>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>

    </person>
  </nodes>
  <directed_relationships>
    <directed_relationship to_id="2" id="1" from_id="1" from_type="person" to_type="person"/>
    <directed_relationship to_id="1" id="2" from_id="2" from_type="person" to_type="person"/>
    <directed_relationship to_id="3" id="3" from_id="2" from_type="person" to_type="person"/>
    <directed_relationship to_id="2" id="4" from_id="3" from_type="person" to_type="person"/>
    <directed_relationship to_id="4" id="5" from_id="2" from_type="person" to_type="person"/>
    <directed_relationship to_id="2" id="6" from_id="4" from_type="person" to_type="person"/>

    <directed_relationship to_id="5" id="7" from_id="2" from_type="person" to_type="person"/>
    <directed_relationship to_id="2" id="8" from_id="5" from_type="person" to_type="person"/>
    <directed_relationship to_id="4" id="9" from_id="5" from_type="person" to_type="person"/>
    <directed_relationship to_id="5" id="10" from_id="4" from_type="person" to_type="person"/>
    <directed_relationship to_id="1" id="11" from_id="4" from_type="person" to_type="person"/>
    <directed_relationship to_id="4" id="12" from_id="1" from_type="person" to_type="person"/>
    <directed_relationship to_id="4" id="13" from_id="3" from_type="person" to_type="person"/>
    <directed_relationship to_id="3" id="14" from_id="4" from_type="person" to_type="person"/>
    <directed_relationship to_id="5" id="15" from_id="3" from_type="person" to_type="person"/>

    <directed_relationship to_id="3" id="16" from_id="5" from_type="person" to_type="person"/>
    <directed_relationship to_id="6" id="17" from_id="4" from_type="person" to_type="person"/>
    <directed_relationship to_id="4" id="18" from_id="6" from_type="person" to_type="person"/>
    <directed_relationship to_id="12" id="19" from_id="7" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" id="20" from_id="12" from_type="person" to_type="person"/>
    <directed_relationship to_id="13" id="21" from_id="7" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" id="22" from_id="13" from_type="person" to_type="person"/>
    <directed_relationship to_id="14" id="23" from_id="7" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" id="24" from_id="14" from_type="person" to_type="person"/>

    <directed_relationship to_id="15" id="25" from_id="7" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" id="26" from_id="15" from_type="person" to_type="person"/>
    <directed_relationship to_id="16" id="27" from_id="7" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" id="28" from_id="16" from_type="person" to_type="person"/>
    <directed_relationship to_id="17" id="29" from_id="7" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" id="30" from_id="17" from_type="person" to_type="person"/>
    <directed_relationship to_id="18" id="31" from_id="7" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" id="32" from_id="18" from_type="person" to_type="person"/>
    <directed_relationship to_id="10" id="33" from_id="7" from_type="person" to_type="person"/>

    <directed_relationship to_id="7" id="34" from_id="10" from_type="person" to_type="person"/>
    <directed_relationship to_id="11" id="35" from_id="7" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" id="36" from_id="11" from_type="person" to_type="person"/>
    <directed_relationship to_id="19" id="37" from_id="7" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" id="38" from_id="19" from_type="person" to_type="person"/>
    <directed_relationship to_id="20" id="39" from_id="7" from_type="person" to_type="entity"/>
    <directed_relationship to_id="7" id="40" from_id="20" from_type="entity" to_type="person"/>
    <directed_relationship to_id="21" id="41" from_id="7" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" id="42" from_id="21" from_type="person" to_type="person"/>

    <directed_relationship to_id="22" id="43" from_id="7" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" id="44" from_id="22" from_type="person" to_type="person"/>
    <directed_relationship to_id="23" id="45" from_id="7" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" id="46" from_id="23" from_type="person" to_type="person"/>
    <directed_relationship to_id="24" id="47" from_id="7" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" id="48" from_id="24" from_type="person" to_type="person"/>
    <directed_relationship to_id="25" id="49" from_id="7" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" id="50" from_id="25" from_type="person" to_type="person"/>
    <directed_relationship to_id="26" id="51" from_id="7" from_type="person" to_type="person"/>

    <directed_relationship to_id="7" id="52" from_id="26" from_type="person" to_type="person"/>
    <directed_relationship to_id="27" id="53" from_id="7" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" id="54" from_id="27" from_type="person" to_type="person"/>
    <directed_relationship to_id="28" id="55" from_id="7" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" id="56" from_id="28" from_type="person" to_type="person"/>
    <directed_relationship to_id="29" id="57" from_id="7" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" id="58" from_id="29" from_type="person" to_type="person"/>
    <directed_relationship to_id="30" id="59" from_id="7" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" id="60" from_id="30" from_type="person" to_type="person"/>

    <directed_relationship to_id="31" id="61" from_id="7" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" id="62" from_id="31" from_type="person" to_type="person"/>
    <directed_relationship to_id="32" id="63" from_id="7" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" id="64" from_id="32" from_type="person" to_type="person"/>
    <directed_relationship to_id="33" id="65" from_id="7" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" id="66" from_id="33" from_type="person" to_type="person"/>
    <directed_relationship to_id="34" id="67" from_id="7" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" id="68" from_id="34" from_type="person" to_type="person"/>
    <directed_relationship to_id="35" id="69" from_id="7" from_type="person" to_type="person"/>

    <directed_relationship to_id="7" id="70" from_id="35" from_type="person" to_type="person"/>
    <directed_relationship to_id="38" id="71" from_id="12" from_type="person" to_type="person"/>
    <directed_relationship to_id="12" id="72" from_id="38" from_type="person" to_type="person"/>
    <directed_relationship to_id="37" id="73" from_id="12" from_type="person" to_type="person"/>
    <directed_relationship to_id="12" id="74" from_id="37" from_type="person" to_type="person"/>
    <directed_relationship to_id="36" id="75" from_id="12" from_type="person" to_type="person"/>
    <directed_relationship to_id="12" id="76" from_id="36" from_type="person" to_type="person"/>
    <directed_relationship to_id="39" id="77" from_id="12" from_type="person" to_type="person"/>
    <directed_relationship to_id="12" id="78" from_id="39" from_type="person" to_type="person"/>

    <directed_relationship to_id="40" id="79" from_id="15" from_type="person" to_type="person"/>
    <directed_relationship to_id="15" id="80" from_id="40" from_type="person" to_type="person"/>
    <directed_relationship to_id="41" id="81" from_id="38" from_type="person" to_type="person"/>
    <directed_relationship to_id="38" id="82" from_id="41" from_type="person" to_type="person"/>
  </directed_relationships>
  <selected_directed_relationship id="26"/>
</wander>;
    }

    protected function josephineToGraceExampleXML():XML {
      return <wander>
  <nodes>
    <person id="1">
      <name>Janis Joplin</name>
      <param>Janis-Joplin</param>
      <primary_photo_url>/assets//1/original/1.png</primary_photo_url>
    </person>

    <person id="2">
      <name>Jim Morrison</name>
      <param>Jim-Morrison</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="3">
      <name>Elvis Presley</name>

      <param>Elvis-Presley</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="4">
      <name>Marilyn Monroe</name>
      <param>Marilyn-Monroe</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>

    </person>
    <person id="5">
      <name>John Fitzgerald Kennedy</name>
      <param>John-Fitzgerald-Kennedy</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="6">

      <name>Abraham Lincoln</name>
      <param>Abraham-Lincoln</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="7">
      <name>Josephine Baker</name>
      <param>Josephine-Baker</param>

      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="10">
      <name>Carrie McDonald</name>
      <param>Carrie-McDonald</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>

    <person id="11">
      <name>Eddie Carson</name>
      <param>Eddie-Carson</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="12">
      <name>Grace Kelly</name>

      <param>Grace-Kelly</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="13">
      <name>Francis Scott Fitzgerald</name>
      <param>Francis-Scott-Fitzgerald</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>

    </person>
    <person id="14">
      <name>Ernest Hemingway</name>
      <param>Ernest-Hemingway</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="15">

      <name>Langston Hughes</name>
      <param>Langston-Hughes</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="16">
      <name>Pablo Picasso</name>
      <param>Pablo-Picasso</param>

      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="17">
      <name>Joe Alex</name>
      <param>Joe-Alex</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>

    <person id="18">
      <name>Walter Winchell</name>
      <param>Walter-Winchell</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="19">
      <name>Akio</name>

      <param>Akio</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <entity id="20">
      <name>Janot</name>
      <param>Janot</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>

    </entity>
    <person id="21">
      <name>Luis</name>
      <param>Luis</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="22">

      <name>Jarry</name>
      <param>Jarry</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="23">
      <name>Jean-Claude</name>
      <param>Jean-Claude</param>

      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="24">
      <name>Moise</name>
      <param>Moise</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>

    <person id="25">
      <name>Brahim</name>
      <param>Brahim</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="26">
      <name>Marianne</name>

      <param>Marianne</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="27">
      <name>Koffi</name>
      <param>Koffi</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>

    </person>
    <person id="28">
      <name>Mara</name>
      <param>Mara</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="29">

      <name>Noel</name>
      <param>Noel</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="30">
      <name>Stellina</name>
      <param>Stellina</param>

      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="31">
      <name>Robert Brady</name>
      <param>Robert-Brady</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>

    <person id="32">
      <name>Giuseppe Abatino</name>
      <param>Giuseppe-Abatino</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="33">
      <name>Willie Wells</name>

      <param>Willie-Wells</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="34">
      <name>Willie Baker</name>
      <param>Willie-Baker</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>

    </person>
    <person id="35">
      <name>Jo Bouillion</name>
      <param>Jo-Bouillion</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="36">

      <name>Angela Martin</name>
      <param>Angela-Martin</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="37">
      <name>Jacqueline Onassis</name>
      <param>Jacqueline-Onassis</param>

      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="38">
      <name>Prince Rainier of Monaco</name>
      <param>Prince-Rainier-of-Monaco</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>

    <person id="39">
      <name>Rock Hudson</name>
      <param>Rock-Hudson</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="40">
      <name>Marcus Garvey</name>

      <param>Marcus-Garvey</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="41">
      <name>Prince Albert of Monaco</name>
      <param>Prince-Albert-of-Monaco</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>

    </person>
  </nodes>
  <directed_relationships>
    <directed_relationship to_id="2" from_id="1" id="1" from_type="person" to_type="person"/>
    <directed_relationship to_id="1" from_id="2" id="2" from_type="person" to_type="person"/>
    <directed_relationship to_id="3" from_id="2" id="3" from_type="person" to_type="person"/>
    <directed_relationship to_id="2" from_id="3" id="4" from_type="person" to_type="person"/>
    <directed_relationship to_id="4" from_id="2" id="5" from_type="person" to_type="person"/>
    <directed_relationship to_id="2" from_id="4" id="6" from_type="person" to_type="person"/>

    <directed_relationship to_id="5" from_id="2" id="7" from_type="person" to_type="person"/>
    <directed_relationship to_id="2" from_id="5" id="8" from_type="person" to_type="person"/>
    <directed_relationship to_id="4" from_id="5" id="9" from_type="person" to_type="person"/>
    <directed_relationship to_id="5" from_id="4" id="10" from_type="person" to_type="person"/>
    <directed_relationship to_id="1" from_id="4" id="11" from_type="person" to_type="person"/>
    <directed_relationship to_id="4" from_id="1" id="12" from_type="person" to_type="person"/>
    <directed_relationship to_id="4" from_id="3" id="13" from_type="person" to_type="person"/>
    <directed_relationship to_id="3" from_id="4" id="14" from_type="person" to_type="person"/>
    <directed_relationship to_id="5" from_id="3" id="15" from_type="person" to_type="person"/>

    <directed_relationship to_id="3" from_id="5" id="16" from_type="person" to_type="person"/>
    <directed_relationship to_id="6" from_id="4" id="17" from_type="person" to_type="person"/>
    <directed_relationship to_id="4" from_id="6" id="18" from_type="person" to_type="person"/>
    <directed_relationship to_id="12" from_id="7" id="19" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" from_id="12" id="20" from_type="person" to_type="person"/>
    <directed_relationship to_id="13" from_id="7" id="21" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" from_id="13" id="22" from_type="person" to_type="person"/>
    <directed_relationship to_id="14" from_id="7" id="23" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" from_id="14" id="24" from_type="person" to_type="person"/>

    <directed_relationship to_id="15" from_id="7" id="25" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" from_id="15" id="26" from_type="person" to_type="person"/>
    <directed_relationship to_id="16" from_id="7" id="27" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" from_id="16" id="28" from_type="person" to_type="person"/>
    <directed_relationship to_id="17" from_id="7" id="29" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" from_id="17" id="30" from_type="person" to_type="person"/>
    <directed_relationship to_id="18" from_id="7" id="31" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" from_id="18" id="32" from_type="person" to_type="person"/>
    <directed_relationship to_id="10" from_id="7" id="33" from_type="person" to_type="person"/>

    <directed_relationship to_id="7" from_id="10" id="34" from_type="person" to_type="person"/>
    <directed_relationship to_id="11" from_id="7" id="35" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" from_id="11" id="36" from_type="person" to_type="person"/>
    <directed_relationship to_id="19" from_id="7" id="37" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" from_id="19" id="38" from_type="person" to_type="person"/>
    <directed_relationship to_id="20" from_id="7" id="39" from_type="person" to_type="entity"/>
    <directed_relationship to_id="7" from_id="20" id="40" from_type="entity" to_type="person"/>
    <directed_relationship to_id="21" from_id="7" id="41" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" from_id="21" id="42" from_type="person" to_type="person"/>

    <directed_relationship to_id="22" from_id="7" id="43" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" from_id="22" id="44" from_type="person" to_type="person"/>
    <directed_relationship to_id="23" from_id="7" id="45" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" from_id="23" id="46" from_type="person" to_type="person"/>
    <directed_relationship to_id="24" from_id="7" id="47" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" from_id="24" id="48" from_type="person" to_type="person"/>
    <directed_relationship to_id="25" from_id="7" id="49" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" from_id="25" id="50" from_type="person" to_type="person"/>
    <directed_relationship to_id="26" from_id="7" id="51" from_type="person" to_type="person"/>

    <directed_relationship to_id="7" from_id="26" id="52" from_type="person" to_type="person"/>
    <directed_relationship to_id="27" from_id="7" id="53" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" from_id="27" id="54" from_type="person" to_type="person"/>
    <directed_relationship to_id="28" from_id="7" id="55" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" from_id="28" id="56" from_type="person" to_type="person"/>
    <directed_relationship to_id="29" from_id="7" id="57" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" from_id="29" id="58" from_type="person" to_type="person"/>
    <directed_relationship to_id="30" from_id="7" id="59" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" from_id="30" id="60" from_type="person" to_type="person"/>

    <directed_relationship to_id="31" from_id="7" id="61" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" from_id="31" id="62" from_type="person" to_type="person"/>
    <directed_relationship to_id="32" from_id="7" id="63" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" from_id="32" id="64" from_type="person" to_type="person"/>
    <directed_relationship to_id="33" from_id="7" id="65" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" from_id="33" id="66" from_type="person" to_type="person"/>
    <directed_relationship to_id="34" from_id="7" id="67" from_type="person" to_type="person"/>
    <directed_relationship to_id="7" from_id="34" id="68" from_type="person" to_type="person"/>
    <directed_relationship to_id="35" from_id="7" id="69" from_type="person" to_type="person"/>

    <directed_relationship to_id="7" from_id="35" id="70" from_type="person" to_type="person"/>
    <directed_relationship to_id="38" from_id="12" id="71" from_type="person" to_type="person"/>
    <directed_relationship to_id="12" from_id="38" id="72" from_type="person" to_type="person"/>
    <directed_relationship to_id="37" from_id="12" id="73" from_type="person" to_type="person"/>
    <directed_relationship to_id="12" from_id="37" id="74" from_type="person" to_type="person"/>
    <directed_relationship to_id="36" from_id="12" id="75" from_type="person" to_type="person"/>
    <directed_relationship to_id="12" from_id="36" id="76" from_type="person" to_type="person"/>
    <directed_relationship to_id="39" from_id="12" id="77" from_type="person" to_type="person"/>
    <directed_relationship to_id="12" from_id="39" id="78" from_type="person" to_type="person"/>

    <directed_relationship to_id="40" from_id="15" id="79" from_type="person" to_type="person"/>
    <directed_relationship to_id="15" from_id="40" id="80" from_type="person" to_type="person"/>
    <directed_relationship to_id="41" from_id="38" id="81" from_type="person" to_type="person"/>
    <directed_relationship to_id="38" from_id="41" id="82" from_type="person" to_type="person"/>
  </directed_relationships>
  <selected_directed_relationship id="19"/>
</wander>
    }

    protected function josephineExampleXML():XML {
      return <network>
  <nodes>
    <person id="1">
      <name>Janis Joplin</name>
      <param>Janis-Joplin</param>
      <primary_photo_url>/assets//1/original/1.png</primary_photo_url>
    </person>

    <person id="2">
      <name>Jim Morrison</name>
      <param>Jim-Morrison</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="3">
      <name>Elvis Presley</name>

      <param>Elvis-Presley</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="4">
      <name>Marilyn Monroe</name>
      <param>Marilyn-Monroe</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>

    </person>
    <person id="5">
      <name>John Fitzgerald Kennedy</name>
      <param>John-Fitzgerald-Kennedy</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="6">

      <name>Abraham Lincoln</name>
      <param>Abraham-Lincoln</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="7">
      <name>Josephine Baker</name>
      <param>Josephine-Baker</param>

      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="10">
      <name>Carrie McDonald</name>
      <param>Carrie-McDonald</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>

    <person id="11">
      <name>Eddie Carson</name>
      <param>Eddie-Carson</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="12">
      <name>Grace Kelly</name>

      <param>Grace-Kelly</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="13">
      <name>Francis Scott Fitzgerald</name>
      <param>Francis-Scott-Fitzgerald</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>

    </person>
    <person id="14">
      <name>Ernest Hemingway</name>
      <param>Ernest-Hemingway</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="15">

      <name>Langston Hughes</name>
      <param>Langston-Hughes</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="16">
      <name>Pablo Picasso</name>
      <param>Pablo-Picasso</param>

      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="17">
      <name>Joe Alex</name>
      <param>Joe-Alex</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>

    <person id="18">
      <name>Walter Winchell</name>
      <param>Walter-Winchell</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="19">
      <name>Akio</name>

      <param>Akio</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <entity id="20">
      <name>Janot</name>
      <param>Janot</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>

    </entity>
    <person id="21">
      <name>Luis</name>
      <param>Luis</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="22">

      <name>Jarry</name>
      <param>Jarry</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="23">
      <name>Jean-Claude</name>
      <param>Jean-Claude</param>

      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="24">
      <name>Moise</name>
      <param>Moise</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>

    <person id="25">
      <name>Brahim</name>
      <param>Brahim</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="26">
      <name>Marianne</name>

      <param>Marianne</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="27">
      <name>Koffi</name>
      <param>Koffi</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>

    </person>
    <person id="28">
      <name>Mara</name>
      <param>Mara</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="29">

      <name>Noel</name>
      <param>Noel</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="30">
      <name>Stellina</name>
      <param>Stellina</param>

      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="31">
      <name>Robert Brady</name>
      <param>Robert-Brady</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>

    <person id="32">
      <name>Giuseppe Abatino</name>
      <param>Giuseppe-Abatino</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="33">
      <name>Willie Wells</name>

      <param>Willie-Wells</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="34">
      <name>Willie Baker</name>
      <param>Willie-Baker</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>

    </person>
    <person id="35">
      <name>Jo Bouillion</name>
      <param>Jo-Bouillion</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="36">

      <name>Angela Martin</name>
      <param>Angela-Martin</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="37">
      <name>Jacqueline Onassis</name>
      <param>Jacqueline-Onassis</param>

      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="38">
      <name>Prince Rainier of Monaco</name>
      <param>Prince-Rainier-of-Monaco</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>

    <person id="39">
      <name>Rock Hudson</name>
      <param>Rock-Hudson</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="40">
      <name>Marcus Garvey</name>

      <param>Marcus-Garvey</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
    </person>
    <person id="41">
      <name>Prince Albert of Monaco</name>
      <param>Prince-Albert-of-Monaco</param>
      <primary_photo_url>/images/default_photo/original.png</primary_photo_url>

    </person>
  </nodes>
  <target type="person" id="7"/>
  <relationship_supergroup metacategory_name="Family" metacategory_id="1">
    <relationship_group category_name="Parent" category_id="6">
      <directed_relationship to_id="10" from_id="7" id="33" from_type="person" to_type="person"/>
      <directed_relationship to_id="11" from_id="7" id="35" from_type="person" to_type="person"/>
    </relationship_group>
    <relationship_group category_name="Child" category_id="7">

      <directed_relationship to_id="19" from_id="7" id="37" from_type="person" to_type="person"/>
      <directed_relationship to_id="20" from_id="7" id="39" from_type="person" to_type="entity"/>
      <directed_relationship to_id="21" from_id="7" id="41" from_type="person" to_type="person"/>
      <directed_relationship to_id="22" from_id="7" id="43" from_type="person" to_type="person"/>
      <directed_relationship to_id="23" from_id="7" id="45" from_type="person" to_type="person"/>
      <directed_relationship to_id="24" from_id="7" id="47" from_type="person" to_type="person"/>
      <directed_relationship to_id="25" from_id="7" id="49" from_type="person" to_type="person"/>
      <directed_relationship to_id="26" from_id="7" id="51" from_type="person" to_type="person"/>
      <directed_relationship to_id="27" from_id="7" id="53" from_type="person" to_type="person"/>

      <directed_relationship to_id="28" from_id="7" id="55" from_type="person" to_type="person"/>
      <directed_relationship to_id="29" from_id="7" id="57" from_type="person" to_type="person"/>
      <directed_relationship to_id="30" from_id="7" id="59" from_type="person" to_type="person"/>
    </relationship_group>
    <relationship_group category_name="Partner" category_id="12">
      <directed_relationship to_id="31" from_id="7" id="61" from_type="person" to_type="person"/>
      <directed_relationship to_id="32" from_id="7" id="63" from_type="person" to_type="person"/>
      <directed_relationship to_id="33" from_id="7" id="65" from_type="person" to_type="person"/>
      <directed_relationship to_id="34" from_id="7" id="67" from_type="person" to_type="person"/>

      <directed_relationship to_id="35" from_id="7" id="69" from_type="person" to_type="person"/>
    </relationship_group>
  </relationship_supergroup>
  <relationship_group category_name="Friend" category_id="8">
    <directed_relationship to_id="12" from_id="7" id="19" from_type="person" to_type="person"/>
    <directed_relationship to_id="13" from_id="7" id="21" from_type="person" to_type="person"/>
    <directed_relationship to_id="14" from_id="7" id="23" from_type="person" to_type="person"/>
    <directed_relationship to_id="15" from_id="7" id="25" from_type="person" to_type="person"/>
    <directed_relationship to_id="16" from_id="7" id="27" from_type="person" to_type="person"/>

  </relationship_group>
  <relationship_group category_name="Associate" category_id="13">
    <directed_relationship to_id="17" from_id="7" id="29" from_type="person" to_type="person"/>
    <directed_relationship to_id="18" from_id="7" id="31" from_type="person" to_type="person"/>
  </relationship_group>
</network>;
    }
  }
}
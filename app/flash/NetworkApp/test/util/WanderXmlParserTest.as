package test.util {
  import asunit.framework.TestCase;
  import test.FlashAppTestCase;
  import com.emmet.model.DirectedRelationship;
  import com.emmet.model.Person;
  import com.emmet.util.WanderXmlParser;

  public class WanderXmlParserTest extends FlashAppTestCase {

    private var _xml:XML;
    private var _parser:WanderXmlParser;

    protected override function setUp():void {
      _xml =  <wander>
                <nodes>
                  <person id="7">
                    <name>Josephine Baker</name>
                    <param>Josephine-Baker</param>
                    <primary_photo_url>/assets/8/original/eng2094.jpg</primary_photo_url>
                  </person>
                  <person id="12">
                    <name>Grace Kelly</name>
                    <param>Grace-Kelly</param>
                    <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
                  </person>
                  <entity id="41">
                    <name>Prince Albert of Monaco</name>
                    <param>Prince-Albert-of-Monaco</param>
                    <primary_photo_url>/images/default_photo/original.png</primary_photo_url>
                  </entity>
                </nodes>
                <directed_relationships>
                  <directed_relationship id="1" from_id="7" to_id="12" from_type="person" to_type="person"/>
                  <directed_relationship id="2" from_id="12" to_id="7" from_type="person" to_type="person"/>
                  <directed_relationship id="3" from_id="7" to_id="41" from_type="person" to_type="entity"/>
                  <directed_relationship id="4" from_id="41" to_id="7" from_type="entity" to_type="person"/>
                </directed_relationships>
                <selected_directed_relationship id="1"/>
              </wander>
      _parser = new WanderXmlParser();
    }

    public function testParse():void {
      var selected:DirectedRelationship = _parser.parse(_xml);
      assertEquals(1, selected.id);
      assertPerson(selected.from, 7, "Josephine Baker", "/network/Josephine-Baker", "/assets/8/original/eng2094.jpg");
      assertPerson(selected.to, 12, "Grace Kelly", "/network/Grace-Kelly", "/images/default_photo/original.png");
      assertEquals(2, selected.from.directedRelationships.length);
      var relationship:DirectedRelationship = selected.from.directedRelationships[0];
      assertEquals(selected.from, relationship.from);
      assertEquals(selected.to, relationship.to);
    }

    private function assertPerson(person:Person, expectedId:int, expectedName:String, expectedNetworkUrl:String, expectedPrimaryPhotoUrl:String):void {
      assertEquals(expectedId, person.id);
      assertEquals(expectedName, person.name);
      assertEquals(expectedNetworkUrl, person.networkUrl);
      assertEquals(expectedPrimaryPhotoUrl, person.primaryPhotoUrl);
    }

  }
}
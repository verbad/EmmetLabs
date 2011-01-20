package test.model {
  import asunit.framework.TestCase;
  import test.FlashAppTestCase;
  import com.emmet.model.Milestone;

  public class MilestoneTest extends FlashAppTestCase {
    private var _milestone:Milestone;
    private var _milestoneFuzzy:Milestone;
    private var _milestoneBce:Milestone;

    protected override function setUp():void {
      _milestone = Milestone.fromXml(<milestone>
                                      <date>
                                        <month>6</month>
                                        <day>3</day>
                                        <year>1906</year>
                                        <estimate>false</estimate>
                                      </date>
                                      <name>Born in Missouri</name>
                                    </milestone>
      );
      _milestoneFuzzy = Milestone.fromXml(<milestone>
                                      <date>
                                        <month>4</month>
                                        <day></day>
                                        <year>1906</year>
                                        <estimate>false</estimate>
                                      </date>
                                      <name>Born in Missouri</name>
                                    </milestone>
      );
      _milestoneBce = Milestone.fromXml(<milestone>
                                      <date>
                                        <month>4</month>
                                        <day></day>
                                        <year>-1234</year>
                                        <estimate>true</estimate>
                                      </date>
                                      <name>Born in Missouri</name>
                                    </milestone>
      );
    }

    public function testName():void {
      assertEquals("Born in Missouri", _milestone.name);
    }

    public function testDate():void {
      assertEquals(5, _milestone.date.month);
      assertEquals(3, _milestone.date.date);
      assertEquals(1906, _milestone.date.fullYear);

      assertEquals(3, _milestoneFuzzy.date.month);
      assertEquals(1, _milestoneFuzzy.date.date);
      assertEquals(1906, _milestoneFuzzy.date.fullYear);

      assertEquals(3, _milestoneBce.date.month);
      assertEquals(1, _milestoneBce.date.date);
      assertEquals(-1234, _milestoneBce.date.fullYear);
    }

    public function testFormattedDate():void {
      assertEquals("Jun 3, 1906", _milestone.formattedDate);
      assertEquals("Apr 1906", _milestoneFuzzy.formattedDate);
      assertEquals("Circa Apr 1234 BCE", _milestoneBce.formattedDate);
    }

  }
}

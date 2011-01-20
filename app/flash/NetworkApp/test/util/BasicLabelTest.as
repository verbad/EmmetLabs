package test.util {
  import asunit.framework.TestCase;
  import com.emmet.util.BasicLabel;
  import flash.text.TextFieldAutoSize;
  import test.FlashAppTestCase;

  public class BasicLabelTest extends FlashAppTestCase {
    private var basicLabel:BasicLabel;
    private var string:String;
    private var fontSize:Number;

    public function BasicLabelTest(testMethod:String = null) {
      super(testMethod);
    }

    protected override function tearDown():void {
    }

    protected override function setUp():void {
      string = "Test String";
      fontSize = 24;
      basicLabel = new BasicLabel(string, fontSize);
    }

    public function testInstantiation():void {
      assertEquals(string, basicLabel.textField.text);
      assertEquals(fontSize, basicLabel.textField.getTextFormat().size);
      assertEquals(TextFieldAutoSize.LEFT, basicLabel.textField.autoSize);
    }

    public function testCenterAt():void {
      basicLabel.centerAt(250, 100);
      assertEquals(250, basicLabel.x);
      assertEquals(100, basicLabel.y);
    }

    public function testRegistration():void {
      basicLabel = new BasicLabel("Test String", 24);
      assertEquals(BasicLabel.CENTER, basicLabel.registrationPoint);

      basicLabel = new BasicLabel("Test String", 24, BasicLabel.CENTER);
      assertXY(-(basicLabel.width/2), -(basicLabel.height/2), basicLabel.textField);

      basicLabel = new BasicLabel("Test String", 24, BasicLabel.LEFT);
      assertXY(0, -(basicLabel.height/2), basicLabel.textField);

      basicLabel = new BasicLabel("Test String", 24, BasicLabel.RIGHT);
      assertXY(-basicLabel.width, -(basicLabel.height/2), basicLabel.textField);

      basicLabel = new BasicLabel("Test String", 24, BasicLabel.TOP);
      assertXY(-(basicLabel.width/2), 0, basicLabel.textField);

      basicLabel = new BasicLabel("Test String", 24, BasicLabel.BOTTOM);
      assertXY(-(basicLabel.width/2), -basicLabel.height, basicLabel.textField);
    }
    public function testSetters():void {
      basicLabel.background = true;
      basicLabel.backgroundColor = 0xeee;
      assertEquals(true, basicLabel.textField.background);
      assertEquals(0xeee, basicLabel.textField.backgroundColor);
    }
  }
}

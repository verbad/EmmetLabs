package {
  import test.AllTests;
  import asunit.textui.FlexTestRunner;
  import flash.display.StageScaleMode;
  import flash.display.StageAlign;

  public class TestSuiteRunner extends FlexTestRunner {
    public function TestSuiteRunner() {
      super();
      stage.scaleMode = StageScaleMode.NO_SCALE;
      stage.align = StageAlign.TOP_LEFT;
      this.width = stage.stageWidth;
      this.height = 500;
      start(AllTests);
    }
  }
}

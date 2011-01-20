package test.mocks {
  import com.emmet.network.Tree;
  import com.emmet.util.Vector;
  import com.emmet.network.Node;
  import com.emmet.network.BranchNode;

  public class MockTree extends Tree {
    public function MockTree():void {
      super(Vector.fromCartesian(0, 0), Vector.fromCartesian(0, 0));
    }

    public override function makeNode():Node {
      return new BranchNode();
    }
  }
}
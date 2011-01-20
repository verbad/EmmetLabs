require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EntityAttributesController, "handling PUT with a Person instance" do
  it_should_behave_like 'login'

  before do
    @node = people(:josephine)
    Person.stub!(:find_by_param).and_return(@node)
  end

  describe "with params[:person][:summary]" do
    it "should update the summary for the person" do
      put :update, :node_id => @node.to_param, :person => { :summary => 'a new summary' }, :node_type => 'person'

      @node.reload
      @node.summary.should == 'a new summary'
    end
    
    it "should render the summary/show partial" do
      put :update, :node_id => @node.to_param, :person => { :summary => 'a new summary' }, :format => 'js', :node_type => 'person'
      response.should render_template('summary/_show')
    end
  end

  describe "with params[:person][:biography]" do
    it "should update the biography for the person" do
      put :update, :node_id => @node.to_param, :person => {:biography => 'a new biography' }, :node_type => 'person'

      @node.reload
      @node.biography.should == 'a new biography'
    end
    
    it "should render the updated partial" do
      put :update, :node_id => @node.to_param, :person => { :biography => 'a new biography' }, :format => 'js', :node_type => 'person'
      response.should render_template('biography/_show')
    end
  end
  
  describe "with params[:person][:tags]" do
    it "should update the tags for the person by way of the tag_list method" do
      @node.tag_list.should == ['dancer', 'paris']
      put :update, :node_id => @node.to_param, :person => { :tag_list => 'foo, bar' }, :format => 'js', :node_type => 'person'

      @node.reload
      @node.tag_list.should include('foo')
      @node.tag_list.should include('bar')
    end
  end
end

describe EntityAttributesController, "handling PUT with an Entity instance" do
  it_should_behave_like 'login'

  before do
    @node = entities(:lipstick)
    Entity.stub!(:find_by_param).and_return(@node)
  end

  describe "with params[:entity][:summary]" do
    it "should update the summary for the entity" do
      put :update, :node_id => @node.to_param, :entity => { :summary => 'a new summary' }, :node_type => 'entity'

      @node.reload
      @node.summary.should == 'a new summary'
    end
    
    it "should render the summary/show partial" do
      put :update, :node_id => @node.to_param, :entity => { :summary => 'a new summary' }, :format => 'js', :node_type => 'entity'
      response.should render_template('entities/_summary')
    end
  end

  describe "with params[:entity][:backgrounder]" do
    it "should update the backgrounder for the entity" do
      put :update, :node_id => @node.to_param, :entity => { :backgrounder => 'a new backgrounder' }, :node_type => 'entity'

      @node.reload
      @node.backgrounder.should == 'a new backgrounder'
    end
    
    it "should render the updated partial" do
      put :update, :node_id => @node.to_param, :entity => { :backgrounder => 'a new backgrounder' }, :format => 'js', :node_type => 'entity'
      response.should render_template('entities/_backgrounder')
    end
  end
  
  describe "with params[:entity][:further_reading]" do
    it "should update the further_reading for the entity" do
      put :update, :node_id => @node.to_param, :entity => { :further_reading => 'a new further reading' }, :node_type => 'entity'

      @node.reload
      @node.further_reading.should == 'a new further reading'
    end
    
    it "should render the updated partial" do
      put :update, :node_id => @node.to_param, :entity => { :further_reading => 'a new further reading' }, :format => 'js', :node_type => 'entity'
      response.should render_template('entities/_further_reading')
    end
  end
end

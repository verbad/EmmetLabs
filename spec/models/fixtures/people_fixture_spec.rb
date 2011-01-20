require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe "Janis Joplin" do
  before do
    @janis = people(:janis)
  end

  it "has 2 relationships" do
    @janis.should_not be_nil
    @janis.directed_relationships.count.should == 2
  end
  
  it "has the 'singer' and 'addict' tags" do
    pending("updated fixtures")
    singer = tags(:singer)
    addict = tags(:addict)
    
    @janis.tags.should include(singer)
    @janis.tags.should include(addict)
  end
end

describe "Jim Morrison" do
  it "has 4 relationships" do
    @jim = people(:jim)
    @jim.should_not be_nil
    @jim.directed_relationships.count.should == 4
  end
end

describe "Elvis Presley" do
  it "has 3 relationships" do
    @elvis = people(:elvis)
    @elvis.should_not be_nil
    @elvis.directed_relationships.count.should == 3
  end
end

describe "Marilyn Monroe" do
  it "has 5 relationships" do
    @marilyn = people(:marilyn)
    @marilyn.should_not be_nil
    @marilyn.directed_relationships.count.should == 5
  end
end

describe "JFK" do
  it "has 3 relationships" do
    jfk = people(:jfk)
    jfk.should_not be_nil
    jfk.directed_relationships.count.should == 3
  end
end

describe "Abraham Lincoln" do
  it "has 1 relationship" do
    abe = people(:abe)
    abe.directed_relationships.count.should == 1
  end
end

describe "Josephine Baker" do
  before do
    @josephine = people(:josephine)
  end

  it "has 26 relationships of various stripes" do
    @josephine.directed_relationships.count.should == 26
    @josephine.directed_relationships.in_category(relationship_categories(:friend)).length.should == 5
    @josephine.directed_relationships.in_category(relationship_categories(:associate)).length.should == 2
    @josephine.directed_relationships.in_category(relationship_categories(:parent)).length.should == 2
    @josephine.directed_relationships.in_category(relationship_categories(:child)).length.should == 12
    @josephine.directed_relationships.in_category(relationship_categories(:partner)).length.should == 5
  end
  
  it "has the 'dancer' and 'paris' tags" do
    pending("updated fixtures")
    @josephine.tags.should include(tags(:dancer))
    @josephine.tags.should include(tags(:paris))
  end

  it "has a biography" do
    @josephine.biography.should =~ /This is Josephine Baker's biography/
  end

  it "has a summary" do
    @josephine.summary.should =~ /This is Josephine Baker's summary/
  end
end

describe "Grace of Monaco" do
  
  before do
    @grace = people(:grace)
  end
  
  it "has the 'paris' and 'princess' tags" do
    pending("updated fixtures")
    @grace.tags.should include(tags(:paris))
    @grace.tags.should include(tags(:princess))
  end
end

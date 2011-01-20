require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe "The addict tag" do
  
  before do
    @addict = tags(:addict)
    @jim = people(:jim)
    @janis = people(:janis)
  end
  
  it "applies both to Jim Morrison and Janis Joplin" do
    addicts = Person.tagged_with(@addict.name, :on => :tags)
    addicts.should include(@jim)
    @jim.tags.should include(@addict)    
    
    addicts.should include(@janis)
    @janis.tags.should include(@addict)
  end
end
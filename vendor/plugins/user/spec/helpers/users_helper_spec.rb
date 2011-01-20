dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe UsersHelper, "#user_select with truncation" do
  it "truncates very long names if desired" do
    user = users(:valid_bob)
    user.profile.first_name = "Short"
    user.profile.last_name = "McLongLongNamethatisalsojustformbreakinglyextremelyhellaciouslylong"
    user.full_name.length.should > 50
    users = [user]
    user_select("select name", users, nil, :truncate_at => 50).should == "<select id=\"select name\" name=\"select name\"><option value=\"1\">Short McLongLongNamethatisalsojustformbreakinglyex...</option></select>" 
  end
end

describe UsersHelper, "#user_select without truncation" do   
  it "does not truncates very long names" do
    user = users(:valid_bob)
    user.profile.first_name = "Short"
    user.profile.last_name = "McLongLongNamethatisalsojustformbreakinglyextremelyhellaciouslylong"
    user.full_name.length.should > 50
    users = [user]
    user_select("select name", users).should == "<select id=\"select name\" name=\"select name\"><option value=\"1\">#{user.full_name}</option></select>" 
  end
end


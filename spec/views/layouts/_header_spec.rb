require File.dirname(__FILE__) + '/../../spec_helper'

describe "layouts/_header" do
  it "should render first name, update and signout" do
    janice = users(:janice)
    template.should_receive(:current_user).any_number_of_times.and_return(janice)
    render "layouts/_header"
    assert response.body =~ /hi, #{janice.unique_name}/i
    assert response.body =~ /change password/i
    assert response.body =~ /sign out/i
    assert response.body =~ /admin/i 
  end
end
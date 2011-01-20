require File.dirname(__FILE__) + '/../../spec_helper'

describe "/people/_synopsis" do
  before do
    @person_with_all_fields = people(:josephine)
    @milestone_label = 'Jan 1, 2008, Paris, France'
    template.should_receive(:milestone_label).twice.and_return(@milestone_label)
  end
  
  it "should render milestones in list elements with the class 'milestone'" do
    assigns[:person] = @person_with_all_fields
    render "/people/_synopsis"
    response.should have_tag('li.milestone', @milestone_label)
  end

  it "should show a summary" do
    assigns[:person] = @person_with_all_fields
    render "/people/_synopsis"
    response.should have_tag('p.summary', @person_with_all_fields.summary)
  end
end
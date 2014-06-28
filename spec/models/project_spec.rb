require 'spec_helper'

describe Project do
  it "should require name" do
    Project.new.should have(1).error_on :name
  end

  it ".to_json should use .as_json" do
    project = Project.create(:name => 'Project')
    ActiveSupport::JSON.decode(project.to_json).should == {"id"=>1, "name" => "Project"}
  end

end

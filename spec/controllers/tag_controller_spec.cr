require "./spec_helper"

def tag_hash
  {"name" => "Fake"}
end

def tag_params
  params = [] of String
  params << "name=#{tag_hash["name"]}"
  params.join("&")
end

def create_tag
  model = Tag.new(tag_hash)
  model.save
  model
end

class TagControllerTest < GarnetSpec::Controller::Test
  getter handler : Amber::Pipe::Pipeline

  def initialize
    @handler = Amber::Pipe::Pipeline.new
    @handler.build :web do
      plug Amber::Pipe::Error.new
      plug Amber::Pipe::Session.new
      plug Amber::Pipe::Flash.new
    end
    @handler.prepare_pipelines
  end
end

describe TagControllerTest do
  subject = TagControllerTest.new

  it "renders tag index template" do
    Tag.clear
    response = subject.get "/tags"

    response.status_code.should eq(200)
    response.body.should contain("Tags")
  end

  it "renders tag show template" do
    Tag.clear
    model = create_tag
    location = "/tags/#{model.id}"

    response = subject.get location

    response.status_code.should eq(200)
    response.body.should contain("Show Tag")
  end

  it "renders tag new template" do
    Tag.clear
    location = "/tags/new"

    response = subject.get location

    response.status_code.should eq(200)
    response.body.should contain("New Tag")
  end

  it "renders tag edit template" do
    Tag.clear
    model = create_tag
    location = "/tags/#{model.id}/edit"

    response = subject.get location

    response.status_code.should eq(200)
    response.body.should contain("Edit Tag")
  end

  it "creates a tag" do
    Tag.clear
    response = subject.post "/tags", body: tag_params

    response.headers["Location"].should eq "/tags"
    response.status_code.should eq(302)
    response.body.should eq "302"
  end

  it "updates a tag" do
    Tag.clear
    model = create_tag
    response = subject.patch "/tags/#{model.id}", body: tag_params

    response.headers["Location"].should eq "/tags"
    response.status_code.should eq(302)
    response.body.should eq "302"
  end

  it "deletes a tag" do
    Tag.clear
    model = create_tag
    response = subject.delete "/tags/#{model.id}"

    response.headers["Location"].should eq "/tags"
    response.status_code.should eq(302)
    response.body.should eq "302"
  end
end

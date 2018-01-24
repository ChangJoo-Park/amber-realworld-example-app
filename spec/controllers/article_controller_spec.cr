require "./spec_helper"

def article_hash
  {"title" => "Fake", "body" => "Fake", "user_id" => "1", "tag_id" => "1"}
end

def article_params
  params = [] of String
  params << "title=#{article_hash["title"]}"
  params << "body=#{article_hash["body"]}"
  params << "user_id=#{article_hash["user_id"]}"
  params << "tag_id=#{article_hash["tag_id"]}"
  params.join("&")
end

def create_article
  model = Article.new(article_hash)
  model.save
  model
end

class ArticleControllerTest < GarnetSpec::Controller::Test
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

describe ArticleControllerTest do
  subject = ArticleControllerTest.new

  it "renders article index template" do
    Article.clear
    response = subject.get "/articles"

    response.status_code.should eq(200)
    response.body.should contain("Articles")
  end

  it "renders article show template" do
    Article.clear
    model = create_article
    location = "/articles/#{model.id}"

    response = subject.get location

    response.status_code.should eq(200)
    response.body.should contain("Show Article")
  end

  it "renders article new template" do
    Article.clear
    location = "/articles/new"

    response = subject.get location

    response.status_code.should eq(200)
    response.body.should contain("New Article")
  end

  it "renders article edit template" do
    Article.clear
    model = create_article
    location = "/articles/#{model.id}/edit"

    response = subject.get location

    response.status_code.should eq(200)
    response.body.should contain("Edit Article")
  end

  it "creates a article" do
    Article.clear
    response = subject.post "/articles", body: article_params

    response.headers["Location"].should eq "/articles"
    response.status_code.should eq(302)
    response.body.should eq "302"
  end

  it "updates a article" do
    Article.clear
    model = create_article
    response = subject.patch "/articles/#{model.id}", body: article_params

    response.headers["Location"].should eq "/articles"
    response.status_code.should eq(302)
    response.body.should eq "302"
  end

  it "deletes a article" do
    Article.clear
    model = create_article
    response = subject.delete "/articles/#{model.id}"

    response.headers["Location"].should eq "/articles"
    response.status_code.should eq(302)
    response.body.should eq "302"
  end
end

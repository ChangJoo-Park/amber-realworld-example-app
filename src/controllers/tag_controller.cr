class TagController < ApplicationController
  def index
    tags = Tag.all
    render("index.slang")
  end

  def show
    if tag = Tag.find params["id"]
      render("show.slang")
    else
      flash["warning"] = "Tag with ID #{params["id"]} Not Found"
      redirect_to "/tags"
    end
  end

  def new
    tag = Tag.new
    render("new.slang")
  end

  def create
    tag = Tag.new(tag_params.validate!)

    if tag.valid? && tag.save
      flash["success"] = "Created Tag successfully."
      redirect_to "/tags"
    else
      flash["danger"] = "Could not create Tag!"
      render("new.slang")
    end
  end

  def edit
    if tag = Tag.find params["id"]
      render("edit.slang")
    else
      flash["warning"] = "Tag with ID #{params["id"]} Not Found"
      redirect_to "/tags"
    end
  end

  def update
    if tag = Tag.find(params["id"])
      tag.set_attributes(tag_params.validate!)
      if tag.valid? && tag.save
        flash["success"] = "Updated Tag successfully."
        redirect_to "/tags"
      else
        flash["danger"] = "Could not update Tag!"
        render("edit.slang")
      end
    else
      flash["warning"] = "Tag with ID #{params["id"]} Not Found"
      redirect_to "/tags"
    end
  end

  def destroy
    if tag = Tag.find params["id"]
      tag.destroy
    else
      flash["warning"] = "Tag with ID #{params["id"]} Not Found"
    end
    redirect_to "/tags"
  end

  def tag_params
    params.validation do
      required(:name) { |f| !f.nil? }
    end
  end
end

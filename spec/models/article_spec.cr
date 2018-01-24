require "./spec_helper"
require "../../src/models/article.cr"

describe Article do
  Spec.before_each do
    Article.clear
  end
end

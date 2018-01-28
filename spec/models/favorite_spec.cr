require "./spec_helper"
require "../../src/models/favorite.cr"

describe Favorite do
  Spec.before_each do
    Favorite.clear
  end
end

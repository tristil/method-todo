class FrontpageController < ApplicationController
  def index
    @todo = Todo.new
  end
end

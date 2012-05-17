class FrontpageController < ApplicationController
  before_filter :authenticate_user!
  def index
    @todo = Todo.new
  end
end

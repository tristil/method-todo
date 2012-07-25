###
# REST controller for fetching +TodoContext+ records

class TodoContextsController < ApplicationController
  before_filter :authenticate_user!

  # GET /contexts
  # @return [void]
  def index
    @contexts = current_user.todo_contexts

    respond_to do |format|
      format.html{ render :json => @contexts }
      format.json { render :json => @contexts }
    end

  end
end

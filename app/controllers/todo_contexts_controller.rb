class TodoContextsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @contexts = current_user.todo_contexts.collect {|context| {:id => context.id, :name => context.name } }

    respond_to do |format|
      format.html{ render :json => @contexts }
      format.json { render :json => @contexts }
    end

  end
end

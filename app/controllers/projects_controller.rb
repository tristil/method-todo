class ProjectsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @projects = current_user.projects.collect {|project| {:id => project.id, :name => project.name }}

    respond_to do |format|
      format.html{ render :json => @projects }
      format.json { render :json => @projects }
    end

  end

end

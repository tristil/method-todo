###
# REST controller for fetching +Project+ records

class ProjectsController < ApplicationController
  before_filter :authenticate_user!

  # GET /projects
  # @return [void]
  def index
    @projects = current_user.projects

    respond_to do |format|
      format.html{ render :json => @projects }
      format.json { render :json => @projects }
    end

  end

end

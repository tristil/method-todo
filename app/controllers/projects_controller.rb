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

  # DELETE /contexts
  # @return [void]
  def destroy
    id = params[:id]
    json_response = {'deleted' => false}

    project = Project.find_by_id id

    if project and project.user_id == current_user.id
      current_user.todos.strip_text! '+'+project.name
      project.destroy
      json_response['deleted'] = true
    end

    respond_to do |format|
      format.html { redirect_to '/' }
      format.json { render :json => json_response }
    end
  end

end

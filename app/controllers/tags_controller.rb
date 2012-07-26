###
# REST controller for fetching +Tag+ records

class TagsController < ApplicationController
  before_filter :authenticate_user!

  # GET /tags
  # @return [void]
  def index
    @tags = current_user.tags

    respond_to do |format|
      format.html{ render :json => @tags }
      format.json { render :json => @tags }
    end
  end

  # DELETE /contexts
  # @return [void]
  def destroy
    id = params[:id]
    json_response = {'deleted' => false}

    tag = Tag.find_by_id id

    if tag and tag.user_id == current_user.id
      current_user.todos.strip_text! '#'+tag.name
      tag.destroy
      json_response['deleted'] = true
    end

    respond_to do |format|
      format.html { redirect_to '/' }
      format.json { render :json => json_response }
    end
  end


end

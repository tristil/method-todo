###
# Controller for front page of application

class FrontpageController < ApplicationController
  before_filter :authenticate_user!

  # GET /
  # @return [void]
  def index
    set_preferences
    bootstrap_page
  end

  # Toggle the status of the :show_help user preference
  # @return [void]
  def toggle_help
    if current_user.preferences[:show_help].nil?
      current_user.preferences[:show_help] = false
    else
      current_user.preferences[:show_help] = current_user.preferences[:show_help] ? false : true
    end

    current_user.save

    respond_to do |format|
      format.html { render :json => current_user.preferences[:show_help] }
    end
  end

  # Get and Set timezone
  # @return [void]
  def set_timezone
    offset, lookup_type = nil, nil
    if geonames_available?
      lookup_type = 'geoname'
      latlon = [params[:latitude].to_f, params[:longitude].to_f]
      timezone = Timezone::Zone.new :latlon => latlon
      offset = timezone.utc_offset / (60 * 60)
    end

    if offset.nil?
      if params[:offset]
        lookup_type = 'javascript'
        offset = params[:offset]
        # Have to flip the sign because getTimezoneOffset is backward
        offset = -offset.to_i
      else
        lookup_type = 'default'
        current_offset = current_user.preferences[:timezone_offset]
        offset = current_offset ? current_offset : 0
      end
    end

    current_user.preferences[:timezone_offset] = offset
    current_user.save

    respond_to do |format|
      format.html { render :json => { :offset => offset, :lookup => lookup_type} }
    end
  end

  #############################################################################
  private

  def geonames_available?
    MethodTodo::Application.config.perform_geoname_lookups &&
      params[:latitude] && params[:longitude]
  end

  def bootstrap_page
    @todo = Todo.new

    @active_todos = current_user.active_todos.collect {|todo| todo.as_json }
    @completed_todos = current_user.completed_todos.collect {|todo| todo.as_json }

    @contexts = current_user.todo_contexts.map(&:as_json)
    @projects = current_user.projects.map(&:as_json)
    @tags = current_user.tags.map(&:as_json)
  end

  def set_preferences
    @show_help = current_user.preferences[:show_help].nil? ? true : current_user.preferences[:show_help]
  end
end

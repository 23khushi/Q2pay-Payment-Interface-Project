class ActivityLogsController < ApplicationController

  def index
    @activitylogs = ActivityLog.all
    render json: @activitylogs, status: :ok
  end

end
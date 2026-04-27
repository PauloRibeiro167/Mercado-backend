class Api::V1::StatusController < ApplicationController
  skip_before_action :authenticate_user!
  
  def index
    render json: {
      status: "online",
      version: "v1",
      timestamp: Time.current
    }
  end
end

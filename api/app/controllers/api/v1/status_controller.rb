module Api
  module V1
    class StatusController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    metadata = Rails.application.config.x.app_metadata

    render json: {
      project: metadata[:project],
      version: metadata[:version],
      environment: metadata[:environment],
      status: metadata[:status],
      documentation_url: metadata[:documentation_url],
      support_contact: metadata[:support_contact]
    }
  end
end

  end
end

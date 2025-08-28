class Api::V1::StoresController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    records = Store.all
    render json: records.to_json
  end
end

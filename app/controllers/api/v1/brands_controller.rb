class Api::V1::BrandsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    records = Brand.all
    render json: records.to_json
  end
end

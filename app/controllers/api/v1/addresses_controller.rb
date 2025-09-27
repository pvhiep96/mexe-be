module Api
  module V1
    class AddressesController < Api::ApplicationController
      # GET /api/v1/addresses/provinces
      def provinces
        provinces = Province.includes(:administrative_unit)
                           .order(:name)

        render json: provinces, each_serializer: ProvinceSerializer
      end

      # GET /api/v1/addresses/wards?province_code=01
      def wards
        return render json: { error: 'Province code is required' }, status: :bad_request unless params[:province_code]

        wards = Ward.includes(:administrative_unit, :province)
                   .where(province_code: params[:province_code])
                   .order(:name)

        render json: wards, each_serializer: WardSerializer
      end

      # GET /api/v1/addresses/administrative_units
      def administrative_units
        units = AdministrativeUnit.order(:id)

        render json: units.map do |unit|
          {
            id: unit.id,
            full_name: unit.full_name,
            short_name: unit.short_name,
            full_name_en: unit.full_name_en,
            short_name_en: unit.short_name_en,
            code_name: unit.code_name
          }
        end
      end

      # GET /api/v1/addresses/search?q=ho+chi+minh
      def search
        query = params[:q]
        return render json: [], status: :ok if query.blank?

        # Tìm kiếm tỉnh/thành phố
        provinces = Province.where(
          "name ILIKE ? OR full_name ILIKE ? OR code_name ILIKE ?",
          "%#{query}%", "%#{query}%", "%#{query}%"
        ).limit(10)

        # Tìm kiếm phường/xã
        wards = Ward.includes(:province).where(
          "name ILIKE ? OR full_name ILIKE ? OR code_name ILIKE ?",
          "%#{query}%", "%#{query}%", "%#{query}%"
        ).limit(10)

        results = {
          provinces: provinces.map do |province|
            {
              type: 'province',
              code: province.code,
              name: province.name,
              full_name: province.full_name
            }
          end,
          wards: wards.map do |ward|
            {
              type: 'ward',
              code: ward.code,
              name: ward.name,
              full_name: ward.full_name,
              province_name: ward.province&.name
            }
          end
        }

        render json: results
      end
    end
  end
end
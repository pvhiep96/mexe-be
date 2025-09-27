# Vietnamese Administrative Units - Sample Queries
# Based on Vietnamese Provinces Database schema
# https://github.com/ThangLeQuoc/vietnamese-provinces-database

class VietnameseAdministrativeQueries
  
  # Get all wards under a province (similar to sample in documentation)
  def self.get_wards_by_province(province_code)
    Ward.joins(:administrative_unit)
        .where(province_code: province_code)
        .select('wards.code, wards.name, wards.full_name, wards.full_name_en, administrative_units.full_name as administrative_unit_name')
        .order('wards.code')
  end
  
  # Get all wards under Khánh Hòa province (from documentation example)
  def self.get_khanh_hoa_wards
    get_wards_by_province('56')
  end
  
  # Get all provinces with their administrative unit type
  def self.get_provinces_with_types
    Province.joins(:administrative_unit)
            .select('provinces.code, provinces.name, provinces.full_name, provinces.full_name_en, administrative_units.short_name as unit_type')
            .order('provinces.code')
  end
  
  # Get all municipalities (Thành phố trực thuộc trung ương)
  def self.get_municipalities
    Province.municipalities
            .select('provinces.code, provinces.name, provinces.name_en, provinces.full_name, provinces.full_name_en')
            .order('provinces.name')
  end
  
  # Get all regular provinces (Tỉnh)
  def self.get_regular_provinces
    Province.provinces_only
            .select('provinces.code, provinces.name, provinces.name_en, provinces.full_name, provinces.full_name_en')
            .order('provinces.name')
  end
  
  # Get ward statistics by province
  def self.get_ward_statistics_by_province
    Province.joins(:wards, :administrative_unit)
            .group('provinces.code, provinces.name, administrative_units.short_name')
            .select('provinces.code, provinces.name, administrative_units.short_name as province_type, COUNT(wards.code) as ward_count')
            .order('ward_count DESC')
  end
  
  # Get wards by type (Phường, Xã, etc.)
  def self.get_wards_by_type(administrative_unit_id)
    Ward.joins(:administrative_unit, :province)
        .where(administrative_unit_id: administrative_unit_id)
        .select('wards.code, wards.name, wards.full_name, provinces.name as province_name, administrative_units.short_name as ward_type')
        .order('provinces.name, wards.name')
  end
  
  # Get all administrative regions
  def self.get_administrative_regions
    AdministrativeRegion.select('id, name, name_en, code_name, code_name_en')
                       .order('id')
  end
  
  # Search provinces by name (Vietnamese or English)
  def self.search_provinces(query)
    Province.where('name LIKE ? OR name_en LIKE ? OR full_name LIKE ? OR full_name_en LIKE ?', 
                   "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%")
            .select('code, name, name_en, full_name, full_name_en')
            .order('name')
  end
  
  # Search wards by name within a province
  def self.search_wards_in_province(province_code, query)
    Ward.where(province_code: province_code)
        .where('name LIKE ? OR name_en LIKE ? OR full_name LIKE ? OR full_name_en LIKE ?',
               "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%")
        .select('code, name, name_en, full_name, full_name_en')
        .order('name')
  end
  
  # Get province hierarchy (Province -> Wards -> Administrative Unit)
  def self.get_province_hierarchy(province_code)
    province = Province.includes(:administrative_unit, wards: :administrative_unit)
                      .find(province_code)
    
    {
      province: {
        code: province.code,
        name: province.name,
        name_en: province.name_en,
        type: province.administrative_unit.short_name,
        type_en: province.administrative_unit.short_name_en
      },
      wards: province.wards.map do |ward|
        {
          code: ward.code,
          name: ward.name,
          name_en: ward.name_en,
          type: ward.administrative_unit.short_name,
          type_en: ward.administrative_unit.short_name_en
        }
      end
    }
  end
  
  # Get summary statistics
  def self.get_summary_statistics
    {
      total_administrative_regions: AdministrativeRegion.count,
      total_administrative_units: AdministrativeUnit.count,
      total_provinces: Province.count,
      total_municipalities: Province.municipalities.count,
      total_regular_provinces: Province.provinces_only.count,
      total_wards: Ward.count,
      total_wards_proper: Ward.wards_only.count,
      total_communes: Ward.communes.count,
      total_special_regions: Ward.special_regions.count
    }
  end
end

# Example usage:
# 
# # Get all wards in Khánh Hòa
# khanh_hoa_wards = VietnameseAdministrativeQueries.get_khanh_hoa_wards
# 
# # Get all municipalities
# municipalities = VietnameseAdministrativeQueries.get_municipalities
# 
# # Search for provinces containing "Ho Chi Minh"
# hcm_results = VietnameseAdministrativeQueries.search_provinces("Ho Chi Minh")
# 
# # Get ward statistics by province
# stats = VietnameseAdministrativeQueries.get_ward_statistics_by_province
# 
# # Get summary
# summary = VietnameseAdministrativeQueries.get_summary_statistics

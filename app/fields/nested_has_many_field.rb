require "administrate/field/base"

class NestedHasManyField < Administrate::Field::Base
  def self.searchable?
    false
  end

  def nested_show?
    options.fetch(:nested_show, false)
  end

  def nested_edit?
    options.fetch(:nested_edit, true)
  end

  def nested_show_attributes
    options.fetch(:nested_show_attributes, [])
  end

  def nested_edit_attributes
    options.fetch(:nested_edit_attributes, [])
  end

  def nested_attributes_name
    "#{attribute}_attributes"
  end

  def nested_attributes
    data.map.with_index do |item, index|
      {
        id: item.id,
        _destroy: false
      }.merge(
        nested_edit_attributes.map { |attr| [attr, item.send(attr)] }.to_h
      )
    end
  end

  def nested_attributes_with_new
    nested_attributes + [nested_edit_attributes.map { |attr| [attr, nil] }.to_h.merge(id: nil, _destroy: false)]
  end
end

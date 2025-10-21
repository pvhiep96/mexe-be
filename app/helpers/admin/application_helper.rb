module Admin
  module ApplicationHelper
    def field_with_errors_wrapper(form, field_name, field_type = :text_field, options = {})
      content_tag :div, class: "field-unit" do
        concat form.label(field_name)
        concat form.send(field_type, field_name, options.merge(class: "text-field"))
        if form.object.errors[field_name].any?
          concat content_tag(:div, class: "field_with_errors") do
            form.send(field_type, field_name, options.merge(class: "text-field"))
          end
        end
      end
    end

    def vietnamese_pluralize(count, singular)
      "#{count} #{singular}"
    end
  end
end

class RevenueReportSerializer
  include JSONAPI::Serializer

  attributes :id, :client_id, :report_date, :report_type, :total_revenue, :total_profit,
             :order_count, :product_count, :average_order_value, :profit_margin,
             :created_at, :updated_at

  attribute :client_name do |object|
    object.client&.display_name
  end

  attribute :formatted_revenue do |object|
    ActionController::Base.helpers.number_to_currency(object.total_revenue, unit: "₫", precision: 0)
  end

  attribute :formatted_profit do |object|
    ActionController::Base.helpers.number_to_currency(object.total_profit, unit: "₫", precision: 0)
  end

  attribute :formatted_average_order_value do |object|
    ActionController::Base.helpers.number_to_currency(object.average_order_value, unit: "₫", precision: 0)
  end

  attribute :formatted_profit_margin do |object|
    ActionController::Base.helpers.number_to_percentage(object.profit_margin, precision: 1)
  end

  attribute :formatted_report_date do |object|
    case object.report_type
    when 'daily'
      object.report_date.strftime('%d/%m/%Y')
    when 'monthly'
      object.report_date.strftime('%m/%Y')
    when 'yearly'
      object.report_date.strftime('%Y')
    else
      object.report_date.strftime('%d/%m/%Y')
    end
  end

  # Summary attributes for aggregated data
  attribute :summary do |object, params|
    if params && params[:include_summary]
      {
        total_revenue: object.total_revenue,
        total_profit: object.total_profit,
        total_orders: object.order_count,
        total_products_sold: object.product_count,
        average_order_value: object.average_order_value,
        average_profit_margin: object.profit_margin
      }
    end
  end
end


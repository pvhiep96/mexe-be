class RevenueReportService
  def self.generate_all_reports_for_date(date)
    # Generate daily reports for all clients
    AdminUser.client.find_each do |client|
      generate_daily_report_for_client(client, date)
    end
  end

  def self.generate_monthly_reports_for_month(year, month)
    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month
    
    AdminUser.client.find_each do |client|
      generate_monthly_report_for_client(client, year, month)
    end
  end

  def self.generate_yearly_reports_for_year(year)
    start_date = Date.new(year, 1, 1)
    end_date = start_date.end_of_year
    
    AdminUser.client.find_each do |client|
      generate_yearly_report_for_client(client, year)
    end
  end

  def self.generate_daily_report_for_client(client, date)
    return unless client.client?

    # Check if report already exists
    existing_report = RevenueReport.find_by(
      client_id: client.id,
      report_date: date,
      report_type: 'daily'
    )

    # Skip if report exists and is recent (less than 1 hour old)
    return existing_report if existing_report&.updated_at&.> 1.hour.ago

    # Get orders for this client on this date
    orders = get_orders_for_client_on_date(client, date)

    # Calculate metrics
    total_revenue = orders.sum(:total_amount)
    total_profit = calculate_profit_for_orders(orders, client)
    order_count = orders.distinct.count
    product_count = calculate_products_sold(orders, client)

    # Create or update report
    report = existing_report || RevenueReport.new(
      client_id: client.id,
      report_date: date,
      report_type: 'daily'
    )

    report.assign_attributes(
      total_revenue: total_revenue,
      total_profit: total_profit,
      order_count: order_count,
      product_count: product_count,
      average_order_value: order_count > 0 ? total_revenue / order_count : 0,
      profit_margin: total_revenue > 0 ? (total_profit / total_revenue * 100).round(2) : 0
    )

    report.save!
    report
  end

  def self.generate_monthly_report_for_client(client, year, month)
    return unless client.client?

    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month

    # Check if report already exists
    existing_report = RevenueReport.find_by(
      client_id: client.id,
      report_date: start_date,
      report_type: 'monthly'
    )

    # Skip if report exists and is recent (less than 1 day old)
    return existing_report if existing_report&.updated_at&.> 1.day.ago

    # Get orders for this client in this month
    orders = get_orders_for_client_in_period(client, start_date, end_date)

    # Calculate metrics
    total_revenue = orders.sum(:total_amount)
    total_profit = calculate_profit_for_orders(orders, client)
    order_count = orders.distinct.count
    product_count = calculate_products_sold(orders, client)

    # Create or update report
    report = existing_report || RevenueReport.new(
      client_id: client.id,
      report_date: start_date,
      report_type: 'monthly'
    )

    report.assign_attributes(
      total_revenue: total_revenue,
      total_profit: total_profit,
      order_count: order_count,
      product_count: product_count,
      average_order_value: order_count > 0 ? total_revenue / order_count : 0,
      profit_margin: total_revenue > 0 ? (total_profit / total_revenue * 100).round(2) : 0
    )

    report.save!
    report
  end

  def self.generate_yearly_report_for_client(client, year)
    return unless client.client?

    start_date = Date.new(year, 1, 1)
    end_date = start_date.end_of_year

    # Check if report already exists
    existing_report = RevenueReport.find_by(
      client_id: client.id,
      report_date: start_date,
      report_type: 'yearly'
    )

    # Skip if report exists and is recent (less than 1 day old)
    return existing_report if existing_report&.updated_at&.> 1.day.ago

    # Get orders for this client in this year
    orders = get_orders_for_client_in_period(client, start_date, end_date)

    # Calculate metrics
    total_revenue = orders.sum(:total_amount)
    total_profit = calculate_profit_for_orders(orders, client)
    order_count = orders.distinct.count
    product_count = calculate_products_sold(orders, client)

    # Create or update report
    report = existing_report || RevenueReport.new(
      client_id: client.id,
      report_date: start_date,
      report_type: 'yearly'
    )

    report.assign_attributes(
      total_revenue: total_revenue,
      total_profit: total_profit,
      order_count: order_count,
      product_count: product_count,
      average_order_value: order_count > 0 ? total_revenue / order_count : 0,
      profit_margin: total_revenue > 0 ? (total_profit / total_revenue * 100).round(2) : 0
    )

    report.save!
    report
  end

  def self.generate_missing_reports
    # Generate missing daily reports for the last 30 days
    (30.days.ago.to_date..Date.current).each do |date|
      generate_all_reports_for_date(date)
    end

    # Generate missing monthly reports for the last 12 months
    (12.months.ago.to_date..Date.current).each do |date|
      generate_monthly_reports_for_month(date.year, date.month)
    end

    # Generate missing yearly reports for the last 3 years
    (3.years.ago.year..Date.current.year).each do |year|
      generate_yearly_reports_for_year(year)
    end
  end

  private

  def self.get_orders_for_client_on_date(client, date)
    Order.joins(:order_items)
         .joins('JOIN products ON order_items.product_id = products.id')
         .where(products: { client_id: client.id })
         .where(created_at: date.beginning_of_day..date.end_of_day)
         .where(status: ['confirmed', 'processing', 'shipped', 'delivered'])
  end

  def self.get_orders_for_client_in_period(client, start_date, end_date)
    Order.joins(:order_items)
         .joins('JOIN products ON order_items.product_id = products.id')
         .where(products: { client_id: client.id })
         .where(created_at: start_date..end_date)
         .where(status: ['confirmed', 'processing', 'shipped', 'delivered'])
  end

  def self.calculate_profit_for_orders(orders, client)
    # For now, we'll use a simple profit calculation
    # In a real scenario, you might want to consider cost of goods sold (COGS)
    # For this example, we'll assume 30% profit margin
    total_revenue = orders.sum(:total_amount)
    total_revenue * 0.3 # 30% profit margin
  end

  def self.calculate_products_sold(orders, client)
    orders.joins(:order_items)
          .joins('JOIN products ON order_items.product_id = products.id')
          .where(products: { client_id: client.id })
          .sum('order_items.quantity')
  end
end


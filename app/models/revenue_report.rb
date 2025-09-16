class RevenueReport < ApplicationRecord
  belongs_to :client, class_name: 'AdminUser', optional: true

  # Scopes for filtering
  scope :by_client, ->(client_id) { where(client_id: client_id) }
  scope :by_date_range, ->(start_date, end_date) { where(report_date: start_date..end_date) }
  scope :by_month, ->(year, month) { where("EXTRACT(YEAR FROM report_date) = ? AND EXTRACT(MONTH FROM report_date) = ?", year, month) }
  scope :by_year, ->(year) { where("EXTRACT(YEAR FROM report_date) = ?", year) }

  # Validations
  validates :report_date, presence: true
  validates :total_revenue, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :total_profit, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :order_count, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :product_count, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Class methods for generating reports
  def self.generate_daily_report(client_id, date)
    # Find or create daily report for specific client and date
    report = find_or_initialize_by(client_id: client_id, report_date: date, report_type: 'daily')
    
    if report.new_record? || report.updated_at < 1.hour.ago
      calculate_daily_metrics(report, client_id, date)
      report.save!
    end
    
    report
  end

  def self.generate_monthly_report(client_id, year, month)
    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month
    
    # Find or create monthly report
    report = find_or_initialize_by(
      client_id: client_id, 
      report_date: start_date, 
      report_type: 'monthly'
    )
    
    if report.new_record? || report.updated_at < 1.day.ago
      calculate_monthly_metrics(report, client_id, start_date, end_date)
      report.save!
    end
    
    report
  end

  def self.generate_yearly_report(client_id, year)
    start_date = Date.new(year, 1, 1)
    end_date = start_date.end_of_year
    
    # Find or create yearly report
    report = find_or_initialize_by(
      client_id: client_id, 
      report_date: start_date, 
      report_type: 'yearly'
    )
    
    if report.new_record? || report.updated_at < 1.day.ago
      calculate_yearly_metrics(report, client_id, start_date, end_date)
      report.save!
    end
    
    report
  end

  # Get revenue summary for all clients (super admin only)
  def self.all_clients_summary(start_date, end_date)
    where(report_date: start_date..end_date)
      .group(:client_id)
      .select('client_id, SUM(total_revenue) as total_revenue, SUM(total_profit) as total_profit, SUM(order_count) as total_orders')
      .includes(:client)
  end

  # Get top performing clients
  def self.top_clients_by_revenue(limit = 10, start_date = 1.month.ago, end_date = Date.current)
    all_clients_summary(start_date, end_date)
      .order('SUM(total_revenue) DESC')
      .limit(limit)
  end

  # Get revenue trends
  def self.revenue_trends(client_id, period = 'monthly')
    case period
    when 'daily'
      by_client(client_id).where(report_type: 'daily').order(:report_date)
    when 'monthly'
      by_client(client_id).where(report_type: 'monthly').order(:report_date)
    when 'yearly'
      by_client(client_id).where(report_type: 'yearly').order(:report_date)
    end
  end

  private

  def self.calculate_daily_metrics(report, client_id, date)
    # Get orders for this client on this date
    orders = Order.joins(:order_items)
                  .joins('JOIN products ON order_items.product_id = products.id')
                  .where(products: { client_id: client_id })
                  .where(created_at: date.beginning_of_day..date.end_of_day)
                  .where(status: ['confirmed', 'processing', 'shipped', 'delivered'])

    # Calculate metrics
    report.total_revenue = orders.sum(:total_amount)
    report.total_profit = calculate_profit(orders, client_id)
    report.order_count = orders.distinct.count
    report.product_count = orders.joins(:order_items)
                                .joins('JOIN products ON order_items.product_id = products.id')
                                .where(products: { client_id: client_id })
                                .sum('order_items.quantity')
    
    # Additional metrics
    report.average_order_value = report.order_count > 0 ? report.total_revenue / report.order_count : 0
    report.profit_margin = report.total_revenue > 0 ? (report.total_profit / report.total_revenue * 100).round(2) : 0
  end

  def self.calculate_monthly_metrics(report, client_id, start_date, end_date)
    # Get orders for this client in this month
    orders = Order.joins(:order_items)
                  .joins('JOIN products ON order_items.product_id = products.id')
                  .where(products: { client_id: client_id })
                  .where(created_at: start_date..end_date)
                  .where(status: ['confirmed', 'processing', 'shipped', 'delivered'])

    # Calculate metrics
    report.total_revenue = orders.sum(:total_amount)
    report.total_profit = calculate_profit(orders, client_id)
    report.order_count = orders.distinct.count
    report.product_count = orders.joins(:order_items)
                                .joins('JOIN products ON order_items.product_id = products.id')
                                .where(products: { client_id: client_id })
                                .sum('order_items.quantity')
    
    # Additional metrics
    report.average_order_value = report.order_count > 0 ? report.total_revenue / report.order_count : 0
    report.profit_margin = report.total_revenue > 0 ? (report.total_profit / report.total_revenue * 100).round(2) : 0
  end

  def self.calculate_yearly_metrics(report, client_id, start_date, end_date)
    # Get orders for this client in this year
    orders = Order.joins(:order_items)
                  .joins('JOIN products ON order_items.product_id = products.id')
                  .where(products: { client_id: client_id })
                  .where(created_at: start_date..end_date)
                  .where(status: ['confirmed', 'processing', 'shipped', 'delivered'])

    # Calculate metrics
    report.total_revenue = orders.sum(:total_amount)
    report.total_profit = calculate_profit(orders, client_id)
    report.order_count = orders.distinct.count
    report.product_count = orders.joins(:order_items)
                                .joins('JOIN products ON order_items.product_id = products.id')
                                .where(products: { client_id: client_id })
                                .sum('order_items.quantity')
    
    # Additional metrics
    report.average_order_value = report.order_count > 0 ? report.total_revenue / report.order_count : 0
    report.profit_margin = report.total_revenue > 0 ? (report.total_profit / report.total_revenue * 100).round(2) : 0
  end

  def self.calculate_profit(orders, client_id)
    # For now, we'll use a simple profit calculation
    # In a real scenario, you might want to consider cost of goods sold (COGS)
    # For this example, we'll assume 30% profit margin
    total_revenue = orders.sum(:total_amount)
    total_revenue * 0.3 # 30% profit margin
  end
end


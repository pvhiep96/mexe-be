module Admin
  class RevenueReportsController < Admin::ApplicationController
    before_action :authenticate_admin
    before_action :set_current_admin_user
    before_action :authorize_access

    def index
      @period = params[:period] || 'daily'
      @start_date = params[:start_date] || 7.days.ago.to_date
      @end_date = params[:end_date] || Date.current
      @client_id = params[:client_id]

      @reports = case @period
      when 'daily'
        get_daily_reports
      when 'monthly'
        get_monthly_reports
      when 'yearly'
        get_yearly_reports
      end

      @summary = calculate_summary(@reports)
      @clients = AdminUser.client.order(:client_name) if @current_admin_user.super_admin?
    end

    def show
      @report = RevenueReport.find(params[:id])
      authorize_report_access(@report)
    end

    def summary
      @period = params[:period] || 'daily'
      @start_date = params[:start_date] || 7.days.ago.to_date
      @end_date = params[:end_date] || Date.current
      @client_id = params[:client_id]

      @summary = case @period
      when 'daily'
        get_daily_summary
      when 'monthly'
        get_monthly_summary
      when 'yearly'
        get_yearly_summary
      end

      @clients = AdminUser.client.order(:client_name) if @current_admin_user.super_admin?
    end

    def trends
      @period = params[:period] || 'monthly'
      @months = params[:months]&.to_i || 12
      @client_id = params[:client_id]

      @trends = get_revenue_trends
      @clients = AdminUser.client.order(:client_name) if @current_admin_user.super_admin?
    end

    def client_dashboard
      unless @current_admin_user.client?
        redirect_to admin_root_path, alert: 'Chỉ client mới có quyền xem dashboard này'
        return
      end

      @period = params[:period] || 'daily'
      
      # Get today's data
      today_report = RevenueReport.by_client(@current_admin_user.id)
                                 .where(report_type: 'daily', report_date: Date.current)
                                 .first
      
      @today_revenue = today_report&.total_revenue || 0
      @today_profit = today_report&.total_profit || 0
      @today_orders = today_report&.order_count || 0
      @today_profit_margin = today_report&.profit_margin || 0

      # Get recent reports
      @recent_reports = case @period
      when 'daily'
        RevenueReport.by_client(@current_admin_user.id)
                    .where(report_type: 'daily')
                    .order(report_date: :desc)
                    .limit(7)
      when 'monthly'
        RevenueReport.by_client(@current_admin_user.id)
                    .where(report_type: 'monthly')
                    .order(report_date: :desc)
                    .limit(6)
      when 'yearly'
        RevenueReport.by_client(@current_admin_user.id)
                    .where(report_type: 'yearly')
                    .order(report_date: :desc)
                    .limit(3)
      end

      # Calculate averages
      if @recent_reports.any?
        @avg_daily_revenue = @recent_reports.average(:total_revenue) || 0
        @avg_daily_profit = @recent_reports.average(:total_profit) || 0
        @avg_daily_orders = @recent_reports.average(:order_count) || 0
        @avg_profit_margin = @recent_reports.average(:profit_margin) || 0
      else
        @avg_daily_revenue = @avg_daily_profit = @avg_daily_orders = @avg_profit_margin = 0
      end
    end

    def top_clients
      unless @current_admin_user.super_admin?
        redirect_to admin_root_path, alert: 'Chỉ Super Admin mới có quyền xem báo cáo này'
        return
      end

      @limit = params[:limit]&.to_i || 10
      @start_date = params[:start_date] || 1.month.ago.to_date
      @end_date = params[:end_date] || Date.current

      @top_clients = RevenueReport.top_clients_by_revenue(@limit, @start_date, @end_date)
    end

    def generate
      @period = params[:period] || 'daily'
      @client_id = @current_admin_user.super_admin? ? params[:client_id]&.to_i : @current_admin_user.id

      unless @client_id
        redirect_to admin_revenue_reports_path, alert: 'Client ID là bắt buộc'
        return
      end

      case @period
      when 'daily'
        date = params[:date] ? Date.parse(params[:date]) : Date.current
        @report = RevenueReport.generate_daily_report(@client_id, date)
        flash[:success] = "Báo cáo ngày #{date.strftime('%d/%m/%Y')} đã được tạo"
      when 'monthly'
        year = params[:year]&.to_i || Date.current.year
        month = params[:month]&.to_i || Date.current.month
        @report = RevenueReport.generate_monthly_report(@client_id, year, month)
        flash[:success] = "Báo cáo tháng #{month}/#{year} đã được tạo"
      when 'yearly'
        year = params[:year]&.to_i || Date.current.year
        @report = RevenueReport.generate_yearly_report(@client_id, year)
        flash[:success] = "Báo cáo năm #{year} đã được tạo"
      end

      redirect_to admin_revenue_reports_path(period: @period)
    end

    private

    def set_current_admin_user
      @current_admin_user = current_admin_user
    end

    def authorize_access
      unless @current_admin_user&.can_view_analytics?
        redirect_to admin_root_path, alert: 'Bạn không có quyền xem báo cáo doanh thu'
      end
    end

    def authorize_report_access(report)
      unless @current_admin_user.super_admin? || report.client_id == @current_admin_user.id
        redirect_to admin_root_path, alert: 'Bạn không có quyền xem báo cáo này'
      end
    end

    def get_daily_reports
      if @current_admin_user.super_admin?
        if @client_id.present?
          RevenueReport.by_client(@client_id)
                      .by_date_range(@start_date, @end_date)
                      .where(report_type: 'daily')
                      .includes(:client)
                      .order(:report_date)
        else
          RevenueReport.by_date_range(@start_date, @end_date)
                      .where(report_type: 'daily')
                      .includes(:client)
                      .order(:report_date)
        end
      else
        RevenueReport.by_client(@current_admin_user.id)
                    .by_date_range(@start_date, @end_date)
                    .where(report_type: 'daily')
                    .order(:report_date)
      end
    end

    def get_monthly_reports
      year = params[:year]&.to_i || Date.current.year
      month = params[:month]&.to_i || Date.current.month

      if @current_admin_user.super_admin?
        if @client_id.present?
          RevenueReport.by_client(@client_id)
                      .by_month(year, month)
                      .where(report_type: 'monthly')
                      .includes(:client)
                      .order(:report_date)
        else
          RevenueReport.by_month(year, month)
                      .where(report_type: 'monthly')
                      .includes(:client)
                      .order(:report_date)
        end
      else
        RevenueReport.by_client(@current_admin_user.id)
                    .by_month(year, month)
                    .where(report_type: 'monthly')
                    .order(:report_date)
      end
    end

    def get_yearly_reports
      year = params[:year]&.to_i || Date.current.year

      if @current_admin_user.super_admin?
        if @client_id.present?
          RevenueReport.by_client(@client_id)
                      .by_year(year)
                      .where(report_type: 'yearly')
                      .includes(:client)
                      .order(:report_date)
        else
          RevenueReport.by_year(year)
                      .where(report_type: 'yearly')
                      .includes(:client)
                      .order(:report_date)
        end
      else
        RevenueReport.by_client(@current_admin_user.id)
                    .by_year(year)
                    .where(report_type: 'yearly')
                    .order(:report_date)
      end
    end

    def get_daily_summary
      if @current_admin_user.super_admin?
        if @client_id.present?
          reports = RevenueReport.by_client(@client_id)
                                .by_date_range(@start_date, @end_date)
                                .where(report_type: 'daily')
        else
          reports = RevenueReport.by_date_range(@start_date, @end_date)
                                .where(report_type: 'daily')
        end
      else
        reports = RevenueReport.by_client(@current_admin_user.id)
                              .by_date_range(@start_date, @end_date)
                              .where(report_type: 'daily')
      end

      calculate_summary(reports)
    end

    def get_monthly_summary
      year = params[:year]&.to_i || Date.current.year
      month = params[:month]&.to_i || Date.current.month

      if @current_admin_user.super_admin?
        if @client_id.present?
          reports = RevenueReport.by_client(@client_id)
                                .by_month(year, month)
                                .where(report_type: 'monthly')
        else
          reports = RevenueReport.by_month(year, month)
                                .where(report_type: 'monthly')
        end
      else
        reports = RevenueReport.by_client(@current_admin_user.id)
                              .by_month(year, month)
                              .where(report_type: 'monthly')
      end

      calculate_summary(reports)
    end

    def get_yearly_summary
      year = params[:year]&.to_i || Date.current.year

      if @current_admin_user.super_admin?
        if @client_id.present?
          reports = RevenueReport.by_client(@client_id)
                                .by_year(year)
                                .where(report_type: 'yearly')
        else
          reports = RevenueReport.by_year(year)
                                .where(report_type: 'yearly')
        end
      else
        reports = RevenueReport.by_client(@current_admin_user.id)
                              .by_year(year)
                              .where(report_type: 'yearly')
      end

      calculate_summary(reports)
    end

    def get_revenue_trends
      if @current_admin_user.super_admin?
        if @client_id.present?
          RevenueReport.revenue_trends(@client_id, @period)
                      .limit(@months)
        else
          # For super admin, show aggregated trends
          RevenueReport.where(report_type: @period)
                      .where(report_date: @months.months.ago..Date.current)
                      .group(:report_date)
                      .select('report_date, SUM(total_revenue) as total_revenue, SUM(total_profit) as total_profit')
                      .order(:report_date)
        end
      else
        RevenueReport.revenue_trends(@current_admin_user.id, @period)
                    .limit(@months)
      end
    end

    def calculate_summary(reports)
      {
        total_revenue: reports.sum(:total_revenue),
        total_profit: reports.sum(:total_profit),
        total_orders: reports.sum(:order_count),
        total_products_sold: reports.sum(:product_count),
        average_order_value: reports.average(:average_order_value) || 0,
        average_profit_margin: reports.average(:profit_margin) || 0,
        report_count: reports.count
      }
    end
  end
end

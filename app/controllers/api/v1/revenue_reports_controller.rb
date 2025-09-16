module Api
  module V1
    class RevenueReportsController < Api::V1::AdminApplicationController
      before_action :authorize_access

      # GET /api/v1/revenue_reports
      def index
        @reports = case params[:period]
        when 'daily'
          get_daily_reports
        when 'monthly'
          get_monthly_reports
        when 'yearly'
          get_yearly_reports
        else
          get_daily_reports # default to daily
        end

        render json: {
          success: true,
          data: @reports,
          period: params[:period] || 'daily',
          date_range: {
            start_date: params[:start_date],
            end_date: params[:end_date]
          }
        }
      end

      # GET /api/v1/revenue_reports/summary
      def summary
        @summary = case params[:period]
        when 'daily'
          get_daily_summary
        when 'monthly'
          get_monthly_summary
        when 'yearly'
          get_yearly_summary
        else
          get_daily_summary
        end

        render json: {
          success: true,
          data: @summary,
          period: params[:period] || 'daily'
        }
      end

      # GET /api/v1/revenue_reports/trends
      def trends
        @trends = get_revenue_trends

        render json: {
          success: true,
          data: @trends
        }
      end

      # GET /api/v1/revenue_reports/top_clients (Super Admin only)
      def top_clients
        unless @current_admin_user.super_admin?
          render json: {
            success: false,
            error: 'Chỉ Super Admin mới có quyền xem báo cáo này'
          }, status: :forbidden
          return
        end

        @top_clients = RevenueReport.top_clients_by_revenue(
          params[:limit]&.to_i || 10,
          parse_date(params[:start_date]) || 1.month.ago,
          parse_date(params[:end_date]) || Date.current
        )

        render json: {
          success: true,
          data: @top_clients
        }
      end

      # GET /api/v1/revenue_reports/generate
      def generate
        case params[:period]
        when 'daily'
          generate_daily_report
        when 'monthly'
          generate_monthly_report
        when 'yearly'
          generate_yearly_report
        else
          render json: {
            success: false,
            error: 'Period không hợp lệ. Chọn: daily, monthly, yearly'
          }, status: :bad_request
        end
      end

      private

      def authorize_access
        unless @current_admin_user&.can_view_analytics?
          render json: {
            success: false,
            error: 'Bạn không có quyền xem báo cáo doanh thu'
          }, status: :forbidden
        end
      end

      def get_daily_reports
        start_date = parse_date(params[:start_date]) || 7.days.ago.to_date
        end_date = parse_date(params[:end_date]) || Date.current

        if @current_admin_user.super_admin?
          # Super admin can see all clients
          client_id = params[:client_id]&.to_i
          if client_id
            RevenueReport.by_client(client_id)
                        .by_date_range(start_date, end_date)
                        .where(report_type: 'daily')
                        .includes(:client)
                        .order(:report_date)
          else
            RevenueReport.by_date_range(start_date, end_date)
                        .where(report_type: 'daily')
                        .includes(:client)
                        .order(:report_date)
          end
        else
          # Client can only see their own reports
          RevenueReport.by_client(@current_admin_user.id)
                      .by_date_range(start_date, end_date)
                      .where(report_type: 'daily')
                      .order(:report_date)
        end
      end

      def get_monthly_reports
        year = params[:year]&.to_i || Date.current.year
        month = params[:month]&.to_i || Date.current.month

        if @current_admin_user.super_admin?
          client_id = params[:client_id]&.to_i
          if client_id
            RevenueReport.by_client(client_id)
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
          client_id = params[:client_id]&.to_i
          if client_id
            RevenueReport.by_client(client_id)
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
        start_date = parse_date(params[:start_date]) || 7.days.ago.to_date
        end_date = parse_date(params[:end_date]) || Date.current

        if @current_admin_user.super_admin?
          client_id = params[:client_id]&.to_i
          reports = if client_id
            RevenueReport.by_client(client_id)
                        .by_date_range(start_date, end_date)
                        .where(report_type: 'daily')
          else
            RevenueReport.by_date_range(start_date, end_date)
                        .where(report_type: 'daily')
          end
        else
          reports = RevenueReport.by_client(@current_admin_user.id)
                                .by_date_range(start_date, end_date)
                                .where(report_type: 'daily')
        end

        calculate_summary(reports)
      end

      def get_monthly_summary
        year = params[:year]&.to_i || Date.current.year
        month = params[:month]&.to_i || Date.current.month

        if @current_admin_user.super_admin?
          client_id = params[:client_id]&.to_i
          reports = if client_id
            RevenueReport.by_client(client_id)
                        .by_month(year, month)
                        .where(report_type: 'monthly')
          else
            RevenueReport.by_month(year, month)
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
          client_id = params[:client_id]&.to_i
          reports = if client_id
            RevenueReport.by_client(client_id)
                        .by_year(year)
                        .where(report_type: 'yearly')
          else
            RevenueReport.by_year(year)
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
        period = params[:period] || 'monthly'
        months = params[:months]&.to_i || 12

        if @current_admin_user.super_admin?
          client_id = params[:client_id]&.to_i
          if client_id
            RevenueReport.revenue_trends(client_id, period)
                        .limit(months)
          else
            # For super admin, show aggregated trends
            RevenueReport.where(report_type: period)
                        .where(report_date: months.months.ago..Date.current)
                        .group(:report_date)
                        .select('report_date, SUM(total_revenue) as total_revenue, SUM(total_profit) as total_profit')
                        .order(:report_date)
          end
        else
          RevenueReport.revenue_trends(@current_admin_user.id, period)
                      .limit(months)
        end
      end

      def generate_daily_report
        date = parse_date(params[:date]) || Date.current
        client_id = @current_admin_user.super_admin? ? params[:client_id]&.to_i : @current_admin_user.id

        unless client_id
          render json: {
            success: false,
            error: 'Client ID là bắt buộc'
          }, status: :bad_request
          return
        end

        report = RevenueReport.generate_daily_report(client_id, date)
        
        render json: {
          success: true,
          data: report,
          message: "Báo cáo ngày #{date.strftime('%d/%m/%Y')} đã được tạo"
        }
      end

      def generate_monthly_report
        year = params[:year]&.to_i || Date.current.year
        month = params[:month]&.to_i || Date.current.month
        client_id = @current_admin_user.super_admin? ? params[:client_id]&.to_i : @current_admin_user.id

        unless client_id
          render json: {
            success: false,
            error: 'Client ID là bắt buộc'
          }, status: :bad_request
          return
        end

        report = RevenueReport.generate_monthly_report(client_id, year, month)
        
        render json: {
          success: true,
          data: report,
          message: "Báo cáo tháng #{month}/#{year} đã được tạo"
        }
      end

      def generate_yearly_report
        year = params[:year]&.to_i || Date.current.year
        client_id = @current_admin_user.super_admin? ? params[:client_id]&.to_i : @current_admin_user.id

        unless client_id
          render json: {
            success: false,
            error: 'Client ID là bắt buộc'
          }, status: :bad_request
          return
        end

        report = RevenueReport.generate_yearly_report(client_id, year)
        
        render json: {
          success: true,
          data: report,
          message: "Báo cáo năm #{year} đã được tạo"
        }
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

      def parse_date(date_string)
        return nil unless date_string.present?
        Date.parse(date_string)
      rescue ArgumentError
        nil
      end
    end
  end
end

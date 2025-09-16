class DailyRevenueReportJob < ApplicationJob
  queue_as :default

  def perform(date = Date.current)
    Rails.logger.info "Starting daily revenue report generation for #{date}"
    
    begin
      RevenueReportService.generate_all_reports_for_date(date)
      Rails.logger.info "Daily revenue report generation completed for #{date}"
    rescue => e
      Rails.logger.error "Failed to generate daily revenue reports for #{date}: #{e.message}"
      raise e
    end
  end
end


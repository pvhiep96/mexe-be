namespace :revenue_reports do
  desc "Generate daily revenue reports for all clients"
  task generate_daily: :environment do
    puts "Generating daily revenue reports..."
    date = ENV['DATE'] ? Date.parse(ENV['DATE']) : Date.current
    RevenueReportService.generate_all_reports_for_date(date)
    puts "Daily revenue reports generated for #{date}"
  end

  desc "Generate monthly revenue reports for all clients"
  task generate_monthly: :environment do
    puts "Generating monthly revenue reports..."
    year = ENV['YEAR']&.to_i || Date.current.year
    month = ENV['MONTH']&.to_i || Date.current.month
    RevenueReportService.generate_monthly_reports_for_month(year, month)
    puts "Monthly revenue reports generated for #{month}/#{year}"
  end

  desc "Generate yearly revenue reports for all clients"
  task generate_yearly: :environment do
    puts "Generating yearly revenue reports..."
    year = ENV['YEAR']&.to_i || Date.current.year
    RevenueReportService.generate_yearly_reports_for_year(year)
    puts "Yearly revenue reports generated for #{year}"
  end

  desc "Generate all missing revenue reports"
  task generate_missing: :environment do
    puts "Generating missing revenue reports..."
    RevenueReportService.generate_missing_reports
    puts "Missing revenue reports generated"
  end

  desc "Generate revenue reports for a specific client"
  task generate_for_client: :environment do
    client_id = ENV['CLIENT_ID']
    unless client_id
      puts "Error: CLIENT_ID is required"
      exit 1
    end

    client = AdminUser.find_by(id: client_id)
    unless client&.client?
      puts "Error: Client not found or not a client user"
      exit 1
    end

    puts "Generating revenue reports for client: #{client.display_name}"

    # Generate daily reports for last 30 days
    (30.days.ago.to_date..Date.current).each do |date|
      RevenueReportService.generate_daily_report_for_client(client, date)
    end

    # Generate monthly reports for last 12 months
    (12.months.ago.to_date..Date.current).each do |date|
      RevenueReportService.generate_monthly_report_for_client(client, date.year, date.month)
    end

    # Generate yearly reports for last 3 years
    (3.years.ago.year..Date.current.year).each do |year|
      RevenueReportService.generate_yearly_report_for_client(client, year)
    end

    puts "Revenue reports generated for client: #{client.display_name}"
  end

  desc "Clean old revenue reports (older than specified days)"
  task clean_old: :environment do
    days = ENV['DAYS']&.to_i || 365
    cutoff_date = days.days.ago.to_date
    
    puts "Cleaning revenue reports older than #{cutoff_date}..."
    
    old_reports = RevenueReport.where('report_date < ?', cutoff_date)
    count = old_reports.count
    
    if count > 0
      old_reports.destroy_all
      puts "Deleted #{count} old revenue reports"
    else
      puts "No old revenue reports found"
    end
  end

  desc "Show revenue report statistics"
  task stats: :environment do
    puts "Revenue Report Statistics:"
    puts "=" * 50
    
    total_reports = RevenueReport.count
    daily_reports = RevenueReport.where(report_type: 'daily').count
    monthly_reports = RevenueReport.where(report_type: 'monthly').count
    yearly_reports = RevenueReport.where(report_type: 'yearly').count
    
    puts "Total reports: #{total_reports}"
    puts "Daily reports: #{daily_reports}"
    puts "Monthly reports: #{monthly_reports}"
    puts "Yearly reports: #{yearly_reports}"
    
    puts "\nBy client:"
    AdminUser.client.includes(:revenue_reports).each do |client|
      count = client.revenue_reports.count
      puts "  #{client.display_name}: #{count} reports"
    end
    
    puts "\nDate range:"
    oldest = RevenueReport.minimum(:report_date)
    newest = RevenueReport.maximum(:report_date)
    puts "  From: #{oldest || 'No reports'}"
    puts "  To: #{newest || 'No reports'}"
  end
end



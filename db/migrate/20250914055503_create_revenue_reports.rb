class CreateRevenueReports < ActiveRecord::Migration[7.2]
  def change
    create_table :revenue_reports do |t|
      t.bigint :client_id, null: false
      t.date :report_date, null: false
      t.string :report_type, null: false
      t.decimal :total_revenue, precision: 15, scale: 2, default: 0.0
      t.decimal :total_profit, precision: 15, scale: 2, default: 0.0
      t.integer :order_count, default: 0
      t.integer :product_count, default: 0
      t.decimal :average_order_value, precision: 15, scale: 2, default: 0.0
      t.decimal :profit_margin, precision: 5, scale: 2, default: 0.0

      t.timestamps
    end

    add_index :revenue_reports, [:client_id, :report_date, :report_type], unique: true, name: 'index_revenue_reports_on_client_date_type'
    add_index :revenue_reports, :report_date
    add_index :revenue_reports, :report_type
    add_foreign_key :revenue_reports, :admin_users, column: :client_id
  end
end

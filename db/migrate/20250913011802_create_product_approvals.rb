class CreateProductApprovals < ActiveRecord::Migration[7.2]
  def change
    create_table :product_approvals do |t|
      t.references :product, null: false, foreign_key: true
      t.references :admin_user, null: false, foreign_key: true, comment: 'The super admin who performed the approval/rejection'
      t.integer :status, null: false, default: 0, comment: 'pending: 0, approved: 1, rejected: 2'
      t.text :reason, comment: 'Reason for approval/rejection'
      t.datetime :approved_at, comment: 'When the approval/rejection was made'
      t.string :approval_type, null: false, default: 'creation', comment: 'creation or edit'

      t.timestamps
    end

    add_index :product_approvals, [:product_id, :approval_type]
    add_index :product_approvals, :status
  end
end

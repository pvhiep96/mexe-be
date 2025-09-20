module Admin
  class SessionsController < Devise::SessionsController
    layout 'devise'
    
    # Override the destroy action to add custom logic
    def destroy
      # Call the parent destroy method
      super do
        # Custom logic after logout
        flash[:notice] = 'Đăng xuất thành công!'
      end
    end

    # Override the after_sign_out_path_for method to redirect to login page
    def after_sign_out_path_for(resource_or_scope)
      new_admin_user_session_path
    end

    # Override the after_sign_in_path_for method to redirect to admin dashboard
    def after_sign_in_path_for(resource_or_scope)
      admin_root_path
    end
  end
end

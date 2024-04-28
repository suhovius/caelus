# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

if Rails.env.development?
  # Admin User for development purposes
  # in production admins must have secure passwords
  admin_user = AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
  admin_user.add_role(:system_admin)
end

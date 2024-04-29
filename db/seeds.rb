# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

if Rails.env.development?
  # Admin User for development purposes
  # in production admins must have secure passwords
  unless AdminUser.exists?(email: 'super.admin@caelus.com')
    admin_user = AdminUser.create!(
      email: 'super.admin@caelus.com',
      password: 'qwerty',
      password_confirmation: 'qwerty'
    )

    admin_user.add_role(:super_admin)
  end

  unless Organization.exists?(name: 'Meteo Tech')
    organization = Organization.create!(
      name: 'Meteo Tech', description: 'Meteorological Services Company'
    )

    organization_admin_user = AdminUser.create!(
      email: 'organization.admin@caelus.com',
      password: 'qwerty',
      password_confirmation: 'qwerty'
    )

    organization_admin_user.grant(:organization_admin, organization)
  end
end

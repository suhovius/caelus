module ActiveAdmin
  module Observations
    class SourcePolicy < AdminPolicy
      include OrganizationAdminFullAccess
    end
  end
end

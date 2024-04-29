module ActiveAdmin
  module Observations
    class ResultPolicy < AdminPolicy
      include OrganizationAdminFullAccess
    end
  end
end

module ActiveAdmin
  module Observations
    class SourcePolicy < AdminPolicy
      include FullAccessForOrganizationAdmin
    end
  end
end

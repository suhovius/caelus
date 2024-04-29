module Observations
  class Source < ApplicationRecord
    belongs_to :organization
    belongs_to :origin, polymorphic: true

    validates :name, presence: true, uniqueness: { scope: :organization_id }

    validates :latitude, :longitude, presence: :true

    attr_accessor :origin_type_and_id # INFO: This is needed for hack in active_admin

    def origin_type_and_id
      @origin_type_and_id || [self.origin_type, self.origin_id].compact.join('-')
    end

    before_validation do
      if origin_type_and_id.present?
        self.origin_type, self.origin_id = origin_type_and_id.split('-')
      end
    end
  end
end

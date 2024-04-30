module Observations
  class SourceDecorator < Draper::Decorator
    delegate_all

    def google_maps_link
      [
        'https://maps.google.com/?q=',
        [latitude, longitude].join(',')
      ].join
    end
  end
end

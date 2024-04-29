module Weather
  class ResponseContract < Dry::Validation::Contract
    params do
      required(:temperature).value(:float?)
      required(:pressure).value(:float?)
      required(:humidity).value(:float?)
      required(:wind_speed).value(:float?)
      required(:wind_deg).value(:float?)
    end
  end
end

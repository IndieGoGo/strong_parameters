require 'airbrake'
module ActionController
  class DecoratesParameters
    attr_reader :params

    methods_to_delegate = (ActionController::Parameters.new.methods - Object.new.methods - [:permit]) + [:require]
    delegate *methods_to_delegate, :to => :params

    def initialize(params)
      @params = params
    end

    def permit(key)
      params.permit(key)
    rescue => e
      Airbrake.notify_or_ignore(
        e,
        :parameters    => params,
        :cgi_data      => ENV.to_hash
      )
    end
  end

  module AirbreakUnpermittedParameters
    def params
      @_params ||= DecoratesParameters.new(Parameters.new(request.parameters))
    end

    def params=(val)
      @_params = val.is_a?(Hash) ? DecoratesParameters.new(Parameters.new(val)) : val
    end
  end
end

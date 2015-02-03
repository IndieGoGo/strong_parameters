module ActionController
  class DecoratesParameters
    attr_reader :params
    cattr_accessor :logger

    self.logger = ActionController::Base.logger

    methods_to_delegate = (ActionController::Parameters.new.methods - Object.new.methods - [:permit]) + [:require]
    delegate *methods_to_delegate, :to => :params

    def initialize(params)
      @params = params
    end

    def permit(key)
      params.permit(key)
    rescue ActionController::UnpermittedParameters => e
      DecoratesParameters.logger.warn(e.message)
    end
  end

  module LoggingParameters
    def params
      @_params ||= DecoratesParameters.new(Parameters.new(request.parameters))
    end

    def params=(val)
      @_params = val.is_a?(Hash) ? DecoratesParameters.new(Parameters.new(val)) : val
    end
  end
end

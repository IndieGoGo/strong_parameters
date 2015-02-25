module ActiveModel
  module AirbrakeForbiddenAttributes
    extend ActiveSupport::Concern

    included do
      alias_method_chain :sanitize_for_mass_assignment, :airbrake
    end

    def sanitize_for_mass_assignment_with_airbrake(*options)
      begin
        sanitize_for_mass_assignment_without_airbrake(*options)
      rescue => e
        Airbrake.notify_or_ignore(
          e,
          :parameters => options.try(:first),
          :cgi_data   => ENV.to_hash
        )
      end
    end
  end
end
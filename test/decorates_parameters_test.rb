require 'test_helper'
require 'action_controller/parameters'
require 'action_controller/airbrake_unpermitted_parameters'

class DecoratesParametersTest < ActiveSupport::TestCase

  test "is_a? masquerades as a Hash or HashWithIndifferentAccess" do
    params = ActionController::DecoratesParameters.new(
      ActionController::Parameters.new(
        {
          :book => { :pages => 65 },
          :fishing => "Turnips"
        }
      )
    )

    assert(params.is_a?(HashWithIndifferentAccess), "not is_a? HashWithIndifferentAccess")
    assert(params.is_a?(Hash), "not is_a? Hash")
  end

  test "kind_of? masquerades as a Hash or HashWithIndifferentAccess" do
    params = ActionController::DecoratesParameters.new(
      ActionController::Parameters.new(
        {
          :book => { :pages => 65 },
          :fishing => "Turnips"
        }
      )
    )

    assert(params.kind_of?(HashWithIndifferentAccess), "not kind_of? HashWithIndifferentAccess")
    assert(params.kind_of?(Hash), "not kind_of? Hash")
  end
end

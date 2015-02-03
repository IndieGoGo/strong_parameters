require 'test_helper'
require 'action_controller/parameters'
require 'action_controller/airbrake_unpermitted_parameters'

class DecoratesParamsActuallyLogsOnUnpermittedParamsTest < ActiveSupport::TestCase
  def setup
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
    ActionController::Parameters.action_on_unpermitted_parameters = false
  end

  test "doesnt raise on unexpected params" do
    params = ActionController::DecoratesParameters.new(ActionController::Parameters.new({
      :book => { :pages => 65 },
      :fishing => "Turnips"
    }))

    Airbrake.expects(:notify_or_ignore)
    params.permit(:book => [:pages])
  end

  test "doesnt raise on unexpected nested params" do
    params = ActionController::DecoratesParameters.new(ActionController::Parameters.new({
      :book => { :pages => 65, :title => "Green Cats and where to find then." }
    }))

    Airbrake.expects(:notify_or_ignore)
    params.permit(:book => [:pages])
  end
end
require 'test_helper'
require 'action_controller/parameters'
require 'action_controller/logging_parameters'

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

    assert_logged('found unpermitted parameters: fishing') do
      params.permit(:book => [:pages])
    end
  end

  test "doesnt raise on unexpected nested params" do
    params = ActionController::DecoratesParameters.new(ActionController::Parameters.new({
      :book => { :pages => 65, :title => "Green Cats and where to find then." }
    }))

    assert_logged('found unpermitted parameters: title') do
      params.permit(:book => [:pages])
    end
  end

  def assert_logged(message)
    log = StringIO.new
    ActionController::DecoratesParameters.logger = Logger.new(log)

    begin
      yield

      log.rewind
      assert_match message, log.read
    end
  end
end
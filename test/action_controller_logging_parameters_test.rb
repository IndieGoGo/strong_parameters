require 'test_helper'

class NewBooksController < ActionController::Base
  include ActionController::StrongParameters
  include ActionController::LoggingParameters

  def create
    params.permit(:book => [:pages])
    head :ok
  end
end

class ActionControllerLoggingParametersTest < ActionController::TestCase
  tests NewBooksController

  def setup
    ActionController::Parameters.action_on_unpermitted_parameters = :log
  end

  def teardown
    ActionController::Parameters.action_on_unpermitted_parameters = false
  end

  test "unpermitted parameters log and not raise" do
    assert_logged('Unpermitted parameters: fishing') do
      post :create, { :book => { :pages => 65 }, :fishing => "Turnips" }
    end
    assert_response :success
  end

  def assert_logged(message)
    old_logger = ActionController::Base.logger
    log = StringIO.new
    ActionController::Base.logger = Logger.new(log)

    begin
      yield

      log.rewind
      assert_match message, log.read
    ensure
      ActionController::Base.logger = old_logger
    end
  end
end

require 'test_helper'

class Place
  include ActiveModel::MassAssignmentSecurity
  include ActiveModel::ForbiddenAttributesProtection
  include ActiveModel::AirbrakeForbiddenAttributes

  public :sanitize_for_mass_assignment
end

class ActiveModelMassUpdateLogTest < ActiveSupport::TestCase
  test "forbidden attributes are logged during mass updating" do
    Airbrake.expects(:notify_or_ignore).with(instance_of(ActiveModel::ForbiddenAttributes), all_of(has_entry(:parameters => { 'a' => 'b' }), has_key(:cgi_data)))
    Place.new.sanitize_for_mass_assignment(ActionController::Parameters.new(:a => 'b'))
  end

  test "permitted attributes can be used for mass updating" do
    assert_nothing_raised do
      assert_equal({ 'a' => 'b' },
                   Place.new.sanitize_for_mass_assignment(ActionController::Parameters.new(:a => 'b').permit(:a)))
    end
  end

  test "regular attributes should still be allowed" do
    assert_nothing_raised do
      assert_equal({ :a => 'b' },
                   Place.new.sanitize_for_mass_assignment(:a => 'b'))
    end
  end
end

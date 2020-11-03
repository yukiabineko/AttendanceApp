require 'test_helper'

class MonthsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get months_show_url
    assert_response :success
  end

end

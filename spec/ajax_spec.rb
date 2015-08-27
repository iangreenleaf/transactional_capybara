require_relative 'support/server'
require_relative 'support/model'

RSpec.describe "server with AJAX", type: :feature, js: true do
  before do
    Capybara.app = AjaxServer
    AjaxServer.should_return_from_ajax = false
    @expected_message = "foobar"
    TestValue.create! content: @expected_message
  end

  it "waits for AJAX" do
    visit "/page_with_ajax"
    expect(page).to have_content("Hello")
    Thread.fork do
      sleep 0.5
      AjaxServer.should_return_from_ajax = true
    end
    expect(find(".message").text).not_to eq(@expected_message)
    TransactionalCapybara::AjaxHelpers.wait_for_ajax(page)
    expect(find(".message").text).to eq(@expected_message)
  end

  context "after hook", check_result_after: true do
    it "automatically waits for AJAX" do
      visit "/page_with_ajax"
      expect(page).to have_content("Hello")
      Thread.fork do
        sleep 0.5
        AjaxServer.should_return_from_ajax = true
      end
      expect(find(".message").text).not_to eq(@expected_message)
    end
  end
end

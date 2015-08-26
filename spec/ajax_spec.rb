require_relative 'support/server'
require_relative 'support/model'

RSpec.describe "server with AJAX", type: :feature, js: true do
  before do
    Capybara.app = AjaxServer
    AjaxServer.should_return_from_ajax = false
    TestValue.create! content: "foobar"
  end

  it "waits for AJAX" do
    visit "/page_with_ajax"
    expect(find(".message").text).not_to eq("foobar")
    TransactionalCapybara::AjaxHelpers.wait_for_ajax(page)
    AjaxServer.should_return_from_ajax = true
    expect(find(".message").text).to eq("foobar")
  end
end

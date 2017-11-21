require_relative 'support/server'

RSpec.describe "integration with Capybara" do
  let(:page) { double }

  def simulate_page_wait(expected_timeout)
    page_handler = TransactionalCapybara::AjaxHelpers::PageWaiting.new(page)
    expect(Timeout).to receive(:timeout).with(expected_timeout).at_least(:once)
    page_handler.wait_until { true }
  end

  context "version >= 2.5", if: (Capybara::VERSION >= "2.5.0")  do
    it "uses Capybara.default_max_wait_time if available" do
      Capybara.default_max_wait_time = 3
      simulate_page_wait(3)
    end
  end

  context "version < 2.5", if: (Capybara::VERSION < "2.5.0")  do
    it "fallbacks on deprecated Capybara.default_wait_time" do
      Capybara.default_wait_time = 6
      simulate_page_wait(6)
    end
  end
end

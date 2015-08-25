module TransactionalCapybara
  module AjaxHelpers
    class PageWaiting
      def initialize(page)
        @page = page
      end

      def wait_for_ajax
        wait_until { finished_all_ajax_requests? }
      end

      def finished_all_ajax_requests?
        capybara_sessions.all? do |name, session|
          if is_session_touched?(session)
            PageWaiting.new(session).finished_ajax_requests?
          else
            true
          end
        end
      end

      def finished_ajax_requests?
        (
          angular_requests
          + jquery_requests
        ).zero?
      end

      def wait_until(timeout=Capybara.default_wait_time)
        Timeout.timeout(timeout) do
          until yield
            sleep(0.01)
          end
        end
      end

      private

      def capybara_sessions
        Capybara.send :session_pool
      end

      def is_session_touched?(session)
         session.instance_variable_get(:@touched)
      end

      def run_js(expr)
        @page.execute_script(expr)
      end

      def angular?
        run_js("!!window.angular") && run_js("angular.element('[ng-app]').length") > 0
      end

      def angular_requests
        if angular?
          run_js("angular.element('[ng-app]').injector().get('$http').pendingRequests.length")
        else
          0
        end
      end

      def jquery?
        run_js("!!window.jQuery")
      end

      def jquery_requests
        if jquery?
          run_js("jQuery.active")
        else
          0
        end
      end
    end

    def wait_for_ajax
      TransactionalCapybara::AjaxHelpers.wait_for_ajax(page)
    end

    def self.wait_for_ajax(page)
      PageWaiting.new(page).wait_for_ajax
    end

    def ajax_finished?
      TransactionalCapybara::AjaxHelpers.ajax_finished?(page)
    end

    def self.ajax_finished?(page)
      PageWaiting.new(page).finished_all_ajax_requests?
    end
  end
end

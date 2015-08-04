module TransactionalCapybara
  module AjaxHelpers
    def wait_for_ajax
      wait_until { finished_all_ajax_requests? }
    end

    def finished_all_ajax_requests?
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
    def run_js(expr)
      page.execute_script(expr)
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
end

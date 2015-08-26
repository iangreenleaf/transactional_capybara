require 'sinatra'
require_relative 'model'

class AjaxServer < Sinatra::Base
  cattr_accessor :should_return_from_ajax

  get "/page_with_ajax" do
    erb :page_with_ajax, layout: :basic
  end

  get "/ajax_endpoint" do
    until AjaxServer.should_return_from_ajax do
      sleep 0.01
    end
    TestValue.last.content
  end
end

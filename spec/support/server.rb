require 'sinatra'
require 'tilt/erb'

class AjaxServer < Sinatra::Base
  set :public_folder, File.dirname(__FILE__) + '/vendor'

  class << self
    attr_accessor :should_return_from_ajax
  end

  get "/boring_page" do
    erb "Hi", layout: :basic
  end

  get "/ajax/jquery" do
    erb :jquery, layout: :basic
  end

  get "/ajax/angular" do
    erb :angular, layout: :basic
  end

  get "/ajax/endpoint" do
    until AjaxServer.should_return_from_ajax do
      sleep 0.01
    end
    TestValue.last.content
  end
end

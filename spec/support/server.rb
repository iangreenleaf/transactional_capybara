require 'sinatra'
require 'tilt/erb'
require_relative 'model'

class AjaxServer < Sinatra::Base
  set :public_folder, File.dirname(__FILE__) + '/vendor'

  cattr_accessor :should_return_from_ajax

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

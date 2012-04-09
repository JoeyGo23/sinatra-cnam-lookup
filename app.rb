require 'sinatra'
require 'sinatra/base'
require 'sinatra/content_for2'
require 'sprockets'
require 'open-uri'
require 'json'
require './lib/sprockets_sinatra_middleware'

helpers Sinatra::ContentFor2

set :root, File.dirname(__FILE__)

use ::SprocketsSinatraMiddleware, :root => settings.root, :path => 'assets' 

before do
  @errors = []
  @success = false
end

get "/" do
  erb :index
end

post '/' do
  name = params[:name]
  tel = params[:tel]
  if name && tel
    check = Checker.new(name, tel)
    if check.pass?
      @success = true
      erb :index
    elsif !check.results
      @errors << "Could not find a CNAM entry for your telephone number."
    else
      @errors << "Telephone number and name are not valid!"
    end
  else
    @errors << "Please provide a full name and telephone number to verify."
  end
  erb :index
end

class Checker
  attr_reader :results

  def initialize(name, tel)
    @results = cnam_results(tel)
    @name = name.downcase
  end

  def pass?
    @results == @name
  end

  private

  def cnam_results(tel)
    begin
      response = open("https://api.opencnam.com/v1/phone/#{tel}?format=json").read
      results = JSON.parse(response)
      results["cnam"].downcase.split(" ").reverse.join(" ")
    rescue
      nil
    end
  end
end

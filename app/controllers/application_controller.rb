class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  def hello
  	render html: "Hello everyone, I'm Tuan!"
  end
end

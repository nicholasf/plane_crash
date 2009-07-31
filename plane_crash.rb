require 'rubygems'
require 'sinatra'
require 'scruffy'
require 'ruby-debug'
require 'tempfile'
require 'shotgun'


get "/" do
  "use /bd"
end

get "/bd" do
  start_date = params[:start_date]
  end_date = params[:end_date]
  total_points = params[:total_points]
  
  graph = Scruffy::Graph.new
  graph.title = "Burndown - #{start_date} - #{end_date}"
  graph.renderer = Scruffy::Renderers::Standard.new
  
  graph.add :line, 'Normal', [total_points.to_i, 0]
  file_name = "bd_#{Time.now.to_i}.svg"
  graph.render :to => "public/#{file_name}"
  # debugger
  
  redirect "#{file_name}"
  # "your file is generated, please visit <a href='#{file_name}'>#{file_name}</a>"
end
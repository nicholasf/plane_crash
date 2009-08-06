require 'rubygems'
require 'sinatra'
require 'scruffy'
require 'graph_utils'
require 'ruby-debug'

include GraphUtils

get "/" do
  "<pre>Visit /bd (burdown) with following parameters on a GET:
  
  start_date=DD-MM-YY, e.g. 1-1-09
  end_date=DD-MM-YY, e.g. 15-1-09
  tp = total points for iteraton, e.g. 100
  dDD-MM-YY=points scored on day, e.g. d13-1-09=12

  You may make as many parameters of the d type as you wish to indicate point scoring to represent days in the spring (only one d entry per day, holding the day total). Obviously it's a bit onerous to build URLs this way, but form input or link generation from Redmine is not far off.
  

  A sample URL to get started:

  http://localhost:4567/bd?start_date=1-1-09&end_date=15-1-09&tp=100&d3-1-09=10&d5-1-09=30&d13-1-09=12</pre>"
end

get "/bd" do
  check_public_dir()
  start_date = params_to_date(params[:start_date])
  end_date = params_to_date(params[:end_date])      
  total_points = params[:tp]
  progress = gather_point_progress_intervals(params, start_date, end_date, total_points.to_i)
  
  graph = Scruffy::Graph.new(:theme => Scruffy::Themes::Keynote.new)

  graph.title = "Burndown - #{start_date.strftime('%Y-%m-%d')} - #{end_date.strftime('%Y-%m-%d')}"
  graph.renderer = Scruffy::Renderers::Standard.new
  
  point_markers = generate_point_markers(start_date, end_date)
  
  graph.point_markers = point_markers
  #debugger
  graph.add :line, 'Avg', generate_ideal_points(point_markers.size, total_points.to_i)
  graph.add :line, 'Actual', progress
  
  # graph.add :line, 'Avg', [100,75,25,0]
  file_name = "bd_#{Time.now.to_i}.svg"
  graph.render :to => "public/#{file_name}"
  redirect "#{file_name}"
end

private
def check_public_dir
  unless File.exist?("public")
    Dir.mkdir("public")
  end
end

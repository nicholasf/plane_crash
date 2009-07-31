require 'rubygems'
require 'sinatra'
require 'scruffy'
require 'graph_utils'
require 'ruby-debug'

include GraphUtils

get "/" do
  puts `env`
  "use /bd"
end

get "/bd" do
  start_date = params_to_date(params[:start_date])
  end_date = params_to_date(params[:end_date])
      
  total_points = params[:total_points]
  
  graph = Scruffy::Graph.new(:theme => Scruffy::Themes::Keynote.new)

  graph.title = "Burndown - #{start_date.strftime('%Y-%m-%d')} - #{end_date.strftime('%Y-%m-%d')}"
  graph.renderer = Scruffy::Renderers::Standard.new
  
  point_markers = generate_point_markers(start_date, end_date)
  
  graph.point_markers = point_markers
  #debugger
  graph.add :line, 'Avg', generate_ideal_points(point_markers.size, total_points.to_i)
  # graph.add :line, 'Avg', [100,75,25,0]
  file_name = "bd_#{Time.now.to_i}.svg"
  graph.render :to => "public/#{file_name}"
  redirect "#{file_name}"
end

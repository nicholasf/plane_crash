module GraphUtils
  
  def params_to_date(param_date)
    bits = param_date.split("-")
    date = DateTime.new("20#{bits[2]}".to_i, bits[1].to_i, bits[0].to_i)
    return date
  end

  def generate_point_markers(start_date, end_date)
    diff_days = (end_date - start_date).to_i

    days = []

    (0..diff_days).each do |day|
      day_date = start_date + day
      days << day_date.strftime("%d")
    end
    days
  end
  
  def generate_ideal_points(intervals, top)
    intervals_qtr = intervals/4
    points = Array.new(intervals_qtr)
      points.each_index do |i|
        if i == 0
          points[i] = top
          next
        end
        
        points[i] = points[i -1] - top/intervals_qtr
      end
      
      points
    end
end
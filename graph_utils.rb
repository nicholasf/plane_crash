module GraphUtils
  
  def bits_to_date(bits)
    DateTime.new("20#{bits[2]}".to_i, bits[1].to_i, bits[0].to_i)
  end

  def params_to_date(param_date)
    bits = param_date.split("-")
    date = bits_to_date(bits) 
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
    
  #interprets values of d2-1-09=3 into 3 points scored on the 2-1-09 and returns them in an array
  def gather_point_progress_intervals(params, start_date, end_date, top)
    days = (end_date - start_date).to_i
    progress = Array.new(days)
    
    dates = {}
    
    params.keys.each do |k|
      if k[0..0] == 'd'
        bits = k[1..-1].split("-")
        progressive_day = bits_to_date(bits)
        dates[progressive_day.to_s] = params[k].to_i
      end
    end
    
    progress.each_index do |i|
      day = start_date + i
      if dates[day.to_s]
        
        progress[i] = top - dates[day.to_s]
        top = top - dates[day.to_s]
      end
    end
    
    return progress
  end
end
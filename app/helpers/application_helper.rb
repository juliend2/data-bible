module ApplicationHelper

  def word_cloud(words)
    html = ''
    html += "<ul class='word-cloud'>"
    higher_bound = words.first.last
    lower_bound = words.last.last
    range = higher_bound - lower_bound
    x_small = range * 0.166666
    small = range * 0.3333333
    medium = range * 0.5
    large = range * 0.666666
    x_large = range * 0.833333
    xx_large = range * 1
    words.sort_by {|key, value| key }.each do |word, count|
      size_class = case count
                   when 0...x_small then 'x-small'
                   when x_small...small then 'small'
                   when small...medium then 'medium'
                   when medium...large then 'large'
                   when large...x_large then 'x-large'
                   else 'xx-large'
                   end
      html += "<li class='#{size_class}'><a href='/verses?query=#{word}'>" + word + "</a></li>"
    end
    html += "</ul>"
    html
  end

end

module ChaptersHelper

  def excerpt_colors
    [
      'C9FFD0', # green
      'FFE2B3', # orange
      'FFB3B3', # red
      'B5E6FF', # blue
      'FFFC96', # yellow
      'FBD4FF', # pink
      'DFDEFF', # purple
      'A1FDFF', # turquoise
      'DEDEDE'  # gray
    ]
  end

  def excerpt_color(i)
    excerpt_colors[i]
  end

end

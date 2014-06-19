module MicropostsHelper
  # Ex 10.5.6 Making sure very long words don't break out layout
  def wrap(content)
    sanitize(raw(content.split.map{ |s| wrap_long_string(s) }.join(' ')))
  end

  private

    def wrap_long_string(text, max_width = 30)
      # http://en.wikipedia.org/wiki/Zero-width_space
      zero_width_space = '&#8203;'
      regex = /.{1,#{max_width}}/
      if text.length < max_width
        text
      else
        text.scan(regex).join(zero_width_space)
      end
    end
end

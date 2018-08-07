class BasicTest < Girbot::Step
  def action options = {}
    puts options
    goto 'google.com'
    puts browser.title
    screenshot('ending')
  end
end

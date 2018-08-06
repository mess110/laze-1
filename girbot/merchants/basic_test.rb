class BasicTest < Girbot::Step
  def action options = {}
    p 'hello'
    goto 'https://www.google.com/'
    p @browser.title
  end
end

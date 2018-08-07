class BasicTest < Girbot::Step
  def action options = {}
    goto 'google.com'
    $logger.info browser.title
    screenshot('ending')
  end
end

class Sandbox < Girbot::Step
  def action options = {}
    options = {
      details: {
        auth: options[:details][:auth][1]
      }
    }
    validate_auth(options)

    goto 'google.com'
    $logger.info browser.title
    screenshot('ending')

    sleep 100
  end
end

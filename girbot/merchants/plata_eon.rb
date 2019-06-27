class PlataEon < Girbot::Step
  def action options = {}
    auth = validate_auth(options)
    card = validate_card(options)

    # $logger.info "Card valid"

    goto 'https://myline-eon.ro/login'
    # $logger.info "On login page"

    text_in_textfield(auth[:user], id: 'userName')
    text_in_textfield(auth[:pass], id: 'password')
    # $logger.info "User and pass inserted"

    click(:button, type: 'submit')
    # $logger.info "login pressed"

    sleep 5

    amount_to_pay = browser.ps.to_a[1].text.split(' ')[0].to_f
    $logger.info amount_to_pay

    # sleep 1000

    if amount_to_pay != 0
      # goto 'https://myline-eon.ro/facturile-mele'

      browser.buttons.to_a[0].click

      sleep 5

      # require 'pry'; binding.pry
      click(:button, class: 'js-pay-btn')
      click(:button, type: 'submit')

      text_in_textfield(card[:number], id: 'creditcard')
      text_in_textfield(card[:name], id: 'cardnameon')
      text_in_textfield(card[:ccv], id: 'cardsecurecode')
      exec_js("document.querySelector('#cardmonth').value = '#{'%02d' % card[:expMonth]}'")
      exec_js("document.querySelector('#cardyear').value = '#{card[:expYear][2...4]}'")
      click(:input, type: 'submit')

      sleep 5
      if browser.alert.exists?
        browser.alert.ok
      end

      do_sms_validation
    end

    screenshot('eon-end', options[:options][:ui] == true)
  end
end

class PlataEon < Girbot::Step
  def action options = {}
    auth = validate_auth(options)
    card = validate_card(options)

    $logger.info "Card valid"

    goto 'https://myline-eon.ro/login'
    $logger.info "On login page"

    text_in_textfield(auth[:user], id: 'username')
    text_in_textfield(auth[:pass], id: 'password')
    $logger.info "User and pass inserted"

    sleep 1
    click(:button, type: 'submit')
    $logger.info "login pressed"

    # click ok alert
    goto 'https://myline-eon.ro/facturile-mele'
    sleep 1

    raw_label = browser.divs(class: 'price-amount')[0].text
    amount_to_pay = raw_label.split[0].gsub(',', '.').to_f
    $logger.info amount_to_pay

    if amount_to_pay != 0
      click(:button, class: 'js-pay-btn')
      click(:button, type: 'submit')

      text_in_textfield(card[:number], id: 'creditcard')
      text_in_textfield(card[:name], id: 'cardnameon')
      text_in_textfield(card[:ccv], id: 'cardsecurecode')
      select_value('%02d' % card[:expMonth], id: 'cardmonth')
      select_value(card[:expYear][2...4], id: 'cardyear')
      click(:button, type: 'submit')

      sleep 5
      if browser.alert.exists?
        browser.alert.ok
      end

      do_sms_validation
    end

    screenshot('eon-end', options[:options][:ui] == true)
  end
end

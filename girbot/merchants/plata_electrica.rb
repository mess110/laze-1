class PlataElectrica < Girbot::Step
  def action options = {}
    auth = validate_auth(options)
    card = validate_card(options)

    goto 'https://myelectrica.ro/index.php?pagina=login'
    text_in_textfield(auth[:user], id: 'myelectrica_utilizator')
    text_in_textfield(auth[:pass], id: 'myelectrica_pass')
    sleep 1
    click(:button, id: 'myelectrica_login_btn')

    goto 'https://myelectrica.ro/index.php?pagina=plateste-online'
    sleep 1

    # TODO: check this code when a bill exists
    # if browser.div(class: 'alert-info').exists?
      # puts browser.divs(class: 'alert-info')[0].p.text
    # end

    tbody = browser.tbodys[0]
    # if there is more than 1 tr it means we have a bill to pay
    # TODO: get the actual amount to pay
    amount_to_pay = tbody.exists? && tbody.trs.size > 1 ? -1 : 0
    $logger.info amount_to_pay

    if amount_to_pay != 0
      fire_event :checkbox, id: 'myelectrica_checkall'
      click(:button, type: 'submit')
      sleep 1
      click(:button, id: 'requestMobilPay')

      # TODO: print how much we pay

      text_in_textfield(card[:number], id: 'paymentCardNumber')
      text_in_textfield(card[:name], id: 'paymentCardName')
      exec_js("document.getElementById('paymentExpMonth').style.opacity='1';")
      select_value(card[:expMonth], id: 'paymentExpMonth')
      exec_js("document.getElementById('paymentExpYear').style.opacity='1';")
      select_value(card[:expYear], id: 'paymentExpYear')
      text_in_textfield(card[:ccv], id: 'paymentCVV2Number')
      click(:button, type: 'submit')

      do_sms_validation
    end

    screenshot('electrica-end', options[:options][:ui] == true)
  end
end

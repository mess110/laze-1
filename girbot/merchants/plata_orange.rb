class PlataOrange < Girbot::Step
  def action options = {}
    auth = validate_auth(options)
    card = validate_card(options)

    goto 'https://sso.orange.ro/wp/oro?jspname=login.jsp&action=LOGINPAGE_SSO&full_page=true'
    text_in_textfield(auth[:user], id: 'login')
    text_in_textfield(auth[:pass], id: 'password')
    click(:button, type: 'submit')

    goto 'https://www.orange.ro/myaccount/invoice/payment-step-one'

    raw_label = browser.span(:css, '#panelMiddle790 > div.careenvelope1 > div.widthpb.float > div > table > tbody > tr:nth-child(1) > td:nth-child(2) > strong > span').text
    amount_to_pay = raw_label.split[0].gsub(',', '.').to_f
    $logger.info amount_to_pay

    if amount_to_pay != 0
      click(:a, id: 'initializePayment')

      append_to_textfield(card[:number], name: 'ccnumber')
      year_month = '%02d' % card[:expMonth] + card[:expYear]
      append_to_textfield(year_month, name: 'ccexp')
      append_to_textfield(card[:ccv], name: 'cardCvv')
      click(:a, class: 'pay-button')

      do_sms_validation_iframe
    end

    screenshot('orange-end', options[:options][:ui] == true)
  end
end

class PlataEon < Girbot::Step
  def action options = {}
    auth = validate_auth(options)
    card = validate_card(options)

    goto 'https://myline-eon.ro/login'
    text_in_textfield(auth[:user], id: 'username')
    text_in_textfield(auth[:pass], id: 'password')
    sleep 1
    click(:button, type: 'submit')

    # click ok alert
    goto 'https://myline-eon.ro/facturile-mele'
    sleep 1
    click(:button, class: 'js-pay-btn')
    click(:button, type: 'submit')

    text_in_textfield(card[:number], id: 'creditcard')
    text_in_textfield(card[:name], id: 'cardnameon')
    text_in_textfield(card[:ccv], id: 'cardsecurecode')
    select_value('%02d' % card[:expMonth], id: 'cardmonth')
    select_value(card[:expYear][2...4], id: 'cardyear')
    click(:button, type: 'submit')

    do_sms_validation

    screenshot('eon-end')
  end
end

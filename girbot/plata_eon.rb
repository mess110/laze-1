require './utils'

class PlataEon < Girbot::Step
  include Common

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
    wait_forever
  end
end

PlataEon.run(
  headless: false,
  maximize: true,
  browser: Girbot::BrowserHolder.new(:chrome, nil),
  details: {
    auth: Girbot::Step.read('../details.json')[:auth][0],
    card: Girbot::Step.read('../details.json')[:cards][0]
  }
)

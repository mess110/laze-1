require "bundler/setup"
require "girbot"

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
    # fullscreen
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

    auth_code = wait_for_sms
    puts "Received #{auth_code}"
    # NOTE: not tested yet
    append_to_textfield(auth_code, id: 'psw_id')
    click(:input, id: 'btnSubmit')

    loop do
      sleep 30
    end
  end
end

PlataEon.run(
  headless: false,
  browser: Girbot::BrowserHolder.new(:chrome, nil),
  details: {
    auth: Girbot::Step.read('../details.json')[:auth][0],
    card: Girbot::Step.read('../details.json')[:cards][0]
  }
)

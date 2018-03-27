require "bundler/setup"
require "girbot"

class PlataEon < Girbot::Step
  def action options = {}
    validate_auth(options)
    validate_card(options)

    goto 'https://myline-eon.ro/login'
    text_in_textfield(options[:details][:auth][:user], id: 'username')
    text_in_textfield(options[:details][:auth][:pass], id: 'password')
    sleep 1
    click(:button, type: 'submit')

    goto 'https://myline-eon.ro/facturile-mele'
    sleep 1
    click(:button, class: 'js-pay-btn')
    click(:button, type: 'submit')

    text_in_textfield(options[:details][:card][:number], id: 'creditcard')
    text_in_textfield(options[:details][:card][:name], id: 'cardnameon')
    text_in_textfield(options[:details][:card][:ccv], id: 'cardsecurecode')
    select_value('%02d' % options[:details][:card][:expMonth], id: 'cardmonth')
    select_value(options[:details][:card][:expYear][2...4], id: 'cardyear')

    click(:button, type: 'submit')

    auth_code = wait_for_sms
    puts "Received #{auth_code}"
    text_in_textfield(auth_code, id: 'smsCode')
    click(:button, type: 'submit')

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

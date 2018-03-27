require "bundler/setup"
require "girbot"

class PlataEon < Girbot::Step
  def action options = {}
    validate_auth(options)
    validate_card(options)

    goto "TODO: ADD_TEST_FULL_PATH"
    # goto 'https://myline-eon.ro/login'
    text_in_textfield(options[:details][:auth][:user], id: 'username')
    text_in_textfield(options[:details][:auth][:pass], id: 'password')
    # sleep 1
    # click(:button, type: 'submit')

    # goto 'https://myelectrica.ro/index.php?pagina=plateste-online'
    # sleep 1
    # fire id: 'myelectrica_checkall'
    # click(:button, type: 'submit')
    # sleep 1
    # click(:button, id: 'requestMobilPay')

    text_in_textfield(options[:details][:card][:number], id: 'paymentCardNumber')
    text_in_textfield(options[:details][:card][:name], id: 'paymentCardName')
    # browser.execute_script("document.getElementById('paymentExpMonth').style.opacity='1';")
    # select_value(options[:details][:card][:expMonth], id: 'paymentExpMonth')
    # browser.execute_script("document.getElementById('paymentExpYear').style.opacity='1';")
    # select_value(options[:details][:card][:expYear], id: 'paymentExpYear')
    text_in_textfield(options[:details][:card][:ccv], id: 'paymentCVV2Number')

    auth_code = wait_for_sms
    puts "Received authCode: #{auth_code}"
    text_in_textfield(auth_code, id: 'smsCode')

    # click(:button, type: 'submit')

    loop do
      sleep 1
    end
  end
end

PlataEon.run(
  headless: false,
  closeBrowser: false,
  browser: Girbot::BrowserHolder.new(:chrome, nil),
  details: {
    auth: Girbot::Step.read('./test_details.json')[:auth][0],
    card: Girbot::Step.read('./test_details.json')[:cards][0]
  }
)

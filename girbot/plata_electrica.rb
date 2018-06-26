require './utils'

class PlataElectrica < Girbot::Step
  include Common

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
    fire id: 'myelectrica_checkall'
    click(:button, type: 'submit')
    sleep 1
    click(:button, id: 'requestMobilPay')

    text_in_textfield(card[:number], id: 'paymentCardNumber')
    text_in_textfield(card[:name], id: 'paymentCardName')
    exec_js("document.getElementById('paymentExpMonth').style.opacity='1';")
    select_value(card[:expMonth], id: 'paymentExpMonth')
    exec_js("document.getElementById('paymentExpYear').style.opacity='1';")
    select_value(card[:expYear], id: 'paymentExpYear')
    text_in_textfield(card[:ccv], id: 'paymentCVV2Number')
    click(:button, type: 'submit')

    do_sms_validation
    wait_forever
  end
end

PlataElectrica.run(
  headless: false,
  browser: Girbot::BrowserHolder.new(:chrome, nil),
  details: {
    auth: Girbot::Step.read('../details.json')[:auth][1],
    card: Girbot::Step.read('../details.json')[:cards][0]
  }
)

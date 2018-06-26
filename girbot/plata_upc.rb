require './utils'

class PlataUpc < Girbot::Step
  def action options = {}
    auth = validate_auth(options)
    card = validate_card(options)

    goto 'https://my.upc.ro/'
    text_in_textfield(auth[:user], id: 'inputEmail')
    text_in_textfield(auth[:pass], id: 'password')
    click(:button, type: 'submit')

    click(:a, class: 'btn')
    click(:a, class: 'btn-card')
    exec_js("$(\"label[for='nopay']\").click()")
    click(:button, class: 'pay-submit-button')
    browser.windows.last.use

    append_to_textfield(card[:number], id: 'cc_card_number')
    exec_js("$('#cc_expiration_month').css('display', '')")
    select_value('%02d' % card[:expMonth], id: 'cc_expiration_month')
    exec_js("$('#cc_expiration_year').css('display', '')")
    select_value(card[:expYear], id: 'cc_expiration_year')
    text_in_textfield(card[:ccv], id: 'cc_cvv_code')
    text_in_textfield(card[:name], id: 'cc_card_holder')
    click(:button, type: 'submit')

    do_sms_validation
    wait_forever
  end
end

PlataUpc.run(
  headless: false,
  browser: Girbot::BrowserHolder.new(:chrome, nil),
  details: {
    auth: Girbot::Step.read('../details.json')[:auth][3],
    card: Girbot::Step.read('../details.json')[:cards][0]
  }
)

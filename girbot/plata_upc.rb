require "bundler/setup"
require "girbot"

class PlataUpc < Girbot::Step
  def action options = {}
    validate_auth(options)
    validate_card(options)

    goto 'https://my.upc.ro/'
    text_in_textfield(options[:details][:auth][:user], id: 'inputEmail')
    text_in_textfield(options[:details][:auth][:pass], id: 'password')
    click(:button, type: 'submit')

    click(:a, class: 'btn')
    click(:a, class: 'btn-card')

    exec_js("$(\"label[for='nopay']\").click()")
    click(:button, class: 'pay-submit-button')

    browser.windows.last.use

    append_to_textfield(options[:details][:card][:number], id: 'cc_card_number')
    exec_js("$('#cc_expiration_month').css('display', '')")
    select_value('%02d' % options[:details][:card][:expMonth], id: 'cc_expiration_month')
    exec_js("$('#cc_expiration_year').css('display', '')")
    select_value(options[:details][:card][:expYear], id: 'cc_expiration_year')
    text_in_textfield(options[:details][:card][:ccv], id: 'cc_cvv_code')

    text_in_textfield(options[:details][:card][:name], id: 'cc_card_holder')
    click(:button, type: 'submit')

    auth_code = wait_for_sms
    puts "Received #{auth_code}"
    append_to_textfield(auth_code, id: 'psw_id')
    click(:button, id: 'btnSubmit')

    loop do
      sleep 30
    end
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

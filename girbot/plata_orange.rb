require "bundler/setup"
require "girbot"

class PlataOrange < Girbot::Step
  def action options = {}
    validate_auth(options)
    validate_card(options)

    goto "https://sso.orange.ro/wp/oro?jspname=login.jsp&action=LOGINPAGE_SSO&full_page=true"
    text_in_textfield(options[:details][:auth][:user], id: 'login')
    text_in_textfield(options[:details][:auth][:pass], id: 'password')
    click(:button, type: 'submit')

    goto "https://www.orange.ro/myaccount/invoice/payment-step-one"

    loop do
      sleep 1
    end
  end
end

PlataOrange.run(
  headless: false,
  browser: Girbot::BrowserHolder.new(:chrome, nil),
  details: {
    auth: Girbot::Step.read('../details.json')[:auth][2],
    card: Girbot::Step.read('../details.json')[:cards][0]
  }
)

require 'girbot'

switches = ['--headless', '--no-sandbox', '--disable-dev-shm-usage', '--window-size=1400,1400']
$browser = Watir::Browser.new :chrome, options: { args: switches }

class Girbot::Step
  def do_sms_validation
    auth_code = wait_for_sms
    puts "Received #{auth_code}"
    append_to_textfield(auth_code, id: 'psw_id')
    click(:input, id: 'btnSubmit')
    sleep 10
  end
end

module Girbot
  module WatirShortcuts
    def browser
      $browser
    end

    def screenshot(label)
      browser.screenshot.save "screenshots/screenshot-#{label}-#{Time.now.to_i}.png"
    end
  end
end

details = Girbot::Step.read('/app/details.json')

require './merchants/basic_test'
require './merchants/plata_electrica'
require './merchants/plata_eon'
require './merchants/plata_orange'
require './merchants/plata_upc'

# PlataElectrica.new(nil).action(
  # details: {
    # auth: details[:auth][1],
    # card: details[:cards][0]
  # }
# )

BasicTest.new(nil).action()

#!/usr/bin/env ruby

require 'bundler/setup'
require 'girbot'

class Girbot::Step
  def do_sms_validation
    auth_code = wait_for_sms
    puts "Received #{auth_code}"
    append_to_textfield(auth_code, id: 'psw_id')
    click(:input, id: 'btnSubmit')
    sleep 10
  end
end

require './merchants/plata_electrica'
require './merchants/plata_eon'
require './merchants/plata_orange'
require './merchants/plata_upc'
require './merchants/basic_test'

browser = Girbot::BrowserHolder.new(:firefox)
details = Girbot::Step.read('../details.json')

def mk_opts(browser, details, auth, card)
  {
    headless: false,
    maximize: true,
    browser: browser,
    details: {
      auth: details[:auth][auth],
      card: details[:cards][card]
    }
  }
end

[
  { klass: BasicTest, auth: 0, card: 0 },
  # { klass: PlataElectrica, auth: 1, card: 0 },
  # { klass: PlataEon, auth: 0, card: 0 },
  # { klass: PlataOrange, auth: 2, card: 0 },
  # { klass: PlataUpc, auth: 3, card: 0 },
].each do |step|
  begin
    puts "Attempting to pay #{step[:klass]}"
    opts = mk_opts(browser, details, step[:auth], step[:card])
    step[:klass].run(opts)
  rescue Watir::Exception::UnknownObjectException
    puts "No payment was made for #{step[:klass]}"
  end
end

require 'girbot'
require 'optparse'
require 'logger'

$logger = Logger.new(STDOUT)
$allowed_steps = Dir['merchants/*.rb'].collect { |e| e.split('/')[1].split('.')[0] }

def help
  $logger.info <<-EOS

Usage:

  ruby girbot.rb [options]
    -u, --ui          Show UI
    -r, --run=STEP    Which step to run
    -h, --help        Show help

Allowed steps: #{$allowed_steps.join(', ')}

Example usage:

  ruby girbot.rb --run=sandbox
  EOS
end

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: girbot.rb [options]"

  opts.on('-u', '--ui', 'Show UI') do |v|
    options[:ui] = v
  end

  opts.on('-runSTEP', '--run=STEP', 'Run') do |v|
    options[:run] = v
  end

  opts.on('-h', '--help', 'Show help') do |v|
    options[:help] = v
  end
end.parse!

if options[:help]
  help
  exit 1
end


if $allowed_steps.include?(options[:run])
  require "./merchants/#{options[:run]}"
else
  $logger.error 'Step not allowed'
  help
  exit 1
end

switches = ['--headless', '--no-sandbox', '--disable-dev-shm-usage', '--window-size=1400,1400']

switches.delete('--headless') if options[:ui]
$logger.info "Starting chrome with #{switches.join(' ')}"

$browser = Watir::Browser.new :chrome, options: { args: switches }

class Girbot::Step
  def do_sms_validation
    auth_code = wait_for_sms
    $logger.info "Received #{auth_code}"
    append_to_textfield(auth_code, id: 'psw_id')
    click(:input, id: 'btnSubmit')
    sleep 10
  end

  def do_sms_validation_iframe
    auth_code = wait_for_sms
    $logger.info "Received #{auth_code}"
    iframe = browser.iframes[0]
    input = iframe.text_field(id: 'psw_id')
    auth_code.chars.each do |c|
      input.append(c)
    end
    iframe.button(id: 'btnSubmit').click
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

details = Girbot::Step.read('details.json')


case options[:run]
when 'plata_electrica'
  PlataElectrica.new(nil).action(
    details: {
      auth: details[:auth][1],
      card: details[:cards][0]
    }
  )
when 'plata_eon'
  PlataEon.new(nil).action(
    details: {
      auth: details[:auth][0],
      card: details[:cards][0]
    }
  )
when 'plata_orange'
  PlataOrange.new(nil).action(
    details: {
      auth: details[:auth][2],
      card: details[:cards][0]
    }
  )
when 'plata_upc'
  PlataUpc.new(nil).action(
    details: {
      auth: details[:auth][3],
      card: details[:cards][0]
    }
  )
when 'sandbox'
  Sandbox.new(nil).action(
    details: details
  )
else
  $logger.error('unknown step')
end

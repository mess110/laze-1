require 'bundler/setup'
require 'girbot'

module Common
  def do_sms_validation
    auth_code = wait_for_sms
    puts "Received #{auth_code}"
    append_to_textfield(auth_code, id: 'psw_id')
    click(:input, id: 'btnSubmit')
  end

  def wait_forever
    loop do
      sleep 30
    end
  end
end

# works
class PlataUpc < Girbot::Step
  def action options = {}
    auth = validate_auth(options)
    card = validate_card(options)

    goto 'https://my.upc.ro/'
    text_in_textfield(auth[:user], name: 'username')
    text_in_textfield(auth[:pass], name: 'password')
    click(:button, type: 'submit')

    sleep 3

    if browser.p(class: 'invoicelastmonths__status--unpaid').exists?
      raw_label = browser.ps(class: 'invoicelastmonths__status--unpaid')[0].text
      amount_to_pay = raw_label.split[2].to_f
    else
      amount_to_pay = 0
    end
    $logger.info amount_to_pay

    if amount_to_pay != 0
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
    end

    screenshot('upc-end', options[:options][:ui] == true)
  end
end

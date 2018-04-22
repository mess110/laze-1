package ro.northpole.laze

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.provider.Telephony
import android.telephony.SmsMessage
import android.util.Log
import android.widget.Toast


class SmsReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        if (Telephony.Sms.Intents.SMS_RECEIVED_ACTION != intent.action) {
            return
        }

        val bundle = intent.extras ?: return

        try {
            val pdus = bundle.get("pdus") as Array<ByteArray>
            for (i in pdus) {
                val msg: SmsMessage = SmsMessage.createFromPdu(i)

                // TODO: more checks
                if (msg.messageBody.contains("BCR") && msg.messageBody.contains("3-D Secure")) {
                    val words = msg.messageBody.split(' ')
                    val authCode = words[words.size - 1]
                    val endpoint = MainActivity.getGirbotEndpoint(context)
                    val url = endpoint + "sms?authCode=" + authCode

                    Toast.makeText(context, "Forwarding SMS", Toast.LENGTH_LONG).show()
                    SmsProxyTask().execute(url)
                }
            }
        } catch (e: Exception) {
            Log.e(MainActivity.name, e.message)
        }
    }
}

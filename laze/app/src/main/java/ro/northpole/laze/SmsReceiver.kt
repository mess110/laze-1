package ro.northpole.laze

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
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
                val msg: SmsMessage
                msg = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    val format = bundle.getString("format")
                    SmsMessage.createFromPdu(i, format)
                } else {
                    SmsMessage.createFromPdu(i)
                }

                processMessage(msg, context)
            }
        } catch (e: Exception) {
            Log.e(MainActivity.name, e.message)
        }
    }

    private fun processMessage(msg: SmsMessage, context: Context) {
        // TODO: more checks
        // msg.displayOriginatingAddress == "BCR"
        if (msg.messageBody.contains("BCR") && msg.messageBody.contains("3-D Secure")) {
            val words = msg.messageBody.split(' ')
            val authCode = words[words.size - 1]
            val endpoint = MainActivity.getGirbotEndpoint(context)
            val url = endpoint + "sms?authCode=" + authCode

            Toast.makeText(context, "Forwarding SMS", Toast.LENGTH_LONG).show()
            ApiCallTask().execute(url)
        }
    }
}

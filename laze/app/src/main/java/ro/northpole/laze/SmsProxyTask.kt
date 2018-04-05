package ro.northpole.laze

import android.os.AsyncTask
import android.util.Log
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.Response

class SmsProxyTask : AsyncTask<String, Void, String>() {

    override fun doInBackground(vararg uri: String): String? {
        val client = OkHttpClient()
        val url = uri[0]
        Log.d(MainActivity.name, "Calling: $url")
        val request = Request.Builder().url(url).build()
        val response: Response = client.newCall(request).execute()
        return response.body().toString()
    }
}
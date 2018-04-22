package ro.northpole.thegate

import android.Manifest
import android.content.Context
import android.content.SharedPreferences
import android.content.pm.PackageManager
import android.os.Bundle
import android.support.v4.app.ActivityCompat
import android.support.v4.content.ContextCompat
import android.support.v7.app.AppCompatActivity
import android.util.Log
import android.view.View
import android.widget.Button
import android.widget.EditText
import android.widget.TextView
import android.widget.Toast
import java.util.*


class MainActivity : AppCompatActivity() {

    companion object {
        const val name = "the gate"
        private const val mode = 0
        const val workerPrefKey = "workerPrefKey"
        private const val defaultWorkerEndpoint = "http://192.168.0.90:3000/"

        fun getSettings(context: Context): SharedPreferences {
            return context.getSharedPreferences(name, mode)
        }

        fun getWorkerEndpoint(context: Context): String {
            val prefs = getSettings(context)
            return prefs.getString(workerPrefKey, defaultWorkerEndpoint)
        }
    }

    private lateinit var workerEditText: EditText
    private lateinit var progressText: TextView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        checkAndRequestPermissions()

        workerEditText = findViewById(R.id.worker_endpoint)
        workerEditText.setText(getWorkerEndpoint(baseContext))
        progressText = findViewById(R.id.progress)

        val saveButton = findViewById<Button>(R.id.save)
        saveButton.setOnClickListener {
            saveSettings()
        }

        val manualButton = findViewById<Button>(R.id.manual)
        manualButton.setOnClickListener {
            manualToggle()
        }

        android.os.Handler().postDelayed({
            Log.d("tag", "auto closing activity")
            finish()
        }, 30 * 1000)

        manualToggle()
    }

    private fun manualToggle() {
        Timer().scheduleAtFixedRate(object : TimerTask() {
            private var count: Int = 21

            override fun run() {
                runOnUiThread {
                    progressText.text = count.toString()
                    if (count == 0) {
                        progressText.visibility = View.INVISIBLE
                    } else {
                        progressText.visibility = View.VISIBLE
                    }
                }
                count -= 1
                if (count == 0) {
                    cancel()
                }
            }
        }, 0, 1000)


        ApiCallTask().execute(workerEditText.text.toString() + "?press=yes")
    }

    private fun saveSettings() {
        val prefs = getSettings(baseContext)
        val preferenceEditorUnique = prefs.edit()
        preferenceEditorUnique.putString(workerPrefKey, workerEditText.text.toString())
        preferenceEditorUnique.apply()
        Toast.makeText(baseContext, "saved", Toast.LENGTH_LONG).show()
    }

    private fun checkAndRequestPermissions(): Boolean {
        val listPermissionsNeeded = ArrayList<String>()

        val allPermissions = ArrayList<String>()
        allPermissions.add(Manifest.permission.INTERNET)

        allPermissions.forEach { it ->
            if (ContextCompat.checkSelfPermission(this, it) != PackageManager.PERMISSION_GRANTED) {
                listPermissionsNeeded.add(it)
            }
        }

        if (!listPermissionsNeeded.isEmpty()) {
            ActivityCompat.requestPermissions(this, listPermissionsNeeded.toTypedArray(), 1)
            return false
        }
        return true
    }
}

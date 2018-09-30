package ro.northpole.laze

import android.Manifest
import android.content.Context
import android.content.SharedPreferences
import android.content.pm.PackageManager
import android.os.Bundle
import android.support.v4.app.ActivityCompat
import android.support.v4.content.ContextCompat
import android.support.v7.app.AppCompatActivity
import android.widget.Button
import android.widget.EditText
import android.widget.Toast

class GirbotActivity : AppCompatActivity() {


    companion object {
        const val name = "lazy"
        private const val mode = 0
        const val girbotPrefKey = "girbotPrefKey"
        private const val defaultGirbotEndpoint = "http://192.168.0.10:4125/"

        fun getSettings(context: Context): SharedPreferences {
            return context.getSharedPreferences(name, mode)
        }

        fun getGirbotEndpoint(context: Context): String {
            val prefs = getSettings(context)
            return prefs.getString(MainActivity.girbotPrefKey, GirbotActivity.defaultGirbotEndpoint)
        }
    }

    private lateinit var girbotEditText: EditText

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_girbot)
        checkAndRequestPermissions()

        girbotEditText = findViewById(R.id.girbot_endpoint)
        girbotEditText.setText(getGirbotEndpoint(baseContext))

        val saveButton = findViewById<Button>(R.id.save)
        saveButton.setOnClickListener {
            saveSettings()
        }
    }


    private fun saveSettings() {
        val prefs = getSettings(baseContext)
        val preferenceEditorUnique = prefs.edit()
        preferenceEditorUnique.putString(girbotPrefKey, girbotEditText.text.toString())
        preferenceEditorUnique.apply()
        Toast.makeText(baseContext, "saved", Toast.LENGTH_LONG).show()
    }

    private fun checkAndRequestPermissions(): Boolean {
        val listPermissionsNeeded = ArrayList<String>()

        val allPermissions = ArrayList<String>()
        allPermissions.add(Manifest.permission.RECEIVE_SMS)
        allPermissions.add(Manifest.permission.INTERNET)
        //allPermissions.add(Manifest.permission.RECORD_AUDIO)

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

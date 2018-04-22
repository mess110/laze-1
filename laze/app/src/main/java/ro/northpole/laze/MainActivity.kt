package ro.northpole.laze

import android.Manifest
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.content.pm.PackageManager
import android.os.Bundle
import android.speech.RecognizerIntent
import android.speech.SpeechRecognizer
import android.support.v4.app.ActivityCompat
import android.support.v4.content.ContextCompat
import android.support.v7.app.AppCompatActivity
import android.widget.Button
import android.widget.EditText
import android.widget.Spinner
import android.widget.Toast
import com.github.zagum.speechrecognitionview.adapters.RecognitionListenerAdapter


class MainActivity : AppCompatActivity() {

    companion object {
        const val name = "lazy"
        private const val mode = 0
        const val girbotPrefKey = "girbotPrefKey"
        const val workerPrefKey = "workerPrefKey"
        const val radioPrefKey = "radioPrefKey"
        private const val defaultGirbotEndpoint = "http://192.168.0.10:4125/"
        private const val defaultWorkerEndpoint = "http://192.168.0.90:3000/"

        fun getSettings(context: Context): SharedPreferences {
            return context.getSharedPreferences(name, mode)
        }

        fun getWorkerEndpoint(context: Context): String {
            val prefs = getSettings(context)
            return prefs.getString(MainActivity.workerPrefKey, MainActivity.defaultWorkerEndpoint)
        }

        fun getGirbotEndpoint(context: Context): String {
            val prefs = getSettings(context)
            return prefs.getString(MainActivity.girbotPrefKey, MainActivity.defaultGirbotEndpoint)
        }

        fun getDefaultRadio(context: Context): String {
            val prefs = getSettings(context)
            return prefs.getString(MainActivity.radioPrefKey, context.resources.getString(R.string.rockfm))
        }
    }

    private lateinit var girbotEditText: EditText
    private lateinit var workerEditText: EditText

    private lateinit var speechRecognizer: SpeechRecognizer

    private lateinit var radioSpinner: Spinner

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        checkAndRequestPermissions()

        girbotEditText = findViewById(R.id.girbot_endpoint)
        girbotEditText.setText(getGirbotEndpoint(baseContext))

        workerEditText = findViewById(R.id.worker_endpoint)
        workerEditText.setText(getWorkerEndpoint(baseContext))

        radioSpinner = findViewById(R.id.radio_spinner)
        val index = resources.getStringArray(R.array.radios_array).indexOf(getDefaultRadio(baseContext))
        radioSpinner.setSelection(index)

        val saveButton = findViewById<Button>(R.id.save)
        saveButton.setOnClickListener {
            saveSettings()
        }

        val radioButton = findViewById<Button>(R.id.radio)
        radioButton.setOnClickListener {
            startRadio()
        }

        val stopRadioButton = findViewById<Button>(R.id.stop_radio)
        stopRadioButton.setOnClickListener {
            stopRadio()
        }

        speechRecognizer = SpeechRecognizer.createSpeechRecognizer(baseContext)
        speechRecognizer.setRecognitionListener(object : RecognitionListenerAdapter() {
            override fun onResults(results: Bundle?) {
                val matches = results?.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)
                val output = matches!![0].toLowerCase()
                Toast.makeText(baseContext, output, Toast.LENGTH_LONG).show()
                if (output.startsWith("start the radio")) {
                    startRadio()
                }
                if (output.startsWith("stop the radio")) {
                    stopRadio()
                }
                if (output.startsWith("open the gate") || output .startsWith("close the gate")) {
                    openTheGate()
                }
            }
        })

        val voiceButton = findViewById<Button>(R.id.voice)
        voiceButton.setOnClickListener {
            startVoiceRecognitionActivity()
        }

        startVoiceRecognitionActivity()
    }

    private fun stopRadio() {
        ApiCallTask().execute(getWorkerEndpoint(baseContext) + "?kill=mplayer")
    }

    private fun startRadio() {
        val key = radioSpinner.selectedItem.toString()
        val hash = HashMap<String, String>()
        hash["rockfm"] = "http://80.86.106.143:9128/rockfm.aacp"
        hash["rockfm2"] = "http://23.29.71.154:8140/listen.pls?sid=1"
        hash["europafm"] = "http://astreaming.europafm.ro:8000/europafm_mp3_64k"
        hash["nature"] = "http://66.55.145.43:7051/"
        hash["chill"] = "http://77.235.42.90:80/listen.pls?sid=1"
        val url = hash[key]
        ApiCallTask().execute(getWorkerEndpoint(baseContext) + "?radio=yes&volume=95&url=" + url)
    }

    private fun openTheGate() {
        ApiCallTask().execute(getWorkerEndpoint(baseContext) + "?press=yes")
    }

    private fun startVoiceRecognitionActivity() {
        val intent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH)
        intent.putExtra(RecognizerIntent.EXTRA_CALLING_PACKAGE, packageName)
        intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM)
        speechRecognizer.startListening(intent)
    }


    private fun saveSettings() {
        val prefs = getSettings(baseContext)
        val preferenceEditorUnique = prefs.edit()
        preferenceEditorUnique.putString(girbotPrefKey, girbotEditText.text.toString())
        preferenceEditorUnique.putString(workerPrefKey, workerEditText.text.toString())
        preferenceEditorUnique.putString(radioPrefKey, radioSpinner.selectedItem.toString())
        preferenceEditorUnique.apply()
        Toast.makeText(baseContext, "saved", Toast.LENGTH_LONG).show()
    }

    private fun checkAndRequestPermissions(): Boolean {
        val listPermissionsNeeded = ArrayList<String>()

        val allPermissions = ArrayList<String>()
        allPermissions.add(Manifest.permission.RECEIVE_SMS)
        allPermissions.add(Manifest.permission.INTERNET)
        allPermissions.add(Manifest.permission.RECORD_AUDIO)

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

    override fun onDestroy() {
        speechRecognizer.destroy()
        super.onDestroy()
    }

    override fun onPause() {
        //speechRecognizer.destroy()
        super.onPause()
    }

    override fun onResume() {
        startVoiceRecognitionActivity()
        super.onResume()
    }
}

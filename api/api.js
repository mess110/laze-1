const http = require('http')
const url = require('url')
const exec = require('child_process').exec

const port = 3000
const DEFAULT_VOLUME = 50
const DEFAULT_LANG = 'en'
const DEFAULT_FROM = 90
const DEFAULT_TO = 140
const DEFAULT_RADIO = 'http://80.86.106.143:9128/rockfm.aacp'

const execute = (cmd, callback) => {
  const child = exec(cmd, (error, stdout, stderr) => {
    const hash = {
      stdout: stdout,
      stderr: stderr,
      execerr: null
    }
    if (error !== null) {
      hash.execerr = error
    }
    callback(hash)
  })
}

const executeShowResponse = (cmd, response) => {
  execute(cmd, (hash) => {
    response.end(JSON.stringify(hash))
  })
}

const requestHandler = (request, response) => {
  const url_parts = url.parse(request.url, true)
  const query = url_parts.query

  if (query.cmd) {

    executeShowResponse(query.cmd, response)

  } else if (query.say) {

    const lang = query.lang ? query.lang : DEFAULT_LANG
    const volume = query.volume ? query.volume : DEFAULT_VOLUME
    const cmd = __dirname + "/tts " + lang + " " + volume + " \"" + query.say + "\""
    executeShowResponse(cmd, response)

  } else if (query.radio) {

    const url = query.url ? query.url : DEFAULT_RADIO
    // https://www.linuxquestions.org/questions/linux-newbie-8/how-to-run-mplayer-in-background-with-command-line-879090/#post4348528
    const cmd = "killall -9 mplayer || echo 'mplayer was not running.' && mplayer '" + url + "' </dev/null >/dev/null 2>&1 &"
    executeShowResponse(cmd, response)

  } else if (query.kill) {

    const cmd = "killall -9 " + query.kill
    executeShowResponse(cmd, response)

  } else if (query.press) {

    const from = query.from ? query.from : DEFAULT_FROM
    const to = query.to ? query.to : DEFAULT_TO
    const cmd = "cd " + __dirname + " && ./press " + from + " " + to
    executeShowResponse(cmd, response)

  } else {

    response.end(JSON.stringify({
      say: {
        volume: DEFAULT_VOLUME,
        lang: DEFAULT_LANG
      },
      press: {
        from: DEFAULT_FROM,
        to: DEFAULT_TO
      },
      radio: {},
      kill: {},
      cmd: {}
    }))
  }
}

const server = http.createServer(requestHandler)

server.listen(port, (err) => {
  if (err) {
    return console.log('something bad happened', err)
  }

  console.log(`server is listening on ${port}`)
})

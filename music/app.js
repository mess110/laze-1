const http = require('http')
const url = require('url')
const exec = require('child_process').exec

const port = 3000

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

const requestHandler = (request, response) => {
  const url_parts = url.parse(request.url, true)
  const query = url_parts.query
  if (query.cmd) {
    execute(query.cmd, (hash) => {
      response.end(JSON.stringify(hash))
    })
  } else if (query.say) {
    const lang = query.lang ? query.lang : 'en'
    const volume = query.volume ? query.volume : 50
    const cmd = "./tts " + lang + " " + volume + " \"" + query.say + "\""
    execute(cmd, (hash) => {
      response.end(JSON.stringify(hash))
    })
  } else if (query.press) {
    const cmd = "cd ../gate && ./press"
    execute(cmd, (hash) => {
      response.end(JSON.stringify(hash))
    })
  } else {
    response.end(JSON.stringify({
      say: "also takes optional lang and volume params",
      cmd: "executes shell"
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

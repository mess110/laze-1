const http = require('http')
const https = require('https')
const url = require('url')
const exec = require('child_process').exec

const HTTPS = process.env.HTTPS
const KEY_PATH = process.env.KEY_PATH || 'server.key'
const CERT_PATH = process.env.CERT_PATH || 'server.cert'
const PORT = process.env.PORT || 3000
const TOKEN = process.env.TOKEN
if (!process.env.TOKEN) {
  console.error('TOKEN env variable missing')
  process.exit(1)
}
let server

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
  if (request.headers.authorization !== TOKEN) {
    response.writeHead(403)
    response.end(JSON.stringify({error: 'unauthorized', code: 403 }))
    return
  }

  console.log(request.headers)
  // console.log(url_parts)

  if (url_parts.query.cmd) {
    executeShowResponse(url_parts.query.cmd, response)
  } else {
    response.end(JSON.stringify({
      cmd: {
        params: {},
        examples: [
          "/?cmd=whoami"
        ]
      }
    }))
  }
}

if (HTTPS) {
  server = https.createServer({
    key: fs.readFileSync(KEY_PATH),
    cert: fs.readFileSync(CERT_PATH)
  })
} else {
  server = http.createServer()
}

server.addListener("request", requestHandler)
server.listen(PORT, (err) => {
  if (err) {
    return console.error('something bad happened', err)
  }

  console.log(`server is listening on ${PORT}`)
})

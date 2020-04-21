let express = require('express')
let robot = require('robotjs')

let app = express()
let http = require('http').createServer(app)
let io = require('socket.io')(http)

app.use(express.static('public'))

io.on('connection', (socket) => {
  console.log('a user connected')

  socket.on('action', function (data) {
    console.log(data);
    let action = data.type
    switch (action) {
      case 'button':
        robot.keyTap(data.which)
        break
      case 'click':
        if (['up', 'down'].includes(data.direction)) {
          robot.mouseToggle(data.direction)
        }
        break
      case 'mousemove':
        let pos = robot.getMousePos()
        robot.moveMouse(data.dX + pos.x, data.dY + pos.y)
        break
      default:
        console.log(`unkown action ${action}`)
    }
  })
})

const { networkInterfaces } = require('os')
const getLocalExternalIP = () => [].concat(...Object.values(networkInterfaces()))
  .filter(details => details.family === 'IPv4' && !details.internal)
  .pop().address

const port = 3000;

http.listen(port, () => {
  console.log(`Listening *:${port}`)
  console.log(`Web UI: http://${getLocalExternalIP()}:${port}\n`)
})

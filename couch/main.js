let express = require('express')
let robot = require("robotjs")

let app = express()
let http = require('http').createServer(app)
let io = require('socket.io')(http)

app.use(express.static('public'))

io.on('connection', (socket) => {
  console.log('a user connected')

  socket.on('action', function (data) {
    let action = data.type
    switch (action) {
      case 'button':
        console.log(data)
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

http.listen(3000, () => {
  console.log('listening on *:3000')
})

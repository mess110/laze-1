#!/usr/bin/env node

const Board = require("firmata")

const degreesUp = process.argv[2] || 90
const degreesDown = process.argv[3] || 140

if (isNaN(degreesUp)) {
  console.error("error: degreesUp " + degreesUp + " is not a number")
  process.exit(1)
}
if (isNaN(degreesDown)) {
  console.error("error: degreesDown " + degreesDown + " is not a number")
  process.exit(1)
}

const delay = function (fn, amount = 1000) {
  setTimeout(fn, amount)
}

Board.requestPort(function(error, port) {
  if (error) {
    console.error(error)
    return
  }

  const msg =  new Date() + " pressing " + degreesUp + " " + degreesDown
  console.log(msg)

  var board = new Board(port.comName)
  board.on("ready", () => {
    board.pinMode(9, board.MODES.SERVO)
    board.servoWrite(9, degreesUp)
    delay(function () {
      board.servoWrite(9, degreesDown)
      delay(function () {
        board.servoWrite(9, degreesUp)
        delay(function () {
          process.exit()
        })
      }, 500)
    })
  })
})

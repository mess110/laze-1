class Gamepad1ButtonScene extends Scene {
  init(options) {
    let camera = Hodler.get('camera')
    camera.position.set(0, 4, 10)
    camera.lookAt(new THREE.Vector3(0,0,0))

    this.add(new THREE.AmbientLight(0xffffff))

    let text = new BaseText({
      text: 'joystick', fillStyle: 'white',
      strokeStyle: 'black', strokeLineWidth: 1,
      canvasW: 512, canvasH: 512, align: 'center',
      font: '74px luckiest-guy'})
    text.position.set(-2, -0.5, 6)
    text.lookAt(Hodler.get('camera').position)
    this.add(text)

    let text2 = new BaseText({
      text: 'button', fillStyle: 'white',
      strokeStyle: 'black', strokeLineWidth: 1,
      canvasW: 512, canvasH: 512, align: 'center',
      font: '74px luckiest-guy'})
    text2.position.set(2, -0.5, 6)
    text2.lookAt(Hodler.get('camera').position)
    this.add(text2)

    this.addControls()
  }

  uninit(options) {
    this.removeControls()
  }

  removeControls() {
    this.vc.uninit()
  }

  addControls() {
    this.vc = new VirtualController()

    this.vc.joystickLeft.addEventListener('touchStart', function () {
      Hodler.get('scene').isPressed = true
    })

    this.vc.joystickLeft.addEventListener('touchEnd', function () {
      Hodler.get('scene').isPressed = false
    })

    this.vc.joystickRight.addEventListener('touchStart', function () {
      socket.emit('action', { type: 'click', direction: 'down' });
    })

    this.vc.joystickRight.addEventListener('touchEnd', function () {
      socket.emit('action', { type: 'click', direction: 'up' });
    })
  }

  tick(tpf) {
    if (this.isPressed === true) {
      let joystick = this.vc.joystickLeft
      socket.emit('action', {
        type: 'mousemove',
        dX: joystick.deltaX(),
        dY: joystick.deltaY(),
        direction: (joystick.right()? 'right': '') + (joystick.up()? 'up': '') + (joystick.down()? 'down': '') + (joystick.left()? 'left': ''),
      })
    }
  }
}

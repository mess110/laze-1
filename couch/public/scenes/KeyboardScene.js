class KeyboardScene extends BaseScene {
  init(options) {
    super.init(options)

    // this.model = Utils.plane({ map: 'logo.png', width: 6, height: 6 })
    // this.add(this.model)

    let text = new BaseText({
      text: 'keyboard', fillStyle: 'white',
      strokeStyle: 'black', strokeLineWidth: 1,
      canvasW: 512, canvasH: 512, align: 'center',
      font: '74px luckiest-guy'})
    text.position.set(0, 2.5, 6)
    text.lookAt(Hodler.get('camera').position)
    this.add(text)

    let Keyboard = window.SimpleKeyboard.default;

    let myKeyboard = new Keyboard({
      onKeyPress: button => onKeyPress(button),
      theme: "hg-theme-default myTheme1",
      layout: {
        'default': [
          'escape f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12',
          '` 1 2 3 4 5 6 7 8 9 0 - = backspace',
          'tab q w e r t y u i o p [ ] \\',
          'enter a s d f g h j k l ; \' enter',
          'shift z x c v b n m , . / right_shift',
          'ctrl alt space up down left right'
        ]
      }
    });

    function onChange(input) {
      console.log("Input changed", input);
    }

    function onKeyPress(button) {
      socket.emit('action', { type: 'button', which: button });
    }
    this.keyboard = myKeyboard
  }

  uninit(options) {
    this.keyboard.destroy()
  }
}

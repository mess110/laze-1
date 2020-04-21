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
    text.position.set(0, -0.5, 6)
    text.lookAt(Hodler.get('camera').position)
    this.add(text)
  }

  uninit(options) {
  }
}

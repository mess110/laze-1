class BaseScene extends Scene {
  init(options) {
    document.querySelector('.controls').style.display = 'block'

    let camera = Hodler.get('camera')
    camera.position.set(0, 4, 10)
    camera.lookAt(new THREE.Vector3(0,0,0))

    // this.add(new THREE.AmbientLight(0xffffff))
  }

  doMouseEvent(event, raycaster) {
    if (event.type === 'mouseup') {
      let isCorner = event.clientX < 30 && event.clientY < 30
      if (isCorner) {
        nextScene();
      }
    }
  }
}

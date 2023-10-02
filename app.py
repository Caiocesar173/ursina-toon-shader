from ursina import Ursina
from ursina.window import Window
from scenes.initial_scene import InitialScene

window = Window.main_monitor = type(
    'obj',
    (object,),
    {'x': 0, 'y': 0, 'width': 1280, 'height': 720},

)

window.vsync = False
window.borderless = False

app = Ursina(
    size=(1280, 720),
    title="test-app",
    editor_ui_enabled=True,
    show_ursina_splash=True,
    development_mode=True,
)

InitialScene()
app.run()

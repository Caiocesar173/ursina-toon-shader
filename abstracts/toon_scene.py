from ursina import Shader, AmbientLight, color, EditorCamera
from abstracts.game_object import GameObject
from materials.prototype import PrototypeDarkMaterial
from shaders.toon_shader import ToonShader

class ToonScene(GameObject):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)

        self.name = kwargs.get('name', self.__class__.__name__.lower())

        self.setup_camera()
        self.setup_light()
        self.setup_floor()
        self.shader = ToonShader(scene=self)

    def setup_camera(self):
        """Configurações da câmera comum."""
        self.camera = EditorCamera()

    def setup_light(self):
        """Configurações de luz."""
        self.light = AmbientLight(color=color.white, intensity=0.1)

    def setup_floor(self):
        """Configurações do chão."""
        self.floor = GameObject(
            model='plane',
            scale=(100, 1, 100),
            material=PrototypeDarkMaterial(),
            collider='box'
        )

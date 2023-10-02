from ursina import Shader, AmbientLight, color, EditorCamera
from abstracts.game_object import GameObject
from materials.prototype import PrototypeDarkMaterial

class Scene(GameObject):
    def __init__(self, name=None, shader_path='shaders/basic_shader', **kwargs):
        super().__init__(**kwargs)

        self.name = name if name else self.__class__.__name__.lower()
        self.shader = self.load_shader(shader_path)

        self.setup_camera()
        self.setup_light()
        self.setup_floor()

    def load_shader(self, shader_path):
        """Carrega o shader básico."""
        return Shader(language=Shader.GLSL, path=shader_path)

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

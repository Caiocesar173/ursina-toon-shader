from ursina import AmbientLight, color, EditorCamera, raycast
from abstracts.game_object import GameObject
from abstracts.scene import Scene
from materials.prototype import PrototypeDarkMaterial
from shaders.toon_shader import ToonShader

from math import tan, radians
from panda3d.core import LVector4f


class ToonScene(Scene):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.name = kwargs.get('name', self.__class__.__name__.lower())

    def load_shader(self):
        self.shader = ToonShader(scene=self)

    def update(self):
        super().update()
        self.shader.scene = self
        self.shader.update()

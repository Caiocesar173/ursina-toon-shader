from math import tan, radians
from ursina import Shader, Vec3, Vec4
from panda3d.core import PerspectiveLens


class CelShader(Shader):
    name = "toon_shader"
    language = Shader.GLSL
    vertex = '/shaders/celShader/celShader_vertex.glsl'
    fragment = '/shaders/celShader/celShader_fragment.glsl'
    geometry = ''
    scene = None
    current_object = None

    def __init__(self, **kwargs):
        self.language = kwargs.get('language', self.language)
        self.scene = kwargs.get('scene', self.scene)

        # self.update()

        super().__init__(
            self.name,
            self.language,
            self.vertex,
            self.fragment,
            self.geometry,
            **kwargs
        )

        self.scene.shader = self

    def update(self):
        pass

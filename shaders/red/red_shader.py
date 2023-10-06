from ursina import Shader
from panda3d.core import Shader as Panda3dShader

class RedShader:
    name = "red_shader"
    language = Shader.GLSL
    vertex = 'shaders/red/red_shader_vertex.glsl'
    fragment = 'shaders/red/red_shader_fragment.glsl'
    geometry = ''

    def load_shader(self, shader_path):
        with open(shader_path, 'r') as f:
            return f.read()

    def __init__(self, *args, **kwargs):
        vertex = self.load_shader(self.vertex)
        fragment = self.load_shader(self.fragment)

        self.shader = Shader(
            self.name,
            self.language,
            vertex,
            fragment,
        )

        # self.compile()

    def compile(self):
        self.compiled_shader = Panda3dShader.make(self.language, self.vertex, self.fragment, self.geometry)

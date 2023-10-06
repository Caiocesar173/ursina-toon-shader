from ursina import Shader, Mat4

class SkyBoxShader:
    name = "skybox_shader"
    language = Shader.GLSL
    vertex = 'shaders/skybox/skybox_shader_vertex.glsl'
    fragment = 'shaders/skybox/skybox_shader_fragment.glsl'
    geometry = ''
    current_object = None
    skybox = None

    sunY = 0

    def load_shader(self, shader_path):
        with open(shader_path, 'r') as f:
            return f.read()

    def __init__(self, *args, **kwargs):
        vertex = self.load_shader(self.vertex)
        fragment = self.load_shader(self.fragment)

        self.shader = Shader(
            self.name,
            Shader.GLSL,
            vertex,
            fragment,
        )

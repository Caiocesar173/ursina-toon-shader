from ursina import Shader, Vec4


class SkyBoxShader(Shader):
    name = "toon_shader"
    language = Shader.GLSL
    vertex = 'shaders/skybox/skybox_shader_vertex.glsl'
    fragment = 'shaders/skybox/skybox_shader_fragment.glsl'
    geometry = ''
    current_object = None
    scene = None

    sunY = 0
    view = Vec4(0, 0, 0, 0)
    projection = Vec4(0, 0, 0, 0)

    def load_shader(self, shader_path):
        with open(shader_path, 'r') as f:
            return f.read()

    def __init__(self, *args, **kwargs):
        vertex = self.load_shader(self.vertex)
        fragment = self.load_shader(self.fragment)
        self.skybox = kwargs.get('skybox', self.scene)

        self.skybox.set_shader_input("view", self.view)
        self.skybox.set_shader_input('sunY', self.sunY)
        self.skybox.set_shader_input("projection", self.projection)

        super().__init__(
            self.name,
            self.language,
            vertex,
            fragment,
            self.geometry,
            **kwargs
        )

    def update(self):
        pass

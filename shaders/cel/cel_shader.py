from ursina import Shader, Vec4, Vec3


class CelShader(Shader):
    name = "cel_shader"
    language = Shader.GLSL
    vertex = 'shaders/cel/celShader_vertex.glsl'
    fragment = 'shaders/cel/celShader_fragment.glsl'
    geometry = ''
    current_object = None
    reference_obj = None

    view = Vec4(0, 0, 0, 0)
    light_position = Vec3(0, 0, 0)
    projection = Vec4(0, 0, 0, 0)

    def load_shader(self, shader_path):
        with open(shader_path, 'r') as f:
            return f.read()

    def __init__(self, *args, **kwargs):
        vertex = self.load_shader(self.vertex)
        fragment = self.load_shader(self.fragment)
        self.reference_obj = kwargs.get('reference_obj', self.reference_obj)

        if(self.reference_obj):
            self.reference_obj.shader = self
            self.reference_obj.set_shader_input("view", self.view)
            self.reference_obj.set_shader_input("projection", self.projection)
            self.reference_obj.set_shader_input('light_position', self.light_position)

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

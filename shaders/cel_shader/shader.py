from ursina import Shader


class CelShader(Shader):
    name = "toon_shader"
    language = Shader.GLSL
    vertex = '/shaders/celShader/celShader_vertex.glsl'
    fragment = '/shaders/celShader/celShader_fragment.glsl'
    geometry = ''
    current_object = None
    scene = None

    def __init__(self, *args, **kwargs):
        super().__init__(
            self.name,
            self.language,
            self.vertex,
            self.fragment,
            self.geometry,
            **kwargs
        )

    def update(self):
        pass

from abstracts.material import Material

class PrototypeDarkMaterial(Material):
    texture_scale = .2

    def __init__(self, variation=1, **kwargs):
        self.texture = f"textures/prototype/dark/texture_{str(variation).zfill(2)}.png"
        super().__init__(**kwargs)

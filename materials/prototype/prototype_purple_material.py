from abstracts.material import Material


class PrototypePurpleMaterial(Material):
    def __init__(self, variation=13, **kwargs):
        self.texture = f"textures/prototype/purple/texture_{str(variation).zfill(2)}.png"
        super().__init__(**kwargs)

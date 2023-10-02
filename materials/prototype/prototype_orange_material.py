from abstracts.material import Material


class PrototypeOrangeMaterial(Material):
    def __init__(self, variation=13, **kwargs):
        self.texture = f"textures/prototype/orange/texture_{str(variation).zfill(2)}.png"
        super().__init__(**kwargs)

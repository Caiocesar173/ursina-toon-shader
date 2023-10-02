from abstracts.material import Material


class PrototypeGreenMaterial(Material):
    def __init__(self, variation=13, **kwargs):
        super().__init__(**kwargs)
        self.texture = f"textures/prototype/green/texture_{str(variation).zfill(2)}.png"

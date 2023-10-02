from ursina import Entity
from abstracts.material import Material


class GameObject(Entity):
    material = None

    def __init__(self, **kwargs):
        super().__init__(**kwargs)

        self.shader = kwargs.get('shader', self.shader)
        self.material = kwargs.get('material', self.material)

        if self.material:
            if not isinstance(self.material, Material):
                raise TypeError("O material deve ser uma instância da classe Material.")

            self.material.apply(self)

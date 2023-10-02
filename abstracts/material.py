import re
from ursina import Entity, Vec2


class Material:
    name = ""
    texture = None
    texture_scale = Vec2(1, 1)
    shader = 'shaders/basic_shader'

    def __init__(self, **kwargs):
        self.texture = kwargs.get('texture', self.texture)
        self.shader = kwargs.get('shader', self.shader)
        self.texture_scale = kwargs.get('texture_scale', self.texture_scale)
        self.get_material_name()

    def apply(self, entity: Entity):
        for key, value in vars(self).items():
            if not hasattr(entity, key) or getattr(entity, key) is None:
                setattr(entity, key, value)

        if hasattr(entity, 'scale') and self.texture_scale is not None:
            entity_scale = entity.scale[0]
            texture_scale = entity_scale * self.texture_scale
            entity.texture_scale = (texture_scale, texture_scale)

        return entity

    def get_material_name(self):
        class_name = self.__class__.__name__
        material_name = '_'.join(
            [word.lower() for word in re.findall('[A-Z][^A-Z]*', class_name)])
        self.name = f"{material_name}_texture"

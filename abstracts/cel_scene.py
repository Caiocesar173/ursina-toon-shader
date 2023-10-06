from ursina import PointLight, color

from prefabs.sun import SunLight
from shaders.cel.cel_shader import CelShader
from abstracts.scene import Scene, GameObject
from materials.prototype import PrototypeOrangeMaterial


class CelScene(Scene):
    initial_light_intensity = .5

    def __init__(self, **kwargs):
        self.define_scene()
        super().__init__(**kwargs)

    def define_scene(self):
        cube = GameObject(
            parent=self,
            model='cube',
            collider='box',
            scale=(1, 1, 1),
            position=(2, 1, 1),
            material=PrototypeOrangeMaterial(),
        )

        cube.shader = CelShader(scene=cube),

    def load_shader(self):
        return CelShader(scene=self)

    def setup_light(self):
        """Configurações de luz."""
        self.sun = SunLight(parent=self, skybox=self.skybox)
        self.point_light1 = PointLight(
            parent=self,
            position=(10, 15, -10),
            color=color.white * self.initial_light_intensity
        )
        self.point_light2 = PointLight(
            parent=self,
            position=(-10, -5, 10),
            color=color.white * self.initial_light_intensity
        )
        self.point_light3 = PointLight(
            parent=self,
            position=(10, -5, 10),
            color=color.white * self.initial_light_intensity
        )
        self.point_light4 = PointLight(
            parent=self,
            position=(-10, 15, -10),
            color=color.white * self.initial_light_intensity
        )

    def update(self):
        super().update()
        self.update_lights()

    def update_lights(self):
        self.point_light1.intensity = 0.5 * self.sun.intensity_factor
        self.point_light2.intensity = 0.5 * self.sun.intensity_factor
        self.point_light3.intensity = 0.5 * self.sun.intensity_factor
        self.point_light4.intensity = 0.5 * self.sun.intensity_factor

        self.skybox.set_shader_input('sunPosition', self.sun.position)

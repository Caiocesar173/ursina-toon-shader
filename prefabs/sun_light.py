from ursina import DirectionalLight, time, color
from abstracts.game_object import GameObject
from math import sin, cos, radians

class SunLight(DirectionalLight):

    name = 'sun_gameobject'
    skybox = None
    sun_reference = GameObject()
    sun_angle = 0
    light_angle = 0
    intensity_factor = 0
    min_intensity_factor = 0.3
    sun_color = color.white * 100

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.skybox = kwargs.get('skybox', self.skybox)
        self.color = self.sun_color

    def update(self):
        # Incrementa o ângulo
        self.sun_angle += time.dt * 10
        self.sun_angle %= 360

        # Rotaciona em torno do eixo Y (vertical)
        y = 0
        x = sin(radians(self.sun_angle)) * self.skybox.y / 2
        z = cos(radians(self.sun_angle)) * self.skybox.z / 2

        self.position = (x, y, z)
        self.look_at(self.sun_reference.position)

        if self.y > 0:  # durante o dia
            # self.skybox.z metade da altura da elipse
            self.intensity_factor = self.y / self.skybox.x
        else:  # durante a noite
            self.intensity_factor = self.min_intensity_factor

import time
from math import sin, cos, radians
from ursina import DirectionalLight, color
from abstracts.game_object import GameObject


class SunLight(GameObject):
    name = 'sun_gameobject'

    skybox = None
    sun_reference = GameObject()

    light = None
    sun_angle = 0
    light_angle = 0
    intensity_factor = 0
    min_intensity_factor = 0.3
    color = color.white * 100

    def __init__(self,  **kwargs):
        super().__init__(**kwargs)
        self.skybox = kwargs.get('skybox', self.skybox)
        self.setup_sun()

    def setup_sun(self):
        self.light = DirectionalLight(color=self.color)

    def update(self):
        # Incrementa o ângulo
        self.light_angle += time.dt * 800
        self.sun_angle %= 360

        # Movimento elíptico
        y = self.light.position.y / self.skybox.x
        z = sin(radians(self.sun_angle)) * self.skybox.z / 2
        x = cos(radians(self.sun_angle)) * self.skybox.x / 2

        self.light.position = (x, y, z)
        # Faz a luz apontar para o ponto de referência
        self.light.look_at(self.sun_reference.position)

        if self.light.y > 0:  # durante o dia
            # self.skybox.z metade da altura da elipse
            self.intensity_factor = self.light.y / self.skybox.z
        else:  # durante a noite
            self.intensity_factor = self.min_intensity_factor

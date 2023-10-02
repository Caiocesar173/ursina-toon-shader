from ursina import *
from ursina.prefabs.first_person_controller import FirstPersonController

from abstracts import GameObject, ToonScene
from materials.prototype import PrototypeOrangeMaterial


class InitialScene(ToonScene):
    def __init__(self, **kwargs):
        super().__init__()

        GameObject(
            model='cube',
            collider='box',
            scale=(1, 1, 1),
            position=(0, 1, 0),
            material=PrototypeOrangeMaterial(),
        )

    def setup_camera(self):
        self.camera = FirstPersonController()

from ursina import *
from ursina.prefabs.first_person_controller import FirstPersonController

from abstracts import GameObject, CelScene
from materials.prototype import PrototypeOrangeMaterial, PrototypeGreenMaterial

from shaders.red.red_shader import RedShader
from ursina.shaders import normals_shader

from panda3d.core import Shader as Panda3dShader

class InitialScene(CelScene):
    def __init__(self, **kwargs):
        super().__init__()

        GameObject(
            model='cube',
            collider='box',
            scale=(1, 1, 1),
            position=(2, 1, 0),
            material=PrototypeOrangeMaterial(),
        )

        GameObject(
            model='sphere',
            collider='box',
            scale=(1, 1, 1),
            position=(4, 1, 4),
            material=PrototypeOrangeMaterial(),
        )

    def setup_camera(self):
        self.camera = EditorCamera()
        # camera.shader = ToonShader().shader

from ursina import *
from ursina.prefabs.first_person_controller import FirstPersonController

from abstracts import GameObject, CelScene
from materials.prototype import PrototypeOrangeMaterial, PrototypeGreenMaterial

from shaders.red.red_shader import RedShader
from ursina.shaders import normals_shader


class InitialScene(CelScene):
    vertex = '''
       #version 140
        uniform mat4 p3d_ModelViewProjectionMatrix;
        uniform mat4 p3d_ModelMatrix;
        in vec4 p3d_Vertex;
        in vec3 p3d_Normal;
        out vec3 world_normal;

        void main() {
            gl_Position = p3d_ModelViewProjectionMatrix * p3d_Vertex;
        }
    '''

    fragment = '''
        #version 330 core

        out vec4 FragColor;
        void main() {
            FragColor = vec4(1.0, 0.0, 0.0, 1.0);  // cor vermelha
        }
    '''


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

        instance = Shader(language=Shader.GLSL, vertex=self.vertex, fragment=self.fragment)
        cubeee = GameObject(model='cube', texture='', position=(-5, 1, 2), shader=instance)
        cubeee = GameObject(model='cube', position=(-7, 1, 2), shader=RedShader().shader)
        self.e = GameObject(model='cube', texture='perlin_noise', position=(-3, 1, 2), shader=normals_shader  )

    def setup_camera(self):
        self.camera = FirstPersonController()

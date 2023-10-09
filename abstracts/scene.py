from panda3d.core import LineSegs, NodePath
from ursina import Shader, AmbientLight, EditorCamera, color, raycast, Vec3

from abstracts.game_object import GameObject
from materials.prototype import PrototypeDarkMaterial
from shaders.skybox.skybox_shader import SkyBoxShader


def draw_line(start, end, color=(1, 0, 0, 1)):
    lines = LineSegs()
    lines.set_color(color)
    lines.move_to(start)
    lines.draw_to(end)
    node = lines.create()
    return NodePath(node)


class Scene(GameObject):
    skybox = None
    looking_at = None
    view_matrix = None
    projection_matrix = None

    def __init__(self, name=None, **kwargs):
        super().__init__(**kwargs)

        self.name = name if name else self.__class__.__name__.lower()

        self.load_shader()
        self.setup_camera()
        self.setup_skybox()
        self.setup_light()
        self.setup_floor()

    def load_shader(self):
        """Carrega o shader básico."""
        return Shader()

    def setup_camera(self):
        """Configurações da câmera comum."""
        self.camera = EditorCamera()

    def setup_light(self):
        """Configurações de luz."""
        self.light = AmbientLight(color=color.white, intensity=0.1)

    def setup_floor(self):
        """Configurações do chão."""
        self.floor = GameObject(
            model='plane',
            scale=(100, 1, 100),
            material=PrototypeDarkMaterial(),
            collider='box'
        )

    def setup_skybox(self):
        self.skybox = GameObject(
            parent=self,
            model="sky_dome",
            scale=100,
            position=(5, 1, 5),
            # double_sided=True,
            # eternally_moving=True,
            shader=SkyBoxShader().shader
        )

    def update_looking_at(self):
        """Atualizar a posição e a direção do raio para coincidir com a câmera."""
        hit_info = raycast(
            origin=self.camera.position,
            direction=self.camera.forward,
            distance=100,
            ignore=[self.camera, self.floor]
        )

        if hit_info.hit:
            line = draw_line(self.camera.position, hit_info.world_point)
            self.looking_at = hit_info.entity
            line.reparent_to(self)

            if (hasattr(self.shader, 'current_object')):
                self.shader.current_object = hit_info.entity

    def update(self):
        self.projection_matrix = base.cam.node().get_lens().get_projection_mat()
        self.view_matrix = base.cam.node().get_lens().get_view_mat()

        self.update_looking_at()

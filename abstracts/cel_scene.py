from ursina import AmbientLight, color, EditorCamera, raycast
from abstracts.game_object import GameObject
from materials.prototype import PrototypeDarkMaterial
from shaders.cel_shader.shader import CelShader


class CelScene(GameObject):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)

        self.name = kwargs.get('name', self.__class__.__name__.lower())

        self.setup_camera()
        self.setup_light()
        self.setup_floor()
        self.shader = CelShader(scene=self)

    def update(self):
        self.update_ray()
        # self.shader.scene = self
        # self.shader.update()

    def setup_camera(self):
        """Configurações da câmera comum."""
        self.camera = EditorCamera()

    def setup_light(self):
        """Configurações de luz."""
        self.light = AmbientLight(
            parent=self, color=color.white, intensity=0.1)

    def setup_floor(self):
        """Configurações do chão."""
        self.floor = GameObject(
            model='plane',
            scale=(100, 1, 100),
            material=PrototypeDarkMaterial(),
            collider='box'
        )

    def update_ray(self):
        """Atualizar a posição e a direção do raio para coincidir com a câmera."""
        hit_info = raycast(origin=self.camera.position,
                           direction=self.camera.forward, distance=100, ignore=[self.camera, ])
        if hit_info.hit:
            self.shader.current_object = hit_info.entity

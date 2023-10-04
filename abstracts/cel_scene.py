from ursina import AmbientLight, PointLight, color, raycast, Shader
from abstracts.scene import Scene
from shaders.cel_shader.shader import CelShader


class CelScene(Scene):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.shader = CelShader()
        self.shader.scene = self

        if(self.shader):
            base.camera.setShader(self.shader._shader)

    def update(self):
        self.update_ray()

    def setup_light(self):
        """Configurações de luz."""
        self.ambient_light = AmbientLight(parent=self, color=color.white * 0.6)

        # Adicionando quatro luzes pontuais
        self.point_light1 = PointLight(
            parent=self,
            position=(10, 15, -10),
            color=color.white * 0.6
        )
        self.point_light2 = PointLight(
            parent=self,
            position=(-10, -5, 10),
            color=color.white * 0.6
        )  # Luz azulada
        self.point_light3 = PointLight(
            parent=self,
            position=(10, -5, 10),
            color=color.white * 0.6
        )    # Luz avermelhada
        self.point_light4 = PointLight(
            parent=self,
            position=(-10, 15, -10),
            color=color.white * 0.6
        ) # Luz esverdeada


    def update_ray(self):
        """Atualizar a posição e a direção do raio para coincidir com a câmera."""
        hit_info = raycast(
            origin=self.camera.position,
            direction=self.camera.forward,
            distance=100,
            ignore=[self.camera, ]
        )

        if hit_info.hit:
            self.shader.current_object = hit_info.entity

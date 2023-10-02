from math import tan, radians
from ursina import scene, Shader, camera
from ursina.camera import Camera
from panda3d.core import PerspectiveLens


class ToonShader(Shader):
    name = "toon_shader"
    language = Shader.GLSL
    vertex = None
    fragment = None
    geometry = None
    scene = None

    def __init__(self, **kwargs):
        self.language = kwargs.get('language', self.language)
        self.scene = kwargs.get('scene', self.scene)

        self.setup_shader()

        super().__init__(
            self.name,
            self.language,
            self.vertex,
            self.fragment,
            self.geometry,
            **kwargs
        )

    def setup_shader(self):
        if (not isinstance(self.camera, Camera)):
            raise ValueError(
                "camera precisa ser uma instancia de ursina.camera")

        lens = base.cam.node().get_lens()

        # Calculando o equivalente a unity_CameraProjection._m11
        fov = lens.get_fov()
        fov_horizontal = fov[0]
        m11 = 1 / tan(radians(fov_horizontal) / 2)

        # Calculando o equivalente a unity_OrthoParams.w
        if isinstance(lens, PerspectiveLens):
            ortho_w = 0
        else:
            ortho_w = lens.get_film_size()[1] / 2

        # Configurando as variáveis uniformes para o shader
        self.scene.shader = self
        self.scene.set_shader_input("panda3D_m11", m11)
        self.scene.set_shader_input("panda3D_ortho_w", ortho_w)

        # Substitua esses valores pelos valores reais ou cálculos
        _IndirectLightMinColor = [0.2, 0.2, 0.2]
        _CelShadeMidPoint = 0.5
        _CelShadeSoftness = 0.1
        _ReceiveShadowMappingAmount = 0.8
        _ShadowMapColor = [0.1, 0.1, 0.1]
        _EmissionMulByBaseColor = 0.5
        _IsFace = True

        # Configurando as variáveis uniformes para o shader
        self.scene.set_shader_input("IndirectLightMinColor", _IndirectLightMinColor)
        self.scene.set_shader_input("CelShadeMidPoint", _CelShadeMidPoint)
        self.scene.set_shader_input("CelShadeSoftness", _CelShadeSoftness)
        self.scene.set_shader_input("ReceiveShadowMappingAmount", _ReceiveShadowMappingAmount)
        self.scene.set_shader_input("ShadowMapColor", _ShadowMapColor)
        self.scene.set_shader_input("EmissionMulByBaseColor", _EmissionMulByBaseColor)
        self.scene.set_shader_input("IsFace", _IsFace)

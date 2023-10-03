from math import tan, radians

from ursina import Shader, Vec3, Vec4
from panda3d.core import LVector4f
from panda3d.core import PerspectiveLens


class ToonShader(Shader):
    name = "toon_shader"
    language = Shader.GLSL
    vertex = None
    fragment = None
    geometry = None
    scene = None
    current_object = None

    def __init__(self, **kwargs):
        self.language = kwargs.get('language', self.language)
        self.scene = kwargs.get('scene', self.scene)

        self.update()

        super().__init__(
            self.name,
            self.language,
            self.vertex,
            self.fragment,
            self.geometry,
            **kwargs
        )

        self.scene.shader = self

    def update(self):
        camera_pos = base.camera.get_pos()
        lens = base.cam.node().get_lens()

        # Calculando o equivalente a unity_CameraProjection._m11
        fov = lens.get_fov()
        fov_vertical = fov[1]
        fov_horizontal = fov[0]
        m11 = 1 / tan(radians(fov_horizontal) / 2)

        # Calculando o equivalente a unity_OrthoParams.w
        if isinstance(lens, PerspectiveLens):
            ortho_w = 0
        else:
            ortho_w = lens.get_film_size()[1] / 2

        # Para panda3D_m11 & panda3D_ortho_w
        self.scene.set_shader_input("panda3D_m11", m11)
        self.scene.set_shader_input("panda3D_ortho_w", ortho_w)

        # Para panda3D_ProjectionParams
        if(self.current_object):
            distance = (camera_pos - self.current_object.get_pos()).length()
            z_value = 1 / tan(radians(fov_vertical / 2)) * distance
            projection_params = Vec4(0, 0, z_value, 0)
            self.scene.set_shader_input("panda3D_ProjectionParams", projection_params)

        # Para panda3D_MATRIX_P
        matrix_p = lens.get_projection_mat()
        self.scene.set_shader_input("panda3D_MATRIX_P", matrix_p)

        self.scene.set_shader_input('p3d_LightColor', Vec3(1.0, 1.0, 1.0))
        self.scene.set_shader_input('p3d_LightDirection', Vec3(0.0, 0.0, -1.0))
        self.scene.set_shader_input('p3d_ColorScale', Vec4(1.0, 1.0, 1.0, 1.0))
        self.scene.set_shader_input('p3d_AmbientLight', Vec3(0.2, 0.2, 0.2))

        self.scene.set_shader_input('_EmissionMulByBaseColor', 1.0)
        self.scene.set_shader_input('_IndirectLightMinColor', Vec3(1.0, 1.0, 1.0))
        self.scene.set_shader_input('_CelShadeMidPoint', 0.5)
        self.scene.set_shader_input('_CelShadeSoftness', 0.1)
        self.scene.set_shader_input('_ReceiveShadowMappingAmount', 0.8)
        self.scene.set_shader_input('_ShadowMapColor', Vec3(0.2, 0.2, 0.2))
        self.scene.set_shader_input('_ShadowMapColor', Vec3(0.2, 0.2, 0.2))
        self.scene.set_shader_input('_IsFace', True)


        # print('#'*20)
        # print('self.scene.light')
        # print(self.scene.light)
        # print('#'*20)

        # self.scene.set_shader_input("DirectionalLightDirection", self.scene.light.direction)
        # self.scene.set_shader_input("DirectionalLightColor", self.scene.light.color)

        # Substitua esses valores pelos valores reais ou cálculos
        # _IndirectLightMinColor = [0.2, 0.2, 0.2]
        # _CelShadeMidPoint = 0.5
        # _CelShadeSoftness = 0.1
        # _ReceiveShadowMappingAmount = 0.8
        # _ShadowMapColor = [0.1, 0.1, 0.1]
        # _EmissionMulByBaseColor = 0.5
        # _IsFace = True

        # # Configurando as variáveis uniformes para o shader
        # self.scene.set_shader_input("IndirectLightMinColor", _IndirectLightMinColor)
        # self.scene.set_shader_input("CelShadeMidPoint", _CelShadeMidPoint)
        # self.scene.set_shader_input("CelShadeSoftness", _CelShadeSoftness)
        # self.scene.set_shader_input("ReceiveShadowMappingAmount", _ReceiveShadowMappingAmount)
        # self.scene.set_shader_input("ShadowMapColor", _ShadowMapColor)
        # self.scene.set_shader_input("EmissionMulByBaseColor", _EmissionMulByBaseColor)
        # self.scene.set_shader_input("IsFace", _IsFace)

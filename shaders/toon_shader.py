from math import tan, radians
from ursina import Shader, Vec3, Vec4
from panda3d.core import PerspectiveLens


class ToonShader(Shader):
    name = "toon_shader"
    language = Shader.GLSL
    vertex = '/shaders/celShader/celShader_vertex.glsl'
    fragment = '/shaders/celShader/celShader_fragment.glsl'
    geometry = ''
    scene = None
    current_object = None

    def __init__(self, **kwargs):
        self.language = kwargs.get('language', self.language)
        self.scene = kwargs.get('scene', self.scene)

        # self.update()

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

        self.scene.set_shader_input("u_fov", fov_horizontal)

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

        # General Variables
        modelMatrix = None
        viewMatrix = None
        projectionMatrix = None

        self.scene.set_shader_input('modelMatrix', modelMatrix)
        self.scene.set_shader_input('viewMatrix', viewMatrix)
        self.scene.set_shader_input('projectionMatrix', projectionMatrix)

        # fog
        fogStart = 10.0
        fogEnd = 50.0
        fogColor = Vec3(1.0, 1.0, 1.0)

        self.scene.set_shader_input('fogStart', fogStart)
        self.scene.set_shader_input('fogEnd', fogEnd)
        self.scene.set_shader_input('fogColor', fogColor)

        # camera
        _CameraPositionWS = None
        self.scene.set_shader_input('_CameraPositionWS', _CameraPositionWS)

        # high level settings
        _IsFace = True
        self.scene.set_shader_input('_IsFace', _IsFace)

        # base color
        _BaseMap_ST = None
        _BaseColor = None
        self.scene.set_shader_input('_BaseMap_ST', _BaseMap_ST)
        self.scene.set_shader_input('_BaseColor', _BaseColor)

        # alpha
        _Cutoff = None
        self.scene.set_shader_input('_Cutoff', _Cutoff)

        # emission
        _UseEmission = None
        _EmissionColor = None
        _EmissionMap = None
        _EmissionMapChannelMask = None
        _EmissionMulByBaseColor = 1.0
        _EmissionTexture = None

        self.scene.set_shader_input('_UseEmission', _UseEmission)
        self.scene.set_shader_input('_EmissionColor', _EmissionColor)
        self.scene.set_shader_input('_EmissionMap', _EmissionMap)
        self.scene.set_shader_input('_EmissionMapChannelMask', _EmissionMapChannelMask)
        self.scene.set_shader_input('_EmissionMulByBaseColor', _EmissionMulByBaseColor)
        self.scene.set_shader_input('_EmissionTexture', _EmissionTexture)

        # occlusion
        _UseOcclusion = None
        _OcclusionStrength = None
        _OcclusionMapChannelMask = None
        _OcclusionRemapStart = None
        _OcclusionRemapEnd = None

        self.scene.set_shader_input('_UseOcclusion', _UseOcclusion)
        self.scene.set_shader_input('_OcclusionStrength', _OcclusionStrength)
        self.scene.set_shader_input('_OcclusionMapChannelMask', _OcclusionMapChannelMask)
        self.scene.set_shader_input('_OcclusionRemapStart', _OcclusionRemapStart)
        self.scene.set_shader_input('_OcclusionRemapEnd', _OcclusionRemapEnd)

        # lighting
        _IndirectLightMinColor = Vec3(1.0,1.0,1.0)
        _CelShadeMidPoint = 0.5
        _CelShadeSoftness = 0.1

        _EnvMap = None
        _MainLightDirection = None
        _MainLightColor = None
        _AdditionalLightsCount = None

        _AdditionalLights = None
        _PerObjectLightIndices = None
        _AdditionalLights = None

        self.scene.set_shader_input('_EnvMap', _EnvMap)
        self.scene.set_shader_input('_MainLightDirection', _MainLightDirection)
        self.scene.set_shader_input('_MainLightColor', _MainLightColor)
        self.scene.set_shader_input('_AdditionalLightsCount', _AdditionalLightsCount)

        self.scene.set_shader_input('_IndirectLightMinColor', _IndirectLightMinColor)
        self.scene.set_shader_input('_CelShadeMidPoint', _CelShadeMidPoint)
        self.scene.set_shader_input('_CelShadeSoftness', _CelShadeSoftness)

        self.scene.set_shader_input('_AdditionalLights', _AdditionalLights)
        self.scene.set_shader_input('_PerObjectLightIndices', _PerObjectLightIndices)
        self.scene.set_shader_input('_AdditionalLights', _AdditionalLights)

        # shadow mapping
        _ReceiveShadowMappingAmount = 0.8
        _ReceiveShadowMappingPosOffset = None
        _ShadowMapColor = Vec3(0.2,0.2,0.2)
        shadowBias = 0.005
        _MAIN_LIGHT_SHADOWS = None
        _ShadowMatrix = None
        _ShadowMap = None
        _AdditionalShadowMaps = None

        self.scene.set_shader_input('_ReceiveShadowMappingAmount', _ReceiveShadowMappingAmount)
        self.scene.set_shader_input('_ReceiveShadowMappingPosOffset', _ReceiveShadowMappingPosOffset)
        self.scene.set_shader_input('_ShadowMapColor', _ShadowMapColor)
        self.scene.set_shader_input('shadowBias', shadowBias)
        self.scene.set_shader_input('_MAIN_LIGHT_SHADOWS', _MAIN_LIGHT_SHADOWS)
        self.scene.set_shader_input('_ShadowMatrix', _ShadowMatrix)
        self.scene.set_shader_input('_ShadowMap', _ShadowMap)
        self.scene.set_shader_input('_AdditionalShadowMaps', _AdditionalShadowMaps)

        # outline
        _OutlineWidth = 0.5
        _OutlineColor = None
        _OutlineZOffset = None
        _OutlineZOffsetMaskTex = None
        _OutlineZOffsetMaskRemapStart = None
        _OutlineZOffsetMaskRemapEnd = None

        self.scene.set_shader_input('_OutlineWidth', _OutlineWidth)
        self.scene.set_shader_input('_OutlineColor', _OutlineColor)
        self.scene.set_shader_input('_OutlineZOffset', _OutlineZOffset)
        self.scene.set_shader_input('_OutlineZOffsetMaskTex', _OutlineZOffsetMaskTex)
        self.scene.set_shader_input('_OutlineZOffsetMaskRemapStart', _OutlineZOffsetMaskRemapStart)
        self.scene.set_shader_input('_OutlineZOffsetMaskRemapEnd', _OutlineZOffsetMaskRemapEnd)

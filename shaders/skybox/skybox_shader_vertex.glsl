#version 330 core

layout(location = 0) in vec3 aPos;

out vec3 TexCoords;

uniform mat4 p3d_ModelViewProjectionMatrix;
uniform mat4 p3d_ModelMatrix;
in vec4 p3d_Vertex;

void main()
{
    TexCoords = aPos;
    gl_Position =  p3d_ModelViewProjectionMatrix * p3d_ModelMatrix * vec4(aPos, 1.0);
}

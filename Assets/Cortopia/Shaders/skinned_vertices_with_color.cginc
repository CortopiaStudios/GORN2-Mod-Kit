struct texcoords
{
    uint color;
    float texcoord0;
    float texcoord1;
};

ByteAddressBuffer _SkinnedVertices;
StructuredBuffer<texcoords> _TexCoords;
uniform float4x4 _ObjectToWorld;
uniform float4x4 _WorldToObject;
uniform int _VertexStride;
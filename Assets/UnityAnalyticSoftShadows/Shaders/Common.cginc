
//ClipToView
float4 ClipToViewSpace(float4 p, float4x4 InverseProjection)
{
	float4 t = mul(InverseProjection, p);
	return t / t.w;
}

struct Light
{
    float3 boundingConePos;
    float boundingConeLength;
    float boundingConeRadius;
    float boundingConeBackadd;
    float4x4 mat;
    float3 minMaxDist;

    float3 color;
};
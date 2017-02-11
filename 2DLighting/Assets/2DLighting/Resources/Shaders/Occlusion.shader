// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Hidden/2DLighting/Occlusion" 
{
	Properties 
	{
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
	}
	SubShader 
	{
		Cull Off
		pass
		{
			CGPROGRAM
				//A very simple shader for renndering out the occluders into the occlusion map
				#include "UnityCG.cginc"
				#pragma vertex vert
				#pragma fragment frag

				uniform sampler2D _MainTex;
				uniform float _Alpha;
				uniform float4x4 LIGHT_MVP;
				uniform float4x4 LIGHT_PROJ;
				uniform float4 _SpriteColor;

				float4 ComputeDistance(float2 TexCoord : TEXCOORD1) : COLOR1
				{
					float4 color = tex2D(_MainTex, TexCoord) * _SpriteColor;
					color = color.a >= _Alpha ? float4(1, 0, 0, 1) : float4(0, 1, 0, 1);
					return color;
				}

				v2f_img vert(appdata_img i)
				{
					v2f_img o;
					float4x4 m = mul(LIGHT_MVP, unity_ObjectToWorld);
					float4x4 mvp = mul(LIGHT_PROJ, m);


					o.pos = mul(mvp, i.vertex);
					o.uv = MultiplyUV(UNITY_MATRIX_TEXTURE0, i.texcoord);
					return o;
				}

				float4 frag(v2f_img i) : COLOR
				{
					return ComputeDistance(i.uv);
				}

			ENDCG
		}
	}
	FallBack "Diffuse"
}

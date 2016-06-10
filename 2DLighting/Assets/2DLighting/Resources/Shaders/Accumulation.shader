Shader "Hidden/2DLighting/Accumulation"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Pass
		{
			//Simple additive shader to render the lights local lightmap into the screen space composite
			Blend One One
			CGPROGRAM
			#include "UnityCG.cginc"
			#pragma vertex vert_img
			#pragma fragment frag


			sampler2D _MainTex;
			uniform sampler2D LightArea_RT;
			uniform float4 LightColor;
			
			
			fixed4 frag (v2f_img i) : SV_Target
			{
				fixed4 col = tex2D(LightArea_RT, i.uv) * LightColor;
				return col;
			}
			ENDCG
		}
	}
}

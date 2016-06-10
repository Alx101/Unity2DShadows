Shader "Hidden/2DLighting/Light" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Resolution ("Resolution", Vector) = (256, 256, 0, 0)
	}

	SubShader 
	{
		Pass
		{
			CGPROGRAM
				//Using the lookup map created in the last shader, we'll render out the areas lit up by the light in the colour of the light
				#include "UnityCG.cginc"

				#pragma vertex vert_img
				#pragma fragment frag

				sampler2D _MainTex;
				fixed4 _Color;
				uniform float2 _Resolution;
				uniform float _Intensity;
				uniform float _Blurring;

				float smpl(float2 coord, float  r)
				{
					return step(r, tex2D(_MainTex, coord).r);
				}

				float4 frag(v2f_img i) : COLOR
				{
					//rectangular to polar
					float2 norm = i.uv * 2.0 - 1.0;
					float theta = atan2(norm.y, norm.x);
					float r = length(norm);
					float coord = (theta + UNITY_PI) / ( 2.0 * UNITY_PI);

					//texcoord to sample the lightmap
					//always 0.0 on the y axis since it's 1 dimensional
					float2 tc = float2(coord, 0.0);

					//center tex coord, gives us hard shadows
					float center = smpl(tc, r);

					//apply blurring through multipliation by distance
					float blur = (1.0 / _Resolution.x) * smoothstep(0.0, 1.0, r) * _Blurring;

					//gaussian blur

					float sum = 0.0;

					sum += smpl(float2(tc.x - 4.0 * blur, tc.y), r) * 0.05;
					sum += smpl(float2(tc.x - 3.0 * blur, tc.y), r) * 0.09;
					sum += smpl(float2(tc.x - 2.0 * blur, tc.y), r) * 0.12;
					sum += smpl(float2(tc.x - 1.0 * blur, tc.y), r) * 0.15;

					sum += center * 0.16;

					sum += smpl(float2(tc.x + 1.0 * blur, tc.y), r) * 0.05;
					sum += smpl(float2(tc.x + 2.0 * blur, tc.y), r) * 0.09;
					sum += smpl(float2(tc.x + 3.0 * blur, tc.y), r) * 0.12;
					sum += smpl(float2(tc.x + 4.0 * blur, tc.y), r) * 0.15;
					
					//sum of 1.0 -> in light, 0.0 -> in shadow

					//mulitply sum by distance, achieves radial falloff
					//finally apply color
					return _Color * float4(sum * smoothstep(1.0, 0.0, r), sum * smoothstep(1.0, 0.0, r), sum * smoothstep(1.0, 0.0, r), sum * smoothstep(1.0, 0.0, r)) * _Intensity * _Color.a;
					
				}

			ENDCG
		}
	}
	FallBack "Diffuse"
}

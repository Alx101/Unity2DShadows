Shader "Hidden/2DLighting/Distance" 
{
	Properties 
	{
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
	}

	SubShader
	{
		Cull Off
		Pass
		{
			CGPROGRAM
				
				//Distance shader, used to create the one dimensional lookup map for determining distance to the nearest occluder
				#include "UnityCG.cginc"
				#pragma multi_compile QUALITY_CRAP QUALITY_LOW QUALITY_MEDIUM QUALITY_HIGH QUALITY_HIGHER QUALITY_BEST
				#pragma vertex vert_img
				#pragma fragment frag
				#pragma target 3.0
				
				//The higher resolution, the more accurate the distance calculation will be
				uniform float2 _Resolution;
				uniform float _SampleRange; //Sample range, for non-circular lights (lightcones)
				sampler2D _MainTex;
				uniform sampler2D _OccTex;


				float4 frag(v2f_img i) : COLOR
				{
					//Determine which resolution to use
					int res = 128;
					#if defined(QUALITY_CRAP)
					res = 128;
					#endif
					#if defined(QUALITY_LOW)
					res = 256;
					#endif
					#if defined(QUALITY_MEDIUM)
					res = 512;
					#endif
					#if defined(QUALITY_HIGH)
					res = 1024;
					#endif
					#if defined(QUALITY_HIGHER)
					res = 2048;
					#endif
					#if defined(QUALITY_BEST)
					res = 4096;
					#endif
					
					//Setup some constants, saves performance
					float dst1 = 1.0;
					float2 norm = float2(i.uv.x, 1) * 2.0 - 1.0;
					float theta = UNITY_PI * 1.5 + norm.x * UNITY_PI;
					float tSin = sin(theta);
					float cSin = cos(theta);
					
					//UNITY_UNROLL is necessary to make the shader WebGL compatible, forcing it to unroll the loop
					UNITY_UNROLL
					#if defined(QUALITY_CRAP)
					for(int y = 0; y < 128; y += 1)
					#endif
					#if defined(QUALITY_LOW)
					for(int y = 0; y < 256; y += 1)
					#endif
					#if defined(QUALITY_MEDIUM)
					for(int y = 0; y < 512; y += 1)
					#endif
					#if defined(QUALITY_HIGH)
					for(int y = 0; y < 512; y += 1)
					{
						//Rectangular to polar
						norm.y = ((float)y / (float)res) * 2.0 - 1.0;
						float r = (1.0 + norm.y) * 0.5;

						//coord which we will sample from occlude map
						float2 coord = float2(-r * tSin, -r * cSin) / 2.0 + 0.5;

						coord.y = 1 - coord.y;

						//sample occlusion map
						float4 data = tex2Dlod(_OccTex, float4(coord, 0.0, 0.0));

						//distance
						float dst2 = (float)y / (float)res;

						//if we've hit an opaque fragment (occluder), we'll get the new distance
						//if the new distance is below the current, then we'll use that for our ray
						float caster = data.r;
						if(caster > 0.5)
						{
							dst1 = min(dst1, dst2);
						}
					}
					for(int y = 512; y < 1024; y += 1)
					#endif
					#if defined(QUALITY_HIGHER)
					for(int y = 0; y < 512; y += 1)
					{
						//Rectangular to polar
						norm.y = ((float)y / (float)res) * 2.0 - 1.0;
						float r = (1.0 + norm.y) * 0.5;

						//coord which we will sample from occlude map
						float2 coord = float2(-r * tSin, -r * cSin) / 2.0 + 0.5;

						coord.y = 1 - coord.y;

						//sample occlusion map
						float4 data = tex2Dlod(_OccTex, float4(coord, 0.0, 0.0));

						//distance
						float dst2 = (float)y / (float)res;

						//if we've hit an opaque fragment (occluder), we'll get the new distance
						//if the new distance is below the current, then we'll use that for our ray
						float caster = data.r;
						if(caster > 0.5)
						{
							dst1 = min(dst1, dst2);
						}
					}
					for(int y = 512; y < 1024; y += 1)
					{
						//Rectangular to polar
						norm.y = ((float)y / (float)res) * 2.0 - 1.0;
						float r = (1.0 + norm.y) * 0.5;

						//coord which we will sample from occlude map
						float2 coord = float2(-r * tSin, -r * cSin) / 2.0 + 0.5;

						coord.y = 1 - coord.y;

						//sample occlusion map
						float4 data = tex2Dlod(_OccTex, float4(coord, 0.0, 0.0));

						//distance
						float dst2 = (float)y / (float)res;

						//if we've hit an opaque fragment (occluder), we'll get the new distance
						//if the new distance is below the current, then we'll use that for our ray
						float caster = data.r;
						if(caster > 0.5)
						{
							dst1 = min(dst1, dst2);
						}
					}
					for(int y = 1024; y < 1536; y += 1)
					{
						//Rectangular to polar
						norm.y = ((float)y / (float)res) * 2.0 - 1.0;
						float r = (1.0 + norm.y) * 0.5;

						//coord which we will sample from occlude map
						float2 coord = float2(-r * tSin, -r * cSin) / 2.0 + 0.5;

						coord.y = 1 - coord.y;

						//sample occlusion map
						float4 data = tex2Dlod(_OccTex, float4(coord, 0.0, 0.0));

						//distance
						float dst2 = (float)y / (float)res;

						//if we've hit an opaque fragment (occluder), we'll get the new distance
						//if the new distance is below the current, then we'll use that for our ray
						float caster = data.r;
						if(caster > 0.5)
						{
							dst1 = min(dst1, dst2);
						}
					}
					for(int y = 1536; y < 2048; y += 1)
					#endif
					#if defined(QUALITY_BEST)
					for(int y = 0; y < 512; y += 1)
					{
						//Rectangular to polar
						norm.y = ((float)y / (float)res) * 2.0 - 1.0;
						float r = (1.0 + norm.y) * 0.5;

						//coord which we will sample from occlude map
						float2 coord = float2(-r * tSin, -r * cSin) / 2.0 + 0.5;

						coord.y = 1 - coord.y;

						//sample occlusion map
						float4 data = tex2Dlod(_OccTex, float4(coord, 0.0, 0.0));

						//distance
						float dst2 = (float)y / (float)res;

						//if we've hit an opaque fragment (occluder), we'll get the new distance
						//if the new distance is below the current, then we'll use that for our ray
						float caster = data.r;
						if(caster > 0.5)
						{
							dst1 = min(dst1, dst2);
						}
					}
					for(int y = 512; y < 1024; y += 1)
					{
						//Rectangular to polar
						norm.y = ((float)y / (float)res) * 2.0 - 1.0;
						float r = (1.0 + norm.y) * 0.5;

						//coord which we will sample from occlude map
						float2 coord = float2(-r * tSin, -r * cSin) / 2.0 + 0.5;

						coord.y = 1 - coord.y;

						//sample occlusion map
						float4 data = tex2Dlod(_OccTex, float4(coord, 0.0, 0.0));

						//distance
						float dst2 = (float)y / (float)res;

						//if we've hit an opaque fragment (occluder), we'll get the new distance
						//if the new distance is below the current, then we'll use that for our ray
						float caster = data.r;
						if(caster > 0.5)
						{
							dst1 = min(dst1, dst2);
						}
					}
					for(int y = 1024; y < 1536; y += 1)
					{
						//Rectangular to polar
						norm.y = ((float)y / (float)res) * 2.0 - 1.0;
						float r = (1.0 + norm.y) * 0.5;

						//coord which we will sample from occlude map
						float2 coord = float2(-r * tSin, -r * cSin) / 2.0 + 0.5;

						coord.y = 1 - coord.y;

						//sample occlusion map
						float4 data = tex2Dlod(_OccTex, float4(coord, 0.0, 0.0));

						//distance
						float dst2 = (float)y / (float)res;

						//if we've hit an opaque fragment (occluder), we'll get the new distance
						//if the new distance is below the current, then we'll use that for our ray
						float caster = data.r;
						if(caster > 0.5)
						{
							dst1 = min(dst1, dst2);
						}
					}
					for(int y = 1536; y < 2048; y += 1)
					{
						//Rectangular to polar
						norm.y = ((float)y / (float)res) * 2.0 - 1.0;
						float r = (1.0 + norm.y) * 0.5;

						//coord which we will sample from occlude map
						float2 coord = float2(-r * tSin, -r * cSin) / 2.0 + 0.5;

						coord.y = 1 - coord.y;

						//sample occlusion map
						float4 data = tex2Dlod(_OccTex, float4(coord, 0.0, 0.0));

						//distance
						float dst2 = (float)y / (float)res;

						//if we've hit an opaque fragment (occluder), we'll get the new distance
						//if the new distance is below the current, then we'll use that for our ray
						float caster = data.r;
						if(caster > 0.5)
						{
							dst1 = min(dst1, dst2);
						}
					}
					for(int y = 2048; y < 2560; y += 1)
					{
						//Rectangular to polar
						norm.y = ((float)y / (float)res) * 2.0 - 1.0;
						float r = (1.0 + norm.y) * 0.5;

						//coord which we will sample from occlude map
						float2 coord = float2(-r * tSin, -r * cSin) / 2.0 + 0.5;

						coord.y = 1 - coord.y;

						//sample occlusion map
						float4 data = tex2Dlod(_OccTex, float4(coord, 0.0, 0.0));

						//distance
						float dst2 = (float)y / (float)res;

						//if we've hit an opaque fragment (occluder), we'll get the new distance
						//if the new distance is below the current, then we'll use that for our ray
						float caster = data.r;
						if(caster > 0.5)
						{
							dst1 = min(dst1, dst2);
						}
					}
					for(int y = 2560; y < 3072; y += 1)
					{
						//Rectangular to polar
						norm.y = ((float)y / (float)res) * 2.0 - 1.0;
						float r = (1.0 + norm.y) * 0.5;

						//coord which we will sample from occlude map
						float2 coord = float2(-r * tSin, -r * cSin) / 2.0 + 0.5;

						coord.y = 1 - coord.y;

						//sample occlusion map
						float4 data = tex2Dlod(_OccTex, float4(coord, 0.0, 0.0));

						//distance
						float dst2 = (float)y / (float)res;

						//if we've hit an opaque fragment (occluder), we'll get the new distance
						//if the new distance is below the current, then we'll use that for our ray
						float caster = data.r;
						if(caster > 0.5)
						{
							dst1 = min(dst1, dst2);
						}
					}
					for(int y = 3072; y < 3584; y += 1)
					{
						//Rectangular to polar
						norm.y = ((float)y / (float)res) * 2.0 - 1.0;
						float r = (1.0 + norm.y) * 0.5;

						//coord which we will sample from occlude map
						float2 coord = float2(-r * tSin, -r * cSin) / 2.0 + 0.5;

						coord.y = 1 - coord.y;

						//sample occlusion map
						float4 data = tex2Dlod(_OccTex, float4(coord, 0.0, 0.0));

						//distance
						float dst2 = (float)y / (float)res;

						//if we've hit an opaque fragment (occluder), we'll get the new distance
						//if the new distance is below the current, then we'll use that for our ray
						float caster = data.r;
						if(caster > 0.5)
						{
							dst1 = min(dst1, dst2);
						}
					}
					for(int y = 3584; y < 4096; y += 1)
					#endif
					{
						//Rectangular to polar
						norm.y = ((float)y / (float)res) * 2.0 - 1.0;
						float r = (1.0 + norm.y) * 0.5;

						//coord which we will sample from occlude map
						float2 coord = float2(-r * tSin, -r * cSin) / 2.0 + 0.5;

						coord.y = 1 - coord.y;

						//sample occlusion map
						float4 data = tex2Dlod(_OccTex, float4(coord, 0.0, 0.0));

						//distance
						float dst2 = (float)y / (float)res;

						//if we've hit an opaque fragment (occluder), we'll get the new distance
						//if the new distance is below the current, then we'll use that for our ray
						float caster = data.r;
						if(caster > 0.5)
						{
							dst1 = min(dst1, dst2);
						}
					}
					//For lightcones, black out the angles outside the cone
					if(i.uv.x < clamp((1 - _SampleRange) / 2, 0, 1) || i.uv.x > clamp(1 - (1 - _SampleRange) / 2, 0, 1)) 
					{
						return float4(0, 0, 0, 1);
					}
					return float4(dst1, dst1, dst1, 1.0);
				}
			

			ENDCG
		}
	}
	FallBack Off
}
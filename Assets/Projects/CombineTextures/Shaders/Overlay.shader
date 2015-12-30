﻿// The Shader takes two textures and blends them together using the _MainTexMultiplier
Shader "Ellioman/CombineTexturesOverlay"
{
	// What variables do we want sent in to the shader?
	Properties
	{
		[HideInInspector] _MainTex ("Base (RGB)", 2D) = "white" {}
		_SecondTex ("Base (RGB)", 2D) = "white" {} 
		_SecondTexMultiplier ("Second Tex Multiplier", Range(0, 10)) = 0.5
		_ResultMultiplier ("Results Multiplier", Range(0, 10)) = 0.5
		_Tint ("Tint", color) = (1,1,1,1)
	}
	
    SubShader
    {
        Pass
        {
//			Blend SrcAlpha OneMinusSrcAlpha // Alpha blending
//			Blend One One // Additive
//			Blend OneMinusDstColor One // Soft Additive
//			Blend DstColor Zero // Multiplicative
//			Blend DstColor SrcColor // 2x Multiplicative

            CGPROGRAM
 			
	 			// Pragmas
				#pragma vertex vert_img // Use the helper vertex shader
				#pragma fragment frag
				
				// Helper functions
				#include "UnityCG.cginc"
	 			
	 			// User Defined Variables
	            uniform sampler2D _MainTex; 
	            uniform float4 _MainTex_TexelSize;
	            uniform sampler2D _SecondTex;
	            uniform float _SecondTexMultiplier;
	            uniform float _ResultMultiplier;
	            uniform float4 _Tint;

				// The Fragment Shader				
				half4 frag(v2f_img i) : COLOR
				{
	            	// Get the color value from the textures
	          		float4 a = tex2D(_MainTex, i.uv);
	          		float4 b = tex2D(_SecondTex, i.uv);

	          		// Blend the two color values
	          		float4 c = _ResultMultiplier * (a + b * _SecondTexMultiplier);
	          		float lum = c.r*.3 + c.g*.59 + c.b*.11;
					float3 bw = float3(lum, lum, lum); 

	          		float4 result = c;
					result.rgb = bw * _Tint.rgb;
					return result;
	            }
 			
            ENDCG
        }
    }
    Fallback "VertexLit"
}
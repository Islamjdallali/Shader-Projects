Shader "Custom/DistortionShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		[NoScaleOffset] _FlowMap("Flow (RG), A Map", 2D) = "black"{}
		[NoScaleOffset] _DerivHeightMap("Deriv (AG) Height (B)", 2D) = "black"{}
		_UJump("U Jump per phase", Range(-0.25,0.25)) = 0.25
		_VJump("V Jump per phase", Range(-0.25,0.25)) = 0.25
		_Tiling("Tiling", Float) = 1
		_Speed("Speed", Float) = 1
		_FlowStrength("Flow Strength", Float) = 1
		_FlowOffset("Flow Offset", Float) = 0
		_HeightScale("Height Scale, Constant", Float) = 0.25
		_HeightScaleModulated("Height Scale, Modulated", Float) = 0.75
		_Smoothness("Smoothness", Range(-1,1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

		#include "CGIncFiles/Flow.cginc"

        sampler2D _MainTex;
		sampler2D _FlowMap, _DerivHeightMap;
		float _UJump, _VJump, _Tiling, _Speed, _FlowStrength, _FlowOffset, _Smoothness, _HeightScale, _HeightScaleModulated;

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _Color;

		float3 UnpackDerivativeHeight(float4 textureData)
		{
			float3 dh = textureData.agb;
			dh.xy = dh.xy * 2 - 1;
			return dh;
		}

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
			float3 flow = tex2D(_FlowMap, IN.uv_MainTex).rgb;
			flow.xy = flow.xy * 2 - 1;
			flow *= _FlowStrength;
			float noise = tex2D(_FlowMap, IN.uv_MainTex).a;
			float time = _Time.y * _Speed + noise;
			float2 jump = float2(_UJump, _VJump);

			float finalHeightScale = length(flow) * _HeightScaleModulated + _HeightScale;

			//2 UV flow values
			float3 uvwA = FlowUVW(IN.uv_MainTex, flow, jump, _FlowOffset, _Tiling, time, false);
			float3 uvwB = FlowUVW(IN.uv_MainTex, flow, jump, _FlowOffset, _Tiling, time, true);

			float3 dhA = UnpackDerivativeHeight(tex2D(_DerivHeightMap, uvwA.xy) * (uvwA.z * finalHeightScale));
			float3 dhB = UnpackDerivativeHeight(tex2D(_DerivHeightMap, uvwB.xy) * (uvwB.z * finalHeightScale));

			o.Normal = normalize(float3 (-(dhA.xy + dhB.xy), 1));

			//2 Albedo Textures using the uv values
			float4 texA = tex2D(_MainTex, uvwA.xy) * uvwA.z;
			float4 texB = tex2D(_MainTex, uvwB.xy) * uvwB.z;

            // Albedo comes from a texture tinted by color
            fixed4 c = (texA + texB) * _Color;
            o.Albedo = c.rgb;

			o.Smoothness = _Smoothness;

            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

Shader "Custom/DistortionShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		[NoScaleOffset] _FlowMap("Flow (RG), A Map", 2D) = "black"{}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
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
		sampler2D _FlowMap;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
			float2 flowVector = tex2D(_FlowMap, IN.uv_MainTex).rg * 2 - 1;
			float noise = tex2D(_FlowMap, IN.uv_MainTex).a;
			float time = _Time.y + noise;

			//2 UV flow values
			float3 uvwA = FlowUVW(IN.uv_MainTex, flowVector, time, false);
			float3 uvwB = FlowUVW(IN.uv_MainTex, flowVector, time, true);

			//2 Textures using the uv values

			float4 texA = tex2D(_MainTex, uvwA.xy) * uvwA.z;
			float4 texB = tex2D(_MainTex, uvwB.xy) * uvwB.z;

            // Albedo comes from a texture tinted by color
            fixed4 c = (texA + texB) * _Color;
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

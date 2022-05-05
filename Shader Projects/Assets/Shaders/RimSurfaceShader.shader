Shader "Custom/RimSurfaceShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _RimValue("Rim Value",Range(0,5)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue" = "Transparent" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard Lambert alpha fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        float _RimValue;
        float4 _Color;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldNormal;
            float3 viewDir;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            float3 normal = normalize(IN.worldNormal);
            float3 dir = normalize(IN.viewDir);
            float rimVal = 1 - abs(dot(dir,normal));

            float rim = pow(rimVal,2) * _RimValue;

            o.Albedo = c.rgb;
            o.Alpha = c.a * rim;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

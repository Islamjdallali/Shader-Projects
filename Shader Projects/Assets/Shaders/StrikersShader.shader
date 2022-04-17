Shader "Custom/StrikersShader"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_OutlineColor("OutlineColor",Color) = (1,1,1,1)
		_OutlineWidth("OutlineWidth",Range(1,2)) = 1
		_MainTex("Texture", 2D) = "white" {}
		[IntRange]_Threshold("Cel threshold", Range(1, 20)) = 5
		_Ambient("Ambient intensity", Range(0., 0.5)) = 0.1
		_NoiseScale("Noise Scale",Range(0,2)) = 1
		_OutlineNoiseScale("OutlineNoise Scale",Range(0,2)) = 1
		_NoiseSnap("Noise Snap",Range(0,1)) = 0.5
    }
    SubShader
    {
		Tags {"RenderType" = "Transparent" "LightMode" = "ForwardBase"}
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
			};

			float _Threshold, _Amount, _NoiseScale, _NoiseSnap;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _Color;


			float3 rand(float3 co)
			{
				return frac(sin(dot(co.xy, float2(12.9898, 78.233))) * 43758.5453);
			}

			inline float snap(float x, float snap)
			{
				return snap * round(x / snap);
			}

			float ToonLight(float3 normal, float3 lightDir)
			{
				float NdotL = max(0.0, dot(normalize(normal), normalize(lightDir)));
				return floor(NdotL * _Threshold) / (_Threshold - .5);
			}

			v2f vert(appdata v)
			{
				v2f o;
				float3 noise = rand(v.normal + snap(_Time.y, _NoiseSnap)) * _NoiseScale;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.normal = mul(v.normal.xyz, (float3x3) unity_WorldToObject);
				o.normal += noise;
				return o;
			}
			fixed4 _LightColor0;
			half _Ambient;

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex,i.uv);
				col.rgb *= saturate(ToonLight(i.normal, _WorldSpaceLightPos0.xyz) + _Ambient) * _LightColor0.rgb;
				return col;
			}
			ENDCG
		}

		Pass
		{

			ZWrite Off
			Cull Front

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
			};

			float _OutlineWidth, _OutlineNoiseScale, _NoiseSnap;
			float4 _OutlineColor;

			float3 rand(float3 co)
			{
				return frac(sin(dot(co.xy, float2(12.9898, 78.233))) * 43758.5453) - 0.5f;
			}

			inline float snap(float x, float snap)
			{
				return snap * round(x / snap);
			}

			v2f vert(appdata v)
			{
				v2f o;
				float time = snap(_Time.y, _NoiseSnap);
				float3 noise = rand(v.vertex.xyz + time) * _OutlineNoiseScale;

				v.vertex.xyz += noise.xyz;
				v.vertex.xyz *= _OutlineWidth;
				o.vertex = UnityObjectToClipPos(v.vertex);

				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				return _OutlineColor;
			}

			ENDCG
		}
    }
}

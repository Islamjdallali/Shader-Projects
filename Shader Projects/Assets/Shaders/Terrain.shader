Shader "Unlit/Terrain"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _NormalTex("Normal Map",2D) = "bump"{}
        [NoScaleOffset]_HeightTex("Height Map",2D) = "White"{}

        _Displacement("Displacement Strength",Range(0,1)) = 0
        _BumpScale("Bump Scale",float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
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

            sampler2D _MainTex, _NormalTex, _HeightTex;
            float4 _MainTex_ST, HeightMap, Size;
            float _Displacement,_BumpScale;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            void InitializeNormal(inout v2f i)
            {
                i.normal.xy = tex2D(_NormalTex,i.uv).rgb;
                i.normal.xy *= _BumpScale;
	            i.normal.z = sqrt(1 - saturate(dot(i.normal.xy, i.normal.xy)));
                i.normal = i.normal.xzy;

                i.normal = normalize(i.normal);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                InitializeNormal(i);             

                float4 ndotl = 1 - saturate(dot(i.normal,_WorldSpaceLightPos0.xyz));

                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv) * ndotl;
                return col;
            }
            ENDCG
        }
    }
}

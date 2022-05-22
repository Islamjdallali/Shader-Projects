Shader "Custom/HalfTone"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _NoiseTex ("Noise Texture", 2D) = "white" {}
        _MainColor("Main Color",Color) = (1,1,1,1)
        _SecondaryColor("Secondary Color",Color) = (1,1,1,1)
        _Threshold ("Light Threshold",float) = 1
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
                float3 normal : NORMAL;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex, _NoiseTex;
            float4 _MainTex_ST, _NoiseTex_ST,_MainColor,_SecondaryColor;
            float _Threshold;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv = TRANSFORM_TEX(v.uv, _NoiseTex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            int Dots(float4 color,float threshold)
            {
                return 1 - step(color.r,threshold);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                i.normal = normalize(i.normal);

                float4 light = 1 - saturate(dot(i.normal,_WorldSpaceLightPos0.xyz));

                // sample the texture
                fixed4 noiseCol = tex2D(_NoiseTex, i.uv) * light;
                fixed4 mainCol = tex2D(_MainTex,i.uv);

                fixed4 newCol = lerp(_MainColor,_SecondaryColor,(Dots(noiseCol,1 - (light * _Threshold) * 0.8f)));

                return newCol;
            }
            ENDCG
        }
    }
}

Shader "Custom/Geometry/Wireframe"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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
            #pragma geometry geo

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 pos : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2g
            {
                float2 uv : TEXCOORD0;
                float4 pos : SV_POSITION;
            };

            struct g2f
            {
                float2 uv : TEXCOORD0;
                float4 pos : SV_POSITION;
                float2 barycentricCoords : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2g vert (appdata v)
            {
                v2g o;
                o.pos = UnityObjectToClipPos(v.pos);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            [maxvertexcount(3)]
            void geo (triangle v2g input[3], inout TriangleStream<g2f> stream)
            {
                g2f o;

                o.barycentricCoords = float2(1,0);
                o.pos = input[0].pos;
                o.uv = input[0].uv;
                stream.Append(o);

                o.barycentricCoords = float2(0,1);
                o.pos = input[1].pos;
                o.uv = input[1].uv;
                stream.Append(o);

                o.barycentricCoords = float2(0,0);
                o.pos = input[2].pos;
                o.uv = input[2].uv;
                stream.Append(o);
            }

            fixed4 frag (g2f i) : SV_Target
            {
                float3 barys;
                barys.xy = i.barycentricCoords;
                barys.z = 1 - barys.x - barys.y;
                float minbary = min(barys.x,min(barys.y,barys.z));
                minbary = smoothstep(0,0.1,minbary);
                fixed4 col = tex2D(_MainTex,i.uv) * minbary;
                return col;
            }
            ENDCG
        }
    }
}

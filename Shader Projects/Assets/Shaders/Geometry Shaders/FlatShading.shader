Shader "Custom/Geometry/FlatShading"
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

            struct v2g
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 pos : TEXCOORD1;
            };

            struct g2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float light : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2g vert (appdata_full  v)
            {
                v2g o;
                o.vertex = v.vertex;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                return o;
            }

            [maxvertexcount(3)]
            void geo(triangle v2g i[3], inout TriangleStream<g2f> stream)
            {
                g2f o;
 
                // Compute the normal
                float3 vecA = i[1].vertex - i[0].vertex;
                float3 vecB = i[2].vertex - i[0].vertex;
                float3 normal = cross(vecA, vecB);
                normal = normalize(mul(normal, (float3x3) unity_WorldToObject));
 
                // Compute diffuse light
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                o.light = max(0., dot(normal, lightDir));
 
                // Compute barycentric uv
                o.uv = (i[0].uv + i[1].uv + i[2].uv) / 3;
 
                for(int j = 0; j < 3; j++)
                {
                    o.pos = i[j].pos;
                    stream.Append(o);
                }
            }

            fixed4 frag (g2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv) * i.light;
                return col;
            }
            ENDCG
        }
    }
}

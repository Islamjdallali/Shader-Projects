Shader "Custom/Inverse"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ObjectPos("Object Position",Vector) = (0,0,0,0)
        _InverseRadius("Inverse Radius",float) = 0
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
                float4 ray : TEXCOORD1;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST,_ObjectPos;
            float _InverseRadius;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            int DistanceCalc(float d)
            {
                if (d < _InverseRadius)
                {
                    return 1;
                }
                return 0;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float dist = distance(i.uv,_ObjectPos.xy + 0.5);
                fixed4 col = abs(DistanceCalc(dist) - tex2D(_MainTex, i.uv));
                return col;
            }
            ENDCG
        }
    }
}

Shader "Custom/Mandelbrot"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        [NoScaleOffset] _Color("Color Texture", 2D) = "white" {}
        _Area ("Area", Vector) = (0,0,4,4)
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
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            sampler2D _Color;
            float4 _MainTex_ST, _Area;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            float4 Mandelbrot(float2 uv)
            {
                float2 c = _Area.xy + (uv - 0.5) * _Area.zw;
                float2 z;
                float itr;

                for (itr = 0; itr < 5000; itr++)
                {
                    z = float2(z.x * z.x - z.y * z.y, 2 * z.x * z.y) + c;

                    if (length(z) > 2) break;
                }

				float4 color = 0;

				if (itr < 5000)
                {
					color = tex2D(_Color, float2((itr / (float)5000) * (5000*0.01) + _Time.x, 0));
				}

				return color;
            }

            fixed4 frag(v2f i) : SV_Target
            {
				return Mandelbrot(i.uv);
            }
            ENDCG
        }
    }
}

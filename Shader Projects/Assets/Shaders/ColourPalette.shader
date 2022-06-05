Shader "Custom/ColourPalette"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ColourPalette("Palette Texture",2D) = "White"{}
        _PaletteNumber("Palette Number",float) = 0
        _PixelSize ("Pixel Size", Range(0.001, 0.1)) = 1.0
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
            sampler2D _ColourPalette;
            float4 _MainTex_ST;
            float _PaletteNumber;
            float _PixelSize;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float ratioX = (int)(i.uv.x / _PixelSize) * _PixelSize;
                float ratioY = (int)(i.uv.y / _PixelSize) * _PixelSize;

                fixed4 col = tex2D(_MainTex, float2(ratioX,ratioY));

                col = dot(col.rgb,float3(0.29, 0.587, 0.114));

                fixed4 newCol = fixed4(0,0,0,0);

                if (col.r <= 0.5)
                {
                    newCol = tex2D(_ColourPalette,float2(0.25,_PaletteNumber));
                }
                else if (col.r > 0.95)
                {
                    newCol = tex2D(_ColourPalette,float2(1,_PaletteNumber));
                }
                else if (col.r > 0.5 && col.r <= 0.7)
                {
                    newCol = tex2D(_ColourPalette,float2(0,_PaletteNumber));;
                }
                else
                {
                    newCol = tex2D(_ColourPalette,float2(0.6,_PaletteNumber));
                }

                return newCol;
            }
            ENDCG
        }
    }
}

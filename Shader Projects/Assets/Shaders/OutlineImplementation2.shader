Shader "Custom/OutlineImplementation2"
{
    Properties
    {
        _BaseColor ("Base Color", Color) = (1,1,1,1)
		_MainTex("Main Texture",2D) = "White" {}
        _OutlineColor ("Outline Color", Color) = (1,1,1,1)
		_OutlineWidth ("Outline Width", Range(1,5)) = 1
    }
    SubShader
    {
		Tags{"Queue" = "Transparent"}
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
                float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
            };

            float4 _BaseColor;
			sampler2D _MainTex;
			float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return _BaseColor;
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

				float _OutlineWidth;
				float4 _OutlineColor;

				v2f vert(appdata v)
				{
					v2f o;
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

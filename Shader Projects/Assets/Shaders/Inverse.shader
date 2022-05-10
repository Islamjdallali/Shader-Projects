Shader "Custom/Inverse/Inverse"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ObjectPos("Object Position",Vector) = (0,0,0,0)
        _InverseRadius("Inverse Radius",float) = 0
        _WarpRadius("Warp Radius", float) = 0
		[IntRange]_StencilRef("StencilRef",Range(0,255)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

            Stencil {
			Ref [_StencilRef]
			Comp always
			Pass replace
		}

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
            float4 _MainTex_ST,_ObjectPos;
            float _InverseRadius, _WarpRadius;

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

            fixed2 WorldToScreenPos(fixed3 pos){
                pos = normalize(pos - _WorldSpaceCameraPos)*(_ProjectionParams.y + (_ProjectionParams.z - _ProjectionParams.y))+_WorldSpaceCameraPos;
                fixed2 uv =0;
                fixed3 toCam = mul(unity_WorldToCamera, pos);
                fixed camPosZ = toCam.z;
                fixed height = 2 * camPosZ / unity_CameraProjection._m11;
                fixed width = _ScreenParams.x / _ScreenParams.y * height;
                uv.x = (toCam.x + width / 2)/width;
                uv.y = (toCam.y + height / 2)/height;
                return uv;
            }


            fixed4 frag (v2f i) : SV_Target
            {

                float dist = distance(i.uv,WorldToScreenPos(_ObjectPos.xyz));
                float wipe = smoothstep(_WarpRadius - 0.1,_WarpRadius + 0.1,dist);
                float ring = wipe * (1 - wipe);
                fixed4 col = abs(DistanceCalc(dist) - tex2D(_MainTex, i.uv + ring));
                return col;
            }
            ENDCG
        }
    }
}

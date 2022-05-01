Shader "Custom/DepthShader"
{
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float4 screenuv : TEXCOORD1;
            };

            v2f vert (appdata_base v)
            {
                v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.screenuv = ComputeScreenPos(o.vertex);
                return o;
            }

			sampler2D _CameraDepthTexture;

            fixed4 frag (v2f i) : SV_Target
            {
				float2 uv = i.screenuv.xy / i.screenuv.w;
				float depth = 1 - Linear01Depth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, uv));
				return fixed4(depth, depth, depth, 1);
            }
            ENDCG
        }
    }
}

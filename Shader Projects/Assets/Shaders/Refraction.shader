Shader "Custom/Refraction"
{
    Properties
    {
		_RefractionAmount("Refraction Amount",Range(0,10)) = 1
	}
	SubShader
	{
		Tags { "Queue" = "Transparent" }
		LOD 100

		GrabPass { "_GrabTexture" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
				float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
				float3 normal : TEXCOORD0;
				float4 grabUV : TEXCOORD1;
				float4 refract : TEXCOORD2;
            };

			float _RefractionAmount;
			sampler2D _GrabTexture;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
				o.normal = UnityObjectToWorldNormal(v.normal);
				o.grabUV = ComputeGrabScreenPos(o.vertex);
				o.refract = float4(v.normal, 0) * _RefractionAmount;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				i.normal = normalize(i.normal);
                fixed4 col = tex2Dproj(_GrabTexture,UNITY_PROJ_COORD(i.grabUV + i.refract));
                return col;
            }
            ENDCG
        }
    }
}

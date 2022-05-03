Shader "Custom/ScanEffect"
{
    Properties
    {
        _ScanDistance("Scan Distance",float) = 0
		_ScanWidth("Scan Width",float) = 0
		_Color("Color",color) = (0,0,0,0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 pos : POSITION;
				float4 ray : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 screenuv : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float4 interpolatedRay : TEXCOORD4;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.pos);
				o.screenuv = ComputeScreenPos(o.vertex);
				o.worldPos = mul(unity_ObjectToWorld, v.pos).xyz;
				o.interpolatedRay = v.ray;
				return o;
			}

			sampler2D _CameraDepthTexture;
			float _ScanDistance,_ScanWidth;
			float4 _Color;

			int ScanThreshold(float _dist, float _depth)
			{
				_dist = _dist * 20;
				if (_dist < _ScanDistance && _dist > _ScanDistance - _ScanWidth && _depth < 1)
				{
					return 1;
				}
				return 0;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				float2 uv = i.screenuv.xy / i.screenuv.w;
				float depth = Linear01Depth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, uv));
				float4 wsDir = depth * i.interpolatedRay;
				float3 wsPos = _WorldSpaceCameraPos + wsDir;
				float dist = distance(wsPos, _WorldSpaceCameraPos);
				return fixed4(ScanThreshold(dist,depth) * _Color.r, ScanThreshold(dist,depth) * _Color.g, ScanThreshold(dist,depth) * _Color.b, 1);
			}
			ENDCG
        }
    }
}

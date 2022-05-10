Shader "Custom/Stencil/StencilEffect"
{
	Properties{
		_MainTex("Base (RGB)", 2D) = "white" {}
		_Color("Color", color) = (1,1,1,1)
		[IntRange]_StencilRef("StencilRef",Range(0,255)) = 0
	}
		SubShader{
			Tags { "RenderType" = "Opaque"}

			Stencil {
				Ref [_StencilRef]
				Comp equal			
			}

			CGPROGRAM
			#pragma surface surf Lambert

			sampler2D _MainTex;
			fixed4 _Color;

			struct Input {
				float2 uv_MainTex;
			};

			void surf(Input IN, inout SurfaceOutput o) {
				half4 c = tex2D(_MainTex, IN.uv_MainTex);
				o.Albedo = c * _Color;
				o.Alpha = c.a;
			}
			ENDCG
	}
		FallBack "Diffuse"
}

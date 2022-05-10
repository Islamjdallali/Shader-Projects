Shader "Custom/Stencil/StencilMask"
{
	Properties
	{
		[IntRange]_StencilRef("StencilRef",Range(0,255)) = 0
	}

	SubShader{
		Tags { "RenderType" = "Transparent" }
		Stencil {
			Ref [_StencilRef]
			Comp always
			Pass replace
		}

		CGPROGRAM
		#pragma surface surf Lambert alpha

		struct Input {
			fixed3 Albedo;
		};

		void surf(Input IN, inout SurfaceOutput o) {
			o.Albedo = fixed3(1, 1, 1);
			o.Alpha = 0;
		}
		ENDCG
    }
    FallBack "Diffuse"
}

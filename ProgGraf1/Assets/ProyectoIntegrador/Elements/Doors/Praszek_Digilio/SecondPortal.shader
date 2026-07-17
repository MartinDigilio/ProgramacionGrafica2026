// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SecondPortal"
{
	Properties
	{
		_Speed("Speed", Float) = 2
		_Scale("Scale", Float) = 3
		_Power("Power", Range( 0 , 1)) = 0.58
		[HDR]_Color("Color", Color) = (0,1,0.08897352,1)
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _Color;
		uniform float _Scale;
		uniform float _Speed;
		uniform float _Power;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;


		float2 voronoihash26( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi26( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash26( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			 		}
			 	}
			}
			
F1 = 8.0;
for ( int j = -2; j <= 2; j++ )
{
for ( int i = -2; i <= 2; i++ )
{
float2 g = mg + float2( i, j );
float2 o = voronoihash26( n + g );
		o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
float d = dot( 0.5 * ( r + mr ), normalize( r - mr ) );
F1 = min( F1, d );
}
}
return F1;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float time26 = 20.0;
			float2 CenteredUV15_g2 = ( i.uv_texcoord - float2( 0.5,0.5 ) );
			float2 break17_g2 = CenteredUV15_g2;
			float2 appendResult23_g2 = (float2(( length( CenteredUV15_g2 ) * 1.0 * 2.0 ) , ( atan2( break17_g2.x , break17_g2.y ) * ( 1.0 / 6.28318548202515 ) * 1.0 )));
			float2 temp_cast_0 = (( ( _Time.y * _Speed ) + appendResult23_g2.x )).xx;
			float2 coords26 = temp_cast_0 * _Scale;
			float2 id26 = 0;
			float2 uv26 = 0;
			float fade26 = 0.5;
			float voroi26 = 0;
			float rest26 = 0;
			for( int it26 = 0; it26 <8; it26++ ){
			voroi26 += fade26 * voronoi26( coords26, time26, id26, uv26, 0 );
			rest26 += fade26;
			coords26 *= 2;
			fade26 *= 0.5;
			}//Voronoi26
			voroi26 /= rest26;
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 temp_output_43_0 = ( pow( voroi26 , ( 1.0 - _Power ) ) * tex2D( _TextureSample0, uv_TextureSample0 ) );
			float4 temp_output_39_0 = ( _Color * temp_output_43_0 );
			o.Albedo = temp_output_39_0.rgb;
			o.Emission = temp_output_39_0.rgb;
			o.Alpha = temp_output_43_0.r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;73.6;974.2;283;-758.3015;392.2763;1.962627;True;False
Node;AmplifyShaderEditor.RangedFloatNode;28;-908.0944,1.278687;Inherit;False;Property;_Speed;Speed;0;0;Create;True;0;0;0;False;0;False;2;0.66;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;30;-894.7921,-257.1605;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;17;-947.2965,267.0335;Inherit;False;Polar Coordinates;-1;;2;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;1;False;4;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;18;-555.2225,216.7277;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-640.0363,-51.64552;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;96.27968,287.5091;Inherit;False;Property;_Power;Power;2;0;Create;True;0;0;0;False;0;False;0.58;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-117.5951,179.2155;Inherit;False;Property;_Scale;Scale;1;0;Create;True;0;0;0;False;0;False;3;2.69;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;21;-307.3686,-50.27189;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;36;389.1911,286.7708;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;26;251.3893,-6.918286;Inherit;False;0;0;1;4;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;20;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.PowerNode;34;540.5869,31.88685;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;42;884.9622,103.6054;Inherit;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;38;1342.299,-359.5475;Inherit;False;Property;_Color;Color;3;0;Create;True;0;0;0;False;1;HDR;False;0,1,0.08897352,1;0.1451387,0.3789335,0.1802078,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;1290.407,-118.0938;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;1675.509,-209.408;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2002.09,-169.5327;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;SecondPortal;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;18;0;17;0
WireConnection;20;0;30;0
WireConnection;20;1;28;0
WireConnection;21;0;20;0
WireConnection;21;1;18;0
WireConnection;36;0;35;0
WireConnection;26;0;21;0
WireConnection;26;2;31;0
WireConnection;34;0;26;0
WireConnection;34;1;36;0
WireConnection;43;0;34;0
WireConnection;43;1;42;0
WireConnection;39;0;38;0
WireConnection;39;1;43;0
WireConnection;0;0;39;0
WireConnection;0;2;39;0
WireConnection;0;9;43;0
ASEEND*/
//CHKSM=BCC7BAAE973F46A722B6B23178E9A64076B1EB1E
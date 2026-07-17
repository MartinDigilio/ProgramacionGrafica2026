// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "NegativeCardFrameTexture"
{
	Properties
	{
		_FrontTexture("Front Texture", 2D) = "white" {}
		_Backtexture("Back texture", 2D) = "white" {}
		_HoloTiling("HoloTiling", Float) = -0.5
		_Cutoff( "Mask Clip Value", Float ) = 0
		_holospeed("holospeed", Float) = 1
		_HoloIntensity("HoloIntensity", Float) = 0
		_TextureSample3("Texture Sample 3", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Off
		Stencil
		{
			Ref 5
			CompFront NotEqual
			PassFront Keep
			FailFront Keep
			ZFailFront Keep
		}
		CGINCLUDE
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 viewDir;
			INTERNAL_DATA
			half ASEVFace : VFACE;
		};

		uniform sampler2D _FrontTexture;
		uniform float4 _FrontTexture_ST;
		uniform sampler2D _TextureSample3;
		uniform float _HoloTiling;
		uniform float _holospeed;
		uniform float _HoloIntensity;
		uniform sampler2D _Backtexture;
		uniform float4 _Backtexture_ST;
		uniform float _Cutoff = 0;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = float3(0,0,1);
			float2 uv_FrontTexture = i.uv_texcoord * _FrontTexture_ST.xy + _FrontTexture_ST.zw;
			float4 tex2DNode2 = tex2D( _FrontTexture, uv_FrontTexture );
			float2 temp_output_13_0 = (i.viewDir).xy;
			float3 unityObjectToViewPos37 = UnityObjectToViewPos( float3( temp_output_13_0 ,  0.0 ) );
			float4 lerpResult30 = lerp( float4( (float3( 0,0,0 ) + (( 1.0 - (tex2DNode2).rgb ) - float3( 0,0,0 )) * (float3( 0.5,0.5,0.5 ) - float3( 0,0,0 )) / (float3( 1,1,1 ) - float3( 0,0,0 ))) , 0.0 ) , ( tex2DNode2 + tex2D( _TextureSample3, ( ( temp_output_13_0 * _HoloTiling ) + ( (unityObjectToViewPos37).xy * _holospeed ) ) ) ) , float4( ( i.viewDir * _HoloIntensity ) , 0.0 ));
			float2 uv_Backtexture = i.uv_texcoord * _Backtexture_ST.xy + _Backtexture_ST.zw;
			float4 tex2DNode7 = tex2D( _Backtexture, uv_Backtexture );
			float4 switchResult9 = (((i.ASEVFace>0)?(lerpResult30):(tex2DNode7)));
			o.Albedo = switchResult9.rgb;
			o.Emission = switchResult9.rgb;
			o.Alpha = 1;
			float switchResult11 = (((i.ASEVFace>0)?(tex2DNode2.a):(tex2DNode7.a)));
			clip( switchResult11 - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

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
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
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
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = IN.tSpace0.xyz * worldViewDir.x + IN.tSpace1.xyz * worldViewDir.y + IN.tSpace2.xyz * worldViewDir.z;
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
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
0;73.6;847.8;458.2;2192.772;295.3227;2.24829;True;False
Node;AmplifyShaderEditor.CommentaryNode;41;-2649.024,741.2195;Inherit;False;2020.303;665.6426;Efecto holografico;11;12;13;37;17;16;36;21;20;22;28;51;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;12;-2599.024,802.6862;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ComponentMaskNode;13;-2401.107,800.0458;Inherit;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;38;-2079.568,21.58804;Inherit;False;1032.538;285.0924;Textura frontal ;6;2;3;29;27;45;59;;1,1,1,1;0;0
Node;AmplifyShaderEditor.UnityObjToViewPosHlpNode;37;-2300.676,1154.024;Inherit;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TexturePropertyNode;3;-2029.566,76.68049;Inherit;True;Property;_FrontTexture;Front Texture;0;0;Create;True;0;0;0;False;0;False;None;33881a67b994dc54ab5ad8b2f27a4cbd;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;17;-2023.427,998.0744;Inherit;False;Property;_HoloTiling;HoloTiling;2;0;Create;True;0;0;0;False;0;False;-0.5;-0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1899.704,1233.127;Inherit;False;Property;_holospeed;holospeed;4;0;Create;True;0;0;0;False;0;False;1;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;36;-2089.338,1179.131;Inherit;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;2;-1735.322,71.58805;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-1857.31,973.0526;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-1733.303,1111.528;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-1625.303,979.5272;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;29;-1428.041,72.84843;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-1200.85,250.6442;Inherit;False;Property;_HoloIntensity;HoloIntensity;5;0;Create;True;0;0;0;False;0;False;0;-0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;51;-1220.698,950.9871;Inherit;True;Property;_TextureSample3;Texture Sample 3;6;0;Create;True;0;0;0;False;0;False;-1;c317c95413d37f842bdf057c59a4fa78;c317c95413d37f842bdf057c59a4fa78;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;39;-1422.677,330.4579;Inherit;False;593.6024;283.3415;Textura Dorsal;2;8;7;;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;59;-1193.934,44.70886;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;46;-2422.79,650.4058;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;28;-781.1213,921.2412;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;8;-1372.677,383.7994;Inherit;True;Property;_Backtexture;Back texture;1;0;Create;True;0;0;0;False;0;False;None;6a3028354918d9c4babc90d154170b3f;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-1174.254,161.6766;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCRemapNode;65;-1032.198,3.195602;Inherit;False;5;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;1,1,1;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0.5,0.5,0.5;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;7;-1150.674,380.4579;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;40;-655.5056,36.34373;Inherit;False;264.7371;368.4932;Cambio textura por cara;2;9;11;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;30;-842.8763,154.0496;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SwitchByFaceNode;11;-599.5684,271.0369;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwitchByFaceNode;9;-605.5056,86.34373;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;NegativeCardFrameTexture;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0;True;True;0;False;TransparentCutout;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;True;5;False;-1;255;False;-1;255;False;-1;6;False;-1;1;False;-1;1;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;3;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;13;0;12;0
WireConnection;37;0;13;0
WireConnection;36;0;37;0
WireConnection;2;0;3;0
WireConnection;21;0;13;0
WireConnection;21;1;17;0
WireConnection;20;0;36;0
WireConnection;20;1;16;0
WireConnection;22;0;21;0
WireConnection;22;1;20;0
WireConnection;29;0;2;0
WireConnection;51;1;22;0
WireConnection;59;0;29;0
WireConnection;46;0;12;0
WireConnection;28;0;2;0
WireConnection;28;1;51;0
WireConnection;45;0;46;0
WireConnection;45;1;27;0
WireConnection;65;0;59;0
WireConnection;7;0;8;0
WireConnection;30;0;65;0
WireConnection;30;1;28;0
WireConnection;30;2;45;0
WireConnection;11;0;2;4
WireConnection;11;1;7;4
WireConnection;9;0;30;0
WireConnection;9;1;7;0
WireConnection;0;0;9;0
WireConnection;0;2;9;0
WireConnection;0;10;11;0
ASEEND*/
//CHKSM=24FB67867C168183DBD16F30C84CCDA5FCC0B116
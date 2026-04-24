// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Building"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Scalefloat("Scale float", Range( 0 , 1)) = 0.5439783
		_TextureSample5("Texture Sample 5", 2D) = "white" {}
		_Texture0("Texture 0", 2D) = "white" {}
		_Float0("Float 0", Float) = 0
		_Float1("Float 1", Float) = 0.6
		_Emissive("Emissive", 2D) = "white" {}
		_GlobalTiling("Global Tiling ", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
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
		};

		uniform sampler2D _Texture0;
		uniform float2 _GlobalTiling;
		uniform sampler2D _TextureSample5;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float _Scalefloat;
		uniform float _Float0;
		uniform float _Float1;
		uniform sampler2D _Emissive;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, 0.0);
		}

		void vertexDataFunc( inout appdata_full v )
		{
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord76 = i.uv_texcoord * _GlobalTiling;
			float2 GlobalUV77 = uv_TexCoord76;
			o.Normal = tex2D( _Texture0, GlobalUV77 ).rgb;
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float Scalefloat8 = _Scalefloat;
			float3 Viewdir10 = i.viewDir;
			float2 Offset4 = ( ( tex2D( _TextureSample0, uv_TextureSample0 ).r - 1 ) * Viewdir10.xy * Scalefloat8 ) + GlobalUV77;
			float2 Offset16 = ( ( tex2D( _TextureSample0, Offset4 ).r - 1 ) * Viewdir10.xy * Scalefloat8 ) + Offset4;
			float2 Offset25 = ( ( tex2D( _TextureSample0, Offset16 ).r - 1 ) * Viewdir10.xy * Scalefloat8 ) + Offset16;
			float2 Offset28 = ( ( tex2D( _TextureSample0, Offset25 ).r - 1 ) * Viewdir10.xy * Scalefloat8 ) + Offset25;
			o.Albedo = ( tex2D( _TextureSample5, GlobalUV77 ) * tex2D( _TextureSample0, Offset28 ) ).rgb;
			float4 temp_cast_17 = (_Float0).xxxx;
			float4 temp_cast_18 = (_Float1).xxxx;
			float4 tex2DNode72 = tex2D( _Emissive, GlobalUV77 );
			float4 smoothstepResult58 = smoothstep( temp_cast_17 , temp_cast_18 , tex2DNode72);
			o.Emission = ( ( smoothstepResult58 * tex2DNode72 ) * float4(1.937173,2,0,0) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
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
				vertexDataFunc( v );
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
0;73.6;823;415.8;4994.279;711.1298;2.946466;True;False
Node;AmplifyShaderEditor.Vector2Node;82;-3719.374,-413.5129;Inherit;False;Property;_GlobalTiling;Global Tiling ;7;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;34;-3256.481,-662.242;Inherit;False;942.48;774.4534;Comment;7;7;6;2;10;8;4;78;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;76;-3568.991,-438.1002;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;77;-3366.899,-441.1648;Inherit;False;GlobalUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-3099.121,-194.7084;Inherit;False;Property;_Scalefloat;Scale float;1;0;Create;True;0;0;0;False;0;False;0.5439783;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;7;-3002.406,-73.38802;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;78;-2708.799,-490.3016;Inherit;False;77;GlobalUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;8;-2841.892,-198.9505;Inherit;False;Scalefloat;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-3206.481,-612.242;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;10;-2765.959,-21.13954;Inherit;False;Viewdir;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;35;-2248.754,-502.8034;Inherit;False;596.4314;455.3682;Comment;4;19;21;5;16;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ParallaxMappingNode;4;-2564.801,-429.6425;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;21;-2089.331,-162.835;Inherit;False;10;Viewdir;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;5;-2198.754,-443.382;Inherit;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;2;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;19;-2089.099,-240.1009;Inherit;False;8;Scalefloat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;36;-2242.575,-20.41983;Inherit;False;588.8162;450.1386;Comment;4;18;23;22;25;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ParallaxMappingNode;16;-1903.123,-452.8034;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;23;-2085.304,237.0529;Inherit;False;8;Scalefloat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;22;-2085.537,314.3188;Inherit;False;10;Viewdir;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;18;-2192.575,38.99341;Inherit;True;Property;_TextureSample2;Texture Sample 2;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;2;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;37;-1595.831,-24.17606;Inherit;False;939.4424;488.2018;Comment;5;31;26;30;29;28;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;79;-775.2946,281.7421;Inherit;False;77;GlobalUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ParallaxMappingNode;25;-1904.556,29.58017;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;30;-1382.325,271.3592;Inherit;False;8;Scalefloat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;26;-1545.831,44.43413;Inherit;True;Property;_TextureSample3;Texture Sample 3;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;2;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;38;-1201.426,-333.2628;Inherit;False;544.0029;291.5407;Comment;3;32;33;80;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-656.189,529.9636;Inherit;False;Property;_Float0;Float 0;4;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-652.1891,591.9636;Inherit;False;Property;_Float1;Float 1;5;0;Create;True;0;0;0;False;0;False;0.6;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;72;-612.9771,236.0506;Inherit;True;Property;_Emissive;Emissive;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;29;-1382.557,348.6255;Inherit;False;10;Viewdir;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SmoothstepOpNode;58;-527.9447,506.9093;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;50;-358.5864,615.7325;Inherit;False;Constant;_Color0;Color 0;9;1;[HDR];Create;True;0;0;0;False;0;False;1.937173,2,0,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;80;-1320.183,-272.5221;Inherit;False;77;GlobalUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;47;-1600.587,488.3516;Inherit;False;595.0409;420.3595;Comment;3;44;46;45;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ParallaxMappingNode;28;-1201.579,63.88625;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;31;-977.9891,25.8239;Inherit;True;Property;_TextureSample4;Texture Sample 4;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;2;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;44;-1550.587,541.1101;Inherit;True;Property;_Texture0;Texture 0;3;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-349.4748,449.8793;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;73;-210.0106,652.9102;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;46;-1509.209,794.3113;Inherit;False;77;GlobalUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;33;-1151.426,-283.2627;Inherit;True;Property;_TextureSample5;Texture Sample 5;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.EdgeLengthTessNode;63;-13.83484,459.7394;Inherit;False;1;0;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-819.8237,-175.522;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;45;-1327.146,538.3518;Inherit;True;Property;_TextureSample6;Texture Sample 6;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-228.6105,449.648;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Building;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;76;0;82;0
WireConnection;77;0;76;0
WireConnection;8;0;6;0
WireConnection;10;0;7;0
WireConnection;4;0;78;0
WireConnection;4;1;2;0
WireConnection;4;2;8;0
WireConnection;4;3;10;0
WireConnection;5;1;4;0
WireConnection;16;0;4;0
WireConnection;16;1;5;0
WireConnection;16;2;19;0
WireConnection;16;3;21;0
WireConnection;18;1;16;0
WireConnection;25;0;16;0
WireConnection;25;1;18;0
WireConnection;25;2;23;0
WireConnection;25;3;22;0
WireConnection;26;1;25;0
WireConnection;72;1;79;0
WireConnection;58;0;72;0
WireConnection;58;1;60;0
WireConnection;58;2;61;0
WireConnection;28;0;25;0
WireConnection;28;1;26;0
WireConnection;28;2;30;0
WireConnection;28;3;29;0
WireConnection;31;1;28;0
WireConnection;49;0;58;0
WireConnection;49;1;72;0
WireConnection;73;0;50;0
WireConnection;33;1;80;0
WireConnection;32;0;33;0
WireConnection;32;1;31;0
WireConnection;45;0;44;0
WireConnection;45;1;46;0
WireConnection;54;0;49;0
WireConnection;54;1;73;0
WireConnection;0;0;32;0
WireConnection;0;1;45;0
WireConnection;0;2;54;0
WireConnection;0;14;63;0
ASEEND*/
//CHKSM=FFBE66CF2203D1743D631B9C5ECCB7B31BFD341A
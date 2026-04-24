// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Alley Wall"
{
	Properties
	{
		_Displacement("Displacement", 2D) = "white" {}
		_Scalefloat("Scale float", Range( 0 , 0.1)) = 0.1
		_Albedo("Albedo", 2D) = "white" {}
		_Normal("Normal", 2D) = "white" {}
		_AO("AO", 2D) = "white" {}
		_GlobalTiling1("Global Tiling ", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
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

		uniform sampler2D _Normal;
		uniform float2 _GlobalTiling1;
		uniform sampler2D _Albedo;
		uniform sampler2D _Displacement;
		uniform float _Scalefloat;
		uniform sampler2D _AO;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, 0.0);
		}

		void vertexDataFunc( inout appdata_full v )
		{
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord63 = i.uv_texcoord * _GlobalTiling1;
			float2 GlobalUV64 = uv_TexCoord63;
			o.Normal = tex2D( _Normal, GlobalUV64 ).rgb;
			float2 GlobalUV69 = float2( 0,0 );
			float Scalefloat12 = _Scalefloat;
			float3 Viewdir10 = i.viewDir;
			float2 Offset13 = ( ( tex2D( _Displacement, GlobalUV69 ).r - 1 ) * Viewdir10.xy * Scalefloat12 ) + GlobalUV64;
			float2 Offset19 = ( ( tex2D( _Displacement, Offset13 ).r - 1 ) * Viewdir10.xy * Scalefloat12 ) + Offset13;
			float2 Offset23 = ( ( tex2D( _Displacement, Offset19 ).r - 1 ) * Viewdir10.xy * Scalefloat12 ) + Offset19;
			float2 Offset28 = ( ( tex2D( _Displacement, Offset23 ).r - 1 ) * Viewdir10.xy * Scalefloat12 ) + Offset23;
			o.Albedo = ( tex2D( _Albedo, GlobalUV64 ) * tex2D( _Displacement, Offset28 ) ).rgb;
			o.Occlusion = tex2D( _AO, GlobalUV64 ).r;
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
0;73.6;823;415.8;1508.846;188.9212;2.21925;True;False
Node;AmplifyShaderEditor.Vector2Node;62;-3870.658,-835.2252;Inherit;False;Property;_GlobalTiling1;Global Tiling ;7;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;63;-3720.275,-859.8125;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;1;-3323.734,-933.8166;Inherit;False;942.48;774.4534;Comment;8;13;12;11;10;8;7;65;69;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;64;-3518.183,-862.8771;Inherit;False;GlobalUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;69;-3309.788,-836.6825;Inherit;False;GlobalUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;7;-3069.659,-344.9625;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;8;-3166.374,-466.2831;Inherit;False;Property;_Scalefloat;Scale float;1;0;Create;True;0;0;0;False;0;False;0.1;0.2;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;10;-2833.213,-292.7142;Inherit;False;Viewdir;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;11;-3311.331,-773.7136;Inherit;True;Property;_Displacement;Displacement;0;0;Create;True;0;0;0;False;0;False;-1;5427c7c46a258e643ac3fc5305f0fb97;5427c7c46a258e643ac3fc5305f0fb97;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;65;-2791.743,-872.843;Inherit;False;64;GlobalUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;12;-2909.145,-470.525;Inherit;False;Scalefloat;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ParallaxMappingNode;13;-2632.055,-701.2172;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;14;-2316.008,-774.3779;Inherit;False;596.4314;455.3682;Comment;4;19;17;16;15;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;17;-2156.584,-434.4095;Inherit;False;10;Viewdir;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;15;-2315.168,-717.0049;Inherit;True;Property;_TextureSample2;Texture Sample 2;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;11;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;16;-2156.352,-511.6754;Inherit;False;12;Scalefloat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ParallaxMappingNode;19;-1970.376,-724.3779;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;18;-2309.828,-291.9945;Inherit;False;588.8162;450.1386;Comment;4;23;22;21;20;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;21;-2152.557,-34.52161;Inherit;False;12;Scalefloat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;20;-2152.79,42.74426;Inherit;False;10;Viewdir;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;22;-2259.828,-232.5812;Inherit;True;Property;_TextureSample3;Texture Sample 3;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;11;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;24;-1663.084,-295.7506;Inherit;False;939.4424;488.2018;Comment;5;30;28;27;26;25;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ParallaxMappingNode;23;-1971.809,-241.9945;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;27;-1495.347,47.35309;Inherit;False;10;Viewdir;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;26;-1499.075,-20.01391;Inherit;False;12;Scalefloat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;25;-1613.084,-227.1405;Inherit;True;Property;_TextureSample4;Texture Sample 4;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;11;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;66;-1444.207,-560.2129;Inherit;False;64;GlobalUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;29;-1268.679,-604.8375;Inherit;False;544.0029;291.5407;Comment;2;34;31;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;37;-1667.841,216.7771;Inherit;False;595.0409;420.3595;Comment;3;42;41;67;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ParallaxMappingNode;28;-1268.833,-207.6884;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;31;-1218.679,-554.8373;Inherit;True;Property;_Albedo;Albedo;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;67;-1556.348,465.5443;Inherit;False;64;GlobalUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;41;-1617.841,269.5356;Inherit;True;Property;_Normal;Normal;3;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;30;-1045.242,-245.7506;Inherit;True;Property;_TextureSample5;Texture Sample 5;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;11;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;68;-1509.506,681.4091;Inherit;False;64;GlobalUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.EdgeLengthTessNode;50;7.00942,417.4329;Inherit;False;1;0;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-887.077,-447.0966;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;61;-1335.088,660.8115;Inherit;True;Property;_AO;AO;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;42;-1389.344,266.7773;Inherit;True;Property;_TextureSample6;Texture Sample 6;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Alley Wall;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;63;0;62;0
WireConnection;64;0;63;0
WireConnection;10;0;7;0
WireConnection;11;1;69;0
WireConnection;12;0;8;0
WireConnection;13;0;65;0
WireConnection;13;1;11;0
WireConnection;13;2;12;0
WireConnection;13;3;10;0
WireConnection;15;1;13;0
WireConnection;19;0;13;0
WireConnection;19;1;15;0
WireConnection;19;2;16;0
WireConnection;19;3;17;0
WireConnection;22;1;19;0
WireConnection;23;0;19;0
WireConnection;23;1;22;0
WireConnection;23;2;21;0
WireConnection;23;3;20;0
WireConnection;25;1;23;0
WireConnection;28;0;23;0
WireConnection;28;1;25;0
WireConnection;28;2;26;0
WireConnection;28;3;27;0
WireConnection;31;1;66;0
WireConnection;30;1;28;0
WireConnection;34;0;31;0
WireConnection;34;1;30;0
WireConnection;61;1;68;0
WireConnection;42;0;41;0
WireConnection;42;1;67;0
WireConnection;0;0;34;0
WireConnection;0;1;42;0
WireConnection;0;5;61;0
WireConnection;0;14;50;0
ASEEND*/
//CHKSM=9FB0EFC9F0321AF9E8B9D46C55FEACB392470D19
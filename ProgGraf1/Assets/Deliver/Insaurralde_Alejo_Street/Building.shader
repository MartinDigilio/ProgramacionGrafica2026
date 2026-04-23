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
		_Vector0("Vector 0", Vector) = (5,5,1,1)
		_Float0("Float 0", Float) = 0
		_Float1("Float 1", Float) = 0.6
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
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
		};

		uniform sampler2D _Texture0;
		uniform float4 _Vector0;
		uniform sampler2D _TextureSample5;
		uniform float4 _TextureSample5_ST;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float _Scalefloat;
		uniform float _Float0;
		uniform float _Float1;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 appendResult40 = (float2(_Vector0.x , _Vector0.y));
			float2 appendResult41 = (float2(_Vector0.z , _Vector0.w));
			float2 ScaleOffset43 = (i.uv_texcoord*appendResult40 + appendResult41);
			o.Normal = tex2D( _Texture0, ScaleOffset43 ).rgb;
			float2 uv_TextureSample5 = i.uv_texcoord * _TextureSample5_ST.xy + _TextureSample5_ST.zw;
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float Scalefloat8 = _Scalefloat;
			float3 Viewdir10 = i.viewDir;
			float2 Offset4 = ( ( tex2D( _TextureSample0, uv_TextureSample0 ).r - 1 ) * Viewdir10.xy * Scalefloat8 ) + ScaleOffset43;
			float2 Offset16 = ( ( tex2D( _TextureSample0, Offset4 ).r - 1 ) * Viewdir10.xy * Scalefloat8 ) + Offset4;
			float2 Offset25 = ( ( tex2D( _TextureSample0, Offset16 ).r - 1 ) * Viewdir10.xy * Scalefloat8 ) + Offset16;
			float2 Offset28 = ( ( tex2D( _TextureSample0, Offset25 ).r - 1 ) * Viewdir10.xy * Scalefloat8 ) + Offset25;
			float4 temp_output_32_0 = ( tex2D( _TextureSample5, uv_TextureSample5 ) * tex2D( _TextureSample0, Offset28 ) );
			o.Albedo = temp_output_32_0.rgb;
			float4 temp_cast_17 = (_Float0).xxxx;
			float4 temp_cast_18 = (_Float1).xxxx;
			float4 smoothstepResult58 = smoothstep( temp_cast_17 , temp_cast_18 , temp_output_32_0);
			o.Emission = ( ( smoothstepResult58 * temp_output_32_0 ) * float4(1.937173,2,0,0) ).rgb;
			o.Alpha = 1;
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
0;73.6;868.6;286.2;1835.278;307.3633;3.035625;False;False
Node;AmplifyShaderEditor.CommentaryNode;34;-3300.377,-664.8241;Inherit;False;942.48;774.4534;Comment;8;7;6;2;10;8;1;4;43;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector4Node;39;-3293.951,-927.868;Inherit;False;Property;_Vector0;Vector 0;4;0;Create;True;0;0;0;False;0;False;5,5,1,1;5,5,1,1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;41;-3066.202,-827.9755;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-2965.996,-621.3039;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;40;-3069.017,-958.9955;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;42;-2749.168,-789.0645;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;7;-3046.302,-75.97013;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;6;-3143.017,-197.2905;Inherit;False;Property;_Scalefloat;Scale float;1;0;Create;True;0;0;0;False;0;False;0.5439783;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;43;-2717.429,-594.9937;Inherit;False;ScaleOffset;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;10;-2809.855,-23.72165;Inherit;False;Viewdir;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;2;-3250.377,-614.8241;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;8;-2885.788,-201.5326;Inherit;False;Scalefloat;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ParallaxMappingNode;4;-2608.697,-432.2246;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;35;-2292.65,-505.3855;Inherit;False;596.4314;455.3682;Comment;4;19;21;5;16;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;5;-2242.65,-445.9641;Inherit;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;2;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;19;-2132.995,-242.683;Inherit;False;8;Scalefloat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;21;-2133.227,-165.4171;Inherit;False;10;Viewdir;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;36;-2286.471,-23.00194;Inherit;False;588.8162;450.1386;Comment;4;18;23;22;25;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ParallaxMappingNode;16;-1947.019,-455.3855;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;22;-2129.433,311.7367;Inherit;False;10;Viewdir;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;23;-2129.2,234.4708;Inherit;False;8;Scalefloat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;18;-2236.471,36.4113;Inherit;True;Property;_TextureSample2;Texture Sample 2;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;2;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ParallaxMappingNode;25;-1948.452,26.99806;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;37;-1639.727,-26.75817;Inherit;False;939.4424;488.2018;Comment;5;31;26;30;29;28;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;26;-1589.727,41.85202;Inherit;True;Property;_TextureSample3;Texture Sample 3;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;2;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;30;-1426.221,268.7771;Inherit;False;8;Scalefloat;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;29;-1426.453,346.0434;Inherit;False;10;Viewdir;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ParallaxMappingNode;28;-1245.475,61.30414;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;38;-1245.322,-335.8449;Inherit;False;544.0029;291.5407;Comment;2;32;33;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;31;-1021.885,23.24179;Inherit;True;Property;_TextureSample4;Texture Sample 4;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;2;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;33;-1195.322,-285.8448;Inherit;True;Property;_TextureSample5;Texture Sample 5;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;60;-700.0849,527.3815;Inherit;False;Property;_Float0;Float 0;6;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-696.085,589.3815;Inherit;False;Property;_Float1;Float 1;7;0;Create;True;0;0;0;False;0;False;0.6;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-863.7196,-178.1041;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;50;-883.6782,669.1841;Inherit;False;Constant;_Color0;Color 0;9;1;[HDR];Create;True;0;0;0;False;0;False;1.937173,2,0,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;58;-571.8406,504.3272;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;47;-1644.483,485.7695;Inherit;False;595.0409;420.3595;Comment;3;44;46;45;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-393.3706,447.2972;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;57;-403.0705,683.165;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;46;-1553.105,790.7292;Inherit;False;43;ScaleOffset;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;44;-1594.483,538.528;Inherit;True;Property;_Texture0;Texture 0;3;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.EdgeLengthTessNode;63;-13.83484,459.7394;Inherit;False;1;0;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;45;-1371.042,535.7697;Inherit;True;Property;_TextureSample6;Texture Sample 6;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;48;-969.9127,483.7452;Inherit;True;Property;_TextureSample7;Texture Sample 7;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-272.5064,447.0659;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Building;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;41;0;39;3
WireConnection;41;1;39;4
WireConnection;40;0;39;1
WireConnection;40;1;39;2
WireConnection;42;0;1;0
WireConnection;42;1;40;0
WireConnection;42;2;41;0
WireConnection;43;0;42;0
WireConnection;10;0;7;0
WireConnection;8;0;6;0
WireConnection;4;0;43;0
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
WireConnection;28;0;25;0
WireConnection;28;1;26;0
WireConnection;28;2;30;0
WireConnection;28;3;29;0
WireConnection;31;1;28;0
WireConnection;32;0;33;0
WireConnection;32;1;31;0
WireConnection;58;0;32;0
WireConnection;58;1;60;0
WireConnection;58;2;61;0
WireConnection;49;0;58;0
WireConnection;49;1;32;0
WireConnection;57;0;50;0
WireConnection;45;0;44;0
WireConnection;45;1;46;0
WireConnection;48;1;28;0
WireConnection;54;0;49;0
WireConnection;54;1;57;0
WireConnection;0;0;32;0
WireConnection;0;1;45;0
WireConnection;0;2;54;0
WireConnection;0;14;63;0
ASEEND*/
//CHKSM=AB8A76E28DC42CE3A88734B2B6FCE118BE1AE1E9
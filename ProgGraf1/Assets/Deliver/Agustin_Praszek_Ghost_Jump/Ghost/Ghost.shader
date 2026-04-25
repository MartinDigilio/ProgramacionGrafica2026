// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Ghost"
{
	Properties
	{
		_Speed("Speed", Float) = 1
		_Tiling("Tiling", Vector) = (5,5,0,0)
		_Offset("Offset", Float) = 0.13
		_OffsetEmisive("OffsetEmisive", Float) = 0.13
		_fantasmano("fantasmano", 2D) = "white" {}
		_Speedoscilacion("Speed oscilacion", Float) = 0.2
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform float _Speedoscilacion;
		uniform float2 _Tiling;
		uniform float _Speed;
		uniform sampler2D _fantasmano;
		uniform float4 _fantasmano_ST;
		uniform float _OffsetEmisive;
		uniform float _Offset;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float temp_output_46_0 = sin( ( _Time.y * _Speedoscilacion ) );
			float4 appendResult50 = (float4(temp_output_46_0 , ( temp_output_46_0 * 0.1 ) , 0.0 , 0.0));
			float4 Oscilacion48 = appendResult50;
			v.vertex.xyz += Oscilacion48.xyz;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float mulTime3 = _Time.y * _Speed;
			float2 panner5 = ( mulTime3 * float2( 0,1 ) + float2( 0,0 ));
			float2 uv_TexCoord6 = i.uv_texcoord * _Tiling + panner5;
			float simplePerlin2D8 = snoise( uv_TexCoord6 );
			simplePerlin2D8 = simplePerlin2D8*0.5 + 0.5;
			float Noise10 = ( simplePerlin2D8 + 0.5 );
			float4 temp_cast_0 = (Noise10).xxxx;
			float2 uv_fantasmano = i.uv_texcoord * _fantasmano_ST.xy + _fantasmano_ST.zw;
			float4 color26 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float smoothstepResult25 = smoothstep( 0.0 , 1.0 , ( ase_vertex3Pos.y + _OffsetEmisive ));
			float4 lerpResult27 = lerp( float4( 0,0,0,0 ) , color26 , smoothstepResult25);
			float4 Emissive28 = lerpResult27;
			float4 lerpResult67 = lerp( temp_cast_0 , tex2D( _fantasmano, uv_fantasmano ) , Emissive28);
			float4 Emission33 = lerpResult67;
			o.Albedo = Emission33.rgb;
			float4 color16 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
			float smoothstepResult14 = smoothstep( 0.0 , 1.0 , ( ase_vertex3Pos.y + _Offset ));
			float4 lerpResult15 = lerp( float4( 0,0,0,0 ) , color16 , smoothstepResult14);
			float4 Opacity17 = lerpResult15;
			o.Alpha = Opacity17.r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

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
				vertexDataFunc( v, customInputData );
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
				surfIN.worldPos = worldPos;
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
0.8;80.8;479;410.2;897.6552;1187.254;2.342118;False;False
Node;AmplifyShaderEditor.CommentaryNode;1;-2712.622,-830.1302;Inherit;False;1875.911;692.5382;Comment;9;9;8;7;6;5;4;3;2;10;Noise;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-2662.622,-396.5918;Inherit;True;Property;_Speed;Speed;0;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;3;-2463.427,-391.7918;Inherit;True;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;32;-2714.228,393.4028;Inherit;False;1159.56;498.7858;offsetEmission;8;22;24;26;25;27;28;23;57;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;4;-2237.826,-678.1883;Inherit;True;Property;_Tiling;Tiling;1;0;Create;True;0;0;0;False;0;False;5,5;5,5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;5;-2234.624,-409.3888;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-2664.073,761.9623;Inherit;False;Property;_OffsetEmisive;OffsetEmisive;3;0;Create;True;0;0;0;False;0;False;0.13;0.13;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;22;-2696.228,615.4819;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-1933.673,-681.1014;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;24;-2423.074,618.9622;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;53;-2710.375,910.8779;Inherit;False;969.12;283.4825;Oscilacion;8;47;44;45;46;52;51;50;48;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1596.991,-509.8943;Inherit;True;Constant;_Booster;Booster;3;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;25;-2207.075,629.9622;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;8;-1606.663,-780.1302;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-2663.875,1055.43;Inherit;False;Property;_Speedoscilacion;Speed oscilacion;5;0;Create;True;0;0;0;False;0;False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;26;-2243.25,452.2035;Inherit;False;Constant;_Color1;Color 1;2;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;44;-2656.475,982.1307;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;31;-2715.829,-124.9497;Inherit;False;1159.56;498.7856;Opacity;7;11;13;12;14;16;15;17;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-2665.675,243.6096;Inherit;False;Property;_Offset;Offset;2;0;Create;True;0;0;0;False;0;False;0.13;0.13;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-2490.375,983.4306;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;27;-1975.409,601.5211;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PosVertexDataNode;11;-2665.829,104.1293;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;9;-1301.592,-649.6964;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;10;-1109.219,-624.8115;Inherit;True;Noise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-2383.026,1078.96;Inherit;False;Constant;_ValorenY;Valor en Y;4;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-2424.675,100.6097;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;69;-1543.642,-114.7938;Inherit;False;732.5052;688.5793;Albedo;5;30;68;33;67;19;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SinOpNode;46;-2360.375,986.4306;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;28;-1778.667,633.1886;Inherit;True;Emissive;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;19;-1477.548,-68.87804;Inherit;True;10;Noise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;16;-2232.145,-74.94972;Inherit;False;Constant;_Color0;Color 0;2;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;30;-1458.089,343.7855;Inherit;True;28;Emissive;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;14;-2208.675,111.6097;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;68;-1516.105,135.1165;Inherit;True;Property;_fantasmano;fantasmano;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-2245.046,1056.606;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;15;-1964.602,98.47852;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;50;-2108.748,962.0439;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;67;-1232.411,44.96781;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;17;-1780.269,114.836;Inherit;True;Opacity;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;48;-1966.054,960.8779;Inherit;False;Oscilacion;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;-1058.4,-42.69231;Inherit;True;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;35;-417.0841,-805.0383;Inherit;True;33;Emission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;49;-377.443,-393.4826;Inherit;False;48;Oscilacion;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;18;-411.7115,-594.8304;Inherit;True;17;Opacity;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;57;-2687.401,446.3169;Inherit;False;SphereMask;-1;;1;988803ee12caf5f4690caee3c8c4a5bb;0;3;15;FLOAT3;0,0,0;False;14;FLOAT;0;False;12;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-165.95,-806.3055;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Ghost;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;3;0;2;0
WireConnection;5;1;3;0
WireConnection;6;0;4;0
WireConnection;6;1;5;0
WireConnection;24;0;22;2
WireConnection;24;1;23;0
WireConnection;25;0;24;0
WireConnection;8;0;6;0
WireConnection;45;0;44;0
WireConnection;45;1;47;0
WireConnection;27;1;26;0
WireConnection;27;2;25;0
WireConnection;9;0;8;0
WireConnection;9;1;7;0
WireConnection;10;0;9;0
WireConnection;12;0;11;2
WireConnection;12;1;13;0
WireConnection;46;0;45;0
WireConnection;28;0;27;0
WireConnection;14;0;12;0
WireConnection;51;0;46;0
WireConnection;51;1;52;0
WireConnection;15;1;16;0
WireConnection;15;2;14;0
WireConnection;50;0;46;0
WireConnection;50;1;51;0
WireConnection;67;0;19;0
WireConnection;67;1;68;0
WireConnection;67;2;30;0
WireConnection;17;0;15;0
WireConnection;48;0;50;0
WireConnection;33;0;67;0
WireConnection;57;15;22;0
WireConnection;0;0;35;0
WireConnection;0;9;18;0
WireConnection;0;11;49;0
ASEEND*/
//CHKSM=64411B312660F4368C9241385DCE7F9F9566E5D4
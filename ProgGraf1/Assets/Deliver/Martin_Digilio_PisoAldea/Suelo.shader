// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Suelo"
{
	Properties
	{
		_Piso("Piso", 2D) = "white" {}
		_Tierra("Tierra", 2D) = "white" {}
		_TierraHeight("TierraHeight", 2D) = "white" {}
		_PisoHeight("PisoHeight", 2D) = "white" {}
		_TierraHeightValue("TierraHeightValue", Float) = 0
		_PisoHeightValue("PisoHeightValue", Float) = 0
		_clampHeight("clampHeight", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _PisoHeight;
		uniform float4 _PisoHeight_ST;
		uniform float _PisoHeightValue;
		uniform sampler2D _TierraHeight;
		uniform float4 _TierraHeight_ST;
		uniform float _TierraHeightValue;
		uniform float _clampHeight;
		uniform sampler2D _Piso;
		uniform float4 _Piso_ST;
		uniform sampler2D _Tierra;
		uniform float4 _Tierra_ST;


		float2 voronoihash6( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi6( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash6( n + g );
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
float2 o = voronoihash6( n + g );
		o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
float d = dot( 0.5 * ( r + mr ), normalize( r - mr ) );
F1 = min( F1, d );
}
}
return F1;
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, 0.0);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 uv_PisoHeight = v.texcoord * _PisoHeight_ST.xy + _PisoHeight_ST.zw;
			float2 uv_TierraHeight = v.texcoord * _TierraHeight_ST.xy + _TierraHeight_ST.zw;
			float time6 = 31.8;
			float2 coords6 = v.texcoord.xy * 39.7;
			float2 id6 = 0;
			float2 uv6 = 0;
			float voroi6 = voronoi6( coords6, time6, id6, uv6, 0 );
			float smoothstepResult8 = smoothstep( 0.0 , 0.79 , voroi6);
			float4 lerpResult19 = lerp( ( tex2Dlod( _PisoHeight, float4( uv_PisoHeight, 0, 0.0) ) * float4( float3(0,1,0) , 0.0 ) * _PisoHeightValue ) , ( tex2Dlod( _TierraHeight, float4( uv_TierraHeight, 0, 0.0) ) * float4( float3(0,1,0) , 0.0 ) * _TierraHeightValue ) , smoothstepResult8);
			float4 break20 = lerpResult19;
			float clampResult22 = clamp( break20.g , 0.0 , _clampHeight );
			float4 appendResult21 = (float4(break20.r , clampResult22 , break20.b , 0.0));
			v.vertex.xyz += appendResult21.xyz;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Piso = i.uv_texcoord * _Piso_ST.xy + _Piso_ST.zw;
			float2 uv_Tierra = i.uv_texcoord * _Tierra_ST.xy + _Tierra_ST.zw;
			float time6 = 31.8;
			float2 coords6 = i.uv_texcoord * 39.7;
			float2 id6 = 0;
			float2 uv6 = 0;
			float voroi6 = voronoi6( coords6, time6, id6, uv6, 0 );
			float smoothstepResult8 = smoothstep( 0.0 , 0.79 , voroi6);
			float4 lerpResult5 = lerp( tex2D( _Piso, uv_Piso ) , tex2D( _Tierra, uv_Tierra ) , smoothstepResult8);
			o.Albedo = lerpResult5.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;73.6;483.8;701.8;890.4587;86.6031;1;False;False
Node;AmplifyShaderEditor.TexturePropertyNode;14;-1157.627,1261.17;Inherit;True;Property;_PisoHeight;PisoHeight;3;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;9;-1163.498,662.1688;Inherit;True;Property;_TierraHeight;TierraHeight;2;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.Vector3Node;17;-795.7239,1468.112;Inherit;False;Constant;_Vector1;Vector 1;3;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;13;-819.3683,1041.183;Inherit;False;Property;_TierraHeightValue;TierraHeightValue;4;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;10;-909.8171,662.7326;Inherit;True;Property;_TextureSample2;Texture Sample 2;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;6;-729.2034,254.807;Inherit;False;0;0;1;4;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;31.8;False;2;FLOAT;39.7;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SamplerNode;15;-903.9458,1261.734;Inherit;True;Property;_TextureSample3;Texture Sample 3;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;12;-801.5952,869.1104;Inherit;False;Constant;_Vector0;Vector 0;3;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;18;-722.1416,1641.246;Inherit;False;Property;_PisoHeightValue;PisoHeightValue;5;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;8;-478.69,241.2173;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.79;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-535.6068,758.29;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-529.7355,1357.291;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;19;-131.4846,1065.065;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;23;65.21408,1343.18;Inherit;False;Property;_clampHeight;clampHeight;6;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;20;96.47726,1062.93;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TexturePropertyNode;1;-948.4697,-268.8388;Inherit;True;Property;_Piso;Piso;0;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;2;-1117.741,-2.825439;Inherit;True;Property;_Tierra;Tierra;1;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;3;-670.6547,-234.5148;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-762.8839,34.48563;Inherit;True;Property;_TextureSample1;Texture Sample 1;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;22;266.5038,1198.107;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.EdgeLengthTessNode;24;636.7419,854.0696;Inherit;False;1;0;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;5;-164.5496,29.22412;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;21;405.0371,1031.229;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;684.3588,239.3854;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Suelo;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;10;0;9;0
WireConnection;15;0;14;0
WireConnection;8;0;6;0
WireConnection;11;0;10;0
WireConnection;11;1;12;0
WireConnection;11;2;13;0
WireConnection;16;0;15;0
WireConnection;16;1;17;0
WireConnection;16;2;18;0
WireConnection;19;0;16;0
WireConnection;19;1;11;0
WireConnection;19;2;8;0
WireConnection;20;0;19;0
WireConnection;3;0;1;0
WireConnection;4;0;2;0
WireConnection;22;0;20;1
WireConnection;22;2;23;0
WireConnection;5;0;3;0
WireConnection;5;1;4;0
WireConnection;5;2;8;0
WireConnection;21;0;20;0
WireConnection;21;1;22;0
WireConnection;21;2;20;2
WireConnection;0;0;5;0
WireConnection;0;11;21;0
WireConnection;0;14;24;0
ASEEND*/
//CHKSM=DC35FEBD57B88221FCB50D65A26099D6F3C17F29
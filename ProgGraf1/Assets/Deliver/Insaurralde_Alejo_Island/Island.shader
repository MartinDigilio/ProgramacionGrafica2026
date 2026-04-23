// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Island"
{
	Properties
	{
		_Heightmap("Heightmap", 2D) = "white" {}
		_Float0("Float 0", Float) = 0
		_clampmax("clamp max", Float) = 15
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

		uniform sampler2D _Heightmap;
		uniform float4 _Heightmap_ST;
		uniform float _Float0;
		uniform float _clampmax;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, 0.0);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 uv_Heightmap = v.texcoord * _Heightmap_ST.xy + _Heightmap_ST.zw;
			float4 tex2DNode3 = tex2Dlod( _Heightmap, float4( uv_Heightmap, 0, 0.0) );
			float4 temp_cast_1 = (_clampmax).xxxx;
			float4 clampResult7 = clamp( ( tex2DNode3 * float4( float3(0,1,0) , 0.0 ) * _Float0 ) , float4( 0,0,0,0 ) , temp_cast_1 );
			v.vertex.xyz += clampResult7.rgb;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color15 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			float4 color14 = IsGammaSpace() ? float4(0.8679245,0.3055415,0,0) : float4(0.7254258,0.07601279,0,0);
			float2 uv_Heightmap = i.uv_texcoord * _Heightmap_ST.xy + _Heightmap_ST.zw;
			float4 tex2DNode3 = tex2D( _Heightmap, uv_Heightmap );
			float4 temp_cast_0 = (0.01).xxxx;
			float4 lerpResult12 = lerp( color15 , color14 , (float4( 0,0,0,0 ) + (tex2DNode3 - temp_cast_0) * (float4( 1,1,1,1 ) - float4( 0,0,0,0 )) / (float4( 1,1,1,1 ) - temp_cast_0)));
			o.Albedo = lerpResult12.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
1536;73.6;829.4;479.8;914.5522;261.3185;1;True;False
Node;AmplifyShaderEditor.TexturePropertyNode;2;-1131.283,-18.37878;Inherit;True;Property;_Heightmap;Heightmap;0;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;3;-905.7133,-35.85269;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;4;-733.1041,192.4948;Inherit;False;Constant;_Vector0;Vector 0;3;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;5;-733.921,355.1761;Inherit;False;Property;_Float0;Float 0;1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-398.7959,-53.85178;Inherit;False;Constant;_Float1;Float 1;3;0;Create;True;0;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-573.7118,-23.93928;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-395.2088,160.8523;Inherit;False;Property;_clampmax;clamp max;2;0;Create;True;0;0;0;False;0;False;15;15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;14;-595.5751,-402.125;Inherit;False;Constant;_Color0;Color 0;3;0;Create;True;0;0;0;False;0;False;0.8679245,0.3055415,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;15;-538.07,-572.5471;Inherit;False;Constant;_Color1;Color 1;3;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;16;-389.1568,-207.2583;Inherit;False;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;3;COLOR;0,0,0,0;False;4;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.EdgeLengthTessNode;1;-294.1555,254.9743;Inherit;False;1;0;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ClampOpNode;7;-329.9076,54.21477;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;12;-106.4937,-317.4851;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Island;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;3;0;2;0
WireConnection;6;0;3;0
WireConnection;6;1;4;0
WireConnection;6;2;5;0
WireConnection;16;0;3;0
WireConnection;16;1;17;0
WireConnection;7;0;6;0
WireConnection;7;2;10;0
WireConnection;12;0;15;0
WireConnection;12;1;14;0
WireConnection;12;2;16;0
WireConnection;0;0;12;0
WireConnection;0;11;7;0
WireConnection;0;14;1;0
ASEEND*/
//CHKSM=F5587C5C722543AC9A0AADBAE2060A70A86A8279
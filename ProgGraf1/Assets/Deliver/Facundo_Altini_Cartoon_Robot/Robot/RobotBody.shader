// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "RobotBody"
{
	Properties
	{
		_Float0("Float 0", Range( 0 , 1)) = 0
		_Float1("Float 1", Range( 0 , 1)) = 0
		_Shirts_textureSet_BaseColor("Shirts_textureSet_BaseColor", 2D) = "white" {}
		_Shirts_textureSet_Normal("Shirts_textureSet_Normal", 2D) = "bump" {}
		_Float2("Float 2", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Shirts_textureSet_Normal;
		uniform float4 _Shirts_textureSet_Normal_ST;
		uniform sampler2D _Shirts_textureSet_BaseColor;
		uniform float4 _Shirts_textureSet_BaseColor_ST;
		uniform float _Float2;
		uniform float _Float0;
		uniform float _Float1;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Shirts_textureSet_Normal = i.uv_texcoord * _Shirts_textureSet_Normal_ST.xy + _Shirts_textureSet_Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Shirts_textureSet_Normal, uv_Shirts_textureSet_Normal ) );
			float2 uv_Shirts_textureSet_BaseColor = i.uv_texcoord * _Shirts_textureSet_BaseColor_ST.xy + _Shirts_textureSet_BaseColor_ST.zw;
			o.Albedo = ( tex2D( _Shirts_textureSet_BaseColor, uv_Shirts_textureSet_BaseColor ) * _Float2 ).rgb;
			o.Metallic = _Float0;
			o.Smoothness = _Float1;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;479.5;887.5;379.5;1237.163;246.7014;2.102135;True;False
Node;AmplifyShaderEditor.SamplerNode;7;-696.4019,-226.2822;Inherit;True;Property;_Shirts_textureSet_BaseColor;Shirts_textureSet_BaseColor;2;0;Create;True;0;0;0;False;0;False;-1;70c821359fc52be4ba055b7d7f7c3b69;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;17;-620.0947,30.77554;Inherit;False;Property;_Float2;Float 2;4;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-93.45038,331.448;Inherit;False;Property;_Float1;Float 1;1;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-167.0625,-85.95955;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;11;-801.5945,168.7041;Inherit;True;Property;_Shirts_textureSet_Normal;Shirts_textureSet_Normal;3;0;Create;True;0;0;0;False;0;False;-1;a389cb3acbfc9084ba83a1552bd6c3bd;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2;-95.03979,251.9771;Inherit;False;Property;_Float0;Float 0;0;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;13;315.8267,357.7626;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;14;420.2683,-27.02194;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;494.1468,21.98768;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;RobotBody;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;10;0;7;0
WireConnection;10;1;17;0
WireConnection;13;0;3;0
WireConnection;14;0;10;0
WireConnection;0;0;14;0
WireConnection;0;1;11;0
WireConnection;0;3;2;0
WireConnection;0;4;13;0
ASEEND*/
//CHKSM=915BA0A4CFA7D4AEBB26FCA53C2760C9269CBB43
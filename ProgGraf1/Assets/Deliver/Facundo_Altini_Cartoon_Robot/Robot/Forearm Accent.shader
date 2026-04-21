// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Forearm Accent"
{
	Properties
	{
		_Color0("Color 0", Color) = (0.05958529,0.2418133,0.9716981,0)
		_Float0("Float 0", Range( 0 , 1)) = 0
		_Float1("Float 1", Range( 0 , 1)) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			half filler;
		};

		uniform float4 _Color0;
		uniform float _Float0;
		uniform float _Float1;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Albedo = _Color0.rgb;
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
0;479.5;887.5;379.5;966.2248;16.63636;1.165128;True;False
Node;AmplifyShaderEditor.ColorNode;6;-530.75,-155.25;Inherit;False;Property;_Color0;Color 0;1;0;Create;True;0;0;0;False;0;False;0.05958529,0.2418133,0.9716981,0;0.05958529,0.2418133,0.9716981,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-601.325,34.207;Inherit;True;Property;_Shirts_textureSet_Normal;Shirts_textureSet_Normal;0;0;Create;True;0;0;0;False;0;False;-1;a389cb3acbfc9084ba83a1552bd6c3bd;a389cb3acbfc9084ba83a1552bd6c3bd;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;7;-556.4551,233.2193;Inherit;False;Property;_Float0;Float 0;2;0;Create;True;0;0;0;False;0;False;0;0.7;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-427.6375,323.3914;Inherit;False;Property;_Float1;Float 1;3;0;Create;True;0;0;0;False;0;False;0;0.8;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Forearm Accent;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;0;0;6;0
WireConnection;0;3;7;0
WireConnection;0;4;8;0
ASEEND*/
//CHKSM=6A8AE480EDCFE99AD0D7CC4C1EE4AC8EC819C7CA
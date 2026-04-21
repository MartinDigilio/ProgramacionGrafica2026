// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Arm Accent"
{
	Properties
	{
		_Shirts_textureSet_BaseColor("Shirts_textureSet_BaseColor", 2D) = "white" {}
		_Shirts_textureSet_Normal("Shirts_textureSet_Normal", 2D) = "bump" {}
		_Color0("Color 0", Color) = (0.3584906,0.3534176,0.3534176,0)
		_Float0("Float 0", Range( 0 , 1)) = 0
		_Float1("Float 1", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
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
			float2 uv_texcoord;
		};

		uniform sampler2D _Shirts_textureSet_Normal;
		uniform float4 _Shirts_textureSet_Normal_ST;
		uniform sampler2D _Shirts_textureSet_BaseColor;
		uniform float4 _Shirts_textureSet_BaseColor_ST;
		uniform float4 _Color0;
		uniform float _Float0;
		uniform float _Float1;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Shirts_textureSet_Normal = i.uv_texcoord * _Shirts_textureSet_Normal_ST.xy + _Shirts_textureSet_Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Shirts_textureSet_Normal, uv_Shirts_textureSet_Normal ) );
			float2 uv_Shirts_textureSet_BaseColor = i.uv_texcoord * _Shirts_textureSet_BaseColor_ST.xy + _Shirts_textureSet_BaseColor_ST.zw;
			o.Albedo = ( tex2D( _Shirts_textureSet_BaseColor, uv_Shirts_textureSet_BaseColor ) * _Color0 ).rgb;
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
0;479.5;887.5;379.5;1921.888;334.2067;2.557366;True;False
Node;AmplifyShaderEditor.ColorNode;3;-989.8649,-145.3744;Inherit;False;Property;_Color0;Color 0;2;0;Create;True;0;0;0;False;0;False;0.3584906,0.3534176,0.3534176,0;0.6226415,0.6020826,0.6020826,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-1058.602,-347.1813;Inherit;True;Property;_Shirts_textureSet_BaseColor;Shirts_textureSet_BaseColor;0;0;Create;True;0;0;0;False;0;False;-1;70c821359fc52be4ba055b7d7f7c3b69;70c821359fc52be4ba055b7d7f7c3b69;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-766.6743,-25.16731;Inherit;True;Property;_Shirts_textureSet_Normal;Shirts_textureSet_Normal;1;0;Create;True;0;0;0;False;0;False;-1;a389cb3acbfc9084ba83a1552bd6c3bd;a389cb3acbfc9084ba83a1552bd6c3bd;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-686.7141,-215.8747;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-688.4441,257.5227;Inherit;False;Property;_Float1;Float 1;4;0;Create;True;0;0;0;False;0;False;0;0.02346064;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-690.115,162.9401;Inherit;False;Property;_Float0;Float 0;3;0;Create;True;0;0;0;False;0;False;0;0.6008969;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Arm Accent;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;2;0
WireConnection;4;1;3;0
WireConnection;0;0;4;0
WireConnection;0;1;1;0
WireConnection;0;3;5;0
WireConnection;0;4;6;0
ASEEND*/
//CHKSM=4DA944D99F8A8D25981B467C7A761B36E3482565
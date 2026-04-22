// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Water"
{
	Properties
	{
		_WaveSpeed("Wave Speed", Float) = 1
		_WaveDirection("Wave Direction", Vector) = (1,0,0,0)
		_Tesselation("Tesselation", Float) = 1
		_WaveUp("Wave Up", Vector) = (0,1,0,0)
		_WaveHeight("Wave Height", Float) = 1
		_Smoothness("Smoothness", Float) = 0.9
		_TextureSample0("Texture Sample 0", 2D) = "bump" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float3 _WaveUp;
		uniform float _WaveHeight;
		uniform float _WaveSpeed;
		uniform float2 _WaveDirection;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float _Smoothness;
		uniform float _Tesselation;


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


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			float4 temp_cast_0 = (_Tesselation).xxxx;
			return temp_cast_0;
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float temp_output_46_0 = ( _Time.y * _WaveSpeed );
			float2 uv_TexCoord58 = v.texcoord.xy * float2( 5,15 );
			float2 panner43 = ( temp_output_46_0 * _WaveDirection + uv_TexCoord58);
			float simplePerlin2D41 = snoise( panner43 );
			float2 panner66 = ( temp_output_46_0 * _WaveDirection + uv_TexCoord58);
			float simplePerlin2D67 = snoise( panner66 );
			float temp_output_71_0 = ( simplePerlin2D41 + simplePerlin2D67 );
			float3 WaveHeight76 = ( ( _WaveUp * _WaveHeight ) * temp_output_71_0 );
			v.vertex.xyz += WaveHeight76;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			o.Normal = UnpackNormal( tex2D( _TextureSample0, uv_TextureSample0 ) );
			float4 color88 = IsGammaSpace() ? float4(0,0.4662966,0.8679245,0) : float4(0,0.1841611,0.7254258,0);
			float4 color89 = IsGammaSpace() ? float4(0,0.5764706,0.8666667,1) : float4(0,0.2917707,0.7230554,1);
			float temp_output_46_0 = ( _Time.y * _WaveSpeed );
			float2 uv_TexCoord58 = i.uv_texcoord * float2( 5,15 );
			float2 panner43 = ( temp_output_46_0 * _WaveDirection + uv_TexCoord58);
			float simplePerlin2D41 = snoise( panner43 );
			float2 panner66 = ( temp_output_46_0 * _WaveDirection + uv_TexCoord58);
			float simplePerlin2D67 = snoise( panner66 );
			float temp_output_71_0 = ( simplePerlin2D41 + simplePerlin2D67 );
			float WavePattern72 = temp_output_71_0;
			float clampResult94 = clamp( WavePattern72 , 0.0 , 1.0 );
			float4 lerpResult87 = lerp( color88 , color89 , clampResult94);
			float4 Albedo95 = lerpResult87;
			o.Albedo = Albedo95.rgb;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;73.6;859.8;489.4;510.9339;-194.6594;1;True;False
Node;AmplifyShaderEditor.SimpleTimeNode;45;-2349.38,963.231;Inherit;True;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-2253.418,1169.668;Inherit;True;Property;_WaveSpeed;Wave Speed;1;0;Create;True;0;0;0;False;0;False;1;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;44;-2185.324,698.4777;Inherit;True;Property;_WaveDirection;Wave Direction;2;0;Create;True;0;0;0;False;0;False;1,0;0,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;58;-2291.141,415.3755;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;5,15;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-2010.102,919.0449;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;66;-1584.629,1009.18;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;43;-1852.662,667.0078;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;41;-1605.18,667.3755;Inherit;True;Simplex2D;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;67;-1320.988,1002.474;Inherit;True;Simplex2D;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;71;-1031.914,874.869;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;97;-852.3288,-1282.013;Inherit;False;838.8765;565.4119;Comment;6;90;89;88;94;87;95;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;72;-797.2346,868.545;Inherit;False;WavePattern;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;90;-802.3288,-866.2112;Inherit;False;72;WavePattern;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-1479.377,273.9992;Inherit;False;Property;_WaveHeight;Wave Height;5;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;64;-1534.266,-29.34845;Inherit;True;Property;_WaveUp;Wave Up;4;0;Create;True;0;0;0;False;0;False;0,1,0;0,1,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;88;-785.1452,-1232.013;Inherit;False;Constant;_Watercolor;Water color;9;0;Create;True;0;0;0;False;0;False;0,0.4662966,0.8679245,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;94;-580.6961,-873.8014;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-1310.049,-29.45106;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;89;-791.9916,-1048.868;Inherit;False;Constant;_Topcolor;Top color;9;0;Create;True;0;0;0;False;0;False;0,0.5764706,0.8666667,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;87;-494.9601,-1037.842;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-1029.116,95.42697;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;95;-253.0095,-1047.675;Inherit;True;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;76;-880.3759,92.28159;Inherit;False;WaveHeight;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;79;-157.4836,97.86334;Inherit;False;Property;_Smoothness;Smoothness;6;0;Create;True;0;0;0;False;0;False;0.9;0.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;63;2.606448,410.9322;Inherit;False;Property;_Tesselation;Tesselation;3;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;77;-287.9088,276.9941;Inherit;False;76;WaveHeight;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;85;-512.1924,-29.26469;Inherit;True;Property;_TextureSample0;Texture Sample 0;7;0;Create;True;0;0;0;False;0;False;-1;None;cf284971540584c4ab7df95b708547e4;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;96;-208.3234,-238.143;Inherit;True;95;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Water;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;1;2.8;10;25;False;0.04;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;46;0;45;0
WireConnection;46;1;47;0
WireConnection;66;0;58;0
WireConnection;66;2;44;0
WireConnection;66;1;46;0
WireConnection;43;0;58;0
WireConnection;43;2;44;0
WireConnection;43;1;46;0
WireConnection;41;0;43;0
WireConnection;67;0;66;0
WireConnection;71;0;41;0
WireConnection;71;1;67;0
WireConnection;72;0;71;0
WireConnection;94;0;90;0
WireConnection;65;0;64;0
WireConnection;65;1;74;0
WireConnection;87;0;88;0
WireConnection;87;1;89;0
WireConnection;87;2;94;0
WireConnection;75;0;65;0
WireConnection;75;1;71;0
WireConnection;95;0;87;0
WireConnection;76;0;75;0
WireConnection;0;0;96;0
WireConnection;0;1;85;0
WireConnection;0;4;79;0
WireConnection;0;11;77;0
WireConnection;0;14;63;0
ASEEND*/
//CHKSM=7469F39E912CE62CA684B25004BA8BA3F7E77FB4
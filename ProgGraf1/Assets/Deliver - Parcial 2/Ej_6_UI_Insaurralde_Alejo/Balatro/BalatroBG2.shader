// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BalatroBG2"
{
	Properties
	{
		_PixelFilter("PixelFilter", Float) = 0
		_speed("speed", Float) = 2
		_Float3("Float 3", Float) = 2
		_Contrast("Contrast", Float) = 2
		_Color1("Color 1", Color) = (1,0,0,0)
		_Color2("Color 2", Color) = (0,0.07902622,1,0)
		_Color3("Color 3", Color) = (1,1,1,0)
		_SwirlScale("Swirl Scale", Float) = 2
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _Color1;
		uniform float4 _Color2;
		uniform float _PixelFilter;
		uniform float _speed;
		uniform float _SwirlScale;
		uniform float _Float3;
		uniform float _Contrast;
		uniform float4 _Color3;


		float2 MyCustomExpression89( float2 uv, float speed )
		{
			float2 uv2 = uv; // Initialize uv2
			for(int i=0; i < 5; i++) {
			    uv2 += sin(max(uv.x, uv.y)) + uv;
			    uv  += 0.5 * float2(cos(5.1123314 + 0.353 * uv2.y + speed * 0.131121),
			                         sin(uv2.x - 0.113 * speed));
			    uv  -= 1.0 * cos(uv.x + uv.y) - 1.0 * sin(uv.x * 0.711 - uv.y);
			}
			return uv;
		}


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 temp_cast_0 = (0.5).xx;
			float2 CenteredUV15_g1 = ( ( ( floor( ( i.uv_texcoord * _PixelFilter ) ) / _PixelFilter ) - temp_cast_0 ) - float2( 0,0 ) );
			float2 break17_g1 = CenteredUV15_g1;
			float2 appendResult23_g1 = (float2(( length( CenteredUV15_g1 ) * 1.0 * 2.0 ) , ( atan2( break17_g1.x , break17_g1.y ) * ( 1.0 / 6.28318548202515 ) * 1.0 )));
			float2 break79 = appendResult23_g1;
			float temp_output_80_0 = ( break79.y + ( _Time.y * _speed ) );
			float2 appendResult141 = (float2(cos( temp_output_80_0 ) , sin( temp_output_80_0 )));
			float2 uv89 = ( ( break79.x * appendResult141 ) * _SwirlScale );
			float speed89 = _Float3;
			float2 localMyCustomExpression89 = MyCustomExpression89( uv89 , speed89 );
			float Contrast102 = _Contrast;
			float clampResult95 = clamp( ( length( localMyCustomExpression89 ) * 0.035 * Contrast102 ) , 0.0 , 2.0 );
			float Paint_Res98 = clampResult95;
			float c2p114 = max( ( 1.0 - ( Paint_Res98 * Contrast102 ) ) , 0.0 );
			float4 lerpResult124 = lerp( _Color1 , _Color2 , c2p114);
			float c1p107 = max( ( 1.0 - ( abs( ( 1.0 - Paint_Res98 ) ) * Contrast102 ) ) , 0.0 );
			float clampResult117 = clamp( ( c1p107 + c2p114 ) , 0.0 , 1.0 );
			float c3p121 = ( 1.0 - clampResult117 );
			float4 lerpResult126 = lerp( lerpResult124 , _Color3 , c3p121);
			o.Emission = lerpResult126.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
252;72.8;904.8;393.4;2812.082;54.81847;1;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;67;-4873.221,-166.1825;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;69;-4821.528,-25.89255;Inherit;False;Property;_PixelFilter;PixelFilter;0;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-4574.527,-113.8925;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FloorOpNode;70;-4438.527,-112.8925;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;143;-4186.06,2.762909;Inherit;False;Constant;_Float4;Float 4;8;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;71;-4313.527,-78.89252;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;73;-4164.974,-85.42857;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-4022.151,190.6871;Inherit;False;Property;_speed;speed;1;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;75;-4051.954,121.9872;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;74;-3995.854,-78.89252;Inherit;False;Polar Coordinates;-1;;1;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT;1;False;4;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-3866.954,121.9872;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;79;-3766.646,-79.6446;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;80;-3669.646,59.3554;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;84;-3532.147,194.039;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode;82;-3530.886,140.5913;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;141;-3378.865,138.9907;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;135;-2591.296,147.4304;Inherit;False;Property;_SwirlScale;Swirl Scale;7;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;142;-3228.481,113.7653;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;90;-2326.101,131.8146;Inherit;False;Property;_Float3;Float 3;2;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;134;-2594.296,61.4304;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;94;-1945.303,193.028;Inherit;False;Property;_Contrast;Contrast;3;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;89;-2320.684,46.34767;Float;False;float2 uv2 = uv@ // Initialize uv2$for(int i=0@ i < 5@ i++) {$    uv2 += sin(max(uv.x, uv.y)) + uv@$    uv  += 0.5 * float2(cos(5.1123314 + 0.353 * uv2.y + speed * 0.131121),$                         sin(uv2.x - 0.113 * speed))@$    uv  -= 1.0 * cos(uv.x + uv.y) - 1.0 * sin(uv.x * 0.711 - uv.y)@$}$return uv@;2;False;2;False;uv;FLOAT2;0,0;In;;Inherit;False;True;speed;FLOAT;0;In;;Inherit;False;My Custom Expression;True;False;0;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;102;-1806.396,192.3401;Inherit;False;Contrast;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;92;-2049.154,46.90226;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;93;-1771.123,60.06897;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0.035;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;95;-1552.204,48.62796;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;98;-1368.351,47.02876;Inherit;False;Paint_Res;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;99;-3366.083,857.9885;Inherit;False;98;Paint_Res;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;97;-3341.383,782.5886;Inherit;False;Constant;_Float0;Float 0;4;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;96;-3207.483,786.4886;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;109;-3215.314,1044.367;Inherit;False;102;Contrast;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;100;-3077.483,786.4887;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;108;-3220.51,969.0211;Inherit;False;98;Paint_Res;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;103;-3102.83,866.7997;Inherit;False;102;Contrast;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;112;-2915.229,1037.872;Inherit;False;Constant;_Float2;Float 2;4;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;105;-2822.029,865.5002;Inherit;False;Constant;_Float1;Float 1;4;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;-2958.383,786.4885;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;-3043.837,961.2269;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;104;-2812.933,788.7956;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;111;-2916.528,954.7315;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;106;-2686.829,779.7001;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;113;-2786.621,957.3298;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;107;-2563.328,774.5353;Inherit;False;c1p;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;114;-2674.294,952.526;Inherit;False;c2p;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;116;-2347.959,776.3751;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;119;-2062.959,754.3751;Inherit;False;Constant;_Float5;Float 5;4;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;117;-2216.959,772.3751;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;118;-2062.959,822.3751;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;125;-871.2193,874.5449;Inherit;False;114;c2p;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;121;-1926.071,817.5229;Inherit;False;c3p;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;122;-1246.615,909.0355;Inherit;False;Property;_Color2;Color 2;5;0;Create;True;0;0;0;False;0;False;0,0.07902622,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;120;-1248.928,739.4637;Inherit;False;Property;_Color1;Color 1;4;0;Create;True;0;0;0;False;0;False;1,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;123;-1243.674,1077.262;Inherit;False;Property;_Color3;Color 3;6;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;124;-870.7889,758.2079;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;128;-656.1829,870.2797;Inherit;False;121;c3p;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;127;-737.183,1001.18;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;88;-2868.911,168.5469;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;129;-5091.477,-179.2229;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;-3073.226,-7.75045;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;126;-580.7842,641.8974;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;-3071.688,204.0765;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;130;-3621.181,-141.6147;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-104.1291,25.50885;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;BalatroBG2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;68;0;67;0
WireConnection;68;1;69;0
WireConnection;70;0;68;0
WireConnection;71;0;70;0
WireConnection;71;1;69;0
WireConnection;73;0;71;0
WireConnection;73;1;143;0
WireConnection;74;1;73;0
WireConnection;77;0;75;0
WireConnection;77;1;76;0
WireConnection;79;0;74;0
WireConnection;80;0;79;1
WireConnection;80;1;77;0
WireConnection;84;0;80;0
WireConnection;82;0;80;0
WireConnection;141;0;82;0
WireConnection;141;1;84;0
WireConnection;142;0;79;0
WireConnection;142;1;141;0
WireConnection;134;0;142;0
WireConnection;134;1;135;0
WireConnection;89;0;134;0
WireConnection;89;1;90;0
WireConnection;102;0;94;0
WireConnection;92;0;89;0
WireConnection;93;0;92;0
WireConnection;93;2;102;0
WireConnection;95;0;93;0
WireConnection;98;0;95;0
WireConnection;96;0;97;0
WireConnection;96;1;99;0
WireConnection;100;0;96;0
WireConnection;101;0;100;0
WireConnection;101;1;103;0
WireConnection;110;0;108;0
WireConnection;110;1;109;0
WireConnection;104;0;105;0
WireConnection;104;1;101;0
WireConnection;111;0;112;0
WireConnection;111;1;110;0
WireConnection;106;0;104;0
WireConnection;113;0;111;0
WireConnection;107;0;106;0
WireConnection;114;0;113;0
WireConnection;116;0;107;0
WireConnection;116;1;114;0
WireConnection;117;0;116;0
WireConnection;118;0;119;0
WireConnection;118;1;117;0
WireConnection;121;0;118;0
WireConnection;124;0;120;0
WireConnection;124;1;122;0
WireConnection;124;2;125;0
WireConnection;127;0;123;0
WireConnection;88;0;86;0
WireConnection;88;1;87;0
WireConnection;86;0;79;0
WireConnection;126;0;124;0
WireConnection;126;1;127;0
WireConnection;126;2;128;0
WireConnection;87;0;79;0
WireConnection;130;0;79;0
WireConnection;0;2;126;0
ASEEND*/
//CHKSM=CC00331D285E76F9676957C728D2174A32DDF433
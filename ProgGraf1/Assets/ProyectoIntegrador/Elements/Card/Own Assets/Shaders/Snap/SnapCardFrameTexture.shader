// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SnapFrameTexture"
{
	Properties
	{
		_FrontTexture("Front Texture", 2D) = "white" {}
		_Backtexture("Back texture", 2D) = "white" {}
		_GlimmerSpeed("GlimmerSpeed", Float) = 0.5
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Intensity("Intensity", Float) = 1
		_RedMask("RedMask", 2D) = "white" {}
		_GreenMask("GreenMask", 2D) = "white" {}
		_BorderColor("BorderColor", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Off
		Stencil
		{
			Ref 5
			CompFront NotEqual
			PassFront Keep
			FailFront Keep
			ZFailFront Keep
		}
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			half ASEVFace : VFACE;
		};

		uniform sampler2D _FrontTexture;
		uniform float4 _FrontTexture_ST;
		uniform sampler2D _Backtexture;
		uniform float4 _Backtexture_ST;
		uniform sampler2D _RedMask;
		uniform float4 _RedMask_ST;
		uniform float _GlimmerSpeed;
		uniform sampler2D _GreenMask;
		uniform float4 _GreenMask_ST;
		uniform sampler2D _BorderColor;
		uniform float4 _BorderColor_ST;
		uniform float _Intensity;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_FrontTexture = i.uv_texcoord * _FrontTexture_ST.xy + _FrontTexture_ST.zw;
			float4 tex2DNode2 = tex2D( _FrontTexture, uv_FrontTexture );
			float2 uv_Backtexture = i.uv_texcoord * _Backtexture_ST.xy + _Backtexture_ST.zw;
			float4 tex2DNode7 = tex2D( _Backtexture, uv_Backtexture );
			float4 switchResult9 = (((i.ASEVFace>0)?(tex2DNode2):(tex2DNode7)));
			o.Albedo = switchResult9.rgb;
			float2 uv_RedMask = i.uv_texcoord * _RedMask_ST.xy + _RedMask_ST.zw;
			float2 uv_GreenMask = i.uv_texcoord * _GreenMask_ST.xy + _GreenMask_ST.zw;
			float2 uv_BorderColor = i.uv_texcoord * _BorderColor_ST.xy + _BorderColor_ST.zw;
			float4 switchResult47 = (((i.ASEVFace>0)?(( ( sin( frac( ( tex2D( _RedMask, uv_RedMask ).r + ( _Time.y * _GlimmerSpeed ) ) ) ) * tex2D( _GreenMask, uv_GreenMask ).g ) * tex2D( _BorderColor, uv_BorderColor ) * _Intensity )):(float4( 0,0,0,0 ))));
			o.Emission = switchResult47.rgb;
			o.Alpha = 1;
			float switchResult11 = (((i.ASEVFace>0)?(tex2DNode2.a):(tex2DNode7.a)));
			clip( switchResult11 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;73.6;847.8;458.2;1095.938;-813.0688;1.319785;True;False
Node;AmplifyShaderEditor.RangedFloatNode;43;-1579.28,946.6992;Inherit;False;Property;_GlimmerSpeed;GlimmerSpeed;2;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;41;-1572.292,881.3555;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-1394.875,881.4117;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;57;-1712.762,666.1913;Inherit;True;Property;_RedMask;RedMask;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;44;-1189.68,914.6988;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;58;-1068.453,915.1406;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;39;-1422.677,330.4579;Inherit;False;593.6024;283.3415;Textura Dorsal;2;8;7;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;62;-1432.907,666.6218;Inherit;True;Property;_GreenMask;GreenMask;6;0;Create;True;0;0;0;False;0;False;-1;32f2bb0f7db94e04c9d54e074f7620ae;32f2bb0f7db94e04c9d54e074f7620ae;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinOpNode;60;-1012.15,645.7583;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;38;-1862.309,33.77076;Inherit;False;1032.538;285.0924;Textura frontal ;2;2;3;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-778.3192,1087.294;Inherit;False;Property;_Intensity;Intensity;4;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-845.5145,887.0098;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;3;-1812.309,88.8632;Inherit;True;Property;_FrontTexture;Front Texture;0;0;Create;True;0;0;0;False;0;False;None;f06041efb8defa745b0464546c1216f1;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;8;-1372.677,383.7994;Inherit;True;Property;_Backtexture;Back texture;1;0;Create;True;0;0;0;False;0;False;None;6a3028354918d9c4babc90d154170b3f;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;63;-494.7305,1208.291;Inherit;True;Property;_BorderColor;BorderColor;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-606.6762,826.3147;Inherit;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2;-1518.065,83.77076;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;40;-655.5056,36.34373;Inherit;False;264.7371;368.4932;Cambio textura por cara;3;9;11;47;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;7;-1150.674,380.4579;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwitchByFaceNode;11;-599.5684,271.0369;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwitchByFaceNode;9;-602.3055,70.34373;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SwitchByFaceNode;47;-598.2511,168.7726;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;45;-1472.881,1033.099;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;SnapFrameTexture;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;True;5;False;-1;255;False;-1;255;False;-1;6;False;-1;1;False;-1;1;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;3;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;42;0;41;0
WireConnection;42;1;43;0
WireConnection;44;0;57;1
WireConnection;44;1;42;0
WireConnection;58;0;44;0
WireConnection;60;0;58;0
WireConnection;51;0;60;0
WireConnection;51;1;62;2
WireConnection;52;0;51;0
WireConnection;52;1;63;0
WireConnection;52;2;55;0
WireConnection;2;0;3;0
WireConnection;7;0;8;0
WireConnection;11;0;2;4
WireConnection;11;1;7;4
WireConnection;9;0;2;0
WireConnection;9;1;7;0
WireConnection;47;0;52;0
WireConnection;0;0;9;0
WireConnection;0;2;47;0
WireConnection;0;10;11;0
ASEEND*/
//CHKSM=88ABFAD75C707138B7276FBAD1FFE490B0FBAB91
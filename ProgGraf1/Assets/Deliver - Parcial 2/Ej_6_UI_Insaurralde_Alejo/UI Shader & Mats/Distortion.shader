// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Distortion"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		
		_StencilComp ("Stencil Comparison", Float) = 8
		_Stencil ("Stencil ID", Float) = 0
		_StencilOp ("Stencil Operation", Float) = 0
		_StencilWriteMask ("Stencil Write Mask", Float) = 255
		_StencilReadMask ("Stencil Read Mask", Float) = 255

		_ColorMask ("Color Mask", Float) = 15

		[Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0
		[NoScaleOffset][Normal]_DistortionNormal("Distortion Normal", 2D) = "bump" {}
		_Texture0("Texture 0", 2D) = "white" {}
		_Speed("Speed", Float) = 0.5

	}

	SubShader
	{
		LOD 0

		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True" }
		
		Stencil
		{
			Ref [_Stencil]
			ReadMask [_StencilReadMask]
			WriteMask [_StencilWriteMask]
			CompFront [_StencilComp]
			PassFront [_StencilOp]
			FailFront Keep
			ZFailFront Keep
			CompBack Always
			PassBack Keep
			FailBack Keep
			ZFailBack Keep
		}


		Cull Off
		Lighting Off
		ZWrite Off
		ZTest [unity_GUIZTestMode]
		Blend SrcAlpha OneMinusSrcAlpha
		ColorMask [_ColorMask]

		
		Pass
		{
			Name "Default"
		CGPROGRAM
			
			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

			#include "UnityCG.cginc"
			#include "UnityUI.cginc"

			#pragma multi_compile __ UNITY_UI_CLIP_RECT
			#pragma multi_compile __ UNITY_UI_ALPHACLIP
			
			#include "UnityShaderVariables.cginc"
			#include "UnityStandardUtils.cginc"

			
			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				half2 texcoord  : TEXCOORD0;
				float4 worldPosition : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				
			};
			
			uniform fixed4 _Color;
			uniform fixed4 _TextureSampleAdd;
			uniform float4 _ClipRect;
			uniform sampler2D _MainTex;
			uniform sampler2D _Texture0;
			uniform sampler2D _DistortionNormal;
			uniform float4 _Texture0_ST;
			uniform float _Speed;

			
			v2f vert( appdata_t IN  )
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID( IN );
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
				UNITY_TRANSFER_INSTANCE_ID(IN, OUT);
				OUT.worldPosition = IN.vertex;
				
				
				OUT.worldPosition.xyz +=  float3( 0, 0, 0 ) ;
				OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);

				OUT.texcoord = IN.texcoord;
				
				OUT.color = IN.color * _Color;
				return OUT;
			}

			fixed4 frag(v2f IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				float2 uv_Texture0 = IN.texcoord.xy * _Texture0_ST.xy + _Texture0_ST.zw;
				float2 MainUvs222_g1 = uv_Texture0;
				float4 tex2DNode65_g1 = tex2D( _DistortionNormal, MainUvs222_g1 );
				float4 appendResult82_g1 = (float4(0.0 , tex2DNode65_g1.g , 0.0 , tex2DNode65_g1.r));
				float temp_output_20_0 = ( _Time.y * _Speed );
				float2 texCoord15 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner36 = ( temp_output_20_0 * float2( 0,0 ) + ( texCoord15 - float2( 0.5,0.5 ) ));
				float temp_output_18_0 = ( length( panner36 ) - temp_output_20_0 );
				float lerpResult32 = lerp( saturate( temp_output_18_0 ) , ( 1.0 - temp_output_18_0 ) , 2.0);
				float2 temp_output_84_0_g1 = (UnpackScaleNormal( appendResult82_g1, lerpResult32 )).xy;
				float2 panner179_g1 = ( 1.0 * _Time.y * panner36 + MainUvs222_g1);
				float2 temp_output_71_0_g1 = ( temp_output_84_0_g1 + panner179_g1 );
				float4 tex2DNode96_g1 = tex2D( _Texture0, temp_output_71_0_g1 );
				
				half4 color = tex2DNode96_g1;
				
				#ifdef UNITY_UI_CLIP_RECT
                color.a *= UnityGet2DClipping(IN.worldPosition.xy, _ClipRect);
                #endif
				
				#ifdef UNITY_UI_ALPHACLIP
				clip (color.a - 0.001);
				#endif

				return color;
			}
		ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
7.2;80.8;859.8;316.6;2331.058;-66.11562;3.025193;True;False
Node;AmplifyShaderEditor.SimpleTimeNode;25;-1367.038,579.2745;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-1326.892,663.7919;Inherit;False;Property;_Speed;Speed;8;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;-1798.474,94.73827;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-1166.748,585.0101;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;16;-1577.975,103.3163;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;36;-1340.072,106.7965;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LengthOpNode;17;-885.3475,298.55;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;18;-703.6603,293.4504;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;22;-477.3734,284.5154;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;34;-478.0396,487.3703;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;32;-274.3955,282.0756;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;27;-969.5787,-109.9586;Inherit;True;Property;_Texture0;Texture 0;7;0;Create;True;0;0;0;False;0;False;f29a69d72fb01164289664bf885fa357;f29a69d72fb01164289664bf885fa357;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.FractNode;24;-33.69051,275.8584;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1;-308.1001,0.8999786;Inherit;True;UI-Sprite Effect Layer;0;;1;789bf62641c5cfe4ab7126850acc22b8;18,74,0,204,0,191,0,225,0,242,0,237,0,249,0,186,0,177,1,182,0,229,0,92,0,98,0,234,0,126,0,129,1,130,0,31,0;18;192;COLOR;1,1,1,1;False;39;COLOR;1,1,1,1;False;37;SAMPLER2D;;False;218;FLOAT2;0,0;False;239;FLOAT2;0,0;False;181;FLOAT2;0.5,0.5;False;75;SAMPLER2D;;False;80;FLOAT;1;False;183;FLOAT2;0,0;False;188;SAMPLER2D;;False;33;SAMPLER2D;;False;248;FLOAT2;0,0;False;233;SAMPLER2D;;False;101;SAMPLER2D;;False;57;FLOAT4;0,0,0,0;False;40;FLOAT;0;False;231;FLOAT;1;False;30;FLOAT;1;False;2;COLOR;0;FLOAT2;172
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;66.56942,-1.84915;Float;False;True;-1;2;ASEMaterialInspector;0;6;Distortion;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;False;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;True;True;True;True;True;0;True;-9;False;False;False;False;False;False;False;True;True;0;True;-5;255;True;-8;255;True;-7;0;True;-4;0;True;-6;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;0;True;-11;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;20;0;25;0
WireConnection;20;1;21;0
WireConnection;16;0;15;0
WireConnection;36;0;16;0
WireConnection;36;1;20;0
WireConnection;17;0;36;0
WireConnection;18;0;17;0
WireConnection;18;1;20;0
WireConnection;22;0;18;0
WireConnection;34;0;18;0
WireConnection;32;0;22;0
WireConnection;32;1;34;0
WireConnection;24;0;32;0
WireConnection;1;37;27;0
WireConnection;1;181;36;0
WireConnection;1;80;32;0
WireConnection;0;0;1;0
ASEEND*/
//CHKSM=907BAD88F2E8B6FDD88B3F3C1A1341C366E18D46
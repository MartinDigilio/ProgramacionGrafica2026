// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Rotation"
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
		_RingColor2("Ring Color", Color) = (0.007084846,1,0,1)
		[NoScaleOffset]_Ring2("Ring", 2D) = "white" {}
		[HideInInspector]_CustomUVS2("CustomUVS", Vector) = (0,0,0.5,1)
		_Vector3("Vector 1", Vector) = (0,-0.06,0.98,2.54)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

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
			uniform float4 _MainTex_ST;
			uniform float4 _RingColor2;
			uniform sampler2D _Ring2;
			uniform float4 _CustomUVS2;
			uniform float4 _Vector3;

			
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

				float2 uv_MainTex = IN.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 tex2DNode51 = tex2D( _MainTex, uv_MainTex );
				float2 appendResult53 = (float2((0.0 + (uv_MainTex.x - _CustomUVS2.x) * (1.0 - 0.0) / (_CustomUVS2.z - _CustomUVS2.x)) , (0.0 + (uv_MainTex.y - _CustomUVS2.y) * (1.0 - 0.0) / (_CustomUVS2.w - _CustomUVS2.y))));
				float4 appendResult52 = (float4(_Vector3.x , ( _Vector3.y * _SinTime.w ) , _Vector3.z , _Vector3.w));
				float4 temp_output_57_0_g9 = appendResult52;
				float2 temp_output_2_0_g9 = (temp_output_57_0_g9).zw;
				float2 temp_cast_0 = (1.0).xx;
				float2 temp_output_13_0_g9 = ( ( ( appendResult53 + (temp_output_57_0_g9).xy ) * temp_output_2_0_g9 ) + -( ( temp_output_2_0_g9 - temp_cast_0 ) * 0.5 ) );
				float TimeVar197_g9 = _Time.y;
				float cos17_g9 = cos( TimeVar197_g9 );
				float sin17_g9 = sin( TimeVar197_g9 );
				float2 rotator17_g9 = mul( temp_output_13_0_g9 - float2( 0.5,0.5 ) , float2x2( cos17_g9 , -sin17_g9 , sin17_g9 , cos17_g9 )) + float2( 0.5,0.5 );
				float4 tex2DNode97_g9 = tex2D( _Ring2, rotator17_g9 );
				float temp_output_115_0_g9 = step( ( (temp_output_13_0_g9).y + -0.5 ) , 0.0 );
				float lerpResult125_g9 = lerp( 1.0 , ( 1.0 - tex2DNode51.a ) , ( 1.0 - temp_output_115_0_g9 ));
				float4 lerpResult58 = lerp( tex2DNode51 , _RingColor2 , (( tex2DNode97_g9 * lerpResult125_g9 * tex2DNode97_g9.a )).a);
				
				half4 color = lerpResult58;
				
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
7.2;80.8;859.8;486.2;3820.651;294.128;4.297384;True;False
Node;AmplifyShaderEditor.CommentaryNode;39;-1558.05,774.5347;Inherit;False;745;437;Comment;4;52;50;46;45;Wavy Ring;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;40;-2528.656,320.252;Inherit;False;797.0422;558.1058;Comment;7;53;48;47;44;43;42;41;Remap Sprite UVs;1,1,1,1;0;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;38;-2918.05,-41.4649;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;41;-2448.338,498.985;Float;False;Property;_CustomUVS2;CustomUVS;9;1;[HideInInspector];Create;True;0;0;0;False;0;False;0,0,0.5,1;0,0,0.5,1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;42;-2478.656,370.252;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;43;-2416.49,763.3572;Float;False;Constant;_Float4;Float 2;4;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-2416.887,673.3583;Float;False;Constant;_Float5;Float 1;4;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;45;-1510.05,822.535;Float;False;Property;_Vector3;Vector 1;10;0;Create;True;0;0;0;False;0;False;0,-0.06,0.98,2.54;0,-0.06,0.98,2.54;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinTimeNode;46;-1446.05,1030.535;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;49;-1432.05,68.53513;Inherit;False;1151;592;Comment;5;59;57;56;55;54;Rotation FX;0,1,0.1310346,1;0;0
Node;AmplifyShaderEditor.SamplerNode;51;-1750.05,-57.46493;Inherit;True;Property;_TextureSample3;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;37e6f91f3efb0954cbdce254638862ea;37e6f91f3efb0954cbdce254638862ea;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-1126.049,982.535;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;48;-2136.377,637.118;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;47;-2131.092,437.025;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;53;-1910.05,566.535;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;54;-1350.05,550.5352;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;55;-1382.049,246.5351;Float;True;Property;_Ring2;Ring;8;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;37e6f91f3efb0954cbdce254638862ea;a99649a3ac7df724eb781c969383e632;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.DynamicAppendNode;52;-982.05,854.5349;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;59;-790.0503,310.5353;Inherit;False;UI-Sprite Effect Layer;0;;9;789bf62641c5cfe4ab7126850acc22b8;18,74,2,204,2,191,0,225,1,242,0,237,1,249,0,186,0,177,0,182,0,229,0,92,0,98,1,234,0,126,1,129,1,130,1,31,0;18;192;COLOR;1,1,1,1;False;39;COLOR;1,1,1,1;False;37;SAMPLER2D;;False;218;FLOAT2;0,0;False;239;FLOAT2;0,0;False;181;FLOAT2;0,0;False;75;SAMPLER2D;;False;80;FLOAT;1;False;183;FLOAT2;0,0;False;188;SAMPLER2D;;False;33;SAMPLER2D;;False;248;FLOAT2;0,0;False;233;SAMPLER2D;;False;101;SAMPLER2D;;False;57;FLOAT4;0,0,0,0;False;40;FLOAT;0;False;231;FLOAT;1;False;30;FLOAT;1;False;2;COLOR;0;FLOAT2;172
Node;AmplifyShaderEditor.ColorNode;56;-758.0503,118.5351;Float;False;Property;_RingColor2;Ring Color;7;0;Create;True;0;0;0;False;0;False;0.007084846,1,0,1;0,1,0.3793103,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;57;-518.0502,294.5353;Inherit;False;False;False;False;True;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;58;-214.0502,-41.4649;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;14;38.06489,-38.5571;Float;False;True;-1;2;ASEMaterialInspector;0;6;Rotation;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;False;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;True;True;True;True;True;0;True;-9;False;False;False;False;False;False;False;True;True;0;True;-5;255;True;-8;255;True;-7;0;True;-4;0;True;-6;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;0;True;-11;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;42;2;38;0
WireConnection;51;0;38;0
WireConnection;50;0;45;2
WireConnection;50;1;46;4
WireConnection;48;0;42;1
WireConnection;48;1;41;1
WireConnection;48;2;41;3
WireConnection;48;3;44;0
WireConnection;48;4;43;0
WireConnection;47;0;42;2
WireConnection;47;1;41;2
WireConnection;47;2;41;4
WireConnection;47;3;44;0
WireConnection;47;4;43;0
WireConnection;53;0;48;0
WireConnection;53;1;47;0
WireConnection;54;0;51;4
WireConnection;52;0;45;1
WireConnection;52;1;50;0
WireConnection;52;2;45;3
WireConnection;52;3;45;4
WireConnection;59;37;55;0
WireConnection;59;239;53;0
WireConnection;59;57;52;0
WireConnection;59;30;54;0
WireConnection;57;0;59;0
WireConnection;58;0;51;0
WireConnection;58;1;56;0
WireConnection;58;2;57;0
WireConnection;14;0;58;0
ASEEND*/
//CHKSM=58E5DAD3D812DF0A8404FAA1E6EF2024711AD6ED
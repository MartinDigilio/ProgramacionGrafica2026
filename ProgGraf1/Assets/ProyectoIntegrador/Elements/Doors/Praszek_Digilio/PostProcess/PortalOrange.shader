// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PortalOrange"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_TwistStrenght("TwistStrenght", Float) = -10
		_spinSpeed("spinSpeed", Float) = 1
		_Intensity("Intensity", Range( 0 , 1)) = 0

	}

	SubShader
	{
		LOD 0

		
		
		ZTest Always
		Cull Off
		ZWrite Off

		
		Pass
		{ 
			CGPROGRAM 

			

			#pragma vertex vert_img_custom 
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata_img_custom
			{
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
				
			};

			struct v2f_img_custom
			{
				float4 pos : SV_POSITION;
				half2 uv   : TEXCOORD0;
				half2 stereoUV : TEXCOORD2;
		#if UNITY_UV_STARTS_AT_TOP
				half4 uv2 : TEXCOORD1;
				half4 stereoUV2 : TEXCOORD3;
		#endif
				float4 ase_texcoord4 : TEXCOORD4;
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform float _spinSpeed;
			uniform float _TwistStrenght;
			uniform float _Intensity;


			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord4 = screenPos;
				
				o.pos = UnityObjectToClipPos( v.vertex );
				o.uv = float4( v.texcoord.xy, 1, 1 );

				#if UNITY_UV_STARTS_AT_TOP
					o.uv2 = float4( v.texcoord.xy, 1, 1 );
					o.stereoUV2 = UnityStereoScreenSpaceUVAdjust ( o.uv2, _MainTex_ST );

					if ( _MainTex_TexelSize.y < 0.0 )
						o.uv.y = 1.0 - o.uv.y;
				#endif
				o.stereoUV = UnityStereoScreenSpaceUVAdjust ( o.uv, _MainTex_ST );
				return o;
			}

			half4 frag ( v2f_img_custom i ) : SV_Target
			{
				#ifdef UNITY_UV_STARTS_AT_TOP
					half2 uv = i.uv2;
					half2 stereoUV = i.stereoUV2;
				#else
					half2 uv = i.uv;
					half2 stereoUV = i.stereoUV;
				#endif	
				
				half4 finalColor;

				// ase common template code
				float4 screenPos = i.ase_texcoord4;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float4 ScreenPosition77 = ase_screenPosNorm;
				float Twist81 = ( distance( ScreenPosition77 , float4( float2( 0.5,0.5 ), 0.0 , 0.0 ) ) * _TwistStrenght );
				float temp_output_91_0 = ( ( _Time.y * _spinSpeed ) + Twist81 );
				float TwistSpeed94 = temp_output_91_0;
				float cos75 = cos( TwistSpeed94 );
				float sin75 = sin( TwistSpeed94 );
				float2 rotator75 = mul( ScreenPosition77.xy - float2( 0.5,0.5 ) , float2x2( cos75 , -sin75 , sin75 , cos75 )) + float2( 0.5,0.5 );
				float2 Rotador86 = rotator75;
				float4 lerpResult98 = lerp( ScreenPosition77 , float4( Rotador86, 0.0 , 0.0 ) , _Intensity);
				float4 Lerp102 = lerpResult98;
				

				finalColor = tex2D( _MainTex, Lerp102.xy );

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
201;73;1263;602;1323.675;407.1656;1;True;False
Node;AmplifyShaderEditor.ScreenPosInputsNode;67;-884.9241,-1076.134;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;77;-687.0642,-1076.317;Inherit;False;ScreenPosition;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;68;-834.532,-404.6122;Inherit;False;Constant;_Vector0;Vector 0;0;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;78;-856.8636,-479.5791;Inherit;False;77;ScreenPosition;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;70;-680.5323,-356.6122;Inherit;False;Property;_TwistStrenght;TwistStrenght;0;0;Create;True;0;0;0;False;0;False;-10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;69;-642.5324,-457.6122;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;-509.5324,-420.6122;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;88;-849.9777,-195.8827;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-836.9777,-116.8827;Inherit;False;Property;_spinSpeed;spinSpeed;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;81;-381.0635,-424.6598;Inherit;False;Twist;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;-691.9777,-192.8827;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;92;-691.9735,-97.04012;Inherit;False;81;Twist;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;91;-521.6735,-193.2402;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;94;-381.5297,-195.649;Inherit;False;TwistSpeed;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;95;-862.4589,-602.2059;Inherit;False;94;TwistSpeed;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;80;-856.9513,-730.5587;Inherit;False;Constant;_Vector1;Vector 1;0;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;79;-881.951,-811.559;Inherit;False;77;ScreenPosition;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RotatorNode;75;-648.5528,-796.8591;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;86;-387.7224,-779.3496;Inherit;False;Rotador;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;101;-998.5127,170.7406;Inherit;False;86;Rotador;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-1098.745,255.9745;Inherit;False;Property;_Intensity;Intensity;2;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;100;-1032.455,92.30218;Inherit;False;77;ScreenPosition;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;98;-726.5755,95.79324;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;102;-531.0237,102.7544;Inherit;False;Lerp;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;83;336.1833,-515.8621;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;103;85.1763,-447.1453;Inherit;False;102;Lerp;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;85;346.0247,-458.2422;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;646.3538,-454.1255;Float;False;True;-1;2;ASEMaterialInspector;0;2;PortalOrange;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;77;0;67;0
WireConnection;69;0;78;0
WireConnection;69;1;68;0
WireConnection;71;0;69;0
WireConnection;71;1;70;0
WireConnection;81;0;71;0
WireConnection;90;0;88;0
WireConnection;90;1;89;0
WireConnection;91;0;90;0
WireConnection;91;1;92;0
WireConnection;94;0;91;0
WireConnection;75;0;79;0
WireConnection;75;1;80;0
WireConnection;75;2;95;0
WireConnection;86;0;75;0
WireConnection;98;0;100;0
WireConnection;98;1;101;0
WireConnection;98;2;96;0
WireConnection;102;0;98;0
WireConnection;85;0;83;0
WireConnection;85;1;103;0
WireConnection;0;0;85;0
ASEEND*/
//CHKSM=B2DA808A201FD498070DFB5FCEDCAA3B3B6A0F74
// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ase_fluid"
{
	Properties
	{
		_Liquid_Level("Liquid_Level", Range( 0 , 1)) = 0
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Top_Color("Top_Color", Color) = (0.9254902,0.07450981,0.07450981,1)
		_Liquid_color("Liquid_color", Color) = (0.7921569,0,0,0)
		_Wobble("Wobble", Float) = 0
		_WobbleAxis("WobbleAxis", Vector) = (0,0,0,0)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows exclude_path:deferred nolightmap  nodynlightmap nodirlightmap nofog noforwardadd 
		struct Input
		{
			half ASEIsFrontFacing : VFACE;
			float3 worldPos;
		};

		uniform float4 _Liquid_color;
		uniform float4 _Top_Color;
		uniform float _Wobble;
		uniform float3 _WobbleAxis;
		uniform float _Liquid_Level;
		uniform float _Cutoff = 0.5;


		float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
		{
			original -= center;
			float C = cos( angle );
			float S = sin( angle );
			float t = 1 - C;
			float m00 = t * u.x * u.x + C;
			float m01 = t * u.x * u.y - S * u.z;
			float m02 = t * u.x * u.z + S * u.y;
			float m10 = t * u.x * u.y + S * u.z;
			float m11 = t * u.y * u.y + C;
			float m12 = t * u.y * u.z - S * u.x;
			float m20 = t * u.x * u.z - S * u.y;
			float m21 = t * u.y * u.z + S * u.x;
			float m22 = t * u.z * u.z + C;
			float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
			return mul( finalMatrix, original ) + center;
		}


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 switchResult19 = (((i.ASEIsFrontFacing>0)?(_Liquid_color):(_Top_Color)));
			o.Emission = switchResult19.rgb;
			o.Alpha = 1;
			float4 transform3 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float3 ase_worldPos = i.worldPos;
			float3 rotatedValue5 = RotateAroundAxis( float3( 0,0,0 ), ( transform3 - float4( ase_worldPos , 0.0 ) ).xyz, normalize( _WobbleAxis ), 90.0 );
			float4 transform12 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			clip( ( (( float4( ( _Wobble * rotatedValue5 ) , 0.0 ) + ( transform12 - float4( ase_worldPos , 0.0 ) ) )).y - ( 1.0 - (0.84 + (_Liquid_Level - 0.0) * (1.04 - 0.84) / (1.0 - 0.0)) ) ) - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.WorldPosInputsNode;2;-2302.063,-155.5418;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;3;-2312.462,-336.2416;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;4;-1991.361,-223.1418;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WorldPosInputsNode;9;-1392.406,67.58852;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-1343.996,-431.2605;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;12;-1406.806,-101.3607;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;14;-1140.711,-8.10327;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-961.784,-31.27024;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ComponentMaskNode;17;-809.2563,-30.26823;Inherit;True;False;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwitchByFaceNode;19;-317.3458,-286.889;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;22;-591.9305,-266.7223;Inherit;False;Property;_Top_Color;Top_Color;2;0;Create;True;0;0;0;False;0;False;0.9254902,0.07450981,0.07450981,1;0.9245283,0.8503916,0.8503916,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;23;-596.6682,-442.5974;Inherit;False;Property;_Liquid_color;Liquid_color;3;0;Create;True;0;0;0;False;0;False;0.7921569,0,0,0;0.6886792,0.626958,0.626958,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;32;-2320.656,-507.9617;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;33;-1613.454,-80.26068;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;44;87.70123,-159.6652;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;ase_fluid;False;False;False;False;False;False;True;True;True;True;False;True;False;False;False;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;True;Opaque;;AlphaTest;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-1382.306,284.648;Float;False;Property;_Liquid_Level;Liquid_Level;0;0;Create;True;0;0;0;False;0;False;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;31;-730.7537,272.0387;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;45;-1029.672,283.7289;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.84;False;4;FLOAT;1.04;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;30;-378.4543,48.4392;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotateAboutAxisNode;5;-1753.246,-386.3292;Inherit;False;True;4;0;FLOAT3;0,0,1;False;1;FLOAT;90;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;46;-2017.13,-471.7065;Inherit;False;Property;_WobbleAxis;WobbleAxis;5;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;7;-1633.876,-496.2622;Inherit;False;Property;_Wobble;Wobble;4;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
WireConnection;4;0;3;0
WireConnection;4;1;2;0
WireConnection;11;0;7;0
WireConnection;11;1;5;0
WireConnection;14;0;12;0
WireConnection;14;1;9;0
WireConnection;16;0;11;0
WireConnection;16;1;14;0
WireConnection;17;0;16;0
WireConnection;19;0;23;0
WireConnection;19;1;22;0
WireConnection;44;2;19;0
WireConnection;44;10;30;0
WireConnection;31;0;45;0
WireConnection;45;0;15;0
WireConnection;30;0;17;0
WireConnection;30;1;31;0
WireConnection;5;0;46;0
WireConnection;5;3;4;0
ASEEND*/
//CHKSM=DDC0ABED369E55AD89B9C17F56A67523733C580A
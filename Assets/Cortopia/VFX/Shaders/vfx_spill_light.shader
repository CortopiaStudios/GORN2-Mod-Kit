// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "vfx_spill_light"
{
	Properties
	{
		[Toggle]_ErodemanualvertexcolA("Erode manual/vertexcol(A)", Float) = 1
		_ContrastBoost("ContrastBoost", Range( 0 , 10)) = 2.67783
		[HDR]_Color0("Color 0", Color) = (0.4669811,0.5426843,1,1)
		_Erode("Erode", Range( 0 , 1)) = 0.5111656
		[Toggle]_VertexColored("VertexColored", Float) = 0
		_Contrast("Contrast", Range( 0 , 2)) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Back
		Blend One One
		ColorMask RGB
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow 
		struct Input
		{
			float4 vertexColor : COLOR;
		};

		uniform float _VertexColored;
		uniform float4 _Color0;
		uniform float _ContrastBoost;
		uniform float _Contrast;
		uniform float _ErodemanualvertexcolA;
		uniform float _Erode;


		float4 CalculateContrast( float contrastValue, float4 colorTarget )
		{
			float t = 0.5 * ( 1.0 - contrastValue );
			return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 appendResult541 = (float3(_Color0.r , _Color0.g , _Color0.b));
			float3 appendResult539 = (float3(i.vertexColor.r , i.vertexColor.g , i.vertexColor.b));
			float4 temp_cast_0 = (i.vertexColor.r).xxxx;
			float3 break529 = saturate( saturate( ( (( _VertexColored )?( appendResult539 ):( appendResult541 )) * saturate( ( _ContrastBoost * ( ( ( saturate( saturate( CalculateContrast(_Contrast,temp_cast_0).r ) ) * (( _ErodemanualvertexcolA )?( saturate( i.vertexColor.a ) ):( _Erode )) ) - ( 1.0 - (( _ErodemanualvertexcolA )?( saturate( i.vertexColor.a ) ):( _Erode )) ) ) / (( _ErodemanualvertexcolA )?( saturate( i.vertexColor.a ) ):( _Erode )) ) ) ) ) ) );
			float4 appendResult530 = (float4(break529.x , break529.y , break529.z , 0.0));
			o.Emission = appendResult530.xyz;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.VertexColorNode;195;-4739.309,1793.777;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;514;-4023.588,2225.135;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;479;-4042.955,1978.349;Inherit;False;Property;_Erode;Erode;4;0;Create;True;0;0;0;False;0;False;0.5111656;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;495;-3570.238,1488.448;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;186;-3629.526,1920.78;Inherit;False;Property;_ErodemanualvertexcolA;Erode manual/vertexcol(A);1;0;Create;True;0;0;0;False;0;False;1;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;399;-2850.708,1570.08;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;521;-2628.864,1944.165;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;433;-3269.69,1491.58;Inherit;True;2;2;0;FLOAT;1;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;397;-2676.731,1475.686;Inherit;True;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;523;-2551.085,1927.885;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;401;-2399.235,1785.245;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;478;-2326.971,676.4628;Inherit;False;Property;_Color0;Color 0;3;1;[HDR];Create;True;0;0;0;False;0;False;0.4669811,0.5426843,1,1;1.059274,0.9312048,0.8052958,0.7019608;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;265;-1931.731,1693.538;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;486;-1682.828,1417.5;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;515;-1425.33,1443.126;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.VertexColorNode;517;-2301.942,923.9631;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;516;-1154.354,1467.427;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;529;-1019.554,1612.526;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SaturateNode;489;-4384.3,1312.583;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;530;-609.6335,1645.101;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;539;-1990.473,934.4994;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ToggleSwitchNode;538;-1709.473,827.4994;Inherit;False;Property;_VertexColored;VertexColored;5;0;Create;True;0;0;0;False;0;False;0;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;183;-2120.185,1701.641;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;541;-2049.673,742.7993;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;196;-2732.515,1361.849;Inherit;False;Property;_ContrastBoost;ContrastBoost;2;0;Create;True;0;0;0;False;0;False;2.67783;2.64;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;561;-4625.697,1403.628;Inherit;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;562;-4937.646,1488.85;Inherit;False;Property;_Contrast;Contrast;6;0;Create;True;0;0;0;False;0;False;1;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;563;-4419.882,1471.162;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;564;94.46069,1559.056;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;vfx_spill_light;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;False;0;False;Custom;;Transparent;All;12;all;True;True;True;False;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;4;1;False;;1;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;514;0;195;4
WireConnection;495;0;489;0
WireConnection;186;0;479;0
WireConnection;186;1;514;0
WireConnection;399;0;186;0
WireConnection;521;0;186;0
WireConnection;433;0;495;0
WireConnection;433;1;186;0
WireConnection;397;0;433;0
WireConnection;397;1;399;0
WireConnection;523;0;521;0
WireConnection;401;0;397;0
WireConnection;401;1;523;0
WireConnection;265;0;183;0
WireConnection;486;0;538;0
WireConnection;486;1;265;0
WireConnection;515;0;486;0
WireConnection;516;0;515;0
WireConnection;529;0;516;0
WireConnection;489;0;563;0
WireConnection;530;0;529;0
WireConnection;530;1;529;1
WireConnection;530;2;529;2
WireConnection;539;0;517;1
WireConnection;539;1;517;2
WireConnection;539;2;517;3
WireConnection;538;0;541;0
WireConnection;538;1;539;0
WireConnection;183;0;196;0
WireConnection;183;1;401;0
WireConnection;541;0;478;1
WireConnection;541;1;478;2
WireConnection;541;2;478;3
WireConnection;561;1;195;1
WireConnection;561;0;562;0
WireConnection;563;0;561;0
WireConnection;564;2;530;0
ASEEND*/
//CHKSM=6680CEA4D30217B20233F1473A86186AA4E8A223
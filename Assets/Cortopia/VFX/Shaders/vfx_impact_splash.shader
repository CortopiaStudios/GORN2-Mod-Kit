// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "vfx_impact_splash"
{
	Properties
	{
		_Layer1panner("Layer1 panner", Vector) = (0,0,0,0)
		_Layer2panner("Layer2 panner", Vector) = (0,0,0,0)
		_Packed("Packed", 2D) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"

			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform sampler2D _Packed;
			uniform float2 _Layer1panner;
			uniform float4 _Packed_ST;
			uniform float2 _Layer2panner;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float4 color388 = IsGammaSpace() ? float4(0,0.01950456,0.6698113,0) : float4(0,0.001509641,0.4061945,0);
				float2 uv_Packed = i.ase_texcoord1.xy * _Packed_ST.xy + _Packed_ST.zw;
				float2 panner16 = ( 1.0 * _Time.y * _Layer1panner + uv_Packed);
				float2 panner38 = ( -1.0 * _Time.y * _Layer2panner + uv_Packed);
				float4 color389 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
				float4 blendOpSrc384 = ( color388 * ( 1.0 - tex2D( _Packed, frac( panner16 ) ).g ) );
				float4 blendOpDest384 = ( ( 1.0 - tex2D( _Packed, frac( panner38 ) ).r ) * color389 );
				
				
				finalColor = ( saturate( ( blendOpSrc384 + blendOpDest384 ) ));
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	Fallback Off
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.CommentaryNode;350;-3801.029,1018.384;Inherit;False;1952.11;625.5881;Comment;14;183;224;186;195;188;189;196;190;265;375;376;377;378;379;Linear trail erode + contrast;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;211;-4886.64,-555.2225;Inherit;False;1831.462;1172.646;Comment;14;17;19;39;75;38;16;72;71;5;79;42;380;381;385;PackInit;1,1,1,1;0;0
Node;AmplifyShaderEditor.PannerNode;16;-3889.381,-505.2225;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FractNode;72;-3689.277,-504.9856;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FractNode;71;-3720.214,391.9649;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;5;-3389.274,-389.7055;Inherit;True;Property;_Tex1;Tex1;7;0;Create;True;0;0;0;False;0;False;75;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;38;-3896.332,391.0998;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;-1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VertexColorNode;195;-3751.028,1374.072;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;188;-3464.936,1313.725;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;189;-3511.511,1532.974;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;224;-3754.674,1142.228;Inherit;False;Property;_LinearWidth_Erode;LinearWidth_Erode;0;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;196;-2695.768,1078.806;Inherit;False;Property;_LinearWidth_ContrastBoost;LinearWidth_ContrastBoost;5;0;Create;True;0;0;0;False;0;False;1;5.53;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;186;-3310.51,1397.129;Inherit;False;Property;_ErodeLinearmanualvertexcolA;ErodeLinear manual/vertexcol(A);3;0;Create;True;0;0;0;False;0;False;0;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;375;-2915.803,1151.654;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;376;-3022.266,1458.53;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;377;-2890.394,1568.632;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;378;-2700.435,1381.504;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;183;-2207.041,1122.242;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;265;-2005.929,1123.739;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;379;-2421.903,1286.326;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;190;-3445.863,1076.63;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;-4571.343,-502.7115;Inherit;False;0;75;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureTransformNode;42;-4836.64,-479.0116;Inherit;False;75;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;380;-4439.058,226.3772;Inherit;False;0;75;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureTransformNode;381;-4704.355,250.0771;Inherit;False;75;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.Vector2Node;19;-4179.851,-346.0075;Float;False;Property;_Layer1panner;Layer1 panner;1;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;39;-4154.668,453.4218;Float;False;Property;_Layer2panner;Layer2 panner;2;0;Create;True;0;0;0;False;0;False;0,0;0.3,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;79;-3375.176,216.7589;Inherit;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;True;0;0;0;False;0;False;75;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;75;-3976.514,-84.26959;Inherit;True;Property;_Packed;Packed;4;0;Create;True;0;0;0;False;0;False;d8adf87e936c80945830f21561f263cb;02b22951e9478c246b3ef1b018bd8ec6;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.OneMinusNode;386;-3031.068,79.27264;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;388;-3036.068,-415.7274;Inherit;False;Constant;_Color0;Color 0;6;0;Create;True;0;0;0;False;0;False;0,0.01950456,0.6698113,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;387;-2726.068,-251.7274;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;389;-3037.068,496.2726;Inherit;False;Constant;_Color1;Color 1;6;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;390;-2706.068,318.2726;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;385;-3060.068,-127.7274;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;384;-2366.584,-3.578125;Inherit;True;LinearDodge;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;396;-1393.556,342.9942;Float;False;True;-1;2;ASEMaterialInspector;100;5;vfx_impact_splash;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
WireConnection;16;0;17;0
WireConnection;16;2;19;0
WireConnection;72;0;16;0
WireConnection;71;0;38;0
WireConnection;5;0;75;0
WireConnection;5;1;72;0
WireConnection;38;0;380;0
WireConnection;38;2;39;0
WireConnection;188;0;224;0
WireConnection;189;0;195;4
WireConnection;186;0;188;0
WireConnection;186;1;189;0
WireConnection;375;0;190;0
WireConnection;375;1;376;0
WireConnection;376;0;186;0
WireConnection;377;0;376;0
WireConnection;378;0;375;0
WireConnection;378;1;377;0
WireConnection;183;0;196;0
WireConnection;183;1;379;0
WireConnection;265;0;183;0
WireConnection;379;0;378;0
WireConnection;190;0;224;0
WireConnection;17;0;42;0
WireConnection;17;1;42;1
WireConnection;380;0;381;0
WireConnection;380;1;381;1
WireConnection;79;0;75;0
WireConnection;79;1;71;0
WireConnection;386;0;79;1
WireConnection;387;0;388;0
WireConnection;387;1;385;0
WireConnection;390;0;386;0
WireConnection;390;1;389;0
WireConnection;385;0;5;2
WireConnection;384;0;387;0
WireConnection;384;1;390;0
WireConnection;396;0;384;0
ASEEND*/
//CHKSM=C431C230D59FB6A17B378FC888668CB6AC21D36C
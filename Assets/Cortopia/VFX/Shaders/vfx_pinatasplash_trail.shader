// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "vfx_pinatasplash_trail"
{
	Properties
	{
		_Erode("Erode", Range( 0 , 0.98)) = 0.8841566
		_Spec("Spec", Range( 0 , 1)) = 1
		_Main("Main", 2D) = "white" {}
		[HDR]_BaseColor("BaseColor", Color) = (0.3301887,0,0,1)
		[HDR]_SpecColor("SpecColor", Color) = (27.3029,1.748462,1.748462,0)
		[Normal]_TextureSample1("Texture Sample 1", 2D) = "bump" {}
		_PanSpeed("PanSpeed", Range( -3 , 3)) = 1
		[Toggle(_VERTEXCOLORON_ON)] _VertexcolorOn("VertexcolorOn", Float) = 0
		_ColorMult("ColorMult", Range( 0 , 1.5)) = 0.1684782

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Transparent" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
		AlphaToMask Off
		Cull Off
		ColorMask RGBA
		ZWrite Off
		ZTest LEqual
		
		
		
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
			#include "UnityStandardUtils.cginc"
			#define ASE_NEEDS_FRAG_COLOR
			#pragma shader_feature_local _VERTEXCOLORON_ON


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_tangent : TANGENT;
				float3 ase_normal : NORMAL;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform sampler2D _TextureSample1;
			uniform float _PanSpeed;
			uniform sampler2D _Main;
			uniform float4 _Main_ST;
			uniform float _Spec;
			uniform float _Erode;
			uniform float4 _SpecColor;
			uniform float4 _BaseColor;
			uniform float _ColorMult;
			float3 HSVToRGB( float3 c )
			{
				float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
				float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
				return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
			}
			
			float3 RGBToHSV(float3 c)
			{
				float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
				float4 p = lerp( float4( c.bg, K.wz ), float4( c.gb, K.xy ), step( c.b, c.g ) );
				float4 q = lerp( float4( p.xyw, c.r ), float4( c.r, p.yzx ), step( p.x, c.r ) );
				float d = q.x - min( q.w, q.y );
				float e = 1.0e-10;
				return float3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
			}

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldTangent = UnityObjectToWorldDir(v.ase_tangent);
				o.ase_texcoord2.xyz = ase_worldTangent;
				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord3.xyz = ase_worldNormal;
				float ase_vertexTangentSign = v.ase_tangent.w * ( unity_WorldTransformParams.w >= 0.0 ? 1.0 : -1.0 );
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord4.xyz = ase_worldBitangent;
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				o.ase_color = v.color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				o.ase_texcoord2.w = 0;
				o.ase_texcoord3.w = 0;
				o.ase_texcoord4.w = 0;
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
				float2 appendResult918 = (float2(_PanSpeed , 0.0));
				float2 uv_Main = i.ase_texcoord1.xy * _Main_ST.xy + _Main_ST.zw;
				float2 panner915 = ( 1.5 * _Time.y * appendResult918 + uv_Main);
				float3 tex2DNode668 = UnpackScaleNormal( tex2D( _TextureSample1, panner915 ), 2.0 );
				float3 ase_worldTangent = i.ase_texcoord2.xyz;
				float3 ase_worldNormal = i.ase_texcoord3.xyz;
				float3 ase_worldBitangent = i.ase_texcoord4.xyz;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 tanNormal750 = tex2DNode668;
				float3 worldNormal750 = normalize( float3(dot(tanToWorld0,tanNormal750), dot(tanToWorld1,tanNormal750), dot(tanToWorld2,tanNormal750)) );
				float smoothstepResult782 = smoothstep( 0.5 , 2.0 , ( worldNormal750.y * 2.0 ));
				float temp_output_724_0 = ( i.ase_color.a * _Erode );
				float temp_output_470_0 = saturate( ( 1.0 - temp_output_724_0 ) );
				float4 tex2DNode533 = tex2D( _Main, panner915 );
				float2 texCoord919 = i.ase_texcoord1.xy * float2( 0.99,1.27 ) + float2( -1.07,-0.61 );
				float2 texCoord940 = i.ase_texcoord1.xy * float2( 0.99,1.49 ) + float2( -0.89,-0.52 );
				float temp_output_610_0 = ( tex2DNode533.r * saturate( ( ( ( saturate( pow( saturate( ( 1.0 - ( saturate( ( texCoord919.x + texCoord919.y ) ) + saturate( ( texCoord940.x - texCoord940.y ) ) ) ) ) , 3.25 ) ) * tex2DNode533.g ) - temp_output_470_0 ) / ( 1.0 - tex2DNode533.r ) ) ) );
				float Erosion819 = temp_output_610_0;
				float4 appendResult841 = (float4(_SpecColor.r , _SpecColor.g , _SpecColor.b , ( _SpecColor.a * Erosion819 )));
				float4 temp_output_644_0 = ( saturate( ( ( saturate( ( saturate( smoothstepResult782 ) - ( ( 1.0 - _Spec ) + 0.23 ) ) ) / temp_output_470_0 ) * _Spec ) ) * appendResult841 );
				float4 GradSpec559 = temp_output_644_0;
				float4 break813 = GradSpec559;
				float4 appendResult855 = (float4(break813.x , break813.y , break813.z , 0.0));
				float3 appendResult974 = (float3(i.ase_color.r , i.ase_color.g , i.ase_color.b));
				#ifdef _VERTEXCOLORON_ON
				float4 staticSwitch973 = float4( appendResult974 , 0.0 );
				#else
				float4 staticSwitch973 = _BaseColor;
				#endif
				float3 hsvTorgb978 = RGBToHSV( staticSwitch973.rgb );
				float3 hsvTorgb979 = HSVToRGB( float3(hsvTorgb978.x,saturate( ( ( hsvTorgb978.y + ( 1.0 - _ColorMult ) ) * 2.0 ) ),( hsvTorgb978.z * _ColorMult )) );
				float3 break716 = saturate( ( hsvTorgb979 * temp_output_610_0 ) );
				float4 appendResult715 = (float4(break716.x , break716.y , break716.z , saturate( temp_output_610_0 )));
				
				
				finalColor = saturate( ( appendResult855 + appendResult715 ) );
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
Node;AmplifyShaderEditor.SimpleDivideOpNode;556;4404.744,4065.735;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;641;3354.363,4403.878;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;703;3541.925,4397.483;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.23;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;555;4143.061,4215.467;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;553;3971.959,4297.159;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;740;3832.49,4229.926;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;648;3428.779,4150.755;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;782;3658.225,4232.918;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;794;3889.412,4407.945;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;663;3609.409,4058.484;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;792;3626.489,4074.68;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;686;3148.56,3765.82;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.09;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;642;4680.879,4502.364;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;643;4131.375,4691.313;Inherit;False;Property;_SpecColor;SpecColor;4;1;[HDR];Create;True;0;0;0;False;0;False;27.3029,1.748462,1.748462,0;0.270787,0.2697134,0.2735849,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;843;4442.79,4859.315;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;841;4628.797,4708.876;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;811;7015.986,2679.566;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;827;7055.603,2895.848;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;822;7517.267,2791.449;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;814;6758.492,2646.264;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;821;6797.462,2857.249;Inherit;True;819;Erosion;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;860;4866.921,4550.422;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;820;7278.363,2772.949;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;723;6470.223,3358.006;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;834;9239.483,3342.123;Inherit;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;560;8948.812,3287.15;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;715;8709.947,3358.449;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;908;7070.332,3060.724;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;910;7263.709,3196.646;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;911;7959.754,3292.694;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;844;7801.146,3071.748;Inherit;False;ErodingSpec;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;842;4201.53,5144.331;Inherit;False;819;Erosion;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;716;7636.502,3369.349;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SaturateNode;835;7062.718,3782.997;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;558;3045.472,4561.779;Inherit;False;Property;_Spec;Spec;1;0;Create;True;0;0;0;False;0;False;1;0.654;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;714;9664.277,3335.634;Float;False;True;-1;2;ASEMaterialInspector;100;5;vfx_pinatasplash_trail;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;2;5;False;;10;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;2;False;;True;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;2;False;;True;3;False;;True;False;0;False;;0;False;;True;1;RenderType=Transparent=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.WorldNormalVector;750;2870.421,3724.847;Inherit;True;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;766;2878.378,3978.033;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;668;2416.094,3844.003;Inherit;True;Property;_TextureSample1;Texture Sample 1;5;1;[Normal];Create;True;0;0;0;False;0;False;-1;92c2bb18f2c473d41accac78ec0464e9;1feb4ec626ea6ae45989e6328344fd6f;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;2;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;918;1926.37,3152.344;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;917;1771.678,3111.939;Inherit;False;Constant;_Float0;Float 0;9;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;916;1645.847,3211.217;Inherit;False;Property;_PanSpeed;PanSpeed;6;0;Create;True;0;0;0;False;0;False;1;0.27;-3;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;464;4790.491,3313.052;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;670;1846.978,2776.093;Inherit;False;0;533;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;470;3447.434,3479.368;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;793;3582.18,3608.945;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;597;3277.347,3499.36;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;480;2707.24,3481.815;Inherit;False;Property;_Erode;Erode;0;0;Create;True;0;0;0;False;0;False;0.8841566;0.925;0;0.98;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;724;3080.612,3464.728;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;744;3243.245,3422.739;Inherit;False;Erodeval;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;596;2745.177,3275.737;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;942;2882.742,2316.831;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;932;2905.742,1975.83;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;929;2581.883,1965.404;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;945;3261.026,2082.289;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;951;3439.924,2353.708;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;944;2983.101,2073.608;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;943;2487.322,2309.742;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;950;3570.794,2157.131;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;3.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;940;2202.742,2267.831;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.99,1.49;False;1;FLOAT2;-0.89,-0.52;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;919;2117.911,1869.298;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.99,1.27;False;1;FLOAT2;-1.07,-0.61;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;610;5191.124,3042.424;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;465;5000.156,3292.865;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;948;3917.721,2778.263;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;958;4152.461,3139.902;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;467;4492.57,3428.096;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;961;4092.114,3435.079;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;962;4128.2,3447.107;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;965;3890.047,3317.204;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;466;4500.333,3162.693;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;966;4302.605,3313.597;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;967;3926.131,3307.583;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;964;4332.675,3300.365;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;563;3749.885,2925.138;Inherit;False;A;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;968;3783.7,3065.268;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;963;4030.597,3167.38;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;969;4001.478,3146.356;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;533;3427.564,3113.931;Inherit;True;Property;_Main;Main;2;0;Create;True;0;0;0;False;0;False;-1;526f092497c01f34c8d42b0aee0f86aa;7f8541b04310ea94e9ed5ff458f6d0ae;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;915;2214.237,3137.271;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;845;5609.114,5126.316;Inherit;False;SpecAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;644;5118.041,4708.451;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;559;5403.695,4717.344;Inherit;False;GradSpec;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BreakToComponentsNode;840;5372.264,4818.572;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SaturateNode;859;6747.633,3363.334;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;906;7135.135,3196.745;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;855;6746.482,3085.118;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;907;6963.447,3188.758;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;819;5435.868,3741.158;Inherit;False;Erosion;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;970;6209.042,3787.6;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;971;6158.125,3755.597;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;561;6163.589,2302.669;Inherit;True;559;GradSpec;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BreakToComponentsNode;813;6483.788,2598.066;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.VertexColorNode;972;4642.627,2061.581;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;567;4851.866,2356.979;Inherit;False;Property;_BaseColor;BaseColor;3;1;[HDR];Create;True;0;0;0;False;0;False;0.3301887,0,0,1;0.3018868,0.00711997,0.00711997,0.9058824;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;973;5211.627,2352.581;Inherit;False;Property;_VertexcolorOn;VertexcolorOn;7;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RGBToHSVNode;978;5474.627,2295.581;Inherit;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;974;4971.627,2091.581;Inherit;True;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;977;5313.627,2643.581;Inherit;False;Property;_ColorMult;ColorMult;8;0;Create;True;0;0;0;False;0;False;0.1684782;0;0;1.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;980;5631.424,2908.354;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;982;5894.424,2879.354;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;984;5797.424,2849.354;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;986;5720.424,2367.354;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;988;5682.424,2423.354;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;991;5681.424,2768.354;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;989;5740.424,2715.354;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;985;5707.424,2407.354;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;992;6064.424,2698.354;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;987;5879.424,2658.354;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;976;5882.627,2748.581;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.HSVToRGBNode;979;6237.627,2759.581;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WireNode;993;6120.424,2816.354;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;983;6046.424,3019.354;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;995;6079.533,2906.3;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;799;5177.981,2457.064;Inherit;False;BaseAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
WireConnection;556;0;555;0
WireConnection;556;1;792;0
WireConnection;641;0;558;0
WireConnection;703;0;641;0
WireConnection;555;0;553;0
WireConnection;553;0;740;0
WireConnection;553;1;794;0
WireConnection;740;0;782;0
WireConnection;648;0;750;2
WireConnection;782;0;648;0
WireConnection;794;0;703;0
WireConnection;663;0;793;0
WireConnection;792;0;663;0
WireConnection;686;0;750;2
WireConnection;686;1;766;0
WireConnection;642;0;556;0
WireConnection;642;1;558;0
WireConnection;843;0;643;4
WireConnection;843;1;842;0
WireConnection;841;0;643;1
WireConnection;841;1;643;2
WireConnection;841;2;643;3
WireConnection;841;3;843;0
WireConnection;811;0;814;0
WireConnection;827;0;821;0
WireConnection;822;0;820;0
WireConnection;814;0;813;0
WireConnection;814;1;813;1
WireConnection;814;2;813;2
WireConnection;860;0;642;0
WireConnection;820;0;811;0
WireConnection;820;1;827;0
WireConnection;723;0;979;0
WireConnection;723;1;610;0
WireConnection;834;0;560;0
WireConnection;560;0;911;0
WireConnection;560;1;715;0
WireConnection;715;0;716;0
WireConnection;715;1;716;1
WireConnection;715;2;716;2
WireConnection;715;3;835;0
WireConnection;908;0;907;0
WireConnection;910;0;906;0
WireConnection;911;0;910;0
WireConnection;844;0;822;0
WireConnection;716;0;859;0
WireConnection;835;0;970;0
WireConnection;714;0;834;0
WireConnection;750;0;668;0
WireConnection;766;0;668;2
WireConnection;668;1;915;0
WireConnection;918;0;916;0
WireConnection;918;1;917;0
WireConnection;464;0;466;0
WireConnection;464;1;467;0
WireConnection;470;0;597;0
WireConnection;793;0;470;0
WireConnection;597;0;724;0
WireConnection;724;0;596;4
WireConnection;724;1;480;0
WireConnection;744;0;724;0
WireConnection;942;0;943;0
WireConnection;932;0;929;0
WireConnection;929;0;919;1
WireConnection;929;1;919;2
WireConnection;945;0;944;0
WireConnection;951;0;945;0
WireConnection;944;0;932;0
WireConnection;944;1;942;0
WireConnection;943;0;940;1
WireConnection;943;1;940;2
WireConnection;950;0;951;0
WireConnection;610;0;968;0
WireConnection;610;1;465;0
WireConnection;465;0;464;0
WireConnection;948;0;950;0
WireConnection;958;0;948;0
WireConnection;958;1;533;2
WireConnection;467;0;962;0
WireConnection;961;0;963;0
WireConnection;962;0;961;0
WireConnection;965;0;470;0
WireConnection;466;0;958;0
WireConnection;466;1;964;0
WireConnection;966;0;967;0
WireConnection;967;0;965;0
WireConnection;964;0;966;0
WireConnection;563;0;533;1
WireConnection;968;0;533;1
WireConnection;963;0;969;0
WireConnection;969;0;533;1
WireConnection;533;1;915;0
WireConnection;915;0;670;0
WireConnection;915;2;918;0
WireConnection;845;0;840;3
WireConnection;644;0;860;0
WireConnection;644;1;841;0
WireConnection;559;0;644;0
WireConnection;840;0;644;0
WireConnection;859;0;723;0
WireConnection;906;0;908;0
WireConnection;855;0;813;0
WireConnection;855;1;813;1
WireConnection;855;2;813;2
WireConnection;907;0;855;0
WireConnection;819;0;610;0
WireConnection;970;0;971;0
WireConnection;971;0;610;0
WireConnection;813;0;561;0
WireConnection;973;1;567;0
WireConnection;973;0;974;0
WireConnection;978;0;973;0
WireConnection;974;0;972;1
WireConnection;974;1;972;2
WireConnection;974;2;972;3
WireConnection;980;0;977;0
WireConnection;982;0;984;0
WireConnection;982;1;980;0
WireConnection;984;0;985;0
WireConnection;986;0;978;1
WireConnection;988;0;978;3
WireConnection;991;0;977;0
WireConnection;989;0;988;0
WireConnection;985;0;978;2
WireConnection;992;0;987;0
WireConnection;987;0;986;0
WireConnection;976;0;989;0
WireConnection;976;1;991;0
WireConnection;979;0;992;0
WireConnection;979;1;983;0
WireConnection;979;2;993;0
WireConnection;993;0;976;0
WireConnection;983;0;995;0
WireConnection;995;0;982;0
WireConnection;799;0;567;4
ASEEND*/
//CHKSM=D97041860B40CF3EF9FAC9CBA9EEB9A74478536F
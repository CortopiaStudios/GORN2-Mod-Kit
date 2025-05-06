// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AsePaintableCharTest"
{
	Properties
	{
		_Diffuse("Diffuse", 2D) = "white" {}
		_MaskTexture("MaskTexture", 2D) = "black" {}
		_Meat("Meat", 2D) = "white" {}
		_BloodCutBruiseMask("BloodCutBruiseMask", 2D) = "white" {}
		_DryBlood("DryBlood", Color) = (0.4150943,0,0,0)
		_WetBlood("WetBlood", Color) = (1,0,0,0)
		_CutEdge("CutEdge", Color) = (0.7529412,0.3137255,0.2392157,0)
		_BruiseColor("BruiseColor", Color) = (0.2873822,0.2028747,0.4433962,0)
		_MeatDark("MeatDark", Float) = 4.5
		_ParallaxHeight("ParallaxHeight", Float) = -0.1
		_BruiseStrenght("BruiseStrenght", Float) = 1
		_BloodEdge("BloodEdge", Float) = 1
		_BloodEdgeTiling("BloodEdgeTiling", Vector) = (5,5,0,0)
		_CutEdgeTiling("CutEdgeTiling", Vector) = (10,10,0,0)
		_BruiseTiling("BruiseTiling", Vector) = (20,20,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 viewDir;
			INTERNAL_DATA
		};

		uniform sampler2D _Meat;
		uniform sampler2D _MaskTexture;
		uniform float4 _MaskTexture_ST;
		uniform float _ParallaxHeight;
		uniform float _MeatDark;
		uniform float4 _CutEdge;
		uniform sampler2D _Diffuse;
		uniform float4 _Diffuse_ST;
		uniform float4 _BruiseColor;
		uniform sampler2D _BloodCutBruiseMask;
		uniform float2 _BruiseTiling;
		uniform float _BruiseStrenght;
		uniform float2 _CutEdgeTiling;
		uniform float4 _DryBlood;
		uniform float4 _WetBlood;
		uniform float _BloodEdge;
		uniform float2 _BloodEdgeTiling;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = float3(0,0,1);
			float2 uv_TexCoord46 = i.uv_texcoord * float2( 5,5 );
			float2 uv_MaskTexture = i.uv_texcoord * _MaskTexture_ST.xy + _MaskTexture_ST.zw;
			float4 tex2DNode2 = tex2D( _MaskTexture, uv_MaskTexture );
			float Cut135 = tex2DNode2.g;
			float2 paralaxOffset65 = ParallaxOffset( Cut135 , _ParallaxHeight , i.viewDir );
			float temp_output_72_0 = ( ( 1.0 - Cut135 ) + 0.65 );
			float4 CutEdgeColor211 = _CutEdge;
			float2 uv_Diffuse = i.uv_texcoord * _Diffuse_ST.xy + _Diffuse_ST.zw;
			float4 Diffuse196 = tex2D( _Diffuse, uv_Diffuse );
			float4 BruiseColor198 = _BruiseColor;
			float Bruises134 = tex2DNode2.b;
			float2 uv_TexCoord180 = i.uv_texcoord * _BruiseTiling;
			float BruiseBreakup181 = tex2D( _BloodCutBruiseMask, uv_TexCoord180 ).a;
			float BruiseLerp201 = saturate( ( Bruises134 * ( BruiseBreakup181 * _BruiseStrenght ) ) );
			float4 lerpResult3 = lerp( Diffuse196 , BruiseColor198 , BruiseLerp201);
			float2 uv_TexCoord174 = i.uv_texcoord * _CutEdgeTiling;
			float CutEdgeMask177 = tex2D( _BloodCutBruiseMask, uv_TexCoord174 ).g;
			float temp_output_41_0 = ( Cut135 + ( Cut135 * CutEdgeMask177 ) );
			float CutEdgeLerp209 = step( temp_output_41_0 , 0.6 );
			float4 lerpResult96 = lerp( CutEdgeColor211 , lerpResult3 , CutEdgeLerp209);
			float CutMaskLerp213 = step( temp_output_41_0 , 0.8 );
			float4 lerpResult36 = lerp( ( tex2D( _Meat, ( uv_TexCoord46 + paralaxOffset65 ) ) * saturate( pow( temp_output_72_0 , _MeatDark ) ) ) , lerpResult96 , CutMaskLerp213);
			float BloodDry132 = tex2DNode2.r;
			float BloodWet133 = tex2DNode2.a;
			float2 uv_TexCoord143 = i.uv_texcoord * _BloodEdgeTiling;
			float BloodEdgeMask175 = tex2D( _BloodCutBruiseMask, uv_TexCoord143 ).r;
			float BloodLerp202 = saturate( step( _BloodEdge , ( BloodDry132 + ( BloodDry132 * BloodEdgeMask175 ) ) ) );
			float4 lerpResult118 = lerp( lerpResult36 , ( ( _DryBlood * BloodDry132 ) + ( _WetBlood * BloodWet133 ) ) , BloodLerp202);
			o.Albedo = lerpResult118.rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = IN.tSpace0.xyz * worldViewDir.x + IN.tSpace1.xyz * worldViewDir.y + IN.tSpace2.xyz * worldViewDir.z;
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.CommentaryNode;123;-657.4001,288.2324;Inherit;False;1150.118;450.8744;BloodMask;8;136;114;116;146;148;157;176;202;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;113;-659.1241,-257.949;Inherit;False;1152.388;533.1783;CutMask_And_CutEdge;10;138;40;41;93;38;37;178;209;211;213;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;87;-655.3412,762.3974;Inherit;False;1142.78;572.1578;BruiseMask;7;111;110;109;193;183;139;201;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;76;-649.3594,-627.3624;Inherit;False;1140.722;352.1894;CutDarkenCenter (get this in parallax);7;72;86;71;61;137;70;160;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;2;-1354.294,-226.269;Inherit;True;Property;_MaskTexture;MaskTexture;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;133;-993.0374,-67.19239;Inherit;False;BloodWet;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;86;352.7857,-586.6308;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;44;16.38317,-867.4875;Inherit;True;Property;_Meat;Meat;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;575.3989,-673.5864;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;46;-653.1776,-865.1249;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;5,5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ParallaxOffsetHlpNode;65;-661.1693,-749.8821;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;68;-410.6218,-792.6445;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;137;-642.5854,-579.0183;Inherit;False;135;Cut;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;134;-1003.16,-149.4545;Inherit;False;Bruises;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;135;-997.6661,-237.5257;Inherit;False;Cut;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;132;-997.3151,-327.1772;Inherit;False;BloodDry;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;41;-196.4259,-214.966;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-432.5918,-112.4362;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;138;-649.3497,-215.7519;Inherit;False;135;Cut;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;178;-646.5389,-93.04408;Inherit;False;177;CutEdgeMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;175;-1003.068,64.67744;Inherit;False;BloodEdgeMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;143;-1606.563,68.64729;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;5,5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;174;-1599.005,265.6931;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;10,10;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;182;-1832.025,87.31982;Inherit;False;Property;_BloodEdgeTiling;BloodEdgeTiling;12;0;Create;True;0;0;0;False;0;False;5,5;5,5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;184;-1829.477,285.9804;Inherit;False;Property;_CutEdgeTiling;CutEdgeTiling;13;0;Create;True;0;0;0;False;0;False;10,10;5,5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;177;-1014.753,286.2508;Inherit;False;CutEdgeMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;179;-1362.47,437.4956;Inherit;True;Property;_TextureSample1;Texture Sample 1;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;142;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;180;-1606.564,466.4039;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;5,5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;185;-1831.012,486.0269;Inherit;False;Property;_BruiseTiling;BruiseTiling;14;0;Create;True;0;0;0;False;0;False;20,20;5,5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;66;-1066.592,-949.8809;Inherit;False;Property;_ParallaxHeight;ParallaxHeight;9;0;Create;True;0;0;0;False;0;False;-0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;67;-1090.628,-833.4075;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;141;-922.4424,-1022.167;Inherit;False;135;Cut;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1357.444,-425.6466;Inherit;True;Property;_Diffuse;Diffuse;0;0;Create;True;0;0;0;False;0;False;-1;None;ed6c812fefc816740984fa70b2cefd55;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;196;-1001.639,-426.8839;Inherit;False;Diffuse;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;181;-1012.765,532.7059;Inherit;False;BruiseBreakup;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;136;-643.9296,432.4744;Inherit;False;132;BloodDry;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;-432.7103,516.1415;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;116;48.86977,409.3631;Inherit;True;2;0;FLOAT;0.91;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;146;-143.3898,348.9427;Inherit;False;Property;_BloodEdge;BloodEdge;11;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;157;-196.7396,434.4481;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;176;-646.9471,536.6927;Inherit;False;175;BloodEdgeMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;202;289.5011,550.7649;Inherit;False;BloodLerp;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;148;256.5045,409.2475;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;139;-606.9958,1035.461;Inherit;False;134;Bruises;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;110;-596.9654,1190.107;Inherit;False;Property;_BruiseStrenght;BruiseStrenght;10;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;183;-628.7003,1109.209;Inherit;False;181;BruiseBreakup;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;193;-134.5887,1044.796;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;-400.8396,1116.938;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;111;82.61307,1044.095;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;201;246.5427,1039.779;Inherit;False;BruiseLerp;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;34;-75.77417,827.2397;Inherit;False;Property;_BruiseColor;BruiseColor;7;0;Create;True;0;0;0;False;0;False;0.2873822,0.2028747,0.4433962,0;0.2113207,0,0.6037736,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;198;251.6804,826.8846;Inherit;False;BruiseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;72;-256.1237,-591.0297;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.65;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;70;-465.6585,-576.2056;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-206.1408,-361.62;Inherit;False;Property;_MeatDark;MeatDark;8;0;Create;True;0;0;0;False;0;False;4.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;160;-428.1819,-497.8883;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;208;77.94415,-379.8285;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;45.45146,-594.4345;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;38;69.33189,-217.0459;Inherit;False;2;0;FLOAT;0.8;False;1;FLOAT;0.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;142;-1353.996,41.24463;Inherit;True;Property;_BloodCutBruiseMask;BloodCutBruiseMask;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;173;-1356.911,238.2904;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;142;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;93;70.6252,-105.6263;Inherit;False;2;0;FLOAT;0.7;False;1;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;37;4.930472,23.26546;Inherit;False;Property;_CutEdge;CutEdge;6;0;Create;True;0;0;0;False;0;False;0.7529412,0.3137255,0.2392157,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;209;272.1737,-110.5389;Inherit;False;CutEdgeLerp;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;211;273.4734,23.36111;Inherit;False;CutEdgeColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;213;268.4441,-223.4068;Inherit;False;CutMaskLerp;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;118;1977.518,-320.9405;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;203;1531.266,338.8925;Inherit;False;202;BloodLerp;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;120;1247.132,-119.6919;Inherit;False;Property;_DryBlood;DryBlood;4;0;Create;True;0;0;0;False;0;False;0.4150943,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;124;1470.742,-19.65694;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;126;1606.669,133.643;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;125;1460.166,220.3828;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;131;1059.222,3.481905;Inherit;False;132;BloodDry;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;140;1068.773,236.5556;Inherit;False;133;BloodWet;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;127;1242.105,94.29644;Inherit;False;Property;_WetBlood;WetBlood;5;0;Create;True;0;0;0;False;0;False;1,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2281.39,-321.7833;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;AsePaintableCharTest;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.LerpOp;36;1536.536,-413.843;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;1,1,1,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;96;1090.002,-387.5654;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;212;819.6943,-441.7984;Inherit;False;211;CutEdgeColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;199;562.3214,-340.0814;Inherit;False;198;BruiseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;200;568.5836,-262.0183;Inherit;False;201;BruiseLerp;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;197;572.8604,-415.7493;Inherit;False;196;Diffuse;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;3;778.6278,-363.4987;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;210;825.5943,-148.7984;Inherit;False;209;CutEdgeLerp;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;215;1324.965,-316.5661;Inherit;False;213;CutMaskLerp;1;0;OBJECT;;False;1;FLOAT;0
WireConnection;133;0;2;4
WireConnection;86;0;208;0
WireConnection;44;1;68;0
WireConnection;55;0;44;0
WireConnection;55;1;86;0
WireConnection;65;0;141;0
WireConnection;65;1;66;0
WireConnection;65;2;67;0
WireConnection;68;0;46;0
WireConnection;68;1;65;0
WireConnection;134;0;2;3
WireConnection;135;0;2;2
WireConnection;132;0;2;1
WireConnection;41;0;138;0
WireConnection;41;1;40;0
WireConnection;40;0;138;0
WireConnection;40;1;178;0
WireConnection;175;0;142;1
WireConnection;143;0;182;0
WireConnection;174;0;184;0
WireConnection;177;0;173;2
WireConnection;179;1;180;0
WireConnection;180;0;185;0
WireConnection;196;0;1;0
WireConnection;181;0;179;4
WireConnection;114;0;136;0
WireConnection;114;1;176;0
WireConnection;116;0;146;0
WireConnection;116;1;157;0
WireConnection;157;0;136;0
WireConnection;157;1;114;0
WireConnection;202;0;148;0
WireConnection;148;0;116;0
WireConnection;193;0;139;0
WireConnection;193;1;109;0
WireConnection;109;0;183;0
WireConnection;109;1;110;0
WireConnection;111;0;193;0
WireConnection;201;0;111;0
WireConnection;198;0;34;0
WireConnection;72;0;70;0
WireConnection;70;0;137;0
WireConnection;208;0;72;0
WireConnection;208;1;61;0
WireConnection;71;0;72;0
WireConnection;71;1;61;0
WireConnection;38;0;41;0
WireConnection;142;1;143;0
WireConnection;173;1;174;0
WireConnection;93;0;41;0
WireConnection;209;0;93;0
WireConnection;211;0;37;0
WireConnection;213;0;38;0
WireConnection;118;0;36;0
WireConnection;118;1;126;0
WireConnection;118;2;203;0
WireConnection;124;0;120;0
WireConnection;124;1;131;0
WireConnection;126;0;124;0
WireConnection;126;1;125;0
WireConnection;125;0;127;0
WireConnection;125;1;140;0
WireConnection;0;0;118;0
WireConnection;36;0;55;0
WireConnection;36;1;96;0
WireConnection;36;2;215;0
WireConnection;96;0;212;0
WireConnection;96;1;3;0
WireConnection;96;2;210;0
WireConnection;3;0;197;0
WireConnection;3;1;199;0
WireConnection;3;2;200;0
ASEEND*/
//CHKSM=A73D5F80494B71C078FBD5F1BFBC1BD3A243D0E4
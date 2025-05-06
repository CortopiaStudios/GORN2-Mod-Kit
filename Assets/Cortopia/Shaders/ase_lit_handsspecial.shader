// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ase_lit_handsspecial"
{
	Properties
	{
		_AlbedoSmoothness("Albedo Smoothness", 2D) = "white" {}
		[Toggle(_NORMALMAPENABLED_ON)] _NormalmapEnabled("Normalmap Enabled", Float) = 0
		_Normal("Normal", 2D) = "bump" {}
		[Toggle(_ISMETALLIC_ON)] _IsMetallic("IsMetallic", Float) = 0
		[Toggle(_FORCEGRABBABLE_ON)] _ForceGrabbable("ForceGrabbable", Float) = 0
		_Inline("Inline", Int) = 0
		_Texture0("Texture 0", 2D) = "white" {}
		_ContrastBoost("ContrastBoost", Range( 0 , 10)) = 2.67783
		_Erode("Erode", Range( 0 , 1)) = 0.7828199
		_Wonker("Wonker", Range( -3 , 3)) = 1.794596
		[Toggle]_InvertPowerUpTex("InvertPowerUpTex", Float) = 0
		[HDR]_PowerUpCol("PowerUpCol", Color) = (0,0.5913393,1,0.5960785)
		_PowerUpTexPanner("PowerUpTexPanner", Range( -1 , 1)) = 0.2301106
		_FresnelMult("FresnelMult", Range( 0 , 3)) = 0
		_Fade("Fade", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _NORMALMAPENABLED_ON
		#pragma shader_feature_local _FORCEGRABBABLE_ON
		#pragma shader_feature_local _ISMETALLIC_ON
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
			float4 vertexColor : COLOR;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _AlbedoSmoothness;
		uniform float4 _AlbedoSmoothness_ST;
		uniform float _Fade;
		uniform float4 _PowerUpCol;
		uniform float _ContrastBoost;
		uniform float _InvertPowerUpTex;
		uniform sampler2D _Texture0;
		uniform float _PowerUpTexPanner;
		uniform float4 _Texture0_ST;
		uniform float _Wonker;
		uniform float _Erode;
		uniform float _FresnelMult;
		uniform int _Inline;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			#ifdef _NORMALMAPENABLED_ON
				float3 staticSwitch3 = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			#else
				float3 staticSwitch3 = float3(0,0,1);
			#endif
			o.Normal = staticSwitch3;
			float2 uv_AlbedoSmoothness = i.uv_texcoord * _AlbedoSmoothness_ST.xy + _AlbedoSmoothness_ST.zw;
			float4 tex2DNode1 = tex2D( _AlbedoSmoothness, uv_AlbedoSmoothness );
			o.Albedo = tex2DNode1.rgb;
			float mulTime63 = _Time.y * _PowerUpTexPanner;
			float2 uv_TexCoord32 = i.uv_texcoord * _Texture0_ST.xy + _Texture0_ST.zw;
			float2 panner39 = ( mulTime63 * float2( -0.3,-0.3 ) + uv_TexCoord32);
			float2 uv_TexCoord35 = i.uv_texcoord * ( _Texture0_ST.xy * float2( 1.5,1 ) ) + _Texture0_ST.zw;
			float2 panner37 = ( mulTime63 * float2( 0.3,0.3 ) + uv_TexCoord35);
			float4 tex2DNode33 = tex2D( _Texture0, panner37 );
			float2 temp_cast_1 = (( ( _Wonker * tex2DNode33.r ) + tex2DNode33.r )).xx;
			float2 lerpResult59 = lerp( panner39 , temp_cast_1 , float2( 0.5,0.5 ));
			float temp_output_21_0 = ( tex2D( _Texture0, lerpResult59 ).r * _Erode );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV12 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode12 = ( 0.0 + 162.1 * pow( 1.0 - fresnelNdotV12, 17.0 ) );
			float fresnelNdotV11_g1 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode11_g1 = ( 0.0 + 2.0 * pow( 1.0 - fresnelNdotV11_g1, 5.0 ) );
			#ifdef _FORCEGRABBABLE_ON
				float staticSwitch9 = ( _Inline * fresnelNode11_g1 );
			#else
				float staticSwitch9 = 0.0;
			#endif
			o.Emission = ( _Fade * ( i.vertexColor * ( ( _PowerUpCol * ( saturate( ( _ContrastBoost * ( ( saturate( (( _InvertPowerUpTex )?( ( 1.0 - temp_output_21_0 ) ):( temp_output_21_0 )) ) - ( 1.0 - _Erode ) ) / _Erode ) ) ) + ( fresnelNode12 * _FresnelMult ) ) ) + staticSwitch9 ) ) ).rgb;
			#ifdef _ISMETALLIC_ON
				float staticSwitch8 = i.vertexColor.r;
			#else
				float staticSwitch8 = 0.0;
			#endif
			o.Metallic = staticSwitch8;
			o.Smoothness = tex2DNode1.a;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows exclude_path:deferred nodynlightmap nofog noforwardadd 

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
				half4 color : COLOR0;
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
				o.color = v.color;
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
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.vertexColor = IN.color;
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
Node;AmplifyShaderEditor.Vector3Node;2;-436.8333,-768.3466;Inherit;False;Constant;_Vector0;Vector 0;8;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;4;-538.8333,-606.5569;Inherit;True;Property;_Normal;Normal;2;0;Create;True;0;0;0;False;0;False;-1;None;815947030db20514499a9a38bbb6ba95;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;6;-453.5,35.25;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;7;-425.5,-48.75;Inherit;False;Constant;_Float0;Float 0;4;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;8;-73.5,49.25;Inherit;False;Property;_IsMetallic;IsMetallic;3;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;3;-146.8333,-516.3466;Inherit;False;Property;_NormalmapEnabled;Normalmap Enabled;1;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;9;-149.5,-191.75;Inherit;False;Property;_ForceGrabbable;ForceGrabbable;4;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-405.5,-250.75;Inherit;False;Constant;_Float1;Float 1;5;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;11;-499.5,-167.75;Inherit;False;ase_function_forcegrab;5;;1;28a011451f93f55429710d8f45046efa;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;1003.303,-884.4003;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;15;1217.576,-540.3524;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;660.4883,-274.798;Inherit;True;Property;_AlbedoSmoothness;Albedo Smoothness;0;0;Create;True;0;0;0;False;0;False;-1;None;4230e633362bde44ea81c6205150bbc7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;69;-293.8033,-1699.057;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;70;-315.4044,-1693.057;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;22;-688.9783,-1602.099;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;40;-1957.771,-2736.643;Inherit;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.OneMinusNode;60;-1075.151,-1994.691;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-1316.262,-2086.527;Inherit;True;2;2;0;FLOAT;1;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;1487.072,-519.8677;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;29;-1639.217,-2437.438;Inherit;True;Property;_TextureSample0;Texture Sample 0;9;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;59;-1802.638,-2372.513;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;33;-2428.945,-2003.184;Inherit;True;Property;_TextureSample1;Texture Sample 1;9;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;37;-2756.97,-1968.38;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.3,0.3;False;1;FLOAT;0.3;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;73;-2841.653,-1979.847;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;74;-2858.124,-2239.269;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;39;-2108.027,-2523.56;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.3,-0.3;False;1;FLOAT;0.1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;32;-3170.509,-2531.397;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;19;-2683.538,-2841.999;Inherit;True;Property;_Texture0;Texture 0;7;0;Create;True;0;0;0;False;0;False;ee2aca0150f742c45b3548c859d3470b;dfefd45a87f80d344ad079e21d5da47c;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleAddOpNode;58;-1995.911,-2225.829;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-2146.419,-2263.893;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-2421.752,-2264.204;Inherit;False;Property;_Wonker;Wonker;10;0;Create;True;0;0;0;False;0;False;1.794596;-0.93;-3;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-1688.823,-1732.131;Inherit;False;Property;_Erode;Erode;9;0;Create;True;0;0;0;False;0;False;0.7828199;0.568;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;28;-1380.308,-1601.991;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;24;-140.7325,-1847.756;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;23;-464.9046,-1920.913;Inherit;True;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;61;-928.8473,-2085.593;Inherit;False;Property;_InvertPowerUpTex;InvertPowerUpTex;11;0;Create;True;0;0;0;False;0;False;0;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;67;-689.8407,-2085.656;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2202.774,-223.8776;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;ase_lit_handsspecial;False;False;False;False;False;False;False;True;False;True;False;True;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.RangedFloatNode;76;1584.122,-660.4453;Inherit;False;Property;_Fade;Fade;15;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;63;-3136.951,-2096.652;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;78;-2689.077,-2364.608;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;77;-2765.077,-2119.608;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-3409.328,-2096.724;Inherit;False;Property;_PowerUpTexPanner;PowerUpTexPanner;13;0;Create;True;0;0;0;False;0;False;0.2301106;-0.152;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;35;-3192.67,-2324.667;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;5,0.5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;17;629.3495,-857.2861;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;27;319.1746,-1719.72;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;125.4984,-1888.636;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-216.3208,-2060.397;Inherit;False;Property;_ContrastBoost;ContrastBoost;8;0;Create;True;0;0;0;False;0;False;2.67783;7.52;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureTransformNode;31;-3731.95,-2513.301;Inherit;False;19;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;-3503.005,-2302.555;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;1.5,1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VertexColorNode;71;1267.379,-767.5645;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;1894.762,-540.1927;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-111.0227,-834.2491;Inherit;False;Property;_FresnelMult;FresnelMult;14;0;Create;True;0;0;0;False;0;False;0;1.63;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;215.6466,-1043.027;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;12;-32.99789,-1073.316;Inherit;False;Standard;TangentNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;162.1;False;3;FLOAT;17;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;52;731.9588,-1676.84;Inherit;False;Property;_PowerUpCol;PowerUpCol;12;1;[HDR];Create;True;0;0;0;False;0;False;0,0.5913393,1,0.5960785;0,0.5913393,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;8;1;7;0
WireConnection;8;0;6;1
WireConnection;3;1;2;0
WireConnection;3;0;4;0
WireConnection;9;1;10;0
WireConnection;9;0;11;0
WireConnection;53;0;52;0
WireConnection;53;1;17;0
WireConnection;15;0;53;0
WireConnection;15;1;9;0
WireConnection;69;0;70;0
WireConnection;70;0;20;0
WireConnection;22;0;28;0
WireConnection;40;0;19;0
WireConnection;60;0;21;0
WireConnection;21;0;29;1
WireConnection;21;1;20;0
WireConnection;72;0;71;0
WireConnection;72;1;15;0
WireConnection;29;0;40;0
WireConnection;29;1;59;0
WireConnection;59;0;39;0
WireConnection;59;1;58;0
WireConnection;33;0;19;0
WireConnection;33;1;37;0
WireConnection;37;0;73;0
WireConnection;37;1;63;0
WireConnection;73;0;74;0
WireConnection;74;0;35;0
WireConnection;39;0;32;0
WireConnection;39;1;78;0
WireConnection;32;0;31;0
WireConnection;32;1;31;1
WireConnection;58;0;41;0
WireConnection;58;1;33;1
WireConnection;41;0;42;0
WireConnection;41;1;33;1
WireConnection;28;0;20;0
WireConnection;24;0;23;0
WireConnection;24;1;69;0
WireConnection;23;0;67;0
WireConnection;23;1;22;0
WireConnection;61;0;21;0
WireConnection;61;1;60;0
WireConnection;67;0;61;0
WireConnection;0;0;1;0
WireConnection;0;1;3;0
WireConnection;0;2;75;0
WireConnection;0;3;8;0
WireConnection;0;4;1;4
WireConnection;63;0;62;0
WireConnection;78;0;77;0
WireConnection;77;0;63;0
WireConnection;35;0;80;0
WireConnection;35;1;31;1
WireConnection;17;0;27;0
WireConnection;17;1;14;0
WireConnection;27;0;26;0
WireConnection;26;0;25;0
WireConnection;26;1;24;0
WireConnection;80;0;31;0
WireConnection;75;0;76;0
WireConnection;75;1;72;0
WireConnection;14;0;12;0
WireConnection;14;1;64;0
ASEEND*/
//CHKSM=97D00470D934FA7B692596995DEAFB29DF574F57
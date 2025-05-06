// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ase_water_ripples_parallax"
{
	Properties
	{
		_RippleTex("_RippleTex", 2D) = "white" {}
		_Color0("Color 0", Color) = (0,0.9301295,1,0)
		_Offset("Offset", Float) = -0.001
		_Caustics("Caustics", 2D) = "white" {}
		_DepthTex("DepthTex", 2D) = "white" {}
		[HDR]_DepthCol("DepthCol", Color) = (0.1587837,0.09233712,0.7830189,0)
		_DepthTiling("DepthTiling", Range( 0 , 5)) = 1
		_DepthTexIntensity("DepthTexIntensity", Range( -3 , 3)) = 0
		_DepthAdd("DepthAdd", Range( 0 , 1)) = 0
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

		uniform sampler2D _Caustics;
		uniform sampler2D _RippleTex;
		uniform float4 _RippleTex_ST;
		uniform float _DepthTexIntensity;
		uniform sampler2D _DepthTex;
		uniform float _DepthTiling;
		uniform float _Offset;
		uniform float _DepthAdd;
		uniform float4 _Color0;
		uniform float4 _DepthCol;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Normal = float3(0,0,1);
			float2 uv_TexCoord39 = i.uv_texcoord * float2( 3,3 );
			float mulTime46 = _Time.y * 0.1;
			float2 temp_cast_0 = (mulTime46).xx;
			float2 uv_TexCoord43 = i.uv_texcoord * float2( 4,4 ) + temp_cast_0;
			float2 uv_RippleTex = i.uv_texcoord * _RippleTex_ST.xy + _RippleTex_ST.zw;
			float2 temp_cast_1 = (_DepthTiling).xx;
			float temp_output_59_0 = ( 0.01 + _Offset );
			float2 uv_TexCoord75 = i.uv_texcoord * temp_cast_1 + ( i.viewDir * temp_output_59_0 ).xy;
			float lerpResult79 = lerp( tex2D( _DepthTex, uv_TexCoord75 ).r , 1.0 , 0.1);
			float2 temp_cast_3 = (_DepthTiling).xx;
			float temp_output_60_0 = ( temp_output_59_0 + _Offset );
			float2 uv_TexCoord66 = i.uv_texcoord * temp_cast_3 + ( i.viewDir * temp_output_60_0 ).xy;
			float smoothstepResult73 = smoothstep( 0.05 , 1.0 , tex2D( _DepthTex, uv_TexCoord66 ).r);
			float lerpResult76 = lerp( smoothstepResult73 , 1.0 , 0.2);
			float2 temp_cast_5 = (_DepthTiling).xx;
			float2 uv_TexCoord69 = i.uv_texcoord * temp_cast_5 + ( i.viewDir * ( temp_output_60_0 + _Offset ) ).xy;
			float smoothstepResult74 = smoothstep( 0.15 , 1.0 , tex2D( _DepthTex, uv_TexCoord69 ).r);
			float lerpResult77 = lerp( smoothstepResult74 , 1.0 , 0.3);
			float4 temp_cast_7 = (( _DepthTexIntensity * ( 1.0 - ( lerpResult79 * ( lerpResult76 * lerpResult77 ) ) ) * ( 1.0 - _DepthAdd ) )).xxxx;
			float4 temp_output_87_0 = ( tex2D( _Caustics, ( uv_TexCoord39 + ( ( tex2D( _Caustics, uv_TexCoord43 ).a * 0.1 ) * ( 1.0 - saturate( ( tex2D( _RippleTex, uv_RippleTex ).r * 5.0 ) ) ) ) ) ) - temp_cast_7 );
			float4 temp_cast_8 = (( _DepthTexIntensity * ( 1.0 - ( lerpResult79 * ( lerpResult76 * lerpResult77 ) ) ) * ( 1.0 - _DepthAdd ) )).xxxx;
			o.Emission = saturate( ( ( temp_output_87_0 * _Color0 ) + ( _DepthAdd * ( saturate( temp_output_87_0 ) * _DepthCol ) ) ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows 

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
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
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
Node;AmplifyShaderEditor.SimpleAddOpNode;25;599.3029,-689.3334;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;60;-5468.772,688.7537;Inherit;False;2;2;0;FLOAT;0.001;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;61;-5388.772,1232.754;Inherit;False;2;2;0;FLOAT;0.001;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;63;-5228.772,928.7537;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-4972.772,1008.754;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;70;-3564.769,448.7537;Inherit;True;Property;_TextureSample4;Texture Sample 4;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;72;-3548.769,912.7537;Inherit;True;Property;_TextureSample6;Texture Sample 6;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;78;-3564.769,0.7537422;Inherit;True;Property;_TextureSample1;Texture Sample 1;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;36;-1452.576,-896.0084;Inherit;True;Property;_Caustics;Caustics;3;0;Create;True;0;0;0;False;0;False;-1;0405c09f850d93b4cabfc04955114fd7;0405c09f850d93b4cabfc04955114fd7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;44;-1583.256,-870.9142;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;14;-1986.644,-631.5432;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;33;-2138.433,-491.316;Inherit;False;1;0;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;39;-1942.812,-1006.82;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;3,3;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-2595.475,-226.7215;Inherit;True;Property;_RippleTex;_RippleTex;0;0;Create;True;0;0;0;False;0;False;-1;None;7cf6afe4105669349bd222f33ba5795d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;86;-5106.585,-199.0776;Inherit;False;Property;_DepthTiling;DepthTiling;6;0;Create;True;0;0;0;False;0;False;1;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;88;-836.5122,-204.3324;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;59;-5596.772,352.7537;Inherit;False;2;2;0;FLOAT;0.01;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;58;-6076.772,352.7537;Inherit;False;Property;_Offset;Offset;2;0;Create;True;0;0;0;False;0;False;-0.001;-0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-1762.591,-778.0934;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;87;-1111.985,-155.8488;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;2;-1335.359,-1154.715;Inherit;False;Property;_Color0;Color 0;1;0;Create;True;0;0;0;False;0;False;0,0.9301295,1,0;0,1,0.9098039,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-2277.841,-355.4698;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;47;-2346.391,-840.9592;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;36;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-2024.508,-794.999;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-842.1518,-837.8221;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;-161.2884,-28.03862;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;97;-764.9478,-326.1418;Inherit;False;Property;_DepthAdd;DepthAdd;8;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;-1363.336,-121.2956;Inherit;False;3;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;93;-1701.589,-199.0887;Inherit;False;Property;_DepthTexIntensity;DepthTexIntensity;7;0;Create;True;0;0;0;False;0;False;0;0;-3;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;103;-1437.613,63.68541;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;105;-1364.497,88.89778;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;-484.1561,602.7366;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;89;-713.5959,272.7182;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;83;-756.9682,664.4251;Inherit;False;Property;_DepthCol;DepthCol;5;1;[HDR];Create;True;0;0;0;False;0;False;0.1587837,0.09233712,0.7830189,0;0.1587837,0.09233712,0.7830189,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;98;-502.1904,-111.8867;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;106;-376.1702,63.68538;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;104;-343.394,30.90902;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;76;-2894.752,450.3116;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;-2226.493,334.5572;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;-2498.493,670.5572;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;96;-1994.397,253.8777;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;73;-3183.963,449.3978;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.05;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;107;-1543.125,-9.543048;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;77;-2861.266,924.5756;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;74;-3203.791,927.3141;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.15;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;79;-3198.253,27.03971;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;69;-4560.853,718.8863;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;66;-4478.854,525.0234;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;67;-4483.527,-252.1895;Inherit;True;Property;_DepthTex;DepthTex;4;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;75;-4365.138,344.4629;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;-5003.255,269.0092;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-4976.393,722.1484;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;62;-5233.912,537.7424;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;68;-5293.849,51.3536;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SaturateNode;90;839.1431,-687.9988;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;112;1232.047,-734.9209;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;ase_water_ripples_parallax;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleTimeNode;46;-2856.818,-769.7596;Inherit;False;1;0;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;43;-2588.185,-816.3596;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;4,4;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;25;0;37;0
WireConnection;25;1;84;0
WireConnection;60;0;59;0
WireConnection;60;1;58;0
WireConnection;61;0;60;0
WireConnection;61;1;58;0
WireConnection;64;0;63;0
WireConnection;64;1;61;0
WireConnection;70;0;67;0
WireConnection;70;1;66;0
WireConnection;72;0;67;0
WireConnection;72;1;69;0
WireConnection;78;0;67;0
WireConnection;78;1;75;0
WireConnection;36;1;44;0
WireConnection;44;0;39;0
WireConnection;44;1;50;0
WireConnection;14;0;33;0
WireConnection;33;0;56;0
WireConnection;59;1;58;0
WireConnection;50;0;45;0
WireConnection;50;1;14;0
WireConnection;87;0;36;0
WireConnection;87;1;91;0
WireConnection;56;0;1;1
WireConnection;47;1;43;0
WireConnection;45;0;47;4
WireConnection;37;0;87;0
WireConnection;37;1;2;0
WireConnection;84;0;97;0
WireConnection;84;1;82;0
WireConnection;91;0;93;0
WireConnection;91;1;107;0
WireConnection;91;2;103;0
WireConnection;103;0;105;0
WireConnection;105;0;106;0
WireConnection;82;0;89;0
WireConnection;82;1;83;0
WireConnection;89;0;87;0
WireConnection;98;0;97;0
WireConnection;106;0;104;0
WireConnection;104;0;98;0
WireConnection;76;0;73;0
WireConnection;80;0;79;0
WireConnection;80;1;81;0
WireConnection;81;0;76;0
WireConnection;81;1;77;0
WireConnection;96;0;80;0
WireConnection;73;0;70;1
WireConnection;107;0;96;0
WireConnection;77;0;74;0
WireConnection;74;0;72;1
WireConnection;79;0;78;1
WireConnection;69;0;86;0
WireConnection;69;1;64;0
WireConnection;66;0;86;0
WireConnection;66;1;65;0
WireConnection;75;0;86;0
WireConnection;75;1;71;0
WireConnection;71;0;68;0
WireConnection;71;1;59;0
WireConnection;65;0;62;0
WireConnection;65;1;60;0
WireConnection;90;0;25;0
WireConnection;112;2;90;0
WireConnection;43;1;46;0
ASEEND*/
//CHKSM=DBB57DA35BB28A463A6C57F0038D3C16C5AD21FA
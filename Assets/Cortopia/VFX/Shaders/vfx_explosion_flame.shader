// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "vfx_explosion_flame"
{
	Properties
	{
		_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex ("Particle Texture", 2D) = "white" {}
		_InvFade ("Soft Particles Factor", Range(0.01,3.0)) = 1.0
		[HDR]_Shape("Shape", Color) = (1,0.8563805,0,1)
		[HDR]_Basecolor("Basecolor", Color) = (0.8396226,0.1119497,0,0)
		_Erode("Erode", Range( 0 , 1)) = 1
		_Edgemasktex("Edgemask tex", 2D) = "white" {}
		_Gradmasktex("Gradmask tex", 2D) = "white" {}
		_Edgerim("Edgerim", Color) = (1,0,0.6578746,0)
		_ShapeTex("ShapeTex", 2D) = "white" {}
		_Base("Base", 2D) = "white" {}
		_Masker("Masker", 2D) = "white" {}
		[Toggle]_Erodevaluevertexcol("Erode value/vertexcol", Float) = 1
		_Contrast("Contrast", Range( 0 , 2)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}


	Category 
	{
		SubShader
		{
		LOD 0

			Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" }
			Blend One One
			ColorMask RGB
			Cull Off
			Lighting Off 
			ZWrite Off
			ZTest LEqual
			
			Pass {
			
				CGPROGRAM
				
				#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
				#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
				#endif
				
				#pragma vertex vert
				#pragma fragment frag
				#pragma target 2.0
				#pragma multi_compile_instancing
				#pragma multi_compile_particles
				#pragma multi_compile_fog
				#include "UnityShaderVariables.cginc"
				#define ASE_NEEDS_FRAG_COLOR


				#include "UnityCG.cginc"

				struct appdata_t 
				{
					float4 vertex : POSITION;
					fixed4 color : COLOR;
					float4 texcoord : TEXCOORD0;
					UNITY_VERTEX_INPUT_INSTANCE_ID
					half3 ase_normal : NORMAL;
				};

				struct v2f 
				{
					float4 vertex : SV_POSITION;
					fixed4 color : COLOR;
					float4 texcoord : TEXCOORD0;
					UNITY_FOG_COORDS(1)
					#ifdef SOFTPARTICLES_ON
					float4 projPos : TEXCOORD2;
					#endif
					UNITY_VERTEX_INPUT_INSTANCE_ID
					UNITY_VERTEX_OUTPUT_STEREO
					float4 ase_texcoord3 : TEXCOORD3;
					float4 ase_texcoord4 : TEXCOORD4;
				};
				
				
				#if UNITY_VERSION >= 560
				UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
				#else
				uniform sampler2D_float _CameraDepthTexture;
				#endif

				//Don't delete this comment
				// uniform sampler2D_float _CameraDepthTexture;

				uniform sampler2D _MainTex;
				uniform fixed4 _TintColor;
				uniform float4 _MainTex_ST;
				uniform float _InvFade;
				uniform half _Contrast;
				uniform half4 _Edgerim;
				uniform sampler2D _Edgemasktex;
				uniform half4 _Shape;
				uniform sampler2D _ShapeTex;
				uniform half4 _ShapeTex_ST;
				uniform half4 _Basecolor;
				uniform sampler2D _Base;
				uniform half4 _Base_ST;
				uniform sampler2D _Gradmasktex;
				uniform half4 _Gradmasktex_ST;
				uniform sampler2D _Masker;
				uniform half4 _Masker_ST;
				uniform half _Erodevaluevertexcol;
				uniform half _Erode;
				float4 CalculateContrast( float contrastValue, float4 colorTarget )
				{
					float t = 0.5 * ( 1.0 - contrastValue );
					return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
				}


				v2f vert ( appdata_t v  )
				{
					v2f o;
					UNITY_SETUP_INSTANCE_ID(v);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
					UNITY_TRANSFER_INSTANCE_ID(v, o);
					float3 ase_worldPos = mul(unity_ObjectToWorld, float4( (v.vertex).xyz, 1 )).xyz;
					o.ase_texcoord3.xyz = ase_worldPos;
					half3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
					o.ase_texcoord4.xyz = ase_worldNormal;
					
					
					//setting value to unused interpolator channels and avoid initialization warnings
					o.ase_texcoord3.w = 0;
					o.ase_texcoord4.w = 0;

					v.vertex.xyz +=  float3( 0, 0, 0 ) ;
					o.vertex = UnityObjectToClipPos(v.vertex);
					#ifdef SOFTPARTICLES_ON
						o.projPos = ComputeScreenPos (o.vertex);
						COMPUTE_EYEDEPTH(o.projPos.z);
					#endif
					o.color = v.color;
					o.texcoord = v.texcoord;
					UNITY_TRANSFER_FOG(o,o.vertex);
					return o;
				}

				fixed4 frag ( v2f i  ) : SV_Target
				{
					UNITY_SETUP_INSTANCE_ID( i );
					UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( i );

					#ifdef SOFTPARTICLES_ON
						float sceneZ = LinearEyeDepth (SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)));
						float partZ = i.projPos.z;
						float fade = saturate (_InvFade * (sceneZ-partZ));
						i.color.a *= fade;
					#endif

					half2 texCoord264 = i.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
					half4 tex2DNode234 = tex2D( _Edgemasktex, texCoord264 );
					half2 panner246 = ( 0.0 * _Time.y * float2( 0,1 ) + float2( 0,0 ));
					half2 texCoord251 = i.texcoord.xy * _ShapeTex_ST.xy + ( _ShapeTex_ST.zw + panner246 );
					float3 ase_worldPos = i.ase_texcoord3.xyz;
					float3 ase_worldViewDir = UnityWorldSpaceViewDir(ase_worldPos);
					ase_worldViewDir = normalize(ase_worldViewDir);
					half3 ase_worldNormal = i.ase_texcoord4.xyz;
					half fresnelNdotV183 = dot( ase_worldNormal, ase_worldViewDir );
					half fresnelNode183 = ( -0.17 + 4.53 * pow( max( 1.0 - fresnelNdotV183 , 0.0001 ), 2.66 ) );
					half clampResult189 = clamp( fresnelNode183 , 0.0 , 1.0 );
					half4 temp_output_291_0 = ( tex2Dlod( _ShapeTex, float4( texCoord251, 0, 0.0) ) * ( 1.0 - clampResult189 ) );
					half2 panner248 = ( 0.0 * _Time.y * float2( 0,1 ) + float2( 0,0 ));
					half2 texCoord252 = i.texcoord.xy * _Base_ST.xy + ( _Base_ST.zw + panner248 );
					half4 clampResult226 = clamp( ( ( _Shape * temp_output_291_0 ) + ( ( 1.0 - temp_output_291_0 ) * ( _Basecolor * ( ( _Basecolor + tex2Dlod( _Base, float4( texCoord252, 0, 0.0) ) ) + clampResult189 ) ) ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,1 ) );
					half4 break173 = ( ( _Edgerim * tex2DNode234.r ) + ( clampResult226 * ( 1.0 - tex2DNode234.r ) ) );
					half2 texCoord297 = i.texcoord.xy * _Gradmasktex_ST.xy + _Gradmasktex_ST.zw;
					float2 uv_Masker = i.texcoord.xy * _Masker_ST.xy + _Masker_ST.zw;
					half temp_output_202_0 = ( saturate( ( break173.r + break173.g + break173.b ) ) * saturate( ( tex2D( _Gradmasktex, texCoord297 ).r + tex2D( _Masker, uv_Masker ).r ) ) );
					half clampResult272 = clamp( _Erode , 0.0 , 1.0 );
					half temp_output_310_0 = saturate( ( ( saturate( temp_output_202_0 ) - (( _Erodevaluevertexcol )?( ( 1.0 - i.color.a ) ):( clampResult272 )) ) / ( 1.0 - (( _Erodevaluevertexcol )?( ( 1.0 - i.color.a ) ):( clampResult272 )) ) ) );
					half4 appendResult175 = (half4(break173.r , break173.g , break173.b , temp_output_310_0));
					half clampResult295 = clamp( ( i.color.r + i.color.g + i.color.b ) , 0.0 , 1.0 );
					half4 temp_output_305_0 = saturate( ( appendResult175 * ( temp_output_310_0 * clampResult295 ) ) );
					

					fixed4 col = CalculateContrast(_Contrast,temp_output_305_0);
					UNITY_APPLY_FOG(i.fogCoord, col);
					return col;
				}
				ENDCG 
			}
		}	
	}
	CustomEditor "ASEMaterialInspector"
	
	Fallback Off
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.PannerNode;248;-2439.614,527.6461;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,1;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureTransformNode;247;-2546.627,260.8033;Inherit;False;253;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SimpleAddOpNode;250;-2203.122,389.783;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;246;-1607.172,-201.9003;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,1;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FresnelNode;183;-1849.946,786.0546;Inherit;True;Standard;WorldNormal;ViewDir;True;True;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;-0.17;False;2;FLOAT;4.53;False;3;FLOAT;2.66;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;249;-1358.568,-274.1484;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;252;-2072.25,295.2384;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,0.2;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;253;-1817.616,346.6409;Inherit;True;Property;_Base;Base;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;MipLevel;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;189;-1449.501,683.6046;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;251;-1146.418,-385.8254;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;254;-925.4453,-366.401;Inherit;True;Property;_ShapeTex;ShapeTex;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;MipLevel;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;286;-1334.786,324.6391;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;291;-503.7355,-242.3196;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;216;-3296.708,-396.9965;Inherit;True;Property;_Edgemasktex;Edgemask tex;3;0;Create;True;0;0;0;False;0;False;None;4f822721b1adefc4daadd6fec2b31408;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.OneMinusNode;285;-335.7231,-219.6577;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;222;-2877.07,-545.4019;Inherit;False;Edgemask_ref;-1;True;1;0;SAMPLER2D;0;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;277;-109.1758,-20.23831;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-158.3096,-458.7308;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;264;-977.6777,950.6069;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;233;-947.3401,670.8621;Inherit;False;222;Edgemask_ref;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleAddOpNode;255;200.9285,-315.286;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;234;-623.78,782.382;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;226;566.8843,120.7738;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;235;-268.1312,634.5187;Inherit;False;Property;_Edgerim;Edgerim;5;0;Create;True;0;0;0;False;0;False;1,0,0.6578746,0;0,0.5377356,0.5377356,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;270;-3093.806,-94.48399;Inherit;True;Property;_Gradmasktex;Gradmask tex;4;0;Create;True;0;0;0;False;0;False;None;ee2aca0150f742c45b3548c859d3470b;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.OneMinusNode;241;227.6708,858.6823;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;271;-2622.652,-254.7777;Inherit;False;Gradmask;-1;True;1;0;SAMPLER2D;0;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TextureTransformNode;296;645.7408,1907.359;Inherit;False;270;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;236;146.0667,507.8872;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;242;866.9078,559.3099;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;297;943.5058,1871.149;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,0.2;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;224;1087.701,1295.608;Inherit;False;271;Gradmask;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleAddOpNode;243;1146.821,430.1942;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;198;1416.979,1436.398;Inherit;True;Property;_Edgemask;Edgemask;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;287;1399.957,1776.286;Inherit;True;Property;_Masker;Masker;8;0;Create;True;0;0;0;False;0;False;-1;None;7cf6afe4105669349bd222f33ba5795d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;173;1467.34,177.9747;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;208;1564.813,393.7832;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;292;2179.765,1355.042;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;203;2014.069,1045.358;Inherit;False;Property;_Erode;Erode;2;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;289;1788.882,1560.628;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;272;2324.149,1051.662;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;300;2422.784,1286.353;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;294;2987.289,1446.746;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;295;3176.28,1373.43;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;175;3411.059,204.4959;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;188;3611.018,594.387;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;268;2326.889,880.4438;Inherit;False;Erode;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;171;3877.739,654.8151;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;1,1,1,1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TextureTransformNode;245;-1679.481,-484.1184;Inherit;True;254;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.ColorNode;30;-621.4395,-689.6265;Inherit;False;Property;_Shape;Shape;0;1;[HDR];Create;True;0;0;0;False;0;False;1,0.8563805,0,1;0.07772844,1.215464,1.498039,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;99;-1723.818,-39.43621;Inherit;False;Property;_Basecolor;Basecolor;1;1;[HDR];Create;True;0;0;0;False;0;False;0.8396226,0.1119497,0,0;0,9.420512,9.75938,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;174;4554.014,709.8542;Half;False;True;-1;2;ASEMaterialInspector;0;11;vfx_explosion_flame;0b6a9f8b4f707c74ca64c0be8e590de0;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;2;True;True;4;1;False;;1;False;;0;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;True;True;2;False;;False;True;True;True;True;False;0;False;;False;False;False;False;False;False;False;False;False;True;2;False;;True;3;False;;False;True;4;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;0;;0;0;Standard;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;301;4180.514,853.5161;Inherit;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;302;3847.424,942.9382;Inherit;False;Property;_Contrast;Contrast;10;0;Create;True;0;0;0;False;0;False;1;1.193;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;168;-653.5811,-18.59508;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.85,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;280;-1031.805,161.9036;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;290;-1194.42,655.6912;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;304;1909.484,364.0435;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;305;3963.144,552.5131;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.OneMinusNode;282;3085.361,1017.053;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;202;2460.69,512.9092;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;303;2063.355,1305.524;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;306;2713.844,549.9132;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;307;2929.644,543.4131;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;299;2576.534,1019.226;Inherit;False;Property;_Erodevaluevertexcol;Erode value/vertexcol;9;0;Create;True;0;0;0;False;0;False;1;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;273;2856.212,1023.153;Inherit;True;Step Antialiasing;-1;;1;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;308;2969.942,715.0131;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;309;3149.344,621.4131;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;310;3259.844,578.5132;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;293;3361.819,835.913;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
WireConnection;250;0;247;1
WireConnection;250;1;248;0
WireConnection;249;0;245;1
WireConnection;249;1;246;0
WireConnection;252;0;247;0
WireConnection;252;1;250;0
WireConnection;253;1;252;0
WireConnection;189;0;183;0
WireConnection;251;0;245;0
WireConnection;251;1;249;0
WireConnection;254;1;251;0
WireConnection;286;0;99;0
WireConnection;286;1;253;0
WireConnection;291;0;254;0
WireConnection;291;1;290;0
WireConnection;285;0;291;0
WireConnection;222;0;216;0
WireConnection;277;0;285;0
WireConnection;277;1;168;0
WireConnection;31;0;30;0
WireConnection;31;1;291;0
WireConnection;255;0;31;0
WireConnection;255;1;277;0
WireConnection;234;0;233;0
WireConnection;234;1;264;0
WireConnection;226;0;255;0
WireConnection;241;0;234;1
WireConnection;271;0;270;0
WireConnection;236;0;235;0
WireConnection;236;1;234;1
WireConnection;242;0;226;0
WireConnection;242;1;241;0
WireConnection;297;0;296;0
WireConnection;297;1;296;1
WireConnection;243;0;236;0
WireConnection;243;1;242;0
WireConnection;198;0;224;0
WireConnection;198;1;297;0
WireConnection;173;0;243;0
WireConnection;208;0;173;0
WireConnection;208;1;173;1
WireConnection;208;2;173;2
WireConnection;289;0;198;1
WireConnection;289;1;287;1
WireConnection;272;0;203;0
WireConnection;300;0;292;4
WireConnection;294;0;292;1
WireConnection;294;1;292;2
WireConnection;294;2;292;3
WireConnection;295;0;294;0
WireConnection;175;0;173;0
WireConnection;175;1;173;1
WireConnection;175;2;173;2
WireConnection;175;3;310;0
WireConnection;188;0;175;0
WireConnection;188;1;293;0
WireConnection;268;0;203;0
WireConnection;171;0;305;0
WireConnection;174;0;301;0
WireConnection;301;1;305;0
WireConnection;301;0;302;0
WireConnection;168;0;99;0
WireConnection;168;1;280;0
WireConnection;280;0;286;0
WireConnection;280;1;189;0
WireConnection;290;0;189;0
WireConnection;304;0;208;0
WireConnection;305;0;188;0
WireConnection;282;0;273;0
WireConnection;202;0;304;0
WireConnection;202;1;303;0
WireConnection;303;0;289;0
WireConnection;306;0;202;0
WireConnection;307;0;306;0
WireConnection;307;1;299;0
WireConnection;299;0;272;0
WireConnection;299;1;300;0
WireConnection;273;1;202;0
WireConnection;273;2;299;0
WireConnection;308;1;299;0
WireConnection;309;0;307;0
WireConnection;309;1;308;0
WireConnection;310;0;309;0
WireConnection;293;0;310;0
WireConnection;293;1;295;0
ASEEND*/
//CHKSM=A71D0506B778E5323B8F82146FDB44A4611999A8
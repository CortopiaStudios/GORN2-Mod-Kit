// Upgrade NOTE: upgraded instancing buffer 'Cortopia_LowEndase_character_bloodpaint_lowend' to new syntax.

// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Cortopia/_LowEnd/ase_character_bloodpaint_lowend"
{
	Properties
	{
		_Albedo_Smoothness("Albedo_Smoothness", 2D) = "black" {}
		_MaskTexture("MaskTexture", 2D) = "black" {}
		_BloodCutBruiseMask("BloodCutBruiseMask", 2D) = "white" {}
		_Damage("Damage", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

		//_TransmissionShadow( "Transmission Shadow", Range( 0, 1 ) ) = 0.5
		//_TransStrength( "Trans Strength", Range( 0, 50 ) ) = 1
		//_TransNormal( "Trans Normal Distortion", Range( 0, 1 ) ) = 0.5
		//_TransScattering( "Trans Scattering", Range( 1, 50 ) ) = 2
		//_TransDirect( "Trans Direct", Range( 0, 1 ) ) = 0.9
		//_TransAmbient( "Trans Ambient", Range( 0, 1 ) ) = 0.1
		//_TransShadow( "Trans Shadow", Range( 0, 1 ) ) = 0.5
		//_TessPhongStrength( "Tess Phong Strength", Range( 0, 1 ) ) = 0.5
		//_TessValue( "Tess Max Tessellation", Range( 1, 32 ) ) = 16
		//_TessMin( "Tess Min Distance", Float ) = 10
		//_TessMax( "Tess Max Distance", Float ) = 25
		//_TessEdgeLength ( "Tess Edge length", Range( 2, 50 ) ) = 16
		//_TessMaxDisp( "Tess Max Displacement", Float ) = 25
		//[ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
		//[ToggleOff] _GlossyReflections("Reflections", Float) = 1.0
	}

	SubShader
	{
		
		Tags { "RenderType"="Opaque" "Queue"="Geometry" "DisableBatching"="False" }
	LOD 0

		Cull Back
		AlphaToMask Off
		ZWrite On
		ZTest LEqual
		ColorMask RGBA
		
		Blend Off
		

		CGINCLUDE
		#pragma target 3.0

		float4 FixedTess( float tessValue )
		{
			return tessValue;
		}

		float CalcDistanceTessFactor (float4 vertex, float minDist, float maxDist, float tess, float4x4 o2w, float3 cameraPos )
		{
			float3 wpos = mul(o2w,vertex).xyz;
			float dist = distance (wpos, cameraPos);
			float f = clamp(1.0 - (dist - minDist) / (maxDist - minDist), 0.01, 1.0) * tess;
			return f;
		}

		float4 CalcTriEdgeTessFactors (float3 triVertexFactors)
		{
			float4 tess;
			tess.x = 0.5 * (triVertexFactors.y + triVertexFactors.z);
			tess.y = 0.5 * (triVertexFactors.x + triVertexFactors.z);
			tess.z = 0.5 * (triVertexFactors.x + triVertexFactors.y);
			tess.w = (triVertexFactors.x + triVertexFactors.y + triVertexFactors.z) / 3.0f;
			return tess;
		}

		float CalcEdgeTessFactor (float3 wpos0, float3 wpos1, float edgeLen, float3 cameraPos, float4 scParams )
		{
			float dist = distance (0.5 * (wpos0+wpos1), cameraPos);
			float len = distance(wpos0, wpos1);
			float f = max(len * scParams.y / (edgeLen * dist), 1.0);
			return f;
		}

		float DistanceFromPlane (float3 pos, float4 plane)
		{
			float d = dot (float4(pos,1.0f), plane);
			return d;
		}

		bool WorldViewFrustumCull (float3 wpos0, float3 wpos1, float3 wpos2, float cullEps, float4 planes[6] )
		{
			float4 planeTest;
			planeTest.x = (( DistanceFromPlane(wpos0, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos1, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos2, planes[0]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.y = (( DistanceFromPlane(wpos0, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos1, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos2, planes[1]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.z = (( DistanceFromPlane(wpos0, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos1, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos2, planes[2]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.w = (( DistanceFromPlane(wpos0, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos1, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos2, planes[3]) > -cullEps) ? 1.0f : 0.0f );
			return !all (planeTest);
		}

		float4 DistanceBasedTess( float4 v0, float4 v1, float4 v2, float tess, float minDist, float maxDist, float4x4 o2w, float3 cameraPos )
		{
			float3 f;
			f.x = CalcDistanceTessFactor (v0,minDist,maxDist,tess,o2w,cameraPos);
			f.y = CalcDistanceTessFactor (v1,minDist,maxDist,tess,o2w,cameraPos);
			f.z = CalcDistanceTessFactor (v2,minDist,maxDist,tess,o2w,cameraPos);

			return CalcTriEdgeTessFactors (f);
		}

		float4 EdgeLengthBasedTess( float4 v0, float4 v1, float4 v2, float edgeLength, float4x4 o2w, float3 cameraPos, float4 scParams )
		{
			float3 pos0 = mul(o2w,v0).xyz;
			float3 pos1 = mul(o2w,v1).xyz;
			float3 pos2 = mul(o2w,v2).xyz;
			float4 tess;
			tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
			tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
			tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
			tess.w = (tess.x + tess.y + tess.z) / 3.0f;
			return tess;
		}

		float4 EdgeLengthBasedTessCull( float4 v0, float4 v1, float4 v2, float edgeLength, float maxDisplacement, float4x4 o2w, float3 cameraPos, float4 scParams, float4 planes[6] )
		{
			float3 pos0 = mul(o2w,v0).xyz;
			float3 pos1 = mul(o2w,v1).xyz;
			float3 pos2 = mul(o2w,v2).xyz;
			float4 tess;

			if (WorldViewFrustumCull(pos0, pos1, pos2, maxDisplacement, planes))
			{
				tess = 0.0f;
			}
			else
			{
				tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
				tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
				tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
				tess.w = (tess.x + tess.y + tess.z) / 3.0f;
			}
			return tess;
		}
		ENDCG

		
		Pass
		{
			
			Name "ForwardBase"
			Tags { "LightMode"="ForwardBase" }

			Blend One Zero

			CGPROGRAM
			#define ASE_NEEDS_FRAG_SHADOWCOORDS
			#define ASE_ABSOLUTE_VERTEX_POS 1

			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase
			#ifndef UNITY_PASS_FORWARDBASE
				#define UNITY_PASS_FORWARDBASE
			#endif
			#include "HLSLSupport.cginc"
			#ifndef UNITY_INSTANCED_LOD_FADE
				#define UNITY_INSTANCED_LOD_FADE
			#endif
			#ifndef UNITY_INSTANCED_SH
				#define UNITY_INSTANCED_SH
			#endif
			#ifndef UNITY_INSTANCED_LIGHTMAPSTS
				#define UNITY_INSTANCED_LIGHTMAPSTS
			#endif
			#include "UnityShaderVariables.cginc"
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			#include "AutoLight.cginc"

			#pragma multi_compile_instancing
			#include "../skinned_vertices_with_color.cginc"

			struct appdata {
				float4 vertex : POSITION;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct v2f {
				#if UNITY_VERSION >= 201810
					UNITY_POSITION(pos);
				#else
					float4 pos : SV_POSITION;
				#endif
				#if defined(LIGHTMAP_ON) || (!defined(LIGHTMAP_ON) && SHADER_TARGET >= 30)
					float4 lmap : TEXCOORD0;
				#endif
				#if !defined(LIGHTMAP_ON) && UNITY_SHOULD_SAMPLE_SH
					half3 sh : TEXCOORD1;
				#endif
				#if defined(UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS) && UNITY_VERSION >= 201810 && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					UNITY_LIGHTING_COORDS(2,3)
				#elif defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if UNITY_VERSION >= 201710
						UNITY_SHADOW_COORDS(2)
					#else
						SHADOW_COORDS(2)
					#endif
				#endif
				#ifdef ASE_FOG
					UNITY_FOG_COORDS(4)
				#endif
				float4 tSpace0 : TEXCOORD5;
				float4 tSpace1 : TEXCOORD6;
				float4 tSpace2 : TEXCOORD7;
				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
				float4 screenPos : TEXCOORD8;
				#endif
				float4 ase_texcoord9 : TEXCOORD9;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			uniform sampler2D _Albedo_Smoothness;
			uniform sampler2D _MaskTexture;
			uniform sampler2D _BloodCutBruiseMask;
			UNITY_INSTANCING_BUFFER_START(Cortopia_LowEndase_character_bloodpaint_lowend)
				UNITY_DEFINE_INSTANCED_PROP(float4, _Albedo_Smoothness_ST)
#define _Albedo_Smoothness_ST_arr Cortopia_LowEndase_character_bloodpaint_lowend
				UNITY_DEFINE_INSTANCED_PROP(float4, _MaskTexture_ST)
#define _MaskTexture_ST_arr Cortopia_LowEndase_character_bloodpaint_lowend
				UNITY_DEFINE_INSTANCED_PROP(float, _Damage)
#define _Damage_arr Cortopia_LowEndase_character_bloodpaint_lowend
			UNITY_INSTANCING_BUFFER_END(Cortopia_LowEndase_character_bloodpaint_lowend)


			
			v2f VertexFunction (appdata v  ) {
				UNITY_SETUP_INSTANCE_ID(v);
				v2f o;
				UNITY_INITIALIZE_OUTPUT(v2f,o);
				UNITY_TRANSFER_INSTANCE_ID(v,o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				o.ase_texcoord9.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord9.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.vertex.w = 1;
				v.normal = v.normal;
				v.tangent = v.tangent;

				o.pos = UnityObjectToClipPos(v.vertex);
				float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
				fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
				fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				fixed3 worldBinormal = cross(worldNormal, worldTangent) * tangentSign;
				o.tSpace0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
				o.tSpace1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
				o.tSpace2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);

				#ifdef DYNAMICLIGHTMAP_ON
				o.lmap.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
				#endif
				#ifdef LIGHTMAP_ON
				o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif

				#ifndef LIGHTMAP_ON
					#if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
						o.sh = 0;
						#ifdef VERTEXLIGHT_ON
						o.sh += Shade4PointLights (
							unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
							unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
							unity_4LightAtten0, worldPos, worldNormal);
						#endif
						o.sh = ShadeSHPerVertex (worldNormal, o.sh);
					#endif
				#endif

				#if UNITY_VERSION >= 201810 && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					UNITY_TRANSFER_LIGHTING(o, v.texcoord1.xy);
				#elif defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if UNITY_VERSION >= 201710
						UNITY_TRANSFER_SHADOW(o, v.texcoord1.xy);
					#else
						TRANSFER_SHADOW(o);
					#endif
				#endif

				#ifdef ASE_FOG
					UNITY_TRANSFER_FOG(o,o.pos);
				#endif
				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
					o.screenPos = ComputeScreenPos(o.pos);
				#endif
				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( appdata v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.tangent = v.tangent;
				o.normal = v.normal;
				o.texcoord1 = v.texcoord1;
				o.texcoord2 = v.texcoord2;
				o.ase_texcoord = v.ase_texcoord;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, UNITY_MATRIX_M, _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, UNITY_MATRIX_M, _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, UNITY_MATRIX_M, _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			v2f DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				appdata o = (appdata) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.tangent = patch[0].tangent * bary.x + patch[1].tangent * bary.y + patch[2].tangent * bary.z;
				o.normal = patch[0].normal * bary.x + patch[1].normal * bary.y + patch[2].normal * bary.z;
				o.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
				o.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].normal * (dot(o.vertex.xyz, patch[i].normal) - dot(patch[i].vertex.xyz, patch[i].normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			v2f vert ( appdata v )
			{
				return VertexFunction( v );
			}
			#endif

			fixed4 frag (v2f IN 
				#ifdef _DEPTHOFFSET_ON
				, out float outputDepth : SV_Depth
				#endif
				) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(IN);

				#ifdef LOD_FADE_CROSSFADE
					UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);
				#endif

				#if defined(_SPECULAR_SETUP)
					SurfaceOutputStandardSpecular o = (SurfaceOutputStandardSpecular)0;
				#else
					SurfaceOutputStandard o = (SurfaceOutputStandard)0;
				#endif
				float3 WorldTangent = float3(IN.tSpace0.x,IN.tSpace1.x,IN.tSpace2.x);
				float3 WorldBiTangent = float3(IN.tSpace0.y,IN.tSpace1.y,IN.tSpace2.y);
				float3 WorldNormal = float3(IN.tSpace0.z,IN.tSpace1.z,IN.tSpace2.z);
				float3 worldPos = float3(IN.tSpace0.w,IN.tSpace1.w,IN.tSpace2.w);
				float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					UNITY_LIGHT_ATTENUATION(atten, IN, worldPos)
				#else
					half atten = 1;
				#endif
				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
				float4 ScreenPos = IN.screenPos;
				#endif

				float4 _Albedo_Smoothness_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_Albedo_Smoothness_ST_arr, _Albedo_Smoothness_ST);
				float2 uv_Albedo_Smoothness = IN.ase_texcoord9.xy * _Albedo_Smoothness_ST_Instance.xy + _Albedo_Smoothness_ST_Instance.zw;
				float4 tex2DNode76 = tex2D( _Albedo_Smoothness, uv_Albedo_Smoothness );
				float4 Diffuse77 = tex2DNode76;
				float4 color212 = IsGammaSpace() ? float4(0.7529412,0.2705882,0,0) : float4(0.5271152,0.05951123,0,0);
				float4 BruiseColor80 = color212;
				float4 _MaskTexture_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_MaskTexture_ST_arr, _MaskTexture_ST);
				float2 uv_MaskTexture = IN.ase_texcoord9.xy * _MaskTexture_ST_Instance.xy + _MaskTexture_ST_Instance.zw;
				float4 tex2DNode97 = tex2D( _MaskTexture, uv_MaskTexture );
				float Bruises94 = tex2DNode97.b;
				float2 temp_cast_0 = (20.0).xx;
				float2 texCoord218 = IN.ase_texcoord9.xy * temp_cast_0 + float2( 0,0 );
				float BruiseBreakupMask106 = tex2D( _BloodCutBruiseMask, texCoord218 ).b;
				float BruiseLerp67 = saturate( ( Bruises94 * ( BruiseBreakupMask106 * 1.74 ) ) );
				float4 lerpResult141 = lerp( Diffuse77 , ( Diffuse77 * BruiseColor80 ) , BruiseLerp67);
				float4 color1_g20 = IsGammaSpace() ? float4(0.490566,0.06317896,0,0) : float4(0.2054128,0.005227456,0,0);
				float4 color2_g20 = IsGammaSpace() ? float4(0.4622642,0.07222877,0,0) : float4(0.1807607,0.006240204,0,0);
				float BloodWet112 = tex2DNode97.a;
				float BloodDry93 = tex2DNode97.r;
				float2 temp_cast_1 = (10.0).xx;
				float2 texCoord217 = IN.ase_texcoord9.xy * temp_cast_1 + float2( 0,0 );
				float BloodEdgeMask104 = tex2D( _BloodCutBruiseMask, texCoord217 ).r;
				float temp_output_62_0 = ( BloodDry93 + ( BloodDry93 * BloodEdgeMask104 ) );
				float BloodLerp115 = saturate( step( 0.7 , temp_output_62_0 ) );
				float clampResult182 = clamp( BloodLerp115 , 0.0 , 0.97 );
				float4 lerpResult129 = lerp( lerpResult141 , ( color1_g20 + ( color2_g20 * BloodWet112 ) ) , clampResult182);
				
				float4 color225 = IsGammaSpace() ? float4(0.7372549,0,0,0) : float4(0.5028866,0,0,0);
				float _Damage_Instance = UNITY_ACCESS_INSTANCED_PROP(_Damage_arr, _Damage);
				
				float Smoothness78 = tex2DNode76.a;
				float lerpResult85 = lerp( Smoothness78 , ( BloodWet112 * 0.75 ) , ( BloodWet112 * BloodDry93 ));
				
				o.Albedo = lerpResult129.rgb;
				o.Normal = fixed3( 0, 0, 1 );
				o.Emission = saturate( ( color225 * _Damage_Instance ) ).rgb;
				#if defined(_SPECULAR_SETUP)
					o.Specular = fixed3( 0, 0, 0 );
				#else
					o.Metallic = 0;
				#endif
				o.Smoothness = saturate( lerpResult85 );
				o.Occlusion = 1;
				o.Alpha = 1;
				float AlphaClipThreshold = 0.5;
				float AlphaClipThresholdShadow = 0.5;
				float3 BakedGI = 0;
				float3 RefractionColor = 1;
				float RefractionIndex = 1;
				float3 Transmission = 1;
				float3 Translucency = 1;

				#ifdef _ALPHATEST_ON
					clip( o.Alpha - AlphaClipThreshold );
				#endif

				#ifdef _DEPTHOFFSET_ON
					outputDepth = IN.pos.z;
				#endif

				#ifndef USING_DIRECTIONAL_LIGHT
					fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
				#else
					fixed3 lightDir = _WorldSpaceLightPos0.xyz;
				#endif

				fixed4 c = 0;
				float3 worldN;
				worldN.x = dot(IN.tSpace0.xyz, o.Normal);
				worldN.y = dot(IN.tSpace1.xyz, o.Normal);
				worldN.z = dot(IN.tSpace2.xyz, o.Normal);
				worldN = normalize(worldN);
				o.Normal = worldN;

				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
				gi.indirect.diffuse = 0;
				gi.indirect.specular = 0;
				gi.light.color = _LightColor0.rgb;
				gi.light.dir = lightDir;

				UnityGIInput giInput;
				UNITY_INITIALIZE_OUTPUT(UnityGIInput, giInput);
				giInput.light = gi.light;
				giInput.worldPos = worldPos;
				giInput.worldViewDir = worldViewDir;
				giInput.atten = atten;
				#if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
					giInput.lightmapUV = IN.lmap;
				#else
					giInput.lightmapUV = 0.0;
				#endif
				#if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
					giInput.ambient = IN.sh;
				#else
					giInput.ambient.rgb = 0.0;
				#endif
				giInput.probeHDR[0] = unity_SpecCube0_HDR;
				giInput.probeHDR[1] = unity_SpecCube1_HDR;
				#if defined(UNITY_SPECCUBE_BLENDING) || defined(UNITY_SPECCUBE_BOX_PROJECTION)
					giInput.boxMin[0] = unity_SpecCube0_BoxMin;
				#endif
				#ifdef UNITY_SPECCUBE_BOX_PROJECTION
					giInput.boxMax[0] = unity_SpecCube0_BoxMax;
					giInput.probePosition[0] = unity_SpecCube0_ProbePosition;
					giInput.boxMax[1] = unity_SpecCube1_BoxMax;
					giInput.boxMin[1] = unity_SpecCube1_BoxMin;
					giInput.probePosition[1] = unity_SpecCube1_ProbePosition;
				#endif

				#if defined(_SPECULAR_SETUP)
					LightingStandardSpecular_GI(o, giInput, gi);
				#else
					LightingStandard_GI( o, giInput, gi );
				#endif

				#ifdef ASE_BAKEDGI
					gi.indirect.diffuse = BakedGI;
				#endif

				#if UNITY_SHOULD_SAMPLE_SH && !defined(LIGHTMAP_ON) && defined(ASE_NO_AMBIENT)
					gi.indirect.diffuse = 0;
				#endif

				#if defined(_SPECULAR_SETUP)
					c += LightingStandardSpecular (o, worldViewDir, gi);
				#else
					c += LightingStandard( o, worldViewDir, gi );
				#endif

				#ifdef ASE_TRANSMISSION
				{
					float shadow = _TransmissionShadow;
					#ifdef DIRECTIONAL
						float3 lightAtten = lerp( _LightColor0.rgb, gi.light.color, shadow );
					#else
						float3 lightAtten = gi.light.color;
					#endif
					half3 transmission = max(0 , -dot(o.Normal, gi.light.dir)) * lightAtten * Transmission;
					c.rgb += o.Albedo * transmission;
				}
				#endif

				#ifdef ASE_TRANSLUCENCY
				{
					float shadow = _TransShadow;
					float normal = _TransNormal;
					float scattering = _TransScattering;
					float direct = _TransDirect;
					float ambient = _TransAmbient;
					float strength = _TransStrength;

					#ifdef DIRECTIONAL
						float3 lightAtten = lerp( _LightColor0.rgb, gi.light.color, shadow );
					#else
						float3 lightAtten = gi.light.color;
					#endif
					half3 lightDir = gi.light.dir + o.Normal * normal;
					half transVdotL = pow( saturate( dot( worldViewDir, -lightDir ) ), scattering );
					half3 translucency = lightAtten * (transVdotL * direct + gi.indirect.diffuse * ambient) * Translucency;
					c.rgb += o.Albedo * translucency * strength;
				}
				#endif

				//#ifdef ASE_REFRACTION
				//	float4 projScreenPos = ScreenPos / ScreenPos.w;
				//	float3 refractionOffset = ( RefractionIndex - 1.0 ) * mul( UNITY_MATRIX_V, WorldNormal ).xyz * ( 1.0 - dot( WorldNormal, WorldViewDirection ) );
				//	projScreenPos.xy += refractionOffset.xy;
				//	float3 refraction = UNITY_SAMPLE_SCREENSPACE_TEXTURE( _GrabTexture, projScreenPos ) * RefractionColor;
				//	color.rgb = lerp( refraction, color.rgb, color.a );
				//	color.a = 1;
				//#endif

				c.rgb += o.Emission;

				#ifdef ASE_FOG
					UNITY_APPLY_FOG(IN.fogCoord, c);
				#endif
				return c;
			}
			ENDCG
		}

		
		Pass
		{
			
			Name "Meta"
			Tags { "LightMode"="Meta" }
			Cull Off

			CGPROGRAM
			#define ASE_NEEDS_FRAG_SHADOWCOORDS
			#define ASE_ABSOLUTE_VERTEX_POS 1

			#pragma vertex vert
			#pragma fragment frag
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#pragma shader_feature EDITOR_VISUALIZATION
			#ifndef UNITY_PASS_META
				#define UNITY_PASS_META
			#endif
			#include "HLSLSupport.cginc"
			#if !defined( UNITY_INSTANCED_LOD_FADE )
				#define UNITY_INSTANCED_LOD_FADE
			#endif
			#if !defined( UNITY_INSTANCED_SH )
				#define UNITY_INSTANCED_SH
			#endif
			#if !defined( UNITY_INSTANCED_LIGHTMAPSTS )
				#define UNITY_INSTANCED_LIGHTMAPSTS
			#endif
			#include "UnityShaderVariables.cginc"
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			#include "UnityMetaPass.cginc"

			#pragma multi_compile_instancing
			#include "../skinned_vertices_with_color.cginc"

			struct appdata {
				float4 vertex : POSITION;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			struct v2f {
				#if UNITY_VERSION >= 201810
					UNITY_POSITION(pos);
				#else
					float4 pos : SV_POSITION;
				#endif
				#ifdef EDITOR_VISUALIZATION
					float2 vizUV : TEXCOORD1;
					float4 lightCoord : TEXCOORD2;
				#endif
				float4 ase_texcoord3 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			uniform sampler2D _Albedo_Smoothness;
			uniform sampler2D _MaskTexture;
			uniform sampler2D _BloodCutBruiseMask;
			UNITY_INSTANCING_BUFFER_START(Cortopia_LowEndase_character_bloodpaint_lowend)
				UNITY_DEFINE_INSTANCED_PROP(float4, _Albedo_Smoothness_ST)
#define _Albedo_Smoothness_ST_arr Cortopia_LowEndase_character_bloodpaint_lowend
				UNITY_DEFINE_INSTANCED_PROP(float4, _MaskTexture_ST)
#define _MaskTexture_ST_arr Cortopia_LowEndase_character_bloodpaint_lowend
				UNITY_DEFINE_INSTANCED_PROP(float, _Damage)
#define _Damage_arr Cortopia_LowEndase_character_bloodpaint_lowend
			UNITY_INSTANCING_BUFFER_END(Cortopia_LowEndase_character_bloodpaint_lowend)


			
			v2f VertexFunction (appdata v  ) {
				UNITY_SETUP_INSTANCE_ID(v);
				v2f o;
				UNITY_INITIALIZE_OUTPUT(v2f,o);
				UNITY_TRANSFER_INSTANCE_ID(v,o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				o.ase_texcoord3.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord3.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.vertex.w = 1;
				v.normal = v.normal;
				v.tangent = v.tangent;

				#ifdef EDITOR_VISUALIZATION
					o.vizUV = 0;
					o.lightCoord = 0;
					if (unity_VisualizationMode == EDITORVIZ_TEXTURE)
						o.vizUV = UnityMetaVizUV(unity_EditorViz_UVIndex, v.texcoord.xy, v.texcoord1.xy, v.texcoord2.xy, unity_EditorViz_Texture_ST);
					else if (unity_VisualizationMode == EDITORVIZ_SHOWLIGHTMASK)
					{
						o.vizUV = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
						o.lightCoord = mul(unity_EditorViz_WorldToLight, mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1)));
					}
				#endif

				o.pos = UnityMetaVertexPosition(v.vertex, v.texcoord1.xy, v.texcoord2.xy, unity_LightmapST, unity_DynamicLightmapST);

				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( appdata v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.tangent = v.tangent;
				o.normal = v.normal;
				o.texcoord1 = v.texcoord1;
				o.texcoord2 = v.texcoord2;
				o.ase_texcoord = v.ase_texcoord;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, UNITY_MATRIX_M, _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, UNITY_MATRIX_M, _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, UNITY_MATRIX_M, _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			v2f DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				appdata o = (appdata) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.tangent = patch[0].tangent * bary.x + patch[1].tangent * bary.y + patch[2].tangent * bary.z;
				o.normal = patch[0].normal * bary.x + patch[1].normal * bary.y + patch[2].normal * bary.z;
				o.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
				o.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].normal * (dot(o.vertex.xyz, patch[i].normal) - dot(patch[i].vertex.xyz, patch[i].normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			v2f vert ( appdata v )
			{
				return VertexFunction( v );
			}
			#endif

			fixed4 frag (v2f IN 
				#ifdef _DEPTHOFFSET_ON
				, out float outputDepth : SV_Depth
				#endif
				) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(IN);

				#ifdef LOD_FADE_CROSSFADE
					UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);
				#endif

				#if defined(_SPECULAR_SETUP)
					SurfaceOutputStandardSpecular o = (SurfaceOutputStandardSpecular)0;
				#else
					SurfaceOutputStandard o = (SurfaceOutputStandard)0;
				#endif

				float4 _Albedo_Smoothness_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_Albedo_Smoothness_ST_arr, _Albedo_Smoothness_ST);
				float2 uv_Albedo_Smoothness = IN.ase_texcoord3.xy * _Albedo_Smoothness_ST_Instance.xy + _Albedo_Smoothness_ST_Instance.zw;
				float4 tex2DNode76 = tex2D( _Albedo_Smoothness, uv_Albedo_Smoothness );
				float4 Diffuse77 = tex2DNode76;
				float4 color212 = IsGammaSpace() ? float4(0.7529412,0.2705882,0,0) : float4(0.5271152,0.05951123,0,0);
				float4 BruiseColor80 = color212;
				float4 _MaskTexture_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_MaskTexture_ST_arr, _MaskTexture_ST);
				float2 uv_MaskTexture = IN.ase_texcoord3.xy * _MaskTexture_ST_Instance.xy + _MaskTexture_ST_Instance.zw;
				float4 tex2DNode97 = tex2D( _MaskTexture, uv_MaskTexture );
				float Bruises94 = tex2DNode97.b;
				float2 temp_cast_0 = (20.0).xx;
				float2 texCoord218 = IN.ase_texcoord3.xy * temp_cast_0 + float2( 0,0 );
				float BruiseBreakupMask106 = tex2D( _BloodCutBruiseMask, texCoord218 ).b;
				float BruiseLerp67 = saturate( ( Bruises94 * ( BruiseBreakupMask106 * 1.74 ) ) );
				float4 lerpResult141 = lerp( Diffuse77 , ( Diffuse77 * BruiseColor80 ) , BruiseLerp67);
				float4 color1_g20 = IsGammaSpace() ? float4(0.490566,0.06317896,0,0) : float4(0.2054128,0.005227456,0,0);
				float4 color2_g20 = IsGammaSpace() ? float4(0.4622642,0.07222877,0,0) : float4(0.1807607,0.006240204,0,0);
				float BloodWet112 = tex2DNode97.a;
				float BloodDry93 = tex2DNode97.r;
				float2 temp_cast_1 = (10.0).xx;
				float2 texCoord217 = IN.ase_texcoord3.xy * temp_cast_1 + float2( 0,0 );
				float BloodEdgeMask104 = tex2D( _BloodCutBruiseMask, texCoord217 ).r;
				float temp_output_62_0 = ( BloodDry93 + ( BloodDry93 * BloodEdgeMask104 ) );
				float BloodLerp115 = saturate( step( 0.7 , temp_output_62_0 ) );
				float clampResult182 = clamp( BloodLerp115 , 0.0 , 0.97 );
				float4 lerpResult129 = lerp( lerpResult141 , ( color1_g20 + ( color2_g20 * BloodWet112 ) ) , clampResult182);
				
				float4 color225 = IsGammaSpace() ? float4(0.7372549,0,0,0) : float4(0.5028866,0,0,0);
				float _Damage_Instance = UNITY_ACCESS_INSTANCED_PROP(_Damage_arr, _Damage);
				
				o.Albedo = lerpResult129.rgb;
				o.Normal = fixed3( 0, 0, 1 );
				o.Emission = saturate( ( color225 * _Damage_Instance ) ).rgb;
				o.Alpha = 1;
				float AlphaClipThreshold = 0.5;

				#ifdef _ALPHATEST_ON
					clip( o.Alpha - AlphaClipThreshold );
				#endif

				#ifdef _DEPTHOFFSET_ON
					outputDepth = IN.pos.z;
				#endif

				UnityMetaInput metaIN;
				UNITY_INITIALIZE_OUTPUT(UnityMetaInput, metaIN);
				metaIN.Albedo = o.Albedo;
				metaIN.Emission = o.Emission;
				#ifdef EDITOR_VISUALIZATION
					metaIN.VizUV = IN.vizUV;
					metaIN.LightCoord = IN.lightCoord;
				#endif
				return UnityMetaFragment(metaIN);
			}
			ENDCG
		}

		
		Pass
		{
			
			Name "ShadowCaster"
			Tags { "LightMode"="ShadowCaster" }
			ZWrite On
			ZTest LEqual
			AlphaToMask Off

			CGPROGRAM
			#define ASE_NEEDS_FRAG_SHADOWCOORDS
			#pragma multi_compile_instancing
			#define ASE_ABSOLUTE_VERTEX_POS 1

			#pragma vertex vert
			#pragma fragment frag
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#pragma multi_compile_shadowcaster
			#ifndef UNITY_PASS_SHADOWCASTER
				#define UNITY_PASS_SHADOWCASTER
			#endif
			#include "HLSLSupport.cginc"
			#ifndef UNITY_INSTANCED_LOD_FADE
				#define UNITY_INSTANCED_LOD_FADE
			#endif
			#ifndef UNITY_INSTANCED_SH
				#define UNITY_INSTANCED_SH
			#endif
			#ifndef UNITY_INSTANCED_LIGHTMAPSTS
				#define UNITY_INSTANCED_LIGHTMAPSTS
			#endif
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityShaderVariables.cginc"
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"

			#include "../skinned_vertices_with_color.cginc"

			struct appdata {
				float4 vertex : POSITION;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct v2f {
				V2F_SHADOW_CASTER;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			#ifdef UNITY_STANDARD_USE_DITHER_MASK
				sampler3D _DitherMaskLOD;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			UNITY_INSTANCING_BUFFER_START(Cortopia_LowEndase_character_bloodpaint_lowend)
			UNITY_INSTANCING_BUFFER_END(Cortopia_LowEndase_character_bloodpaint_lowend)


			
			v2f VertexFunction (appdata v  ) {
				UNITY_SETUP_INSTANCE_ID(v);
				v2f o;
				UNITY_INITIALIZE_OUTPUT(v2f,o);
				UNITY_TRANSFER_INSTANCE_ID(v,o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.vertex.w = 1;
				v.normal = v.normal;
				v.tangent = v.tangent;

				TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( appdata v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.tangent = v.tangent;
				o.normal = v.normal;
				o.texcoord1 = v.texcoord1;
				o.texcoord2 = v.texcoord2;
				
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, UNITY_MATRIX_M, _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, UNITY_MATRIX_M, _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, UNITY_MATRIX_M, _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			v2f DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				appdata o = (appdata) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.tangent = patch[0].tangent * bary.x + patch[1].tangent * bary.y + patch[2].tangent * bary.z;
				o.normal = patch[0].normal * bary.x + patch[1].normal * bary.y + patch[2].normal * bary.z;
				o.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
				o.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].normal * (dot(o.vertex.xyz, patch[i].normal) - dot(patch[i].vertex.xyz, patch[i].normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			v2f vert ( appdata v )
			{
				return VertexFunction( v );
			}
			#endif

			fixed4 frag (v2f IN 
				#ifdef _DEPTHOFFSET_ON
				, out float outputDepth : SV_Depth
				#endif
				#if !defined( CAN_SKIP_VPOS )
				, UNITY_VPOS_TYPE vpos : VPOS
				#endif
				) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(IN);

				#ifdef LOD_FADE_CROSSFADE
					UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);
				#endif

				#if defined(_SPECULAR_SETUP)
					SurfaceOutputStandardSpecular o = (SurfaceOutputStandardSpecular)0;
				#else
					SurfaceOutputStandard o = (SurfaceOutputStandard)0;
				#endif

				
				o.Normal = fixed3( 0, 0, 1 );
				o.Occlusion = 1;
				o.Alpha = 1;
				float AlphaClipThreshold = 0.5;
				float AlphaClipThresholdShadow = 0.5;

				#ifdef _ALPHATEST_SHADOW_ON
					if (unity_LightShadowBias.z != 0.0)
						clip(o.Alpha - AlphaClipThresholdShadow);
					#ifdef _ALPHATEST_ON
					else
						clip(o.Alpha - AlphaClipThreshold);
					#endif
				#else
					#ifdef _ALPHATEST_ON
						clip(o.Alpha - AlphaClipThreshold);
					#endif
				#endif

				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif

				#ifdef UNITY_STANDARD_USE_DITHER_MASK
					half alphaRef = tex3D(_DitherMaskLOD, float3(vpos.xy*0.25,o.Alpha*0.9375)).a;
					clip(alphaRef - 0.01);
				#endif

				#ifdef _DEPTHOFFSET_ON
					outputDepth = IN.pos.z;
				#endif

				SHADOW_CASTER_FRAGMENT(IN)
			}
			ENDCG
		}
		
	}
	CustomEditor "ASEMaterialInspector"
	
	Fallback Off
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.CommentaryNode;49;-1372.125,-377.7216;Inherit;False;311;304;Bruises;1;141;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;50;-978.7049,-377.1264;Inherit;False;311;304;Blood;1;129;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;51;-614.1343,-659.4135;Inherit;False;531.663;304;Cut - Blood paints under cut, make sure cutmask is slightly smaller;3;144;143;142;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;52;-3067.394,323.4416;Inherit;False;1150.118;450.8744;BloodMask;8;116;114;113;63;62;61;60;174;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;53;-3069.117,-222.7398;Inherit;False;1152.388;533.1783;CutMask;8;111;110;109;99;59;58;177;215;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;54;-3065.334,797.6063;Inherit;False;1142.78;572.1578;BruiseMask;9;101;100;80;67;66;65;64;56;212;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;55;-3059.353,-592.1536;Inherit;False;1140.722;352.1894;CutDarkenCenter (get this in parallax);8;96;75;74;72;71;70;69;57;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-2810.833,1152.147;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;57;-2057.208,-551.4219;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;62;-2606.733,469.657;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-2544.583,1080.005;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;66;-2327.38,1079.304;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;69;-2875.651,-540.9968;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;70;-2332.049,-344.6194;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;71;-2818.175,-349.6792;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;73;-3763.989,76.45389;Inherit;True;Property;_BloodCutBruiseMask;BloodCutBruiseMask;3;0;Create;True;0;0;0;False;0;False;-1;None;5657507ec4511ef43a15e0e101373dad;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;75;-2666.116,-555.8209;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;94;-3413.153,-114.2452;Inherit;False;Bruises;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;95;-3407.659,-202.3165;Inherit;False;Cut;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-2616.134,-326.4109;Inherit;False;Property;_MeatDark;MeatDark;4;0;Create;True;0;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;97;-3767.618,-191.1425;Inherit;True;Property;_MaskTexture;MaskTexture;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;112;-3402.03,-31.98309;Inherit;False;BloodWet;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;-1857.063,-575.4355;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;123;-3761.684,-744.3282;Inherit;True;Property;_Flesh;Flesh;2;0;Create;True;0;0;0;False;0;False;-1;None;b08a8a603eacafc40b6911d58012c0fe;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;129;-928.7049,-327.1264;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;137;-1572.889,-278.2644;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;138;-1794.832,-372.7401;Inherit;False;77;Diffuse;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;140;-1602.908,-171.0092;Inherit;False;67;BruiseLerp;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;141;-1322.125,-327.7216;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;142;-334.1553,-586.5835;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;1,1,1,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;133;-1765.82,58.43068;Inherit;False;112;BloodWet;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;76;-3763.801,-530.0417;Inherit;True;Property;_Albedo_Smoothness;Albedo_Smoothness;0;0;Create;True;0;0;0;False;0;False;-1;None;50dba9ba2dc14f94492be611c2367303;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;127;-3421.677,-744.6595;Inherit;False;Flesh Diffuse;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;126;-3425.833,-649.0927;Inherit;False;FleshSmoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;77;-3409.289,-529.9959;Inherit;False;Diffuse;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;78;-3409.087,-434.9158;Inherit;False;Smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;67;-2163.45,1074.988;Inherit;False;BruiseLerp;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;72;-3092.472,-541.4628;Inherit;False;95;Cut;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;64;-3016.989,1070.67;Inherit;False;94;Bruises;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;100;-3054.294,1152.218;Inherit;False;106;BruiseBreakupMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;139;-1797.27,-254.0724;Inherit;False;80;BruiseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;145;110.4302,-302.7878;Float;False;False;-1;2;ASEMaterialInspector;0;4;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;ExtraPrePass;0;0;ExtraPrePass;6;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;2;False;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=ForwardBase;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;147;110.4302,-302.7878;Float;False;False;-1;2;ASEMaterialInspector;0;4;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;ForwardAdd;0;2;ForwardAdd;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;2;False;0;False;True;4;1;False;;1;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;True;1;LightMode=ForwardAdd;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;148;110.4302,-302.7878;Float;False;False;-1;2;ASEMaterialInspector;0;4;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;Deferred;0;3;Deferred;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Deferred;True;2;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;149;110.4302,-302.7878;Float;False;False;-1;2;ASEMaterialInspector;0;4;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;Meta;0;4;Meta;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;150;110.4302,-302.7878;Float;False;False;-1;2;ASEMaterialInspector;0;4;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;ShadowCaster;0;5;ShadowCaster;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;True;1;LightMode=ShadowCaster;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;80;-2158.313,862.0934;Inherit;False;BruiseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;144;-559.7985,-616.9305;Inherit;False;127;Flesh Diffuse;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;143;-584.251,-494.7858;Inherit;False;111;CutMaskLerp;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;113;-3059.261,575.3824;Inherit;False;104;BloodEdgeMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;174;-2366.885,565.7926;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.7;False;2;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;104;-3413.062,99.8867;Inherit;False;BloodEdgeMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;115;-2137.293,619.274;Inherit;False;BloodLerp;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;93;-3407.309,-291.968;Inherit;False;BloodDry;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;116;-3053.923,467.6834;Inherit;False;93;BloodDry;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;134;-1429.733,160.7217;Inherit;False;115;BloodLerp;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;136;-1259.387,-67.34058;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;131;-1412.129,33.95706;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;205;-1790.625,-65.86808;Inherit;False;ase_function_bloodcolor;-1;;20;439e2ac262e7b8a4db20b11e6f95045c;0;0;2;COLOR;0;COLOR;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;106;-3430.758,335.9149;Inherit;False;BruiseBreakupMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;212;-2465.382,863.9089;Inherit;False;Constant;_BruiseColor;BruiseColor;5;0;Create;True;0;0;0;False;0;False;0.7529412,0.2705882,0,0;0.8396226,0.2056701,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;105;-3761.463,263.7047;Inherit;True;Property;_TextureSample1;Texture Sample 1;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;73;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;58;-2513.919,-178.7569;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;99;-2377.64,-177.8986;Inherit;False;2;0;FLOAT;0.7;False;1;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-2665.585,-112.2269;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;215;-2823.749,-19.06366;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;61;-2356.236,360.6671;Inherit;False;2;0;FLOAT;0.91;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-2816.703,551.3503;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;-2364.542,-559.2256;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;101;-3006.958,1225.316;Inherit;False;Constant;_BruiseStrenght;BruiseStrenght;7;0;Create;True;0;0;0;False;0;False;1.74;1.74;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;114;-2567.887,371.1822;Inherit;False;Constant;_BloodNoise;BloodNoise;5;0;Create;True;0;0;0;False;0;False;0.7;0.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;177;-2620.483,87.55;Inherit;False;Constant;_CutStepMin;CutStepMin;6;0;Create;True;0;0;0;False;0;False;0.88;0.87;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;63;-2203.195,367.7745;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;182;-1134.823,13.76929;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.97;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;170;-4176.307,-695.4691;Inherit;False;Constant;_Float0;Float 0;9;0;Create;True;0;0;0;False;0;False;20;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;216;-4003.2,-719.4307;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;217;-3976.059,100.7009;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;218;-3974.629,287.9449;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;172;-4155.847,125.2806;Inherit;False;Constant;_Float1;Float 1;8;0;Create;True;0;0;0;False;0;False;10;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;220;-4160.981,310.1494;Inherit;False;Constant;_Float3;Float 1;8;0;Create;True;0;0;0;False;0;False;20;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;111;-2147.63,-176.3813;Inherit;False;CutMaskLerp;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;110;-3042.433,-19.83481;Inherit;False;206;CutsBreakupMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;109;-2930.342,-183.5428;Inherit;False;95;Cut;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;210;-3764.798,471.9794;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;73;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;219;-3986.629,494.9449;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;211;-4155.592,519.6527;Inherit;False;Constant;_Float2;Float 2;7;0;Create;True;0;0;0;False;0;False;30;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;206;-3435.093,496.1896;Inherit;False;CutsBreakupMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;146;274.4007,-326.7048;Float;False;True;-1;2;ASEMaterialInspector;0;4;Cortopia/_LowEnd/ase_character_bloodpaint_lowend;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;ForwardBase;0;1;ForwardBase;18;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;2;False;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;False;2;Include;;False;;Native;False;0;0;;Include;../skinned_vertices_with_color.cginc;False;;Custom;False;0;0;;;0;0;Standard;40;Workflow,InvertActionOnDeselection;1;0;Surface;0;0;  Blend;0;0;  Refraction Model;0;0;  Dither Shadows;1;0;Two Sided;1;0;Deferred Pass;0;638524978028902860;Transmission;0;0;  Transmission Shadow;0.5,False,;0;Translucency;0;0;  Translucency Strength;1,False,;0;  Normal Distortion;0.5,False,;0;  Scattering;2,False,;0;  Direct;0.9,False,;0;  Ambient;0.1,False,;0;  Shadow;0.5,False,;0;Cast Shadows;1;0;  Use Shadow Threshold;0;0;Receive Shadows;1;0;GPU Instancing;1;0;LOD CrossFade;0;638524978212026190;Built-in Fog;0;638524978233044624;Ambient Light;1;0;Meta Pass;1;638524979019655531;Add Pass;0;638524978279906822;Override Baked GI;0;0;Extra Pre Pass;0;0;Tessellation;0;0;  Phong;0;0;  Strength;0.5,False,;0;  Type;0;0;  Tess;16,False,;0;  Min;10,False,;0;  Max;25,False,;0;  Edge Length;16,False,;0;  Max Displacement;25,False,;0;Fwd Specular Highlights Toggle;0;0;Fwd Reflections Toggle;0;0;Disable Batching;0;0;Vertex Position,InvertActionOnDeselection;0;638423007020048860;0;6;False;True;False;False;True;True;False;;False;0
Node;AmplifyShaderEditor.LerpOp;86;-320.2308,106.3803;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;98;-578.1889,372.8875;Inherit;False;111;CutMaskLerp;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;-803.7345,235.4505;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.75;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;85;-551.7481,212.1081;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;83;-834.2211,137.8805;Inherit;False;78;Smoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;82;-1028.242,235.1994;Inherit;False;112;BloodWet;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;200;-802.5262,349.1598;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;87;-693.0488,54.0128;Inherit;False;126;FleshSmoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;201;-1098.713,374.0731;Inherit;False;93;BloodDry;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;88;-147.9443,212.4084;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;223;54.5058,-251.2417;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;224;-134.4942,-253.2417;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;225;-559.1131,-252.9397;Inherit;False;Constant;_Color1;Color 0;13;0;Create;True;0;0;0;False;0;False;0.7372549,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;226;-325.4942,-100.2417;Inherit;False;InstancedProperty;_Damage;Damage;5;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
WireConnection;56;0;100;0
WireConnection;56;1;101;0
WireConnection;57;0;74;0
WireConnection;62;0;116;0
WireConnection;62;1;60;0
WireConnection;65;0;64;0
WireConnection;65;1;56;0
WireConnection;66;0;65;0
WireConnection;69;0;72;0
WireConnection;70;0;75;0
WireConnection;70;1;96;0
WireConnection;73;1;217;0
WireConnection;75;0;69;0
WireConnection;94;0;97;3
WireConnection;95;0;97;2
WireConnection;112;0;97;4
WireConnection;117;1;57;0
WireConnection;123;1;216;0
WireConnection;129;0;141;0
WireConnection;129;1;136;0
WireConnection;129;2;182;0
WireConnection;137;0;138;0
WireConnection;137;1;139;0
WireConnection;141;0;138;0
WireConnection;141;1;137;0
WireConnection;141;2;140;0
WireConnection;142;0;144;0
WireConnection;142;1;129;0
WireConnection;142;2;143;0
WireConnection;127;0;123;0
WireConnection;126;0;123;4
WireConnection;77;0;76;0
WireConnection;78;0;76;4
WireConnection;67;0;66;0
WireConnection;80;0;212;0
WireConnection;174;0;62;0
WireConnection;104;0;73;1
WireConnection;115;0;63;0
WireConnection;93;0;97;1
WireConnection;136;0;205;0
WireConnection;136;1;131;0
WireConnection;131;0;205;3
WireConnection;131;1;133;0
WireConnection;106;0;105;3
WireConnection;105;1;218;0
WireConnection;58;0;109;0
WireConnection;58;1;59;0
WireConnection;99;0;58;0
WireConnection;99;1;177;0
WireConnection;59;0;109;0
WireConnection;59;1;215;0
WireConnection;215;0;110;0
WireConnection;61;0;114;0
WireConnection;61;1;62;0
WireConnection;60;0;116;0
WireConnection;60;1;113;0
WireConnection;74;0;75;0
WireConnection;74;1;96;0
WireConnection;63;0;61;0
WireConnection;182;0;134;0
WireConnection;216;0;170;0
WireConnection;217;0;172;0
WireConnection;218;0;220;0
WireConnection;111;0;99;0
WireConnection;210;1;219;0
WireConnection;219;0;211;0
WireConnection;206;0;210;1
WireConnection;146;0;129;0
WireConnection;146;2;223;0
WireConnection;146;5;88;0
WireConnection;86;0;87;0
WireConnection;86;1;85;0
WireConnection;86;2;98;0
WireConnection;81;0;82;0
WireConnection;85;0;83;0
WireConnection;85;1;81;0
WireConnection;85;2;200;0
WireConnection;200;0;82;0
WireConnection;200;1;201;0
WireConnection;88;0;85;0
WireConnection;223;0;224;0
WireConnection;224;0;225;0
WireConnection;224;1;226;0
ASEEND*/
//CHKSM=2865028C56DD7798AB746C1AF97B3B5D097DE50D
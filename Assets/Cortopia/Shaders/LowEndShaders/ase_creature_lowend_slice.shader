// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Cortopia/_LowEnd/ase_creature_lowend_slice"
{
	Properties
	{
		_Albedo_Smoothness("Albedo_Smoothness", 2D) = "black" {}
		[Toggle(_ISMETALLIC_ON)] _IsMetallic("IsMetallic", Float) = 0
		_BreakUpNoise("BreakUpNoise", 2D) = "white" {}
		_MaskTexture("MaskTexture", 2D) = "black" {}

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
			#pragma multi_compile_instancing
			#pragma multi_compile __ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
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

			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_TANGENT
			#pragma multi_compile __ _Slicable
			#pragma shader_feature _SmoothnessView
			#pragma shader_feature _DiffuseOnlyMode
			#pragma shader_feature_local _ISMETALLIC_ON
			#include "../skinned_vertices_with_color.cginc"

			struct appdata {
				float4 vertex : POSITION;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				uint ase_vertexID : SV_VertexID;
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
				float4 ase_texcoord10 : TEXCOORD10;
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
			uniform sampler2D _BreakUpNoise;


			float3 SliceVertexPosition2_g13( int vertex_id )
			{
				const int offset = vertex_id * _VertexStride;
				const float3 pos = asfloat(_SkinnedVertices.Load3(offset));
				return mul(_ObjectToWorld, float4(pos, 1.0f));
			}
			
			float3 SliceVertexNormal2_g12( int vertex_id )
			{
				const int offset = vertex_id * _VertexStride + 12;
				const float3 norm = asfloat(_SkinnedVertices.Load3(offset));
				return normalize(mul(norm, (float3x3)_WorldToObject));
			}
			
			float4 SliceVertexTangent2_g14( int vertex_id )
			{
				const int offset = vertex_id * _VertexStride + 24;
				const float4 tan = asfloat(_SkinnedVertices.Load4(offset));
				return normalize(mul(tan, _ObjectToWorld));
			}
			
			float2 SliceVertexTexcoord5_g15( int vertex_id )
			{
				return float2(_TexCoords[vertex_id].texcoord0, _TexCoords[vertex_id].texcoord1);
			}
			
			float Color123( int vertex_id )
			{
				return (_TexCoords[vertex_id].color & 0xFF) > 0 ? 1 : 0;
			}
			

			v2f VertexFunction (appdata v  ) {
				UNITY_SETUP_INSTANCE_ID(v);
				v2f o;
				UNITY_INITIALIZE_OUTPUT(v2f,o);
				UNITY_TRANSFER_INSTANCE_ID(v,o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				int vertex_id2_g13 = v.ase_vertexID;
				float3 localSliceVertexPosition2_g13 = SliceVertexPosition2_g13( vertex_id2_g13 );
				#ifdef _Slicable
				float3 staticSwitch16_g11 = localSliceVertexPosition2_g13;
				#else
				float3 staticSwitch16_g11 = v.vertex.xyz;
				#endif
				float3 SkinnedPosition105 = staticSwitch16_g11;
				
				int vertex_id2_g12 = v.ase_vertexID;
				float3 localSliceVertexNormal2_g12 = SliceVertexNormal2_g12( vertex_id2_g12 );
				#ifdef _Slicable
				float3 staticSwitch12_g11 = localSliceVertexNormal2_g12;
				#else
				float3 staticSwitch12_g11 = v.normal;
				#endif
				float3 SkinnedNormal104 = staticSwitch12_g11;
				
				int vertex_id2_g14 = v.ase_vertexID;
				float4 localSliceVertexTangent2_g14 = SliceVertexTangent2_g14( vertex_id2_g14 );
				float4 vertexToFrag6_g11 = localSliceVertexTangent2_g14;
				#ifdef _Slicable
				float4 staticSwitch11_g11 = vertexToFrag6_g11;
				#else
				float4 staticSwitch11_g11 = float4( v.tangent.xyz , 0.0 );
				#endif
				float4 SkinnedTangent102 = staticSwitch11_g11;
				
				int vertex_id5_g15 = v.ase_vertexID;
				float2 localSliceVertexTexcoord5_g15 = SliceVertexTexcoord5_g15( vertex_id5_g15 );
				float2 vertexToFrag9_g11 = localSliceVertexTexcoord5_g15;
				o.ase_texcoord9.zw = vertexToFrag9_g11;
				
				o.ase_texcoord9.xy = v.ase_texcoord.xy;
				o.ase_texcoord10.x = v.ase_vertexID;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord10.yzw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = SkinnedPosition105;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.vertex.w = 1;
				v.normal = SkinnedNormal104;
				v.tangent = SkinnedTangent102;

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
				uint ase_vertexID : SV_VertexID;
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
				o.vertex = v.vertex;
				o.ase_vertexID = v.ase_vertexID;
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
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_vertexID = patch[0].ase_vertexID * bary.x + patch[1].ase_vertexID * bary.y + patch[2].ase_vertexID * bary.z;
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

				float2 vertexToFrag9_g11 = IN.ase_texcoord9.zw;
				#ifdef _Slicable
				float2 staticSwitch10_g11 = vertexToFrag9_g11;
				#else
				float2 staticSwitch10_g11 = IN.ase_texcoord9.xy;
				#endif
				float2 TexCoord103 = staticSwitch10_g11;
				float4 tex2DNode72 = tex2D( _Albedo_Smoothness, TexCoord103 );
				float4 color1_g3 = IsGammaSpace() ? float4(0.490566,0.06317896,0,0) : float4(0.2054128,0.005227456,0,0);
				float4 tex2DNode80 = tex2D( _MaskTexture, TexCoord103 );
				float4 color2_g3 = IsGammaSpace() ? float4(0.4622642,0.07222877,0,0) : float4(0.1807607,0.006240204,0,0);
				float temp_output_70_0 = ( tex2DNode80.r + ( tex2DNode80.r * tex2D( _BreakUpNoise, ( TexCoord103 * float2( 8,8 ) ) ).r ) );
				float temp_output_74_0 = step( 0.75 , temp_output_70_0 );
				float4 lerpResult88 = lerp( tex2DNode72 , ( ( color1_g3 * tex2DNode80.r ) + ( color2_g3 * tex2DNode80.a ) ) , temp_output_74_0);
				float4 temp_output_10_0_g7 = lerpResult88;
				float4 temp_cast_1 = (0.0).xxxx;
				#ifdef _DiffuseOnlyMode
				float4 staticSwitch2_g7 = temp_cast_1;
				#else
				float4 staticSwitch2_g7 = temp_output_10_0_g7;
				#endif
				float4 temp_cast_2 = (0.0).xxxx;
				#ifdef _SmoothnessView
				float4 staticSwitch1_g7 = temp_cast_2;
				#else
				float4 staticSwitch1_g7 = staticSwitch2_g7;
				#endif
				
				float4 temp_output_17_0_g7 = float4( 0,0,0,0 );
				#ifdef _DiffuseOnlyMode
				float4 staticSwitch5_g7 = temp_output_10_0_g7;
				#else
				float4 staticSwitch5_g7 = temp_output_17_0_g7;
				#endif
				float clampResult81 = clamp( tex2DNode80.a , 0.1 , 0.75 );
				float lerpResult85 = lerp( tex2DNode72.a , clampResult81 , step( 0.95 , temp_output_70_0 ));
				float temp_output_11_0_g7 = saturate( lerpResult85 );
				float4 temp_cast_4 = (temp_output_11_0_g7).xxxx;
				#ifdef _SmoothnessView
				float4 staticSwitch6_g7 = temp_cast_4;
				#else
				float4 staticSwitch6_g7 = temp_output_17_0_g7;
				#endif
				#ifdef _SmoothnessView
				float4 staticSwitch3_g7 = staticSwitch6_g7;
				#else
				float4 staticSwitch3_g7 = staticSwitch5_g7;
				#endif
				
				int vertex_id123 = IN.ase_texcoord10.x;
				float localColor123 = Color123( vertex_id123 );
				#ifdef _ISMETALLIC_ON
				float staticSwitch122 = localColor123;
				#else
				float staticSwitch122 = 0.0;
				#endif
				#ifdef _DiffuseOnlyMode
				float staticSwitch8_g7 = 0.0;
				#else
				float staticSwitch8_g7 = ( staticSwitch122 * saturate( ( 1.0 - temp_output_74_0 ) ) );
				#endif
				
				#ifdef _SmoothnessView
				float staticSwitch4_g7 = 0.0;
				#else
				float staticSwitch4_g7 = temp_output_11_0_g7;
				#endif
				#ifdef _DiffuseOnlyMode
				float staticSwitch7_g7 = 0.0;
				#else
				float staticSwitch7_g7 = staticSwitch4_g7;
				#endif
				
				o.Albedo = staticSwitch1_g7.xyz;
				o.Normal = fixed3( 0, 0, 1 );
				o.Emission = staticSwitch3_g7.xyz;
				#if defined(_SPECULAR_SETUP)
					o.Specular = fixed3( 0, 0, 0 );
				#else
					o.Metallic = staticSwitch8_g7;
				#endif
				o.Smoothness = staticSwitch7_g7;
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
			
			Name "ForwardAdd"
			Tags { "LightMode"="ForwardAdd" }
			ZWrite Off
			Blend One One

			CGPROGRAM
			#define ASE_NEEDS_FRAG_SHADOWCOORDS
			#pragma multi_compile_instancing
			#pragma multi_compile __ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define ASE_ABSOLUTE_VERTEX_POS 1

			#pragma vertex vert
			#pragma fragment frag
			#pragma skip_variants INSTANCING_ON
			#pragma multi_compile_fwdadd_fullshadows
			#ifndef UNITY_PASS_FORWARDADD
				#define UNITY_PASS_FORWARDADD
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
			#include "AutoLight.cginc"

			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_TANGENT
			#pragma multi_compile __ _Slicable
			#pragma shader_feature _SmoothnessView
			#pragma shader_feature _DiffuseOnlyMode
			#pragma shader_feature_local _ISMETALLIC_ON
			#include "../skinned_vertices_with_color.cginc"

			struct appdata {
				float4 vertex : POSITION;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				uint ase_vertexID : SV_VertexID;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			struct v2f {
				#if UNITY_VERSION >= 201810
					UNITY_POSITION(pos);
				#else
					float4 pos : SV_POSITION;
				#endif
				#if UNITY_VERSION >= 201810 && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					UNITY_LIGHTING_COORDS(1,2)
				#elif defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if UNITY_VERSION >= 201710
						UNITY_SHADOW_COORDS(1)
					#else
						SHADOW_COORDS(1)
					#endif
				#endif
				#ifdef ASE_FOG
					UNITY_FOG_COORDS(3)
				#endif
				float4 tSpace0 : TEXCOORD5;
				float4 tSpace1 : TEXCOORD6;
				float4 tSpace2 : TEXCOORD7;
				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
				float4 screenPos : TEXCOORD8;
				#endif
				float4 ase_texcoord9 : TEXCOORD9;
				float4 ase_texcoord10 : TEXCOORD10;
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
			uniform sampler2D _BreakUpNoise;


			float3 SliceVertexPosition2_g13( int vertex_id )
			{
				const int offset = vertex_id * _VertexStride;
				const float3 pos = asfloat(_SkinnedVertices.Load3(offset));
				return mul(_ObjectToWorld, float4(pos, 1.0f));
			}
			
			float3 SliceVertexNormal2_g12( int vertex_id )
			{
				const int offset = vertex_id * _VertexStride + 12;
				const float3 norm = asfloat(_SkinnedVertices.Load3(offset));
				return normalize(mul(norm, (float3x3)_WorldToObject));
			}
			
			float4 SliceVertexTangent2_g14( int vertex_id )
			{
				const int offset = vertex_id * _VertexStride + 24;
				const float4 tan = asfloat(_SkinnedVertices.Load4(offset));
				return normalize(mul(tan, _ObjectToWorld));
			}
			
			float2 SliceVertexTexcoord5_g15( int vertex_id )
			{
				return float2(_TexCoords[vertex_id].texcoord0, _TexCoords[vertex_id].texcoord1);
			}
			
			float Color123( int vertex_id )
			{
				return (_TexCoords[vertex_id].color & 0xFF) > 0 ? 1 : 0;
			}
			

			v2f VertexFunction (appdata v  ) {
				UNITY_SETUP_INSTANCE_ID(v);
				v2f o;
				UNITY_INITIALIZE_OUTPUT(v2f,o);
				UNITY_TRANSFER_INSTANCE_ID(v,o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				int vertex_id2_g13 = v.ase_vertexID;
				float3 localSliceVertexPosition2_g13 = SliceVertexPosition2_g13( vertex_id2_g13 );
				#ifdef _Slicable
				float3 staticSwitch16_g11 = localSliceVertexPosition2_g13;
				#else
				float3 staticSwitch16_g11 = v.vertex.xyz;
				#endif
				float3 SkinnedPosition105 = staticSwitch16_g11;
				
				int vertex_id2_g12 = v.ase_vertexID;
				float3 localSliceVertexNormal2_g12 = SliceVertexNormal2_g12( vertex_id2_g12 );
				#ifdef _Slicable
				float3 staticSwitch12_g11 = localSliceVertexNormal2_g12;
				#else
				float3 staticSwitch12_g11 = v.normal;
				#endif
				float3 SkinnedNormal104 = staticSwitch12_g11;
				
				int vertex_id2_g14 = v.ase_vertexID;
				float4 localSliceVertexTangent2_g14 = SliceVertexTangent2_g14( vertex_id2_g14 );
				float4 vertexToFrag6_g11 = localSliceVertexTangent2_g14;
				#ifdef _Slicable
				float4 staticSwitch11_g11 = vertexToFrag6_g11;
				#else
				float4 staticSwitch11_g11 = float4( v.tangent.xyz , 0.0 );
				#endif
				float4 SkinnedTangent102 = staticSwitch11_g11;
				
				int vertex_id5_g15 = v.ase_vertexID;
				float2 localSliceVertexTexcoord5_g15 = SliceVertexTexcoord5_g15( vertex_id5_g15 );
				float2 vertexToFrag9_g11 = localSliceVertexTexcoord5_g15;
				o.ase_texcoord9.zw = vertexToFrag9_g11;
				
				o.ase_texcoord9.xy = v.ase_texcoord.xy;
				o.ase_texcoord10.x = v.ase_vertexID;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord10.yzw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = SkinnedPosition105;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.vertex.w = 1;
				v.normal = SkinnedNormal104;
				v.tangent = SkinnedTangent102;

				o.pos = UnityObjectToClipPos(v.vertex);
				float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
				fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
				fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				fixed3 worldBinormal = cross(worldNormal, worldTangent) * tangentSign;
				o.tSpace0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
				o.tSpace1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
				o.tSpace2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);

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
				uint ase_vertexID : SV_VertexID;
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
				o.vertex = v.vertex;
				o.ase_vertexID = v.ase_vertexID;
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
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_vertexID = patch[0].ase_vertexID * bary.x + patch[1].ase_vertexID * bary.y + patch[2].ase_vertexID * bary.z;
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

			fixed4 frag ( v2f IN 
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


				float2 vertexToFrag9_g11 = IN.ase_texcoord9.zw;
				#ifdef _Slicable
				float2 staticSwitch10_g11 = vertexToFrag9_g11;
				#else
				float2 staticSwitch10_g11 = IN.ase_texcoord9.xy;
				#endif
				float2 TexCoord103 = staticSwitch10_g11;
				float4 tex2DNode72 = tex2D( _Albedo_Smoothness, TexCoord103 );
				float4 color1_g3 = IsGammaSpace() ? float4(0.490566,0.06317896,0,0) : float4(0.2054128,0.005227456,0,0);
				float4 tex2DNode80 = tex2D( _MaskTexture, TexCoord103 );
				float4 color2_g3 = IsGammaSpace() ? float4(0.4622642,0.07222877,0,0) : float4(0.1807607,0.006240204,0,0);
				float temp_output_70_0 = ( tex2DNode80.r + ( tex2DNode80.r * tex2D( _BreakUpNoise, ( TexCoord103 * float2( 8,8 ) ) ).r ) );
				float temp_output_74_0 = step( 0.75 , temp_output_70_0 );
				float4 lerpResult88 = lerp( tex2DNode72 , ( ( color1_g3 * tex2DNode80.r ) + ( color2_g3 * tex2DNode80.a ) ) , temp_output_74_0);
				float4 temp_output_10_0_g7 = lerpResult88;
				float4 temp_cast_1 = (0.0).xxxx;
				#ifdef _DiffuseOnlyMode
				float4 staticSwitch2_g7 = temp_cast_1;
				#else
				float4 staticSwitch2_g7 = temp_output_10_0_g7;
				#endif
				float4 temp_cast_2 = (0.0).xxxx;
				#ifdef _SmoothnessView
				float4 staticSwitch1_g7 = temp_cast_2;
				#else
				float4 staticSwitch1_g7 = staticSwitch2_g7;
				#endif
				
				float4 temp_output_17_0_g7 = float4( 0,0,0,0 );
				#ifdef _DiffuseOnlyMode
				float4 staticSwitch5_g7 = temp_output_10_0_g7;
				#else
				float4 staticSwitch5_g7 = temp_output_17_0_g7;
				#endif
				float clampResult81 = clamp( tex2DNode80.a , 0.1 , 0.75 );
				float lerpResult85 = lerp( tex2DNode72.a , clampResult81 , step( 0.95 , temp_output_70_0 ));
				float temp_output_11_0_g7 = saturate( lerpResult85 );
				float4 temp_cast_4 = (temp_output_11_0_g7).xxxx;
				#ifdef _SmoothnessView
				float4 staticSwitch6_g7 = temp_cast_4;
				#else
				float4 staticSwitch6_g7 = temp_output_17_0_g7;
				#endif
				#ifdef _SmoothnessView
				float4 staticSwitch3_g7 = staticSwitch6_g7;
				#else
				float4 staticSwitch3_g7 = staticSwitch5_g7;
				#endif
				
				int vertex_id123 = IN.ase_texcoord10.x;
				float localColor123 = Color123( vertex_id123 );
				#ifdef _ISMETALLIC_ON
				float staticSwitch122 = localColor123;
				#else
				float staticSwitch122 = 0.0;
				#endif
				#ifdef _DiffuseOnlyMode
				float staticSwitch8_g7 = 0.0;
				#else
				float staticSwitch8_g7 = ( staticSwitch122 * saturate( ( 1.0 - temp_output_74_0 ) ) );
				#endif
				
				#ifdef _SmoothnessView
				float staticSwitch4_g7 = 0.0;
				#else
				float staticSwitch4_g7 = temp_output_11_0_g7;
				#endif
				#ifdef _DiffuseOnlyMode
				float staticSwitch7_g7 = 0.0;
				#else
				float staticSwitch7_g7 = staticSwitch4_g7;
				#endif
				
				o.Albedo = staticSwitch1_g7.xyz;
				o.Normal = fixed3( 0, 0, 1 );
				o.Emission = staticSwitch3_g7.xyz;
				#if defined(_SPECULAR_SETUP)
					o.Specular = fixed3( 0, 0, 0 );
				#else
					o.Metallic = staticSwitch8_g7;
				#endif
				o.Smoothness = staticSwitch7_g7;
				o.Occlusion = 1;
				o.Alpha = 1;
				float AlphaClipThreshold = 0.5;
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
				gi.light.color *= atten;

				#if defined(_SPECULAR_SETUP)
					c += LightingStandardSpecular( o, worldViewDir, gi );
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

				#ifdef ASE_FOG
					UNITY_APPLY_FOG(IN.fogCoord, c);
				#endif
				return c;
			}
			ENDCG
		}

		
		Pass
		{
			
			Name "Deferred"
			Tags { "LightMode"="Deferred" }

			AlphaToMask Off

			CGPROGRAM
			#define ASE_NEEDS_FRAG_SHADOWCOORDS
			#pragma multi_compile_instancing
			#pragma multi_compile __ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define ASE_ABSOLUTE_VERTEX_POS 1

			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#pragma multi_compile_prepassfinal
			#ifndef UNITY_PASS_DEFERRED
				#define UNITY_PASS_DEFERRED
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

			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_TANGENT
			#pragma multi_compile __ _Slicable
			#pragma shader_feature _SmoothnessView
			#pragma shader_feature _DiffuseOnlyMode
			#pragma shader_feature_local _ISMETALLIC_ON
			#include "../skinned_vertices_with_color.cginc"

			struct appdata {
				float4 vertex : POSITION;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				uint ase_vertexID : SV_VertexID;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct v2f {
				#if UNITY_VERSION >= 201810
					UNITY_POSITION(pos);
				#else
					float4 pos : SV_POSITION;
				#endif
				float4 lmap : TEXCOORD2;
				#ifndef LIGHTMAP_ON
					#if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
						half3 sh : TEXCOORD3;
					#endif
				#else
					#ifdef DIRLIGHTMAP_OFF
						float4 lmapFadePos : TEXCOORD4;
					#endif
				#endif
				float4 tSpace0 : TEXCOORD5;
				float4 tSpace1 : TEXCOORD6;
				float4 tSpace2 : TEXCOORD7;
				float4 ase_texcoord8 : TEXCOORD8;
				float4 ase_texcoord9 : TEXCOORD9;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			#ifdef LIGHTMAP_ON
			float4 unity_LightmapFade;
			#endif
			fixed4 unity_Ambient;
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
			uniform sampler2D _BreakUpNoise;


			float3 SliceVertexPosition2_g13( int vertex_id )
			{
				const int offset = vertex_id * _VertexStride;
				const float3 pos = asfloat(_SkinnedVertices.Load3(offset));
				return mul(_ObjectToWorld, float4(pos, 1.0f));
			}
			
			float3 SliceVertexNormal2_g12( int vertex_id )
			{
				const int offset = vertex_id * _VertexStride + 12;
				const float3 norm = asfloat(_SkinnedVertices.Load3(offset));
				return normalize(mul(norm, (float3x3)_WorldToObject));
			}
			
			float4 SliceVertexTangent2_g14( int vertex_id )
			{
				const int offset = vertex_id * _VertexStride + 24;
				const float4 tan = asfloat(_SkinnedVertices.Load4(offset));
				return normalize(mul(tan, _ObjectToWorld));
			}
			
			float2 SliceVertexTexcoord5_g15( int vertex_id )
			{
				return float2(_TexCoords[vertex_id].texcoord0, _TexCoords[vertex_id].texcoord1);
			}
			
			float Color123( int vertex_id )
			{
				return (_TexCoords[vertex_id].color & 0xFF) > 0 ? 1 : 0;
			}
			

			v2f VertexFunction (appdata v  ) {
				UNITY_SETUP_INSTANCE_ID(v);
				v2f o;
				UNITY_INITIALIZE_OUTPUT(v2f,o);
				UNITY_TRANSFER_INSTANCE_ID(v,o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				int vertex_id2_g13 = v.ase_vertexID;
				float3 localSliceVertexPosition2_g13 = SliceVertexPosition2_g13( vertex_id2_g13 );
				#ifdef _Slicable
				float3 staticSwitch16_g11 = localSliceVertexPosition2_g13;
				#else
				float3 staticSwitch16_g11 = v.vertex.xyz;
				#endif
				float3 SkinnedPosition105 = staticSwitch16_g11;
				
				int vertex_id2_g12 = v.ase_vertexID;
				float3 localSliceVertexNormal2_g12 = SliceVertexNormal2_g12( vertex_id2_g12 );
				#ifdef _Slicable
				float3 staticSwitch12_g11 = localSliceVertexNormal2_g12;
				#else
				float3 staticSwitch12_g11 = v.normal;
				#endif
				float3 SkinnedNormal104 = staticSwitch12_g11;
				
				int vertex_id2_g14 = v.ase_vertexID;
				float4 localSliceVertexTangent2_g14 = SliceVertexTangent2_g14( vertex_id2_g14 );
				float4 vertexToFrag6_g11 = localSliceVertexTangent2_g14;
				#ifdef _Slicable
				float4 staticSwitch11_g11 = vertexToFrag6_g11;
				#else
				float4 staticSwitch11_g11 = float4( v.tangent.xyz , 0.0 );
				#endif
				float4 SkinnedTangent102 = staticSwitch11_g11;
				
				int vertex_id5_g15 = v.ase_vertexID;
				float2 localSliceVertexTexcoord5_g15 = SliceVertexTexcoord5_g15( vertex_id5_g15 );
				float2 vertexToFrag9_g11 = localSliceVertexTexcoord5_g15;
				o.ase_texcoord8.zw = vertexToFrag9_g11;
				
				o.ase_texcoord8.xy = v.ase_texcoord.xy;
				o.ase_texcoord9.x = v.ase_vertexID;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord9.yzw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = SkinnedPosition105;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.vertex.w = 1;
				v.normal = SkinnedNormal104;
				v.tangent = SkinnedTangent102;

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
				#else
					o.lmap.zw = 0;
				#endif
				#ifdef LIGHTMAP_ON
					o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
					#ifdef DIRLIGHTMAP_OFF
						o.lmapFadePos.xyz = (mul(unity_ObjectToWorld, v.vertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w;
						o.lmapFadePos.w = (-UnityObjectToViewPos(v.vertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w);
					#endif
				#else
					o.lmap.xy = 0;
					#if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
						o.sh = 0;
						o.sh = ShadeSHPerVertex (worldNormal, o.sh);
					#endif
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
				uint ase_vertexID : SV_VertexID;
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
				o.vertex = v.vertex;
				o.ase_vertexID = v.ase_vertexID;
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
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_vertexID = patch[0].ase_vertexID * bary.x + patch[1].ase_vertexID * bary.y + patch[2].ase_vertexID * bary.z;
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

			void frag (v2f IN 
				, out half4 outGBuffer0 : SV_Target0
				, out half4 outGBuffer1 : SV_Target1
				, out half4 outGBuffer2 : SV_Target2
				, out half4 outEmission : SV_Target3
				#if defined(SHADOWS_SHADOWMASK) && (UNITY_ALLOWED_MRT_COUNT > 4)
				, out half4 outShadowMask : SV_Target4
				#endif
				#ifdef _DEPTHOFFSET_ON
				, out float outputDepth : SV_Depth
				#endif
			)
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
				half atten = 1;

				float2 vertexToFrag9_g11 = IN.ase_texcoord8.zw;
				#ifdef _Slicable
				float2 staticSwitch10_g11 = vertexToFrag9_g11;
				#else
				float2 staticSwitch10_g11 = IN.ase_texcoord8.xy;
				#endif
				float2 TexCoord103 = staticSwitch10_g11;
				float4 tex2DNode72 = tex2D( _Albedo_Smoothness, TexCoord103 );
				float4 color1_g3 = IsGammaSpace() ? float4(0.490566,0.06317896,0,0) : float4(0.2054128,0.005227456,0,0);
				float4 tex2DNode80 = tex2D( _MaskTexture, TexCoord103 );
				float4 color2_g3 = IsGammaSpace() ? float4(0.4622642,0.07222877,0,0) : float4(0.1807607,0.006240204,0,0);
				float temp_output_70_0 = ( tex2DNode80.r + ( tex2DNode80.r * tex2D( _BreakUpNoise, ( TexCoord103 * float2( 8,8 ) ) ).r ) );
				float temp_output_74_0 = step( 0.75 , temp_output_70_0 );
				float4 lerpResult88 = lerp( tex2DNode72 , ( ( color1_g3 * tex2DNode80.r ) + ( color2_g3 * tex2DNode80.a ) ) , temp_output_74_0);
				float4 temp_output_10_0_g7 = lerpResult88;
				float4 temp_cast_1 = (0.0).xxxx;
				#ifdef _DiffuseOnlyMode
				float4 staticSwitch2_g7 = temp_cast_1;
				#else
				float4 staticSwitch2_g7 = temp_output_10_0_g7;
				#endif
				float4 temp_cast_2 = (0.0).xxxx;
				#ifdef _SmoothnessView
				float4 staticSwitch1_g7 = temp_cast_2;
				#else
				float4 staticSwitch1_g7 = staticSwitch2_g7;
				#endif
				
				float4 temp_output_17_0_g7 = float4( 0,0,0,0 );
				#ifdef _DiffuseOnlyMode
				float4 staticSwitch5_g7 = temp_output_10_0_g7;
				#else
				float4 staticSwitch5_g7 = temp_output_17_0_g7;
				#endif
				float clampResult81 = clamp( tex2DNode80.a , 0.1 , 0.75 );
				float lerpResult85 = lerp( tex2DNode72.a , clampResult81 , step( 0.95 , temp_output_70_0 ));
				float temp_output_11_0_g7 = saturate( lerpResult85 );
				float4 temp_cast_4 = (temp_output_11_0_g7).xxxx;
				#ifdef _SmoothnessView
				float4 staticSwitch6_g7 = temp_cast_4;
				#else
				float4 staticSwitch6_g7 = temp_output_17_0_g7;
				#endif
				#ifdef _SmoothnessView
				float4 staticSwitch3_g7 = staticSwitch6_g7;
				#else
				float4 staticSwitch3_g7 = staticSwitch5_g7;
				#endif
				
				int vertex_id123 = IN.ase_texcoord9.x;
				float localColor123 = Color123( vertex_id123 );
				#ifdef _ISMETALLIC_ON
				float staticSwitch122 = localColor123;
				#else
				float staticSwitch122 = 0.0;
				#endif
				#ifdef _DiffuseOnlyMode
				float staticSwitch8_g7 = 0.0;
				#else
				float staticSwitch8_g7 = ( staticSwitch122 * saturate( ( 1.0 - temp_output_74_0 ) ) );
				#endif
				
				#ifdef _SmoothnessView
				float staticSwitch4_g7 = 0.0;
				#else
				float staticSwitch4_g7 = temp_output_11_0_g7;
				#endif
				#ifdef _DiffuseOnlyMode
				float staticSwitch7_g7 = 0.0;
				#else
				float staticSwitch7_g7 = staticSwitch4_g7;
				#endif
				
				o.Albedo = staticSwitch1_g7.xyz;
				o.Normal = fixed3( 0, 0, 1 );
				o.Emission = staticSwitch3_g7.xyz;
				#if defined(_SPECULAR_SETUP)
					o.Specular = fixed3( 0, 0, 0 );
				#else
					o.Metallic = staticSwitch8_g7;
				#endif
				o.Smoothness = staticSwitch7_g7;
				o.Occlusion = 1;
				o.Alpha = 1;
				float AlphaClipThreshold = 0.5;
				float3 BakedGI = 0;

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
				gi.light.color = 0;
				gi.light.dir = half3(0,1,0);

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
					LightingStandardSpecular_GI( o, giInput, gi );
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
					outEmission = LightingStandardSpecular_Deferred( o, worldViewDir, gi, outGBuffer0, outGBuffer1, outGBuffer2 );
				#else
					outEmission = LightingStandard_Deferred( o, worldViewDir, gi, outGBuffer0, outGBuffer1, outGBuffer2 );
				#endif

				#if defined(SHADOWS_SHADOWMASK) && (UNITY_ALLOWED_MRT_COUNT > 4)
					outShadowMask = UnityGetRawBakedOcclusions (IN.lmap.xy, float3(0, 0, 0));
				#endif
				#ifndef UNITY_HDR_ON
					outEmission.rgb = exp2(-outEmission.rgb);
				#endif
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
			#pragma multi_compile_instancing
			#pragma multi_compile __ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
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

			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_TANGENT
			#pragma multi_compile __ _Slicable
			#pragma shader_feature _SmoothnessView
			#pragma shader_feature _DiffuseOnlyMode
			#include "../skinned_vertices_with_color.cginc"

			struct appdata {
				float4 vertex : POSITION;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				uint ase_vertexID : SV_VertexID;
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
			uniform sampler2D _BreakUpNoise;


			float3 SliceVertexPosition2_g13( int vertex_id )
			{
				const int offset = vertex_id * _VertexStride;
				const float3 pos = asfloat(_SkinnedVertices.Load3(offset));
				return mul(_ObjectToWorld, float4(pos, 1.0f));
			}
			
			float3 SliceVertexNormal2_g12( int vertex_id )
			{
				const int offset = vertex_id * _VertexStride + 12;
				const float3 norm = asfloat(_SkinnedVertices.Load3(offset));
				return normalize(mul(norm, (float3x3)_WorldToObject));
			}
			
			float4 SliceVertexTangent2_g14( int vertex_id )
			{
				const int offset = vertex_id * _VertexStride + 24;
				const float4 tan = asfloat(_SkinnedVertices.Load4(offset));
				return normalize(mul(tan, _ObjectToWorld));
			}
			
			float2 SliceVertexTexcoord5_g15( int vertex_id )
			{
				return float2(_TexCoords[vertex_id].texcoord0, _TexCoords[vertex_id].texcoord1);
			}
			

			v2f VertexFunction (appdata v  ) {
				UNITY_SETUP_INSTANCE_ID(v);
				v2f o;
				UNITY_INITIALIZE_OUTPUT(v2f,o);
				UNITY_TRANSFER_INSTANCE_ID(v,o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				int vertex_id2_g13 = v.ase_vertexID;
				float3 localSliceVertexPosition2_g13 = SliceVertexPosition2_g13( vertex_id2_g13 );
				#ifdef _Slicable
				float3 staticSwitch16_g11 = localSliceVertexPosition2_g13;
				#else
				float3 staticSwitch16_g11 = v.vertex.xyz;
				#endif
				float3 SkinnedPosition105 = staticSwitch16_g11;
				
				int vertex_id2_g12 = v.ase_vertexID;
				float3 localSliceVertexNormal2_g12 = SliceVertexNormal2_g12( vertex_id2_g12 );
				#ifdef _Slicable
				float3 staticSwitch12_g11 = localSliceVertexNormal2_g12;
				#else
				float3 staticSwitch12_g11 = v.normal;
				#endif
				float3 SkinnedNormal104 = staticSwitch12_g11;
				
				int vertex_id2_g14 = v.ase_vertexID;
				float4 localSliceVertexTangent2_g14 = SliceVertexTangent2_g14( vertex_id2_g14 );
				float4 vertexToFrag6_g11 = localSliceVertexTangent2_g14;
				#ifdef _Slicable
				float4 staticSwitch11_g11 = vertexToFrag6_g11;
				#else
				float4 staticSwitch11_g11 = float4( v.tangent.xyz , 0.0 );
				#endif
				float4 SkinnedTangent102 = staticSwitch11_g11;
				
				int vertex_id5_g15 = v.ase_vertexID;
				float2 localSliceVertexTexcoord5_g15 = SliceVertexTexcoord5_g15( vertex_id5_g15 );
				float2 vertexToFrag9_g11 = localSliceVertexTexcoord5_g15;
				o.ase_texcoord3.zw = vertexToFrag9_g11;
				
				o.ase_texcoord3.xy = v.ase_texcoord.xy;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = SkinnedPosition105;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.vertex.w = 1;
				v.normal = SkinnedNormal104;
				v.tangent = SkinnedTangent102;

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
				uint ase_vertexID : SV_VertexID;
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
				o.vertex = v.vertex;
				o.ase_vertexID = v.ase_vertexID;
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
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_vertexID = patch[0].ase_vertexID * bary.x + patch[1].ase_vertexID * bary.y + patch[2].ase_vertexID * bary.z;
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

				float2 vertexToFrag9_g11 = IN.ase_texcoord3.zw;
				#ifdef _Slicable
				float2 staticSwitch10_g11 = vertexToFrag9_g11;
				#else
				float2 staticSwitch10_g11 = IN.ase_texcoord3.xy;
				#endif
				float2 TexCoord103 = staticSwitch10_g11;
				float4 tex2DNode72 = tex2D( _Albedo_Smoothness, TexCoord103 );
				float4 color1_g3 = IsGammaSpace() ? float4(0.490566,0.06317896,0,0) : float4(0.2054128,0.005227456,0,0);
				float4 tex2DNode80 = tex2D( _MaskTexture, TexCoord103 );
				float4 color2_g3 = IsGammaSpace() ? float4(0.4622642,0.07222877,0,0) : float4(0.1807607,0.006240204,0,0);
				float temp_output_70_0 = ( tex2DNode80.r + ( tex2DNode80.r * tex2D( _BreakUpNoise, ( TexCoord103 * float2( 8,8 ) ) ).r ) );
				float temp_output_74_0 = step( 0.75 , temp_output_70_0 );
				float4 lerpResult88 = lerp( tex2DNode72 , ( ( color1_g3 * tex2DNode80.r ) + ( color2_g3 * tex2DNode80.a ) ) , temp_output_74_0);
				float4 temp_output_10_0_g7 = lerpResult88;
				float4 temp_cast_1 = (0.0).xxxx;
				#ifdef _DiffuseOnlyMode
				float4 staticSwitch2_g7 = temp_cast_1;
				#else
				float4 staticSwitch2_g7 = temp_output_10_0_g7;
				#endif
				float4 temp_cast_2 = (0.0).xxxx;
				#ifdef _SmoothnessView
				float4 staticSwitch1_g7 = temp_cast_2;
				#else
				float4 staticSwitch1_g7 = staticSwitch2_g7;
				#endif
				
				float4 temp_output_17_0_g7 = float4( 0,0,0,0 );
				#ifdef _DiffuseOnlyMode
				float4 staticSwitch5_g7 = temp_output_10_0_g7;
				#else
				float4 staticSwitch5_g7 = temp_output_17_0_g7;
				#endif
				float clampResult81 = clamp( tex2DNode80.a , 0.1 , 0.75 );
				float lerpResult85 = lerp( tex2DNode72.a , clampResult81 , step( 0.95 , temp_output_70_0 ));
				float temp_output_11_0_g7 = saturate( lerpResult85 );
				float4 temp_cast_4 = (temp_output_11_0_g7).xxxx;
				#ifdef _SmoothnessView
				float4 staticSwitch6_g7 = temp_cast_4;
				#else
				float4 staticSwitch6_g7 = temp_output_17_0_g7;
				#endif
				#ifdef _SmoothnessView
				float4 staticSwitch3_g7 = staticSwitch6_g7;
				#else
				float4 staticSwitch3_g7 = staticSwitch5_g7;
				#endif
				
				o.Albedo = staticSwitch1_g7.xyz;
				o.Normal = fixed3( 0, 0, 1 );
				o.Emission = staticSwitch3_g7.xyz;
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
			#pragma multi_compile __ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
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

			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_TANGENT
			#pragma multi_compile __ _Slicable
			#include "../skinned_vertices_with_color.cginc"

			struct appdata {
				float4 vertex : POSITION;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				uint ase_vertexID : SV_VertexID;
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
			

			float3 SliceVertexPosition2_g13( int vertex_id )
			{
				const int offset = vertex_id * _VertexStride;
				const float3 pos = asfloat(_SkinnedVertices.Load3(offset));
				return mul(_ObjectToWorld, float4(pos, 1.0f));
			}
			
			float3 SliceVertexNormal2_g12( int vertex_id )
			{
				const int offset = vertex_id * _VertexStride + 12;
				const float3 norm = asfloat(_SkinnedVertices.Load3(offset));
				return normalize(mul(norm, (float3x3)_WorldToObject));
			}
			
			float4 SliceVertexTangent2_g14( int vertex_id )
			{
				const int offset = vertex_id * _VertexStride + 24;
				const float4 tan = asfloat(_SkinnedVertices.Load4(offset));
				return normalize(mul(tan, _ObjectToWorld));
			}
			

			v2f VertexFunction (appdata v  ) {
				UNITY_SETUP_INSTANCE_ID(v);
				v2f o;
				UNITY_INITIALIZE_OUTPUT(v2f,o);
				UNITY_TRANSFER_INSTANCE_ID(v,o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				int vertex_id2_g13 = v.ase_vertexID;
				float3 localSliceVertexPosition2_g13 = SliceVertexPosition2_g13( vertex_id2_g13 );
				#ifdef _Slicable
				float3 staticSwitch16_g11 = localSliceVertexPosition2_g13;
				#else
				float3 staticSwitch16_g11 = v.vertex.xyz;
				#endif
				float3 SkinnedPosition105 = staticSwitch16_g11;
				
				int vertex_id2_g12 = v.ase_vertexID;
				float3 localSliceVertexNormal2_g12 = SliceVertexNormal2_g12( vertex_id2_g12 );
				#ifdef _Slicable
				float3 staticSwitch12_g11 = localSliceVertexNormal2_g12;
				#else
				float3 staticSwitch12_g11 = v.normal;
				#endif
				float3 SkinnedNormal104 = staticSwitch12_g11;
				
				int vertex_id2_g14 = v.ase_vertexID;
				float4 localSliceVertexTangent2_g14 = SliceVertexTangent2_g14( vertex_id2_g14 );
				float4 vertexToFrag6_g11 = localSliceVertexTangent2_g14;
				#ifdef _Slicable
				float4 staticSwitch11_g11 = vertexToFrag6_g11;
				#else
				float4 staticSwitch11_g11 = float4( v.tangent.xyz , 0.0 );
				#endif
				float4 SkinnedTangent102 = staticSwitch11_g11;
				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = SkinnedPosition105;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.vertex.w = 1;
				v.normal = SkinnedNormal104;
				v.tangent = SkinnedTangent102;

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
				uint ase_vertexID : SV_VertexID;

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
				o.vertex = v.vertex;
				o.ase_vertexID = v.ase_vertexID;
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
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_vertexID = patch[0].ase_vertexID * bary.x + patch[1].ase_vertexID * bary.y + patch[2].ase_vertexID * bary.z;
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
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-1374.859,245.6986;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;70;-1143.859,221.6988;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;71;-1730.756,243.3628;Inherit;True;Property;_BreakUpNoise;BreakUpNoise;2;0;Create;True;0;0;0;False;0;False;-1;None;5657507ec4511ef43a15e0e101373dad;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;72;-890.0727,-656.6401;Inherit;True;Property;_Albedo_Smoothness;Albedo_Smoothness;0;0;Create;True;0;0;0;False;0;False;-1;None;744c1865ebf860541b3c9b3171c84a81;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;-1000.842,-460.3407;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;74;-814.4727,115.1059;Inherit;True;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;75;-815.002,341.2267;Inherit;True;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-1073.001,463.2267;Inherit;False;Constant;_Float0;Float 0;6;0;Create;True;0;0;0;False;0;False;0.95;0.35;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;80;-1745.859,-171.5204;Inherit;True;Property;_MaskTexture;MaskTexture;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;-947.7227,-342.9201;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;83;-696.6417,-441.8698;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;88;-311.3236,-451.1441;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;85;-284.0858,-262.1621;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;86;-88.93699,-260.8986;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;-48.61038,-140.8503;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;81;-825.3843,-65.08672;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;0.75;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;94;500.684,-282.1075;Float;False;False;-1;2;ASEMaterialInspector;0;4;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;ExtraPrePass;0;0;ExtraPrePass;6;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;2;False;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=ForwardBase;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;95;500.684,-282.1075;Float;False;True;-1;2;ASEMaterialInspector;0;4;Cortopia/_LowEnd/ase_creature_lowend_slice;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;ForwardBase;0;1;ForwardBase;18;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;2;False;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;False;2;Include;;False;;Native;False;0;0;;Include;../skinned_vertices_with_color.cginc;False;;Custom;False;0;0;;;0;0;Standard;40;Workflow,InvertActionOnDeselection;1;0;Surface;0;0;  Blend;0;0;  Refraction Model;0;0;  Dither Shadows;1;0;Two Sided;1;0;Deferred Pass;1;0;Transmission;0;0;  Transmission Shadow;0.5,False,;0;Translucency;0;0;  Translucency Strength;1,False,;0;  Normal Distortion;0.5,False,;0;  Scattering;2,False,;0;  Direct;0.9,False,;0;  Ambient;0.1,False,;0;  Shadow;0.5,False,;0;Cast Shadows;1;0;  Use Shadow Threshold;0;0;Receive Shadows;1;0;GPU Instancing;1;0;LOD CrossFade;1;0;Built-in Fog;1;0;Ambient Light;1;0;Meta Pass;1;0;Add Pass;1;0;Override Baked GI;0;0;Extra Pre Pass;0;0;Tessellation;0;0;  Phong;0;0;  Strength;0.5,False,;0;  Type;0;0;  Tess;16,False,;0;  Min;10,False,;0;  Max;25,False,;0;  Edge Length;16,False,;0;  Max Displacement;25,False,;0;Fwd Specular Highlights Toggle;0;0;Fwd Reflections Toggle;0;0;Disable Batching;0;0;Vertex Position,InvertActionOnDeselection;0;638524894639113699;0;6;False;True;True;True;True;True;False;;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;96;500.684,-282.1075;Float;False;False;-1;2;ASEMaterialInspector;0;4;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;ForwardAdd;0;2;ForwardAdd;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;2;False;0;False;True;4;1;False;;1;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;True;1;LightMode=ForwardAdd;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;97;500.684,-282.1075;Float;False;False;-1;2;ASEMaterialInspector;0;4;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;Deferred;0;3;Deferred;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Deferred;True;2;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;98;500.684,-282.1075;Float;False;False;-1;2;ASEMaterialInspector;0;4;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;Meta;0;4;Meta;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;99;500.684,-282.1075;Float;False;False;-1;2;ASEMaterialInspector;0;4;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;ShadowCaster;0;5;ShadowCaster;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;True;1;LightMode=ShadowCaster;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;102;535.1874,-690.4173;Inherit;False;SkinnedTangent;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;104;535.3165,-778.1092;Inherit;False;SkinnedNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;105;535.2404,-863.8588;Inherit;False;SkinnedPosition;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;-1926.39,268.8072;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;116;-2144.39,198.8072;Inherit;False;103;TexCoord;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;119;-2119.39,305.8072;Inherit;False;Constant;_Vector0;Vector 0;4;0;Create;True;0;0;0;False;0;False;8,8;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;103;538.9615,-607.4232;Inherit;False;TexCoord;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;112;206.4518,-81.05479;Inherit;False;105;SkinnedPosition;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;113;206.2997,-11.47883;Inherit;False;104;SkinnedNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;111;207.167,61.84778;Inherit;False;102;SkinnedTangent;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;115;-2039.209,-143.4811;Inherit;False;103;TexCoord;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;114;-1184.08,-665.6669;Inherit;False;103;TexCoord;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;92;-408.5489,64.98114;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;93;-254.4118,-42.99662;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;120;-419.0771,241.2761;Inherit;False;Constant;_NoMetallic1;No Metallic;6;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexIdVariableNode;124;-556.3584,349.9806;Inherit;False;0;1;INT;0
Node;AmplifyShaderEditor.CustomExpressionNode;123;-404.2344,351.1614;Inherit;False;return (_TexCoords[vertex_id].color & 0xFF) > 0 ? 1 : 0@;1;Create;1;True;vertex_id;INT;0;In;;Inherit;False;Color;True;False;0;;False;1;0;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;79;-1605.236,-341.0033;Inherit;False;ase_function_bloodcolor;-1;;3;439e2ac262e7b8a4db20b11e6f95045c;0;0;2;COLOR;0;COLOR;3
Node;AmplifyShaderEditor.FunctionNode;90;161.6746,-281.1722;Inherit;False;ase_function_DifSmooth;-1;;7;4551715450b1c93418e0161fef7c1ebf;0;4;10;FLOAT4;0,0,0,0;False;11;FLOAT;0;False;17;FLOAT4;0,0,0,0;False;13;FLOAT;0;False;4;FLOAT4;0;FLOAT4;14;FLOAT;15;FLOAT;16
Node;AmplifyShaderEditor.StaticSwitch;122;-160.3308,291.0655;Inherit;False;Property;_IsMetallic;IsMetallic;1;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;78;-1079.181,61.66542;Inherit;False;Constant;_BloodNoise;BloodNoise;4;0;Create;True;0;0;0;False;0;False;0.75;0.75;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;128;132.0059,-768.8361;Inherit;False;ase_function_slice_vertex;-1;;11;a50857cedb7c3cf46a5350d53761078b;0;0;4;FLOAT3;22;FLOAT3;21;FLOAT4;20;FLOAT2;0
WireConnection;69;0;80;1
WireConnection;69;1;71;1
WireConnection;70;0;80;1
WireConnection;70;1;69;0
WireConnection;71;1;117;0
WireConnection;72;1;114;0
WireConnection;73;0;79;0
WireConnection;73;1;80;1
WireConnection;74;0;78;0
WireConnection;74;1;70;0
WireConnection;75;0;77;0
WireConnection;75;1;70;0
WireConnection;80;1;115;0
WireConnection;82;0;79;3
WireConnection;82;1;80;4
WireConnection;83;0;73;0
WireConnection;83;1;82;0
WireConnection;88;0;72;0
WireConnection;88;1;83;0
WireConnection;88;2;74;0
WireConnection;85;0;72;4
WireConnection;85;1;81;0
WireConnection;85;2;75;0
WireConnection;86;0;85;0
WireConnection;91;0;122;0
WireConnection;91;1;93;0
WireConnection;81;0;80;4
WireConnection;95;0;90;0
WireConnection;95;2;90;14
WireConnection;95;4;90;15
WireConnection;95;5;90;16
WireConnection;95;15;112;0
WireConnection;95;16;113;0
WireConnection;95;17;111;0
WireConnection;102;0;128;20
WireConnection;104;0;128;21
WireConnection;105;0;128;22
WireConnection;117;0;116;0
WireConnection;117;1;119;0
WireConnection;103;0;128;0
WireConnection;92;0;74;0
WireConnection;93;0;92;0
WireConnection;123;0;124;0
WireConnection;90;10;88;0
WireConnection;90;11;86;0
WireConnection;90;13;91;0
WireConnection;122;1;120;0
WireConnection;122;0;123;0
ASEEND*/
//CHKSM=3FE558E61B56516995E13BF13EF071EB00C73264
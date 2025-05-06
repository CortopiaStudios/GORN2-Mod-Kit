// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Cortopia/ase_character_slice"
{
	Properties
	{
		_Albedo_Smoothness("Albedo_Smoothness", 2D) = "black" {}
		_Normal("Normal", 2D) = "bump" {}
		_MaskTexture("MaskTexture", 2D) = "black" {}
		_Flesh("Flesh", 2D) = "white" {}
		_Flesh_Normal("Flesh_Normal", 2D) = "bump" {}
		_BloodCutBruiseMask("BloodCutBruiseMask", 2D) = "white" {}
		_Telekinesis_Int("Telekinesis_Int", Int) = 0

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

			#define ASE_NEEDS_FRAG_WORLD_TANGENT
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_BITANGENT
			#define ASE_NEEDS_FRAG_WORLD_VIEW_DIR
			#include "skinned_vertices_with_color.cginc"

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
			uniform sampler2D _Flesh;
			uniform sampler2D _MaskTexture;
			uniform sampler2D _Albedo_Smoothness;
			uniform sampler2D _BloodCutBruiseMask;
			uniform sampler2D _Flesh_Normal;
			uniform sampler2D _Normal;
			uniform int _Telekinesis_Int;


			float3 MyCustomExpression2_g9( int vertex_id )
			{
				const int offset = vertex_id * _VertexStride;
				const float3 pos = asfloat(_SkinnedVertices.Load3(offset));
				return mul(_ObjectToWorld, float4(pos, 1.0f));
			}
			
			float3 MyCustomExpression2_g8( int vertex_id )
			{
				const int offset = vertex_id * _VertexStride + 12;
				const float3 norm = asfloat(_SkinnedVertices.Load3(offset));
				return normalize(mul(norm, (float3x3)_WorldToObject));
			}
			
			float4 MyCustomExpression2_g7( int vertex_id )
			{
				const int offset = vertex_id * _VertexStride + 24;
				const float4 tan = asfloat(_SkinnedVertices.Load4(offset));
				return normalize(mul(tan, _ObjectToWorld));
			}
			
			float2 Texcoord196( int vertex_id )
			{
				return float2(_TexCoords[vertex_id].texcoord0, _TexCoords[vertex_id].texcoord1);
			}
			

			v2f VertexFunction (appdata v  ) {
				UNITY_SETUP_INSTANCE_ID(v);
				v2f o;
				UNITY_INITIALIZE_OUTPUT(v2f,o);
				UNITY_TRANSFER_INSTANCE_ID(v,o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				int vertex_id2_g9 = (int)(float)v.ase_vertexID;
				float3 localMyCustomExpression2_g9 = MyCustomExpression2_g9( vertex_id2_g9 );
				float3 SkinnedPosition207 = localMyCustomExpression2_g9;
				
				int vertex_id2_g8 = (int)(float)v.ase_vertexID;
				float3 localMyCustomExpression2_g8 = MyCustomExpression2_g8( vertex_id2_g8 );
				float3 SkinnedNormal209 = localMyCustomExpression2_g8;
				
				int vertex_id2_g7 = (int)(float)v.ase_vertexID;
				float4 localMyCustomExpression2_g7 = MyCustomExpression2_g7( vertex_id2_g7 );
				float4 vertexToFrag203 = localMyCustomExpression2_g7;
				float4 SkinnedTangent210 = vertexToFrag203;
				
				int vertex_id196 = v.ase_vertexID;
				float2 localTexcoord196 = Texcoord196( vertex_id196 );
				float2 vertexToFrag199 = localTexcoord196;
				o.ase_texcoord9.xy = vertexToFrag199;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord9.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = SkinnedPosition207;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.vertex.w = 1;
				v.normal = SkinnedNormal209;
				v.tangent = SkinnedTangent210;

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

				float2 vertexToFrag199 = IN.ase_texcoord9.xy;
				float2 TexCoord200 = vertexToFrag199;
				float4 tex2DNode61 = tex2D( _MaskTexture, TexCoord200 );
				float Cut127 = tex2DNode61.g;
				float3 tanToWorld0 = float3( WorldTangent.x, WorldBiTangent.x, WorldNormal.x );
				float3 tanToWorld1 = float3( WorldTangent.y, WorldBiTangent.y, WorldNormal.y );
				float3 tanToWorld2 = float3( WorldTangent.z, WorldBiTangent.z, WorldNormal.z );
				float3 ase_tanViewDir =  tanToWorld0 * worldViewDir.x + tanToWorld1 * worldViewDir.y  + tanToWorld2 * worldViewDir.z;
				ase_tanViewDir = normalize(ase_tanViewDir);
				float2 paralaxOffset65 = ParallaxOffset( Cut127 , -0.2 , ase_tanViewDir );
				float2 temp_output_66_0 = ( ( TexCoord200 * 20.0 ) + paralaxOffset65 );
				float4 tex2DNode63 = tex2D( _Flesh, temp_output_66_0 );
				float4 Flesh_Diffuse179 = tex2DNode63;
				float4 tex2DNode1 = tex2D( _Albedo_Smoothness, TexCoord200 );
				float4 Diffuse79 = tex2DNode1;
				float4 color93 = IsGammaSpace() ? float4(0.7529412,0.2705882,0,0) : float4(0.5271152,0.05951123,0,0);
				float4 BruiseColor94 = color93;
				float Bruises126 = tex2DNode61.b;
				float BruiseBreakupMask115 = tex2D( _BloodCutBruiseMask, ( TexCoord200 * float2( 20,20 ) ) ).b;
				float BruiseLerp92 = saturate( ( Bruises126 * ( BruiseBreakupMask115 * 1.74 ) ) );
				float4 lerpResult114 = lerp( Diffuse79 , ( Diffuse79 * BruiseColor94 ) , BruiseLerp92);
				float4 color1_g2 = IsGammaSpace() ? float4(0.490566,0.06317896,0,0) : float4(0.2054128,0.005227456,0,0);
				float4 color2_g2 = IsGammaSpace() ? float4(0.4622642,0.07222877,0,0) : float4(0.1807607,0.006240204,0,0);
				float BloodWet125 = tex2DNode61.a;
				float BloodDry128 = tex2DNode61.r;
				float BloodEdgeMask71 = tex2D( _BloodCutBruiseMask, ( TexCoord200 * 10.0 ) ).r;
				float BloodLerp129 = saturate( step( 0.7 , ( BloodDry128 + ( BloodDry128 * BloodEdgeMask71 ) ) ) );
				float clampResult247 = clamp( BloodLerp129 , 0.0 , 0.97 );
				float4 lerpResult105 = lerp( lerpResult114 , ( color1_g2 + ( color2_g2 * BloodWet125 ) ) , clampResult247);
				float CutsBreakupMask240 = tex2D( _BloodCutBruiseMask, ( TexCoord200 * 30.0 ) ).r;
				float CutMaskLerp116 = step( ( Cut127 + ( Cut127 * CutsBreakupMask240 ) ) , 0.86 );
				float4 lerpResult103 = lerp( Flesh_Diffuse179 , lerpResult105 , CutMaskLerp116);
				
				float3 FleshNormal158 = UnpackNormal( tex2D( _Flesh_Normal, temp_output_66_0 ) );
				float3 lerpResult156 = lerp( FleshNormal158 , UnpackNormal( tex2D( _Normal, TexCoord200 ) ) , CutMaskLerp116);
				
				float dotResult3_g4 = dot( WorldNormal , worldViewDir );
				float4 color11_g4 = IsGammaSpace() ? float4(0.682353,0.6941177,1,0) : float4(0.4232678,0.4396573,1,0);
				
				float FleshSmoothness151 = tex2DNode63.a;
				float Smoothness132 = tex2DNode1.a;
				float lerpResult137 = lerp( Smoothness132 , ( BloodWet125 * 0.95 ) , ( BloodWet125 * BloodDry128 ));
				float lerpResult149 = lerp( FleshSmoothness151 , lerpResult137 , CutMaskLerp116);
				
				o.Albedo = lerpResult103.rgb;
				o.Normal = lerpResult156;
				o.Emission = ( ( saturate( ( ( ( 1.0 - dotResult3_g4 ) - 0.45 ) * 5.0 ) ) * color11_g4 ) * saturate( _Telekinesis_Int ) ).rgb;
				#if defined(_SPECULAR_SETUP)
					o.Specular = fixed3( 0, 0, 0 );
				#else
					o.Metallic = 0;
				#endif
				o.Smoothness = saturate( lerpResult149 );
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
			#pragma multi_compile_instancing
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

			#define ASE_NEEDS_VERT_TANGENT
			#define ASE_NEEDS_VERT_NORMAL
			#include "skinned_vertices_with_color.cginc"

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
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
				float4 ase_texcoord6 : TEXCOORD6;
				float4 ase_texcoord7 : TEXCOORD7;
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
			uniform sampler2D _Flesh;
			uniform sampler2D _MaskTexture;
			uniform sampler2D _Albedo_Smoothness;
			uniform sampler2D _BloodCutBruiseMask;
			uniform int _Telekinesis_Int;


			float3 MyCustomExpression2_g9( int vertex_id )
			{
				const int offset = vertex_id * _VertexStride;
				const float3 pos = asfloat(_SkinnedVertices.Load3(offset));
				return mul(_ObjectToWorld, float4(pos, 1.0f));
			}
			
			float3 MyCustomExpression2_g8( int vertex_id )
			{
				const int offset = vertex_id * _VertexStride + 12;
				const float3 norm = asfloat(_SkinnedVertices.Load3(offset));
				return normalize(mul(norm, (float3x3)_WorldToObject));
			}
			
			float4 MyCustomExpression2_g7( int vertex_id )
			{
				const int offset = vertex_id * _VertexStride + 24;
				const float4 tan = asfloat(_SkinnedVertices.Load4(offset));
				return normalize(mul(tan, _ObjectToWorld));
			}
			
			float2 Texcoord196( int vertex_id )
			{
				return float2(_TexCoords[vertex_id].texcoord0, _TexCoords[vertex_id].texcoord1);
			}
			

			v2f VertexFunction (appdata v  ) {
				UNITY_SETUP_INSTANCE_ID(v);
				v2f o;
				UNITY_INITIALIZE_OUTPUT(v2f,o);
				UNITY_TRANSFER_INSTANCE_ID(v,o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				int vertex_id2_g9 = (int)(float)v.ase_vertexID;
				float3 localMyCustomExpression2_g9 = MyCustomExpression2_g9( vertex_id2_g9 );
				float3 SkinnedPosition207 = localMyCustomExpression2_g9;
				
				int vertex_id2_g8 = (int)(float)v.ase_vertexID;
				float3 localMyCustomExpression2_g8 = MyCustomExpression2_g8( vertex_id2_g8 );
				float3 SkinnedNormal209 = localMyCustomExpression2_g8;
				
				int vertex_id2_g7 = (int)(float)v.ase_vertexID;
				float4 localMyCustomExpression2_g7 = MyCustomExpression2_g7( vertex_id2_g7 );
				float4 vertexToFrag203 = localMyCustomExpression2_g7;
				float4 SkinnedTangent210 = vertexToFrag203;
				
				int vertex_id196 = v.ase_vertexID;
				float2 localTexcoord196 = Texcoord196( vertex_id196 );
				float2 vertexToFrag199 = localTexcoord196;
				o.ase_texcoord3.xy = vertexToFrag199;
				float3 ase_worldTangent = UnityObjectToWorldDir(v.tangent);
				o.ase_texcoord4.xyz = ase_worldTangent;
				float3 ase_worldNormal = UnityObjectToWorldNormal(v.normal);
				o.ase_texcoord5.xyz = ase_worldNormal;
				float ase_vertexTangentSign = v.tangent.w * ( unity_WorldTransformParams.w >= 0.0 ? 1.0 : -1.0 );
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord6.xyz = ase_worldBitangent;
				float3 ase_worldPos = mul(unity_ObjectToWorld, float4( (v.vertex).xyz, 1 )).xyz;
				o.ase_texcoord7.xyz = ase_worldPos;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord3.zw = 0;
				o.ase_texcoord4.w = 0;
				o.ase_texcoord5.w = 0;
				o.ase_texcoord6.w = 0;
				o.ase_texcoord7.w = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = SkinnedPosition207;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.vertex.w = 1;
				v.normal = SkinnedNormal209;
				v.tangent = SkinnedTangent210;

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

				float2 vertexToFrag199 = IN.ase_texcoord3.xy;
				float2 TexCoord200 = vertexToFrag199;
				float4 tex2DNode61 = tex2D( _MaskTexture, TexCoord200 );
				float Cut127 = tex2DNode61.g;
				float3 ase_worldTangent = IN.ase_texcoord4.xyz;
				float3 ase_worldNormal = IN.ase_texcoord5.xyz;
				float3 ase_worldBitangent = IN.ase_texcoord6.xyz;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 ase_worldPos = IN.ase_texcoord7.xyz;
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(ase_worldPos);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_tanViewDir =  tanToWorld0 * ase_worldViewDir.x + tanToWorld1 * ase_worldViewDir.y  + tanToWorld2 * ase_worldViewDir.z;
				ase_tanViewDir = normalize(ase_tanViewDir);
				float2 paralaxOffset65 = ParallaxOffset( Cut127 , -0.2 , ase_tanViewDir );
				float2 temp_output_66_0 = ( ( TexCoord200 * 20.0 ) + paralaxOffset65 );
				float4 tex2DNode63 = tex2D( _Flesh, temp_output_66_0 );
				float4 Flesh_Diffuse179 = tex2DNode63;
				float4 tex2DNode1 = tex2D( _Albedo_Smoothness, TexCoord200 );
				float4 Diffuse79 = tex2DNode1;
				float4 color93 = IsGammaSpace() ? float4(0.7529412,0.2705882,0,0) : float4(0.5271152,0.05951123,0,0);
				float4 BruiseColor94 = color93;
				float Bruises126 = tex2DNode61.b;
				float BruiseBreakupMask115 = tex2D( _BloodCutBruiseMask, ( TexCoord200 * float2( 20,20 ) ) ).b;
				float BruiseLerp92 = saturate( ( Bruises126 * ( BruiseBreakupMask115 * 1.74 ) ) );
				float4 lerpResult114 = lerp( Diffuse79 , ( Diffuse79 * BruiseColor94 ) , BruiseLerp92);
				float4 color1_g2 = IsGammaSpace() ? float4(0.490566,0.06317896,0,0) : float4(0.2054128,0.005227456,0,0);
				float4 color2_g2 = IsGammaSpace() ? float4(0.4622642,0.07222877,0,0) : float4(0.1807607,0.006240204,0,0);
				float BloodWet125 = tex2DNode61.a;
				float BloodDry128 = tex2DNode61.r;
				float BloodEdgeMask71 = tex2D( _BloodCutBruiseMask, ( TexCoord200 * 10.0 ) ).r;
				float BloodLerp129 = saturate( step( 0.7 , ( BloodDry128 + ( BloodDry128 * BloodEdgeMask71 ) ) ) );
				float clampResult247 = clamp( BloodLerp129 , 0.0 , 0.97 );
				float4 lerpResult105 = lerp( lerpResult114 , ( color1_g2 + ( color2_g2 * BloodWet125 ) ) , clampResult247);
				float CutsBreakupMask240 = tex2D( _BloodCutBruiseMask, ( TexCoord200 * 30.0 ) ).r;
				float CutMaskLerp116 = step( ( Cut127 + ( Cut127 * CutsBreakupMask240 ) ) , 0.86 );
				float4 lerpResult103 = lerp( Flesh_Diffuse179 , lerpResult105 , CutMaskLerp116);
				
				float dotResult3_g4 = dot( ase_worldNormal , ase_worldViewDir );
				float4 color11_g4 = IsGammaSpace() ? float4(0.682353,0.6941177,1,0) : float4(0.4232678,0.4396573,1,0);
				
				o.Albedo = lerpResult103.rgb;
				o.Normal = fixed3( 0, 0, 1 );
				o.Emission = ( ( saturate( ( ( ( 1.0 - dotResult3_g4 ) - 0.45 ) * 5.0 ) ) * color11_g4 ) * saturate( _Telekinesis_Int ) ).rgb;
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

			#include "skinned_vertices_with_color.cginc"

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
			

			float3 MyCustomExpression2_g9( int vertex_id )
			{
				const int offset = vertex_id * _VertexStride;
				const float3 pos = asfloat(_SkinnedVertices.Load3(offset));
				return mul(_ObjectToWorld, float4(pos, 1.0f));
			}
			
			float3 MyCustomExpression2_g8( int vertex_id )
			{
				const int offset = vertex_id * _VertexStride + 12;
				const float3 norm = asfloat(_SkinnedVertices.Load3(offset));
				return normalize(mul(norm, (float3x3)_WorldToObject));
			}
			
			float4 MyCustomExpression2_g7( int vertex_id )
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

				int vertex_id2_g9 = (int)(float)v.ase_vertexID;
				float3 localMyCustomExpression2_g9 = MyCustomExpression2_g9( vertex_id2_g9 );
				float3 SkinnedPosition207 = localMyCustomExpression2_g9;
				
				int vertex_id2_g8 = (int)(float)v.ase_vertexID;
				float3 localMyCustomExpression2_g8 = MyCustomExpression2_g8( vertex_id2_g8 );
				float3 SkinnedNormal209 = localMyCustomExpression2_g8;
				
				int vertex_id2_g7 = (int)(float)v.ase_vertexID;
				float4 localMyCustomExpression2_g7 = MyCustomExpression2_g7( vertex_id2_g7 );
				float4 vertexToFrag203 = localMyCustomExpression2_g7;
				float4 SkinnedTangent210 = vertexToFrag203;
				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = SkinnedPosition207;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.vertex.w = 1;
				v.normal = SkinnedNormal209;
				v.tangent = SkinnedTangent210;

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
Node;AmplifyShaderEditor.CommentaryNode;182;-915.4608,-230.2693;Inherit;False;311;304;Bruises;1;114;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;181;-522.04,-229.674;Inherit;False;311;304;Blood;1;105;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;51;-159.9022,-229.3061;Inherit;False;531.663;304;Cut - Blood (edge) paints under cut, make sure cutmask is slightly smaller;3;104;103;180;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;52;-2610.728,470.8939;Inherit;False;1150.118;450.8744;BloodMask;8;129;124;85;84;83;82;81;80;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;53;-2612.452,-75.28753;Inherit;False;1152.388;533.1783;CutMask;7;117;116;70;69;68;67;246;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;54;-2608.669,945.0589;Inherit;False;1142.78;572.1578;BruiseMask;9;94;93;92;91;90;89;88;87;86;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;55;-2602.687,-444.701;Inherit;False;1140.722;352.1894;CutDarkenCenter (get this in parallax);8;121;120;119;118;97;96;95;62;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;-2354.167,1299.599;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;62;-1600.542,-403.9693;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;67;-2149.754,-32.30462;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-2385.92,70.22533;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;-2386.038,698.8028;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;83;-2150.068,617.1094;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;85;-1696.823,591.909;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;86;-2560.324,1218.122;Inherit;False;126;Bruises;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;-2087.917,1227.457;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;91;-1870.715,1226.756;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;95;-2418.986,-393.5442;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;119;-1875.384,-197.167;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;120;-2361.51,-202.2268;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;121;-2595.913,-396.3568;Inherit;False;127;Cut;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;97;-1907.877,-411.773;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;118;-2209.451,-408.3683;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-3307.136,-382.5891;Inherit;True;Property;_Albedo_Smoothness;Albedo_Smoothness;0;0;Create;True;0;0;0;False;0;False;-1;None;50dba9ba2dc14f94492be611c2367303;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;142;-548.3327,549.3743;Inherit;False;125;BloodWet;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;133;-371.3113,441.0553;Inherit;False;132;Smoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;137;-82.83823,526.283;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;149;142.6788,409.555;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;145;376.8752,410.5832;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;156;379.1229,111.7707;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;46;-290.1034,135.6746;Inherit;True;Property;_Normal;Normal;1;0;Create;True;0;0;0;False;0;False;-1;None;acf476204686eae4fa4d24969dea04df;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;96;-2159.469,-178.9585;Inherit;False;Property;_MeatDark;MeatDark;6;0;Create;True;0;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;61;-3310.953,-43.69022;Inherit;True;Property;_MaskTexture;MaskTexture;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;88;-2597.629,1299.67;Inherit;False;115;BruiseBreakupMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;159;42.21979,88.37179;Inherit;False;158;FleshNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;157;32.02334,235.2713;Inherit;False;116;CutMaskLerp;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;84;-2602.596,722.8349;Inherit;False;71;BloodEdgeMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;80;-2597.258,615.1358;Inherit;False;128;BloodDry;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;122;-1400.398,-427.9829;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;66;-3512.083,-570.78;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;158;-2979.566,-803.1887;Inherit;False;FleshNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;63;-3305.018,-596.8757;Inherit;True;Property;_Flesh;Flesh;3;0;Create;True;0;0;0;False;0;False;-1;None;b08a8a603eacafc40b6911d58012c0fe;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;59;-4111.857,-730.2605;Inherit;False;127;Cut;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;154;-3305.968,-800.8497;Inherit;True;Property;_Flesh_Normal;Flesh_Normal;4;0;Create;True;0;0;0;False;0;False;-1;None;b40b938aa922e60418384e628ed2d66e;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;105;-472.0398,-179.674;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;-1025.973,185.9006;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;136;-1299.469,116.0754;Inherit;False;ase_function_bloodcolor;-1;;2;439e2ac262e7b8a4db20b11e6f95045c;0;0;2;COLOR;0;COLOR;3
Node;AmplifyShaderEditor.GetLocalVarNode;101;-1274.664,240.3742;Inherit;False;125;BloodWet;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;106;-837.2311,115.6029;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;-1116.224,-130.812;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;111;-1340.605,-106.62;Inherit;False;94;BruiseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;113;-1146.243,-23.55687;Inherit;False;92;BruiseLerp;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;114;-865.4608,-180.2693;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;103;120.0765,-156.4761;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;1,1,1,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;104;-130.0189,-64.67846;Inherit;False;116;CutMaskLerp;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;180;-105.5664,-186.8231;Inherit;False;179;Flesh Diffuse;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;125;-2945.365,115.4692;Inherit;False;BloodWet;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;126;-2956.488,33.20702;Inherit;False;Bruises;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;127;-2950.994,-54.86419;Inherit;False;Cut;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;128;-2950.643,-144.5157;Inherit;False;BloodDry;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;132;-2951.162,-286.1932;Inherit;False;Smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;79;-2952.623,-382.5433;Inherit;False;Diffuse;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;151;-2969.167,-501.6401;Inherit;False;FleshSmoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;179;-2965.012,-597.207;Inherit;False;Flesh Diffuse;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;116;-1666.46,-31.55047;Inherit;False;CutMaskLerp;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;129;-1663.827,733.4263;Inherit;False;BloodLerp;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;94;-1701.647,1009.546;Inherit;False;BruiseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;92;-1706.785,1222.44;Inherit;False;BruiseLerp;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;123;-3307.324,223.9062;Inherit;True;Property;_BloodCutBruiseMask;BloodCutBruiseMask;5;0;Create;True;0;0;0;False;0;False;-1;None;5657507ec4511ef43a15e0e101373dad;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;183;698.3609,-154.9338;Float;False;False;-1;2;ASEMaterialInspector;0;4;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;ExtraPrePass;0;0;ExtraPrePass;6;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;2;False;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=ForwardBase;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;185;698.3609,-154.9338;Float;False;False;-1;2;ASEMaterialInspector;0;4;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;ForwardAdd;0;2;ForwardAdd;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;2;False;0;False;True;4;1;False;;1;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;True;1;LightMode=ForwardAdd;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;186;698.3609,-154.9338;Float;False;False;-1;2;ASEMaterialInspector;0;4;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;Deferred;0;3;Deferred;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Deferred;True;2;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;187;698.3609,-154.9338;Float;False;False;-1;2;ASEMaterialInspector;0;4;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;Meta;0;4;Meta;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;188;698.3609,-154.9338;Float;False;False;-1;2;ASEMaterialInspector;0;4;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;ShadowCaster;0;5;ShadowCaster;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;True;1;LightMode=ShadowCaster;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.GetLocalVarNode;112;-1338.167,-225.2878;Inherit;False;79;Diffuse;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;214;-3521.602,-358.0332;Inherit;False;200;TexCoord;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;225;-3672.012,-615.179;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;226;-3829.469,-596.9232;Inherit;False;Constant;_Float0;Float 0;13;0;Create;True;0;0;0;False;0;False;20;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;227;-3862.557,-680.2155;Inherit;False;200;TexCoord;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;228;-3512.545,238.4701;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;229;-3670.002,256.7259;Inherit;False;Constant;_Float1;Float 0;13;0;Create;True;0;0;0;False;0;False;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;230;-3703.09,173.4337;Inherit;False;200;TexCoord;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;237;-3519.273,-23.22962;Inherit;False;200;TexCoord;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;238;-483.2739,161.5462;Inherit;False;200;TexCoord;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ParallaxOffsetHlpNode;65;-3842.783,-451.4758;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;77;-4280.044,-541.501;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.VertexIdVariableNode;202;394.8849,-467.112;Inherit;False;0;1;INT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;210;1269.043,-424.8292;Inherit;False;SkinnedTangent;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;200;1272.817,-341.8353;Inherit;False;TexCoord;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;209;1269.172,-512.5211;Inherit;False;SkinnedNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;207;1269.096,-598.2706;Inherit;False;SkinnedPosition;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StepOpNode;82;-1909.458,508.0245;Inherit;True;2;0;FLOAT;0.91;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;239;-1918.377,717.804;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.7;False;2;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;93;-2029.102,1009.901;Inherit;False;Constant;_BruiseColor;BruiseColor;6;0;Create;True;0;0;0;False;0;False;0.7529412,0.2705882,0,0;0.368627,0.2078426,0.6039216,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;124;-2135.719,531.6041;Inherit;False;Constant;_BloodNoise;BloodNoise;7;0;Create;True;0;0;0;False;0;False;0.7;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;69;-2602.677,-33.09051;Inherit;False;127;Cut;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;71;-2956.396,247.339;Inherit;False;BloodEdgeMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-2550.293,1372.768;Inherit;False;Constant;_BruiseStrenght;BruiseStrenght;7;0;Create;True;0;0;0;False;0;False;1.74;1.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;115;-2974.093,483.3672;Inherit;False;BruiseBreakupMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;75;-3304.798,411.157;Inherit;True;Property;_TextureSample1;Texture Sample 1;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;123;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;234;-3544.557,410.273;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;236;-3744.102,375.2365;Inherit;False;200;TexCoord;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;58;-3777.121,458.4691;Inherit;False;Constant;_BruiseTiling;BruiseTiling;11;0;Create;True;0;0;0;False;0;False;20,20;20,20;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;241;-3303.718,625.3949;Inherit;True;Property;_TextureSample2;Texture Sample 1;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;123;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;242;-3543.476,624.5109;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;243;-3743.021,589.4744;Inherit;False;200;TexCoord;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;245;-3736.955,700.4384;Inherit;False;Constant;_Float2;Float 2;7;0;Create;True;0;0;0;False;0;False;30;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;70;-2603.767,115.6175;Inherit;False;240;CutsBreakupMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;240;-2969.112,654.7054;Inherit;False;CutsBreakupMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;117;-1880.985,-30.99102;Inherit;True;2;0;FLOAT;0.8;False;1;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;246;-2114.225,203.1154;Inherit;False;Constant;_CutStepMin;CutStepMin;6;0;Create;True;0;0;0;False;0;False;0.86;0.87;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;109;-1087.892,355.383;Inherit;False;79;Diffuse;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;-776.8218,213.7778;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;99;-807.6006,353.4849;Inherit;False;129;BloodLerp;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;247;-624.2246,84.11542;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.97;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;211;554.7532,497.9826;Inherit;False;207;SkinnedPosition;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;213;555.4684,640.8851;Inherit;False;210;SkinnedTangent;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;212;554.6011,567.5585;Inherit;False;209;SkinnedNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;150;-151.0663,372.4722;Inherit;False;151;FleshSmoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;152;-123.2791,720.0629;Inherit;False;116;CutMaskLerp;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;248;-322.2246,660.1154;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.75;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;138;-564.7676,697.7169;Inherit;False;128;BloodDry;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;251;628.4802,-85.43468;Inherit;False;ase_function_telekinesis;7;;4;2b3f0b540b332bd4fbb2418f6d292683;0;0;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;184;1082.238,-154.9338;Float;False;True;-1;2;ASEMaterialInspector;0;4;Cortopia/ase_character_slice;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;ForwardBase;0;1;ForwardBase;18;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;2;False;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;False;2;Include;;False;;Native;False;0;0;;Include;skinned_vertices_with_color.cginc;False;;Custom;False;0;0;;;0;0;Standard;40;Workflow,InvertActionOnDeselection;1;0;Surface;0;0;  Blend;0;0;  Refraction Model;0;0;  Dither Shadows;1;0;Two Sided;1;0;Deferred Pass;0;638524981178321677;Transmission;0;0;  Transmission Shadow;0.5,False,;0;Translucency;0;0;  Translucency Strength;1,False,;0;  Normal Distortion;0.5,False,;0;  Scattering;2,False,;0;  Direct;0.9,False,;0;  Ambient;0.1,False,;0;  Shadow;0.5,False,;0;Cast Shadows;1;0;  Use Shadow Threshold;0;0;Receive Shadows;1;0;GPU Instancing;1;0;LOD CrossFade;0;638524981231641128;Built-in Fog;0;638524981240942134;Ambient Light;1;0;Meta Pass;1;0;Add Pass;0;638524981268541485;Override Baked GI;0;0;Extra Pre Pass;0;0;Tessellation;0;0;  Phong;0;0;  Strength;0.5,False,;0;  Type;0;0;  Tess;16,False,;0;  Min;10,False,;0;  Max;25,False,;0;  Edge Length;16,False,;0;  Max Displacement;25,False,;0;Fwd Specular Highlights Toggle;0;0;Fwd Reflections Toggle;0;0;Disable Batching;0;0;Vertex Position,InvertActionOnDeselection;0;638386822356192945;0;6;False;True;False;False;True;True;False;;False;0
Node;AmplifyShaderEditor.VertexToFragmentNode;199;826.1597,-348.2208;Inherit;False;False;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CustomExpressionNode;196;647.2678,-349.1506;Inherit;False;return float2(_TexCoords[vertex_id].texcoord0, _TexCoords[vertex_id].texcoord1)@;2;Create;1;True;vertex_id;INT;0;In;;Inherit;False;Texcoord;True;False;0;;False;1;0;INT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;257;607.3152,-447.1847;Inherit;False;ase_function_slice_vertex_tangent;-1;;7;73b1ffb3d895a0a4888d8af76591fd83;0;1;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;256;603.3152,-530.1847;Inherit;False;ase_function_slice_vertex_normal;-1;;8;6dba14a7d67abd648ac013c25cc006ab;0;1;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.VertexToFragmentNode;203;942.4116,-442.6877;Inherit;False;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;255;602.3497,-615.2268;Inherit;False;ase_function_slice_vertex_position;-1;;9;3b65cf277995d1a49a7c273f0596ca4b;0;1;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;144;-330.8247,547.6254;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.95;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-4257.007,-656.9745;Inherit;False;Constant;_ParallaxHeight;ParallaxHeight;9;0;Create;True;0;0;0;False;0;False;-0.2;-0.05;0;0;0;1;FLOAT;0
WireConnection;90;0;88;0
WireConnection;90;1;87;0
WireConnection;62;0;97;0
WireConnection;67;0;69;0
WireConnection;67;1;68;0
WireConnection;68;0;69;0
WireConnection;68;1;70;0
WireConnection;81;0;80;0
WireConnection;81;1;84;0
WireConnection;83;0;80;0
WireConnection;83;1;81;0
WireConnection;85;0;82;0
WireConnection;89;0;86;0
WireConnection;89;1;90;0
WireConnection;91;0;89;0
WireConnection;95;0;121;0
WireConnection;119;0;118;0
WireConnection;119;1;96;0
WireConnection;97;0;118;0
WireConnection;97;1;96;0
WireConnection;118;0;95;0
WireConnection;1;1;214;0
WireConnection;137;0;133;0
WireConnection;137;1;144;0
WireConnection;137;2;248;0
WireConnection;149;0;150;0
WireConnection;149;1;137;0
WireConnection;149;2;152;0
WireConnection;145;0;149;0
WireConnection;156;0;159;0
WireConnection;156;1;46;0
WireConnection;156;2;157;0
WireConnection;46;1;238;0
WireConnection;61;1;237;0
WireConnection;122;1;62;0
WireConnection;66;0;225;0
WireConnection;66;1;65;0
WireConnection;158;0;154;0
WireConnection;63;1;66;0
WireConnection;154;1;66;0
WireConnection;105;0;114;0
WireConnection;105;1;106;0
WireConnection;105;2;247;0
WireConnection;100;0;136;3
WireConnection;100;1;101;0
WireConnection;106;0;136;0
WireConnection;106;1;100;0
WireConnection;110;0;112;0
WireConnection;110;1;111;0
WireConnection;114;0;112;0
WireConnection;114;1;110;0
WireConnection;114;2;113;0
WireConnection;103;0;180;0
WireConnection;103;1;105;0
WireConnection;103;2;104;0
WireConnection;125;0;61;4
WireConnection;126;0;61;3
WireConnection;127;0;61;2
WireConnection;128;0;61;1
WireConnection;132;0;1;4
WireConnection;79;0;1;0
WireConnection;151;0;63;4
WireConnection;179;0;63;0
WireConnection;116;0;117;0
WireConnection;129;0;85;0
WireConnection;94;0;93;0
WireConnection;92;0;91;0
WireConnection;123;1;228;0
WireConnection;225;0;227;0
WireConnection;225;1;226;0
WireConnection;228;0;230;0
WireConnection;228;1;229;0
WireConnection;65;0;59;0
WireConnection;65;1;60;0
WireConnection;65;2;77;0
WireConnection;210;0;203;0
WireConnection;200;0;199;0
WireConnection;209;0;256;0
WireConnection;207;0;255;0
WireConnection;82;0;124;0
WireConnection;82;1;83;0
WireConnection;239;0;124;0
WireConnection;71;0;123;1
WireConnection;115;0;75;3
WireConnection;75;1;234;0
WireConnection;234;0;236;0
WireConnection;234;1;58;0
WireConnection;241;1;242;0
WireConnection;242;0;243;0
WireConnection;242;1;245;0
WireConnection;240;0;241;1
WireConnection;117;0;67;0
WireConnection;117;1;246;0
WireConnection;102;1;109;0
WireConnection;247;0;99;0
WireConnection;248;0;142;0
WireConnection;248;1;138;0
WireConnection;184;0;103;0
WireConnection;184;1;156;0
WireConnection;184;2;251;0
WireConnection;184;5;145;0
WireConnection;184;15;211;0
WireConnection;184;16;212;0
WireConnection;184;17;213;0
WireConnection;199;0;196;0
WireConnection;196;0;202;0
WireConnection;257;3;202;0
WireConnection;256;3;202;0
WireConnection;203;0;257;0
WireConnection;255;3;202;0
WireConnection;144;0;142;0
ASEEND*/
//CHKSM=CA137DC8DDFE11E64A0520214C474FC1F176BC73
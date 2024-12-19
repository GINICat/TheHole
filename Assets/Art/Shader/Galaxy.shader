Shader "Neko Legends/Galaxy Shader"
{
    Properties
    {
        [NoScaleOffset] MainTexture("MainTexture", 2D) = "white" {}
        [NoScaleOffset]_Edge_Emission("Edge Emission", 2D) = "black" {}
        Metallic("Metallic", Range(0, 1)) = 0
        Smoothness("Smoothness", Range(0, 1)) = 0
        [HDR]_Color("Color", Color) = (1, 1, 1, 0)
        [NoScaleOffset]_FirstLayer("FirstLayer", 2D) = "black" {}
        [NoScaleOffset]_FirstLayerMask("FirstLayerMask", 2D) = "white" {}
        _FirstLayer_Speed("FirstLayer Speed", Range(-10, 10)) = 0
        _FirstLayer_Still_Opacity("FirstLayer Still Opacity", Range(0, 1)) = 0.33
        _Layers_Opacity("Layers Opacity", Range(0, 1)) = 0.4
        _Tile_X("Tile X", Range(0, 10)) = 3
        _Tile_Y("Tile Y", Range(0, 10)) = 3
        [NoScaleOffset]_SecondLayer("SecondLayer", 2D) = "black" {}
        [NoScaleOffset]_SecondLayerMask("SecondLayerMask", 2D) = "white" {}
        _SecondLayer_Speed("SecondLayer Speed", Range(-10, 10)) = 0
        _Tile_X_2("Tile X (2)", Range(0, 10)) = 2
        _Tile_Y_2("Tile Y (2)", Range(0, 10)) = 2
        [NoScaleOffset]_FlareLayer("FlareLayer", 2D) = "white" {}
        [NoScaleOffset]_FlareLayerMask("FlareLayerMask", 2D) = "white" {}
        _Flare_Speed("Flare Speed", Range(-10, 10)) = 0
        _Flare_Noise("Flare Noise", Range(-1, 1)) = 0.1
        _Tile_X_Flare("Tile X (Flare)", Range(0, 10)) = 1
        _Tile_Y_Flare("Tile Y (Flare)", Range(0, 10)) = 1
        [NoScaleOffset]NormalMap("NormalMap", 2D) = "black" {}
        _Normal_Strength("Normal Strength", Float) = 1
        [HideInInspector]_QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector]_QueueControl("_QueueControl", Float) = -1
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
        SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            "RenderType" = "Opaque"
            "UniversalMaterialType" = "Lit"
            "Queue" = "AlphaTest"
            "DisableBatching" = "False"
            "ShaderGraphShader" = "true"
            "ShaderGraphTargetId" = "UniversalLitSubTarget"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
            }

        // Render State
        Cull Off
        Blend One Zero
        ZTest LEqual
        ZWrite On
        AlphaToMask On

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag

        // Keywords
        #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
        #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _SHADOWS_SOFT
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _LIGHT_LAYERS
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma multi_compile_fragment _ _LIGHT_COOKIES
        #pragma multi_compile _ _FORWARD_PLUS
        // GraphKeywords: <None>

        // Defines

        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_FORWARD
        #define _FOG_FRAGMENT 1
        #define _ALPHATEST_ON 1
        #define _RECEIVE_SHADOWS_OFF 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */


        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 TangentSpaceNormal;
             float3 WorldSpaceTangent;
             float3 WorldSpaceBiTangent;
             float3 WorldSpaceViewDirection;
             float3 TangentSpaceViewDirection;
             float3 WorldSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV : INTERP0;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV : INTERP1;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh : INTERP2;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord : INTERP3;
            #endif
             float4 tangentWS : INTERP4;
             float4 texCoord0 : INTERP5;
             float4 fogFactorAndVertexLight : INTERP6;
             float3 positionWS : INTERP7;
             float3 normalWS : INTERP8;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };

        PackedVaryings PackVaryings(Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }

        Varyings UnpackVaryings(PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }


        // --------------------------------------------------
        // Graph

        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 MainTexture_TexelSize;
        float4 NormalMap_TexelSize;
        float _Normal_Strength;
        float _SecondLayer_Speed;
        float _Tile_X_Flare;
        float _Tile_Y_Flare;
        float _Layers_Opacity;
        float _Tile_X_2;
        float _Tile_Y_2;
        float _Tile_Y;
        float Metallic;
        float Smoothness;
        float _Flare_Speed;
        float _FirstLayer_Speed;
        float4 _Color;
        float4 _Edge_Emission_TexelSize;
        float4 _FirstLayer_TexelSize;
        float4 _FirstLayerMask_TexelSize;
        float4 _FlareLayer_TexelSize;
        float4 _FlareLayerMask_TexelSize;
        float4 _SecondLayer_TexelSize;
        float4 _SecondLayerMask_TexelSize;
        float _Flare_Noise;
        float _FirstLayer_Still_Opacity;
        float _Tile_X;
        CBUFFER_END


            // Object and Global properties
            SAMPLER(SamplerState_Linear_Repeat);
            TEXTURE2D(MainTexture);
            SAMPLER(samplerMainTexture);
            TEXTURE2D(NormalMap);
            SAMPLER(samplerNormalMap);
            TEXTURE2D(_Edge_Emission);
            SAMPLER(sampler_Edge_Emission);
            TEXTURE2D(_FirstLayer);
            SAMPLER(sampler_FirstLayer);
            TEXTURE2D(_FirstLayerMask);
            SAMPLER(sampler_FirstLayerMask);
            TEXTURE2D(_FlareLayer);
            SAMPLER(sampler_FlareLayer);
            TEXTURE2D(_FlareLayerMask);
            SAMPLER(sampler_FlareLayerMask);
            TEXTURE2D(_SecondLayer);
            SAMPLER(sampler_SecondLayer);
            TEXTURE2D(_SecondLayerMask);
            SAMPLER(sampler_SecondLayerMask);

            // Graph Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"

            // -- Property used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif

            // -- Properties used by SceneSelectionPass
            #ifdef SCENESELECTIONPASS
            int _ObjectId;
            int _PassValue;
            #endif

            // Graph Functions

            void Unity_Multiply_float_float(float A, float B, out float Out)
            {
                Out = A * B;
            }

            void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
            {
                Out = UV * Tiling + Offset;
            }

            void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
            {
                Out = A * B;
            }

            void Unity_Blend_Dodge_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
            {
                Out = Base / (1.0 - clamp(Blend, 0.000001, 0.999999));
                Out = lerp(Base, Out, Opacity);
            }

            void Unity_Add_float4(float4 A, float4 B, out float4 Out)
            {
                Out = A + B;
            }

            float2 Unity_GradientNoise_LegacyMod_Dir_float(float2 p)
            {
                float x; Hash_LegacyMod_2_1_float(p, x);
                return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
            }

            void Unity_GradientNoise_LegacyMod_float(float2 UV, float3 Scale, out float Out)
            {
                float2 p = UV * Scale.xy;
                float2 ip = floor(p);
                float2 fp = frac(p);
                float d00 = dot(Unity_GradientNoise_LegacyMod_Dir_float(ip), fp);
                float d01 = dot(Unity_GradientNoise_LegacyMod_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                float d10 = dot(Unity_GradientNoise_LegacyMod_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                float d11 = dot(Unity_GradientNoise_LegacyMod_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
            }

            void Unity_NormalFromHeight_Tangent_float(float In, float Strength, float3 Position, float3x3 TangentMatrix, out float3 Out)
            {

                        #if defined(SHADER_STAGE_RAY_TRACING) && defined(RAYTRACING_SHADER_GRAPH_DEFAULT)
                        #error 'Normal From Height' node is not supported in ray tracing, please provide an alternate implementation, relying for instance on the 'Raytracing Quality' keyword
                        #endif
                float3 worldDerivativeX = ddx(Position);
                float3 worldDerivativeY = ddy(Position);

                float3 crossX = cross(TangentMatrix[2].xyz, worldDerivativeX);
                float3 crossY = cross(worldDerivativeY, TangentMatrix[2].xyz);
                float d = dot(worldDerivativeX, crossY);
                float sgn = d < 0.0 ? (-1.0f) : 1.0f;
                float surface = sgn / max(0.000000000000001192093f, abs(d));

                float dHdx = ddx(In);
                float dHdy = ddy(In);
                float3 surfGrad = surface * (dHdx * crossY + dHdy * crossX);
                Out = SafeNormalize(TangentMatrix[2].xyz - (Strength * surfGrad));
                Out = TransformWorldToTangent(Out, TangentMatrix);
            }

            void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A * B;
            }

            void Unity_Add_float2(float2 A, float2 B, out float2 Out)
            {
                Out = A + B;
            }

            void Unity_Blend_Screen_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
            {
                Out = 1.0 - (1.0 - Blend) * (1.0 - Base);
                Out = lerp(Base, Out, Opacity);
            }

            void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
            {
                Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
            }

            void Unity_Remap_float4(float4 In, float2 InMinMax, float2 OutMinMax, out float4 Out)
            {
                Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }

            // Custom interpolators pre vertex
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

            // Graph Vertex
            struct VertexDescription
            {
                float3 Position;
                float3 Normal;
                float3 Tangent;
            };

            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
            {
                VertexDescription description = (VertexDescription)0;
                description.Position = IN.ObjectSpacePosition;
                description.Normal = IN.ObjectSpaceNormal;
                description.Tangent = IN.ObjectSpaceTangent;
                return description;
            }

            // Custom interpolators, pre surface
            #ifdef FEATURES_GRAPH_VERTEX
            Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
            {
            return output;
            }
            #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
            #endif

            // Graph Pixel
            struct SurfaceDescription
            {
                float3 BaseColor;
                float3 NormalTS;
                float3 Emission;
                float Metallic;
                float Smoothness;
                float Occlusion;
                float Alpha;
                float AlphaClipThreshold;
            };

            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                UnityTexture2D _Property_25d58f61f8a745f69d9bc5b84ec4ca18_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(MainTexture);
                float4 _SampleTexture2D_dae5062bfb6345989ac4c7936bcb0325_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_25d58f61f8a745f69d9bc5b84ec4ca18_Out_0_Texture2D.tex, _Property_25d58f61f8a745f69d9bc5b84ec4ca18_Out_0_Texture2D.samplerstate, _Property_25d58f61f8a745f69d9bc5b84ec4ca18_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy));
                float _SampleTexture2D_dae5062bfb6345989ac4c7936bcb0325_R_4_Float = _SampleTexture2D_dae5062bfb6345989ac4c7936bcb0325_RGBA_0_Vector4.r;
                float _SampleTexture2D_dae5062bfb6345989ac4c7936bcb0325_G_5_Float = _SampleTexture2D_dae5062bfb6345989ac4c7936bcb0325_RGBA_0_Vector4.g;
                float _SampleTexture2D_dae5062bfb6345989ac4c7936bcb0325_B_6_Float = _SampleTexture2D_dae5062bfb6345989ac4c7936bcb0325_RGBA_0_Vector4.b;
                float _SampleTexture2D_dae5062bfb6345989ac4c7936bcb0325_A_7_Float = _SampleTexture2D_dae5062bfb6345989ac4c7936bcb0325_RGBA_0_Vector4.a;
                UnityTexture2D _Property_d3f4357a037b4294a4561e4800559a98_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_FirstLayer);
                float _Property_28841e4c56c449d699ce8655774bfb45_Out_0_Float = _Tile_X;
                float _Property_93952c7a35224f899e2b661de6d28d11_Out_0_Float = _Tile_Y;
                float2 _Vector2_0d768a99157947b690b4011919c2e0fd_Out_0_Vector2 = float2(_Property_28841e4c56c449d699ce8655774bfb45_Out_0_Float, _Property_93952c7a35224f899e2b661de6d28d11_Out_0_Float);
                float _Property_f8ada8ccabc84c0fba96d3bdfcfa3418_Out_0_Float = _FirstLayer_Speed;
                float _Multiply_b6f87bb7270344abbfb4b28c5ae45762_Out_2_Float;
                Unity_Multiply_float_float(IN.TimeParameters.x, _Property_f8ada8ccabc84c0fba96d3bdfcfa3418_Out_0_Float, _Multiply_b6f87bb7270344abbfb4b28c5ae45762_Out_2_Float);
                float2 _Vector2_ba806402a04e48e9b8ff180bc6f53dd8_Out_0_Vector2 = float2(1, _Multiply_b6f87bb7270344abbfb4b28c5ae45762_Out_2_Float);
                float2 _TilingAndOffset_8db4474d0ad0448796dee47ee2c0261f_Out_3_Vector2;
                Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_0d768a99157947b690b4011919c2e0fd_Out_0_Vector2, _Vector2_ba806402a04e48e9b8ff180bc6f53dd8_Out_0_Vector2, _TilingAndOffset_8db4474d0ad0448796dee47ee2c0261f_Out_3_Vector2);
                float4 _SampleTexture2D_d6ad14b7f7f54d7fb3ea98bfa5d465cd_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_d3f4357a037b4294a4561e4800559a98_Out_0_Texture2D.tex, _Property_d3f4357a037b4294a4561e4800559a98_Out_0_Texture2D.samplerstate, _Property_d3f4357a037b4294a4561e4800559a98_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_8db4474d0ad0448796dee47ee2c0261f_Out_3_Vector2));
                float _SampleTexture2D_d6ad14b7f7f54d7fb3ea98bfa5d465cd_R_4_Float = _SampleTexture2D_d6ad14b7f7f54d7fb3ea98bfa5d465cd_RGBA_0_Vector4.r;
                float _SampleTexture2D_d6ad14b7f7f54d7fb3ea98bfa5d465cd_G_5_Float = _SampleTexture2D_d6ad14b7f7f54d7fb3ea98bfa5d465cd_RGBA_0_Vector4.g;
                float _SampleTexture2D_d6ad14b7f7f54d7fb3ea98bfa5d465cd_B_6_Float = _SampleTexture2D_d6ad14b7f7f54d7fb3ea98bfa5d465cd_RGBA_0_Vector4.b;
                float _SampleTexture2D_d6ad14b7f7f54d7fb3ea98bfa5d465cd_A_7_Float = _SampleTexture2D_d6ad14b7f7f54d7fb3ea98bfa5d465cd_RGBA_0_Vector4.a;
                UnityTexture2D _Property_c842ca1806df423fa653b7d9754ca8ca_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_FirstLayerMask);
                float4 _SampleTexture2D_27e0a67c861e46c2b3b2a6e513e4f4a3_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_c842ca1806df423fa653b7d9754ca8ca_Out_0_Texture2D.tex, _Property_c842ca1806df423fa653b7d9754ca8ca_Out_0_Texture2D.samplerstate, _Property_c842ca1806df423fa653b7d9754ca8ca_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy));
                float _SampleTexture2D_27e0a67c861e46c2b3b2a6e513e4f4a3_R_4_Float = _SampleTexture2D_27e0a67c861e46c2b3b2a6e513e4f4a3_RGBA_0_Vector4.r;
                float _SampleTexture2D_27e0a67c861e46c2b3b2a6e513e4f4a3_G_5_Float = _SampleTexture2D_27e0a67c861e46c2b3b2a6e513e4f4a3_RGBA_0_Vector4.g;
                float _SampleTexture2D_27e0a67c861e46c2b3b2a6e513e4f4a3_B_6_Float = _SampleTexture2D_27e0a67c861e46c2b3b2a6e513e4f4a3_RGBA_0_Vector4.b;
                float _SampleTexture2D_27e0a67c861e46c2b3b2a6e513e4f4a3_A_7_Float = _SampleTexture2D_27e0a67c861e46c2b3b2a6e513e4f4a3_RGBA_0_Vector4.a;
                float4 _Multiply_086d929899474eef8f9492b3df748da7_Out_2_Vector4;
                Unity_Multiply_float4_float4(_SampleTexture2D_d6ad14b7f7f54d7fb3ea98bfa5d465cd_RGBA_0_Vector4, _SampleTexture2D_27e0a67c861e46c2b3b2a6e513e4f4a3_RGBA_0_Vector4, _Multiply_086d929899474eef8f9492b3df748da7_Out_2_Vector4);
                float4 _Blend_22332064b1dd476eb955d1e6f0d31893_Out_2_Vector4;
                Unity_Blend_Dodge_float4(_SampleTexture2D_dae5062bfb6345989ac4c7936bcb0325_RGBA_0_Vector4, _Multiply_086d929899474eef8f9492b3df748da7_Out_2_Vector4, _Blend_22332064b1dd476eb955d1e6f0d31893_Out_2_Vector4, 1);
                UnityTexture2D _Property_aa17d6cddc844bbd8fffe2f3526f1d75_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_SecondLayer);
                float _Property_5443b670d62042b0bf29b6649506a396_Out_0_Float = _Tile_X_2;
                float _Property_e83f2ffe1d854d7cb7ce9639bef36c35_Out_0_Float = _Tile_Y_2;
                float2 _Vector2_112aab1e2c1a4c60ac52f6ab932daaae_Out_0_Vector2 = float2(_Property_5443b670d62042b0bf29b6649506a396_Out_0_Float, _Property_e83f2ffe1d854d7cb7ce9639bef36c35_Out_0_Float);
                float _Property_a122b213cc6049089080486d0e72dd92_Out_0_Float = _SecondLayer_Speed;
                float _Multiply_74242c5ba0db44a2af24f02259a54654_Out_2_Float;
                Unity_Multiply_float_float(IN.TimeParameters.x, _Property_a122b213cc6049089080486d0e72dd92_Out_0_Float, _Multiply_74242c5ba0db44a2af24f02259a54654_Out_2_Float);
                float2 _Vector2_23a4ed409daa44ebb33e022576272145_Out_0_Vector2 = float2(1, _Multiply_74242c5ba0db44a2af24f02259a54654_Out_2_Float);
                float2 _TilingAndOffset_259fb3e5741d40fbb9d10ab049b94707_Out_3_Vector2;
                Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_112aab1e2c1a4c60ac52f6ab932daaae_Out_0_Vector2, _Vector2_23a4ed409daa44ebb33e022576272145_Out_0_Vector2, _TilingAndOffset_259fb3e5741d40fbb9d10ab049b94707_Out_3_Vector2);
                float4 _SampleTexture2D_836113538fba497181d2063bdfe5dc20_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_aa17d6cddc844bbd8fffe2f3526f1d75_Out_0_Texture2D.tex, _Property_aa17d6cddc844bbd8fffe2f3526f1d75_Out_0_Texture2D.samplerstate, _Property_aa17d6cddc844bbd8fffe2f3526f1d75_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_259fb3e5741d40fbb9d10ab049b94707_Out_3_Vector2));
                float _SampleTexture2D_836113538fba497181d2063bdfe5dc20_R_4_Float = _SampleTexture2D_836113538fba497181d2063bdfe5dc20_RGBA_0_Vector4.r;
                float _SampleTexture2D_836113538fba497181d2063bdfe5dc20_G_5_Float = _SampleTexture2D_836113538fba497181d2063bdfe5dc20_RGBA_0_Vector4.g;
                float _SampleTexture2D_836113538fba497181d2063bdfe5dc20_B_6_Float = _SampleTexture2D_836113538fba497181d2063bdfe5dc20_RGBA_0_Vector4.b;
                float _SampleTexture2D_836113538fba497181d2063bdfe5dc20_A_7_Float = _SampleTexture2D_836113538fba497181d2063bdfe5dc20_RGBA_0_Vector4.a;
                UnityTexture2D _Property_d7c528359ec04b358fe52533578ee6b9_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_SecondLayerMask);
                float4 _SampleTexture2D_d6de786ff7b7453d9af1e36379f1e71c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_d7c528359ec04b358fe52533578ee6b9_Out_0_Texture2D.tex, _Property_d7c528359ec04b358fe52533578ee6b9_Out_0_Texture2D.samplerstate, _Property_d7c528359ec04b358fe52533578ee6b9_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy));
                float _SampleTexture2D_d6de786ff7b7453d9af1e36379f1e71c_R_4_Float = _SampleTexture2D_d6de786ff7b7453d9af1e36379f1e71c_RGBA_0_Vector4.r;
                float _SampleTexture2D_d6de786ff7b7453d9af1e36379f1e71c_G_5_Float = _SampleTexture2D_d6de786ff7b7453d9af1e36379f1e71c_RGBA_0_Vector4.g;
                float _SampleTexture2D_d6de786ff7b7453d9af1e36379f1e71c_B_6_Float = _SampleTexture2D_d6de786ff7b7453d9af1e36379f1e71c_RGBA_0_Vector4.b;
                float _SampleTexture2D_d6de786ff7b7453d9af1e36379f1e71c_A_7_Float = _SampleTexture2D_d6de786ff7b7453d9af1e36379f1e71c_RGBA_0_Vector4.a;
                float4 _Multiply_1ea6dc267b75448e873dab9c0aba9979_Out_2_Vector4;
                Unity_Multiply_float4_float4(_SampleTexture2D_836113538fba497181d2063bdfe5dc20_RGBA_0_Vector4, _SampleTexture2D_d6de786ff7b7453d9af1e36379f1e71c_RGBA_0_Vector4, _Multiply_1ea6dc267b75448e873dab9c0aba9979_Out_2_Vector4);
                float4 _Property_12403b7668af40959b7e6b93ac1deb70_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_Color) : _Color;
                float4 _Multiply_7dad164dce0f4fcaacdb934f7bd9ccaa_Out_2_Vector4;
                Unity_Multiply_float4_float4(_Multiply_1ea6dc267b75448e873dab9c0aba9979_Out_2_Vector4, _Property_12403b7668af40959b7e6b93ac1deb70_Out_0_Vector4, _Multiply_7dad164dce0f4fcaacdb934f7bd9ccaa_Out_2_Vector4);
                float4 _Add_160a66523e9a45d9982c0cb2001a1cd9_Out_2_Vector4;
                Unity_Add_float4(_Multiply_086d929899474eef8f9492b3df748da7_Out_2_Vector4, _Multiply_7dad164dce0f4fcaacdb934f7bd9ccaa_Out_2_Vector4, _Add_160a66523e9a45d9982c0cb2001a1cd9_Out_2_Vector4);
                float4 _Blend_d23b982fe8434a9ba42b28e9067ede89_Out_2_Vector4;
                Unity_Blend_Dodge_float4(_Blend_22332064b1dd476eb955d1e6f0d31893_Out_2_Vector4, _Add_160a66523e9a45d9982c0cb2001a1cd9_Out_2_Vector4, _Blend_d23b982fe8434a9ba42b28e9067ede89_Out_2_Vector4, 0);
                UnityTexture2D _Property_2296a933b1a044b889041aa853a7f13a_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_FlareLayer);
                float _Property_782a0df3d6284fabae7e7ac9130de612_Out_0_Float = _Tile_X_Flare;
                float _Property_cab0217c4db14cb08c0c11fd45bf24d0_Out_0_Float = _Tile_Y_Flare;
                float2 _Vector2_1952ea97bee3429381dad80e93776ec2_Out_0_Vector2 = float2(_Property_782a0df3d6284fabae7e7ac9130de612_Out_0_Float, _Property_cab0217c4db14cb08c0c11fd45bf24d0_Out_0_Float);
                float _Property_aed1ddb6d9a5427580bc310dd089f919_Out_0_Float = _Flare_Speed;
                float _Multiply_4b4bff5c45e140bca122d3c80dc22ea7_Out_2_Float;
                Unity_Multiply_float_float(IN.TimeParameters.x, _Property_aed1ddb6d9a5427580bc310dd089f919_Out_0_Float, _Multiply_4b4bff5c45e140bca122d3c80dc22ea7_Out_2_Float);
                float2 _Vector2_2565b1496cd443f6b1ba17365aa447da_Out_0_Vector2 = float2(0.57, _Multiply_4b4bff5c45e140bca122d3c80dc22ea7_Out_2_Float);
                float4 _UV_6593fae6f24d472d8d9e543f8a171b90_Out_0_Vector4 = IN.uv0;
                float4 _Add_f71da7687c2d4a81ad17d32ca6b91452_Out_2_Vector4;
                Unity_Add_float4((_Multiply_4b4bff5c45e140bca122d3c80dc22ea7_Out_2_Float.xxxx), _UV_6593fae6f24d472d8d9e543f8a171b90_Out_0_Vector4, _Add_f71da7687c2d4a81ad17d32ca6b91452_Out_2_Vector4);
                float _GradientNoise_c42c53c8620e444eb353533ecb9dbac5_Out_2_Float;
                Unity_GradientNoise_LegacyMod_float((_Add_f71da7687c2d4a81ad17d32ca6b91452_Out_2_Vector4.xy), 10, _GradientNoise_c42c53c8620e444eb353533ecb9dbac5_Out_2_Float);
                float _Property_c5fe4c7886864818a6634886e951c3cd_Out_0_Float = _Flare_Noise;
                float3 _NormalFromHeight_aac2a418455049acb09867e85f9521d4_Out_1_Vector3;
                float3x3 _NormalFromHeight_aac2a418455049acb09867e85f9521d4_TangentMatrix = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
                float3 _NormalFromHeight_aac2a418455049acb09867e85f9521d4_Position = IN.WorldSpacePosition;
                Unity_NormalFromHeight_Tangent_float(_GradientNoise_c42c53c8620e444eb353533ecb9dbac5_Out_2_Float,_Property_c5fe4c7886864818a6634886e951c3cd_Out_0_Float,_NormalFromHeight_aac2a418455049acb09867e85f9521d4_Position,_NormalFromHeight_aac2a418455049acb09867e85f9521d4_TangentMatrix, _NormalFromHeight_aac2a418455049acb09867e85f9521d4_Out_1_Vector3);
                float _Float_3b8429aad5284fe6ad703abf61f73644_Out_0_Float = 0.05;
                float3 _Multiply_e0bf4aabf4f046b6af7d6e72cfdb7fe7_Out_2_Vector3;
                Unity_Multiply_float3_float3(_NormalFromHeight_aac2a418455049acb09867e85f9521d4_Out_1_Vector3, (_Float_3b8429aad5284fe6ad703abf61f73644_Out_0_Float.xxx), _Multiply_e0bf4aabf4f046b6af7d6e72cfdb7fe7_Out_2_Vector3);
                float2 _Add_5a53b043f4a94542b971037a99a59c9d_Out_2_Vector2;
                Unity_Add_float2(_Vector2_2565b1496cd443f6b1ba17365aa447da_Out_0_Vector2, (_Multiply_e0bf4aabf4f046b6af7d6e72cfdb7fe7_Out_2_Vector3.xy), _Add_5a53b043f4a94542b971037a99a59c9d_Out_2_Vector2);
                float2 _TilingAndOffset_f850fca5d6c14dd4af26c36689f98822_Out_3_Vector2;
                Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_1952ea97bee3429381dad80e93776ec2_Out_0_Vector2, _Add_5a53b043f4a94542b971037a99a59c9d_Out_2_Vector2, _TilingAndOffset_f850fca5d6c14dd4af26c36689f98822_Out_3_Vector2);
                float4 _SampleTexture2D_16d53b57feef4457b6511a222279c4c2_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_2296a933b1a044b889041aa853a7f13a_Out_0_Texture2D.tex, _Property_2296a933b1a044b889041aa853a7f13a_Out_0_Texture2D.samplerstate, _Property_2296a933b1a044b889041aa853a7f13a_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_f850fca5d6c14dd4af26c36689f98822_Out_3_Vector2));
                float _SampleTexture2D_16d53b57feef4457b6511a222279c4c2_R_4_Float = _SampleTexture2D_16d53b57feef4457b6511a222279c4c2_RGBA_0_Vector4.r;
                float _SampleTexture2D_16d53b57feef4457b6511a222279c4c2_G_5_Float = _SampleTexture2D_16d53b57feef4457b6511a222279c4c2_RGBA_0_Vector4.g;
                float _SampleTexture2D_16d53b57feef4457b6511a222279c4c2_B_6_Float = _SampleTexture2D_16d53b57feef4457b6511a222279c4c2_RGBA_0_Vector4.b;
                float _SampleTexture2D_16d53b57feef4457b6511a222279c4c2_A_7_Float = _SampleTexture2D_16d53b57feef4457b6511a222279c4c2_RGBA_0_Vector4.a;
                UnityTexture2D _Property_daed62fc7e254f5291f7e8d4b4d36cc8_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_FlareLayerMask);
                float4 _SampleTexture2D_f771449173f64fea8fadc2f2470df5a2_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_daed62fc7e254f5291f7e8d4b4d36cc8_Out_0_Texture2D.tex, _Property_daed62fc7e254f5291f7e8d4b4d36cc8_Out_0_Texture2D.samplerstate, _Property_daed62fc7e254f5291f7e8d4b4d36cc8_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy));
                float _SampleTexture2D_f771449173f64fea8fadc2f2470df5a2_R_4_Float = _SampleTexture2D_f771449173f64fea8fadc2f2470df5a2_RGBA_0_Vector4.r;
                float _SampleTexture2D_f771449173f64fea8fadc2f2470df5a2_G_5_Float = _SampleTexture2D_f771449173f64fea8fadc2f2470df5a2_RGBA_0_Vector4.g;
                float _SampleTexture2D_f771449173f64fea8fadc2f2470df5a2_B_6_Float = _SampleTexture2D_f771449173f64fea8fadc2f2470df5a2_RGBA_0_Vector4.b;
                float _SampleTexture2D_f771449173f64fea8fadc2f2470df5a2_A_7_Float = _SampleTexture2D_f771449173f64fea8fadc2f2470df5a2_RGBA_0_Vector4.a;
                float4 _Multiply_ee41795c0bae447793edbbf2ad5d1905_Out_2_Vector4;
                Unity_Multiply_float4_float4(_SampleTexture2D_16d53b57feef4457b6511a222279c4c2_RGBA_0_Vector4, _SampleTexture2D_f771449173f64fea8fadc2f2470df5a2_RGBA_0_Vector4, _Multiply_ee41795c0bae447793edbbf2ad5d1905_Out_2_Vector4);
                float4 _Blend_2dd7dae929b34fe9b21b4b787d2ad749_Out_2_Vector4;
                Unity_Blend_Screen_float4(_Blend_d23b982fe8434a9ba42b28e9067ede89_Out_2_Vector4, _Multiply_ee41795c0bae447793edbbf2ad5d1905_Out_2_Vector4, _Blend_2dd7dae929b34fe9b21b4b787d2ad749_Out_2_Vector4, 1);
                UnityTexture2D _Property_2ceed6d28ce340449e7fbb66d0aff7e3_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(NormalMap);
                float4 _SampleTexture2D_58392379a8634d4f86fe10f033d789c0_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_2ceed6d28ce340449e7fbb66d0aff7e3_Out_0_Texture2D.tex, _Property_2ceed6d28ce340449e7fbb66d0aff7e3_Out_0_Texture2D.samplerstate, _Property_2ceed6d28ce340449e7fbb66d0aff7e3_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy));
                _SampleTexture2D_58392379a8634d4f86fe10f033d789c0_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_58392379a8634d4f86fe10f033d789c0_RGBA_0_Vector4);
                float _SampleTexture2D_58392379a8634d4f86fe10f033d789c0_R_4_Float = _SampleTexture2D_58392379a8634d4f86fe10f033d789c0_RGBA_0_Vector4.r;
                float _SampleTexture2D_58392379a8634d4f86fe10f033d789c0_G_5_Float = _SampleTexture2D_58392379a8634d4f86fe10f033d789c0_RGBA_0_Vector4.g;
                float _SampleTexture2D_58392379a8634d4f86fe10f033d789c0_B_6_Float = _SampleTexture2D_58392379a8634d4f86fe10f033d789c0_RGBA_0_Vector4.b;
                float _SampleTexture2D_58392379a8634d4f86fe10f033d789c0_A_7_Float = _SampleTexture2D_58392379a8634d4f86fe10f033d789c0_RGBA_0_Vector4.a;
                float _Property_429252a545ea49e180d470c51c2ced1f_Out_0_Float = _Normal_Strength;
                float3 _NormalStrength_89cd7be49bc94135bca418619f4f209c_Out_2_Vector3;
                Unity_NormalStrength_float((_SampleTexture2D_58392379a8634d4f86fe10f033d789c0_RGBA_0_Vector4.xyz), _Property_429252a545ea49e180d470c51c2ced1f_Out_0_Float, _NormalStrength_89cd7be49bc94135bca418619f4f209c_Out_2_Vector3);
                UnityTexture2D _Property_94b557a5cefd4f1cb9f8b7647e8d8d0b_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_FirstLayer);
                float _Float_df56ec6f904545a8a767a7ba3c5dd15c_Out_0_Float = 2;
                float3 _Multiply_fae8425b844f415b9edd050b6279c2ac_Out_2_Vector3;
                Unity_Multiply_float3_float3((_Float_df56ec6f904545a8a767a7ba3c5dd15c_Out_0_Float.xxx), IN.TangentSpaceViewDirection, _Multiply_fae8425b844f415b9edd050b6279c2ac_Out_2_Vector3);
                float2 _TilingAndOffset_b36424444c844f9fa22ddbb420625641_Out_3_Vector2;
                Unity_TilingAndOffset_float(IN.uv0.xy, (_Multiply_fae8425b844f415b9edd050b6279c2ac_Out_2_Vector3.xy), (_Multiply_fae8425b844f415b9edd050b6279c2ac_Out_2_Vector3.xy), _TilingAndOffset_b36424444c844f9fa22ddbb420625641_Out_3_Vector2);
                float4 _SampleTexture2D_600ebfe1de5d4c789cf5d509e767528c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_94b557a5cefd4f1cb9f8b7647e8d8d0b_Out_0_Texture2D.tex, _Property_94b557a5cefd4f1cb9f8b7647e8d8d0b_Out_0_Texture2D.samplerstate, _Property_94b557a5cefd4f1cb9f8b7647e8d8d0b_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_b36424444c844f9fa22ddbb420625641_Out_3_Vector2));
                float _SampleTexture2D_600ebfe1de5d4c789cf5d509e767528c_R_4_Float = _SampleTexture2D_600ebfe1de5d4c789cf5d509e767528c_RGBA_0_Vector4.r;
                float _SampleTexture2D_600ebfe1de5d4c789cf5d509e767528c_G_5_Float = _SampleTexture2D_600ebfe1de5d4c789cf5d509e767528c_RGBA_0_Vector4.g;
                float _SampleTexture2D_600ebfe1de5d4c789cf5d509e767528c_B_6_Float = _SampleTexture2D_600ebfe1de5d4c789cf5d509e767528c_RGBA_0_Vector4.b;
                float _SampleTexture2D_600ebfe1de5d4c789cf5d509e767528c_A_7_Float = _SampleTexture2D_600ebfe1de5d4c789cf5d509e767528c_RGBA_0_Vector4.a;
                UnityTexture2D _Property_9ed80af81ecf433682e8492e8eda6983_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_FirstLayerMask);
                float4 _SampleTexture2D_9fea3c05c65144bbabad6ef4512b2893_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_9ed80af81ecf433682e8492e8eda6983_Out_0_Texture2D.tex, _Property_9ed80af81ecf433682e8492e8eda6983_Out_0_Texture2D.samplerstate, _Property_9ed80af81ecf433682e8492e8eda6983_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy));
                float _SampleTexture2D_9fea3c05c65144bbabad6ef4512b2893_R_4_Float = _SampleTexture2D_9fea3c05c65144bbabad6ef4512b2893_RGBA_0_Vector4.r;
                float _SampleTexture2D_9fea3c05c65144bbabad6ef4512b2893_G_5_Float = _SampleTexture2D_9fea3c05c65144bbabad6ef4512b2893_RGBA_0_Vector4.g;
                float _SampleTexture2D_9fea3c05c65144bbabad6ef4512b2893_B_6_Float = _SampleTexture2D_9fea3c05c65144bbabad6ef4512b2893_RGBA_0_Vector4.b;
                float _SampleTexture2D_9fea3c05c65144bbabad6ef4512b2893_A_7_Float = _SampleTexture2D_9fea3c05c65144bbabad6ef4512b2893_RGBA_0_Vector4.a;
                float4 _Multiply_00741ec509bb44e6b7c015c8afbd6f7b_Out_2_Vector4;
                Unity_Multiply_float4_float4(_SampleTexture2D_600ebfe1de5d4c789cf5d509e767528c_RGBA_0_Vector4, _SampleTexture2D_9fea3c05c65144bbabad6ef4512b2893_RGBA_0_Vector4, _Multiply_00741ec509bb44e6b7c015c8afbd6f7b_Out_2_Vector4);
                float _Property_d2a734d059ac4cdeacd546c3e4762220_Out_0_Float = _FirstLayer_Still_Opacity;
                float _Float_4766b030743f4cbd8fcaf0ed448ca5d6_Out_0_Float = _Property_d2a734d059ac4cdeacd546c3e4762220_Out_0_Float;
                float4 _Multiply_0d830f9ef3c74258a1fc4b496e551f55_Out_2_Vector4;
                Unity_Multiply_float4_float4(_Multiply_00741ec509bb44e6b7c015c8afbd6f7b_Out_2_Vector4, (_Float_4766b030743f4cbd8fcaf0ed448ca5d6_Out_0_Float.xxxx), _Multiply_0d830f9ef3c74258a1fc4b496e551f55_Out_2_Vector4);
                float _Property_2f0100c28b754ef7ad75f264ce26809b_Out_0_Float = _Layers_Opacity;
                float _Float_464854d505d5400d94c46694778bb7e8_Out_0_Float = _Property_2f0100c28b754ef7ad75f264ce26809b_Out_0_Float;
                UnityTexture2D _Property_11854fc2ac5e4f94a4d83e9f568c610e_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Edge_Emission);
                float4 _SampleTexture2D_cd98119a8c1d4215b57d6099759b389d_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_11854fc2ac5e4f94a4d83e9f568c610e_Out_0_Texture2D.tex, _Property_11854fc2ac5e4f94a4d83e9f568c610e_Out_0_Texture2D.samplerstate, _Property_11854fc2ac5e4f94a4d83e9f568c610e_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy));
                float _SampleTexture2D_cd98119a8c1d4215b57d6099759b389d_R_4_Float = _SampleTexture2D_cd98119a8c1d4215b57d6099759b389d_RGBA_0_Vector4.r;
                float _SampleTexture2D_cd98119a8c1d4215b57d6099759b389d_G_5_Float = _SampleTexture2D_cd98119a8c1d4215b57d6099759b389d_RGBA_0_Vector4.g;
                float _SampleTexture2D_cd98119a8c1d4215b57d6099759b389d_B_6_Float = _SampleTexture2D_cd98119a8c1d4215b57d6099759b389d_RGBA_0_Vector4.b;
                float _SampleTexture2D_cd98119a8c1d4215b57d6099759b389d_A_7_Float = _SampleTexture2D_cd98119a8c1d4215b57d6099759b389d_RGBA_0_Vector4.a;
                float4 _Add_b9699c2cea3a4e91aaee5df460966234_Out_2_Vector4;
                Unity_Add_float4(_Add_160a66523e9a45d9982c0cb2001a1cd9_Out_2_Vector4, _SampleTexture2D_cd98119a8c1d4215b57d6099759b389d_RGBA_0_Vector4, _Add_b9699c2cea3a4e91aaee5df460966234_Out_2_Vector4);
                float4 _Multiply_46c4d7cd5f3b4d8ea76dac8b7549e4d2_Out_2_Vector4;
                Unity_Multiply_float4_float4((_Float_464854d505d5400d94c46694778bb7e8_Out_0_Float.xxxx), _Add_b9699c2cea3a4e91aaee5df460966234_Out_2_Vector4, _Multiply_46c4d7cd5f3b4d8ea76dac8b7549e4d2_Out_2_Vector4);
                float4 _Remap_a3b4ca48973f445fb1acf58ec78cdbed_Out_3_Vector4;
                Unity_Remap_float4(_Multiply_ee41795c0bae447793edbbf2ad5d1905_Out_2_Vector4, float2 (-1, 1), float2 (-1, 1.02), _Remap_a3b4ca48973f445fb1acf58ec78cdbed_Out_3_Vector4);
                float _Float_20e389ee74214f3ab347f86ca4b66d9e_Out_0_Float = 0.25;
                float4 _Multiply_b40f8c2975ce41108df7579646a56b80_Out_2_Vector4;
                Unity_Multiply_float4_float4(_Remap_a3b4ca48973f445fb1acf58ec78cdbed_Out_3_Vector4, (_Float_20e389ee74214f3ab347f86ca4b66d9e_Out_0_Float.xxxx), _Multiply_b40f8c2975ce41108df7579646a56b80_Out_2_Vector4);
                float4 _Add_f1dab00885fc4aaaa6c73e04985ad9a8_Out_2_Vector4;
                Unity_Add_float4(_Multiply_46c4d7cd5f3b4d8ea76dac8b7549e4d2_Out_2_Vector4, _Multiply_b40f8c2975ce41108df7579646a56b80_Out_2_Vector4, _Add_f1dab00885fc4aaaa6c73e04985ad9a8_Out_2_Vector4);
                float4 _Add_ec1895b218b94d6eb89e1acdc29d14bf_Out_2_Vector4;
                Unity_Add_float4(_Multiply_0d830f9ef3c74258a1fc4b496e551f55_Out_2_Vector4, _Add_f1dab00885fc4aaaa6c73e04985ad9a8_Out_2_Vector4, _Add_ec1895b218b94d6eb89e1acdc29d14bf_Out_2_Vector4);
                float _Property_020a39e9b25e4032b4e8beba87e6bbc6_Out_0_Float = Metallic;
                float _Property_a93c035743944b7bad1ea38a1551869e_Out_0_Float = Smoothness;
                surface.BaseColor = (_Blend_2dd7dae929b34fe9b21b4b787d2ad749_Out_2_Vector4.xyz);
                surface.NormalTS = _NormalStrength_89cd7be49bc94135bca418619f4f209c_Out_2_Vector3;
                surface.Emission = (_Add_ec1895b218b94d6eb89e1acdc29d14bf_Out_2_Vector4.xyz);
                surface.Metallic = _Property_020a39e9b25e4032b4e8beba87e6bbc6_Out_0_Float;
                surface.Smoothness = _Property_a93c035743944b7bad1ea38a1551869e_Out_0_Float;
                surface.Occlusion = 0;
                surface.Alpha = 1;
                surface.AlphaClipThreshold = 0.5;
                return surface;
            }

            // --------------------------------------------------
            // Build Graph Inputs
            #ifdef HAVE_VFX_MODIFICATION
            #define VFX_SRP_ATTRIBUTES Attributes
            #define VFX_SRP_VARYINGS Varyings
            #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
            #endif
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);

                output.ObjectSpaceNormal = input.normalOS;
                output.ObjectSpaceTangent = input.tangentOS.xyz;
                output.ObjectSpacePosition = input.positionOS;

                return output;
            }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

            #ifdef HAVE_VFX_MODIFICATION
            #if VFX_USE_GRAPH_VALUES
                uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
                /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
            #endif
                /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

            #endif



                // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
                float3 unnormalizedNormalWS = input.normalWS;
                const float renormFactor = 1.0 / length(unnormalizedNormalWS);

                // use bitangent on the fly like in hdrp
                // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
                float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0) * GetOddNegativeScale();
                float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);

                output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
                output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);

                // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
                // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
                output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
                output.WorldSpaceBiTangent = renormFactor * bitang;

                output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
                float3x3 tangentSpaceTransform = float3x3(output.WorldSpaceTangent, output.WorldSpaceBiTangent, output.WorldSpaceNormal);
                output.TangentSpaceViewDirection = mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                output.WorldSpacePosition = input.positionWS;

                #if UNITY_UV_STARTS_AT_TOP
                #else
                #endif


                output.uv0 = input.texCoord0;
                output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
            #else
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            #endif
            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

                    return output;
            }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"

            // --------------------------------------------------
            // Visual Effect Vertex Invocations
            #ifdef HAVE_VFX_MODIFICATION
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
            #endif

            ENDHLSL
            }
            Pass
            {
                Name "GBuffer"
                Tags
                {
                    "LightMode" = "UniversalGBuffer"
                }

                // Render State
                Cull Off
                Blend One Zero
                ZTest LEqual
                ZWrite On

                // Debug
                // <None>

                // --------------------------------------------------
                // Pass

                HLSLPROGRAM

                // Pragmas
                #pragma target 4.5
                #pragma exclude_renderers gles gles3 glcore
                #pragma multi_compile_instancing
                #pragma multi_compile_fog
                #pragma instancing_options renderinglayer
                #pragma vertex vert
                #pragma fragment frag

                // Keywords
                #pragma multi_compile _ LIGHTMAP_ON
                #pragma multi_compile _ DYNAMICLIGHTMAP_ON
                #pragma multi_compile _ DIRLIGHTMAP_COMBINED
                #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
                #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
                #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
                #pragma multi_compile_fragment _ _SHADOWS_SOFT
                #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
                #pragma multi_compile _ SHADOWS_SHADOWMASK
                #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
                #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
                #pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
                #pragma multi_compile_fragment _ _RENDER_PASS_ENABLED
                #pragma multi_compile_fragment _ DEBUG_DISPLAY
                // GraphKeywords: <None>

                // Defines

                #define _NORMALMAP 1
                #define _NORMAL_DROPOFF_TS 1
                #define ATTRIBUTES_NEED_NORMAL
                #define ATTRIBUTES_NEED_TANGENT
                #define ATTRIBUTES_NEED_TEXCOORD0
                #define ATTRIBUTES_NEED_TEXCOORD1
                #define ATTRIBUTES_NEED_TEXCOORD2
                #define VARYINGS_NEED_POSITION_WS
                #define VARYINGS_NEED_NORMAL_WS
                #define VARYINGS_NEED_TANGENT_WS
                #define VARYINGS_NEED_TEXCOORD0
                #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                #define VARYINGS_NEED_SHADOW_COORD
                #define FEATURES_GRAPH_VERTEX
                /* WARNING: $splice Could not find named fragment 'PassInstancing' */
                #define SHADERPASS SHADERPASS_GBUFFER
                #define _FOG_FRAGMENT 1
                #define _ALPHATEST_ON 1
                #define _RECEIVE_SHADOWS_OFF 1
                /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */


                // custom interpolator pre-include
                /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

                // Includes
                #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
                #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

                // --------------------------------------------------
                // Structs and Packing

                // custom interpolators pre packing
                /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

                struct Attributes
                {
                     float3 positionOS : POSITION;
                     float3 normalOS : NORMAL;
                     float4 tangentOS : TANGENT;
                     float4 uv0 : TEXCOORD0;
                     float4 uv1 : TEXCOORD1;
                     float4 uv2 : TEXCOORD2;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : INSTANCEID_SEMANTIC;
                    #endif
                };
                struct Varyings
                {
                     float4 positionCS : SV_POSITION;
                     float3 positionWS;
                     float3 normalWS;
                     float4 tangentWS;
                     float4 texCoord0;
                    #if defined(LIGHTMAP_ON)
                     float2 staticLightmapUV;
                    #endif
                    #if defined(DYNAMICLIGHTMAP_ON)
                     float2 dynamicLightmapUV;
                    #endif
                    #if !defined(LIGHTMAP_ON)
                     float3 sh;
                    #endif
                     float4 fogFactorAndVertexLight;
                    #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
                     float4 shadowCoord;
                    #endif
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
                struct SurfaceDescriptionInputs
                {
                     float3 WorldSpaceNormal;
                     float3 TangentSpaceNormal;
                     float3 WorldSpaceTangent;
                     float3 WorldSpaceBiTangent;
                     float3 WorldSpaceViewDirection;
                     float3 TangentSpaceViewDirection;
                     float3 WorldSpacePosition;
                     float4 uv0;
                     float3 TimeParameters;
                };
                struct VertexDescriptionInputs
                {
                     float3 ObjectSpaceNormal;
                     float3 ObjectSpaceTangent;
                     float3 ObjectSpacePosition;
                };
                struct PackedVaryings
                {
                     float4 positionCS : SV_POSITION;
                    #if defined(LIGHTMAP_ON)
                     float2 staticLightmapUV : INTERP0;
                    #endif
                    #if defined(DYNAMICLIGHTMAP_ON)
                     float2 dynamicLightmapUV : INTERP1;
                    #endif
                    #if !defined(LIGHTMAP_ON)
                     float3 sh : INTERP2;
                    #endif
                    #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
                     float4 shadowCoord : INTERP3;
                    #endif
                     float4 tangentWS : INTERP4;
                     float4 texCoord0 : INTERP5;
                     float4 fogFactorAndVertexLight : INTERP6;
                     float3 positionWS : INTERP7;
                     float3 normalWS : INTERP8;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };

                PackedVaryings PackVaryings(Varyings input)
                {
                    PackedVaryings output;
                    ZERO_INITIALIZE(PackedVaryings, output);
                    output.positionCS = input.positionCS;
                    #if defined(LIGHTMAP_ON)
                    output.staticLightmapUV = input.staticLightmapUV;
                    #endif
                    #if defined(DYNAMICLIGHTMAP_ON)
                    output.dynamicLightmapUV = input.dynamicLightmapUV;
                    #endif
                    #if !defined(LIGHTMAP_ON)
                    output.sh = input.sh;
                    #endif
                    #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
                    output.shadowCoord = input.shadowCoord;
                    #endif
                    output.tangentWS.xyzw = input.tangentWS;
                    output.texCoord0.xyzw = input.texCoord0;
                    output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
                    output.positionWS.xyz = input.positionWS;
                    output.normalWS.xyz = input.normalWS;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }

                Varyings UnpackVaryings(PackedVaryings input)
                {
                    Varyings output;
                    output.positionCS = input.positionCS;
                    #if defined(LIGHTMAP_ON)
                    output.staticLightmapUV = input.staticLightmapUV;
                    #endif
                    #if defined(DYNAMICLIGHTMAP_ON)
                    output.dynamicLightmapUV = input.dynamicLightmapUV;
                    #endif
                    #if !defined(LIGHTMAP_ON)
                    output.sh = input.sh;
                    #endif
                    #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
                    output.shadowCoord = input.shadowCoord;
                    #endif
                    output.tangentWS = input.tangentWS.xyzw;
                    output.texCoord0 = input.texCoord0.xyzw;
                    output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
                    output.positionWS = input.positionWS.xyz;
                    output.normalWS = input.normalWS.xyz;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }


                // --------------------------------------------------
                // Graph

                // Graph Properties
                CBUFFER_START(UnityPerMaterial)
                float4 MainTexture_TexelSize;
                float4 NormalMap_TexelSize;
                float _Normal_Strength;
                float _SecondLayer_Speed;
                float _Tile_X_Flare;
                float _Tile_Y_Flare;
                float _Layers_Opacity;
                float _Tile_X_2;
                float _Tile_Y_2;
                float _Tile_Y;
                float Metallic;
                float Smoothness;
                float _Flare_Speed;
                float _FirstLayer_Speed;
                float4 _Color;
                float4 _Edge_Emission_TexelSize;
                float4 _FirstLayer_TexelSize;
                float4 _FirstLayerMask_TexelSize;
                float4 _FlareLayer_TexelSize;
                float4 _FlareLayerMask_TexelSize;
                float4 _SecondLayer_TexelSize;
                float4 _SecondLayerMask_TexelSize;
                float _Flare_Noise;
                float _FirstLayer_Still_Opacity;
                float _Tile_X;
                CBUFFER_END


                    // Object and Global properties
                    SAMPLER(SamplerState_Linear_Repeat);
                    TEXTURE2D(MainTexture);
                    SAMPLER(samplerMainTexture);
                    TEXTURE2D(NormalMap);
                    SAMPLER(samplerNormalMap);
                    TEXTURE2D(_Edge_Emission);
                    SAMPLER(sampler_Edge_Emission);
                    TEXTURE2D(_FirstLayer);
                    SAMPLER(sampler_FirstLayer);
                    TEXTURE2D(_FirstLayerMask);
                    SAMPLER(sampler_FirstLayerMask);
                    TEXTURE2D(_FlareLayer);
                    SAMPLER(sampler_FlareLayer);
                    TEXTURE2D(_FlareLayerMask);
                    SAMPLER(sampler_FlareLayerMask);
                    TEXTURE2D(_SecondLayer);
                    SAMPLER(sampler_SecondLayer);
                    TEXTURE2D(_SecondLayerMask);
                    SAMPLER(sampler_SecondLayerMask);

                    // Graph Includes
                    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"

                    // -- Property used by ScenePickingPass
                    #ifdef SCENEPICKINGPASS
                    float4 _SelectionID;
                    #endif

                    // -- Properties used by SceneSelectionPass
                    #ifdef SCENESELECTIONPASS
                    int _ObjectId;
                    int _PassValue;
                    #endif

                    // Graph Functions

                    void Unity_Multiply_float_float(float A, float B, out float Out)
                    {
                        Out = A * B;
                    }

                    void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                    {
                        Out = UV * Tiling + Offset;
                    }

                    void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
                    {
                        Out = A * B;
                    }

                    void Unity_Blend_Dodge_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
                    {
                        Out = Base / (1.0 - clamp(Blend, 0.000001, 0.999999));
                        Out = lerp(Base, Out, Opacity);
                    }

                    void Unity_Add_float4(float4 A, float4 B, out float4 Out)
                    {
                        Out = A + B;
                    }

                    float2 Unity_GradientNoise_LegacyMod_Dir_float(float2 p)
                    {
                        float x; Hash_LegacyMod_2_1_float(p, x);
                        return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                    }

                    void Unity_GradientNoise_LegacyMod_float(float2 UV, float3 Scale, out float Out)
                    {
                        float2 p = UV * Scale.xy;
                        float2 ip = floor(p);
                        float2 fp = frac(p);
                        float d00 = dot(Unity_GradientNoise_LegacyMod_Dir_float(ip), fp);
                        float d01 = dot(Unity_GradientNoise_LegacyMod_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                        float d10 = dot(Unity_GradientNoise_LegacyMod_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                        float d11 = dot(Unity_GradientNoise_LegacyMod_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                        fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                        Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                    }

                    void Unity_NormalFromHeight_Tangent_float(float In, float Strength, float3 Position, float3x3 TangentMatrix, out float3 Out)
                    {

                                #if defined(SHADER_STAGE_RAY_TRACING) && defined(RAYTRACING_SHADER_GRAPH_DEFAULT)
                                #error 'Normal From Height' node is not supported in ray tracing, please provide an alternate implementation, relying for instance on the 'Raytracing Quality' keyword
                                #endif
                        float3 worldDerivativeX = ddx(Position);
                        float3 worldDerivativeY = ddy(Position);

                        float3 crossX = cross(TangentMatrix[2].xyz, worldDerivativeX);
                        float3 crossY = cross(worldDerivativeY, TangentMatrix[2].xyz);
                        float d = dot(worldDerivativeX, crossY);
                        float sgn = d < 0.0 ? (-1.0f) : 1.0f;
                        float surface = sgn / max(0.000000000000001192093f, abs(d));

                        float dHdx = ddx(In);
                        float dHdy = ddy(In);
                        float3 surfGrad = surface * (dHdx * crossY + dHdy * crossX);
                        Out = SafeNormalize(TangentMatrix[2].xyz - (Strength * surfGrad));
                        Out = TransformWorldToTangent(Out, TangentMatrix);
                    }

                    void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
                    {
                        Out = A * B;
                    }

                    void Unity_Add_float2(float2 A, float2 B, out float2 Out)
                    {
                        Out = A + B;
                    }

                    void Unity_Blend_Screen_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
                    {
                        Out = 1.0 - (1.0 - Blend) * (1.0 - Base);
                        Out = lerp(Base, Out, Opacity);
                    }

                    void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
                    {
                        Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
                    }

                    void Unity_Remap_float4(float4 In, float2 InMinMax, float2 OutMinMax, out float4 Out)
                    {
                        Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
                    }

                    // Custom interpolators pre vertex
                    /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

                    // Graph Vertex
                    struct VertexDescription
                    {
                        float3 Position;
                        float3 Normal;
                        float3 Tangent;
                    };

                    VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                    {
                        VertexDescription description = (VertexDescription)0;
                        description.Position = IN.ObjectSpacePosition;
                        description.Normal = IN.ObjectSpaceNormal;
                        description.Tangent = IN.ObjectSpaceTangent;
                        return description;
                    }

                    // Custom interpolators, pre surface
                    #ifdef FEATURES_GRAPH_VERTEX
                    Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
                    {
                    return output;
                    }
                    #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
                    #endif

                    // Graph Pixel
                    struct SurfaceDescription
                    {
                        float3 BaseColor;
                        float3 NormalTS;
                        float3 Emission;
                        float Metallic;
                        float Smoothness;
                        float Occlusion;
                        float Alpha;
                        float AlphaClipThreshold;
                    };

                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                    {
                        SurfaceDescription surface = (SurfaceDescription)0;
                        UnityTexture2D _Property_25d58f61f8a745f69d9bc5b84ec4ca18_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(MainTexture);
                        float4 _SampleTexture2D_dae5062bfb6345989ac4c7936bcb0325_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_25d58f61f8a745f69d9bc5b84ec4ca18_Out_0_Texture2D.tex, _Property_25d58f61f8a745f69d9bc5b84ec4ca18_Out_0_Texture2D.samplerstate, _Property_25d58f61f8a745f69d9bc5b84ec4ca18_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy));
                        float _SampleTexture2D_dae5062bfb6345989ac4c7936bcb0325_R_4_Float = _SampleTexture2D_dae5062bfb6345989ac4c7936bcb0325_RGBA_0_Vector4.r;
                        float _SampleTexture2D_dae5062bfb6345989ac4c7936bcb0325_G_5_Float = _SampleTexture2D_dae5062bfb6345989ac4c7936bcb0325_RGBA_0_Vector4.g;
                        float _SampleTexture2D_dae5062bfb6345989ac4c7936bcb0325_B_6_Float = _SampleTexture2D_dae5062bfb6345989ac4c7936bcb0325_RGBA_0_Vector4.b;
                        float _SampleTexture2D_dae5062bfb6345989ac4c7936bcb0325_A_7_Float = _SampleTexture2D_dae5062bfb6345989ac4c7936bcb0325_RGBA_0_Vector4.a;
                        UnityTexture2D _Property_d3f4357a037b4294a4561e4800559a98_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_FirstLayer);
                        float _Property_28841e4c56c449d699ce8655774bfb45_Out_0_Float = _Tile_X;
                        float _Property_93952c7a35224f899e2b661de6d28d11_Out_0_Float = _Tile_Y;
                        float2 _Vector2_0d768a99157947b690b4011919c2e0fd_Out_0_Vector2 = float2(_Property_28841e4c56c449d699ce8655774bfb45_Out_0_Float, _Property_93952c7a35224f899e2b661de6d28d11_Out_0_Float);
                        float _Property_f8ada8ccabc84c0fba96d3bdfcfa3418_Out_0_Float = _FirstLayer_Speed;
                        float _Multiply_b6f87bb7270344abbfb4b28c5ae45762_Out_2_Float;
                        Unity_Multiply_float_float(IN.TimeParameters.x, _Property_f8ada8ccabc84c0fba96d3bdfcfa3418_Out_0_Float, _Multiply_b6f87bb7270344abbfb4b28c5ae45762_Out_2_Float);
                        float2 _Vector2_ba806402a04e48e9b8ff180bc6f53dd8_Out_0_Vector2 = float2(1, _Multiply_b6f87bb7270344abbfb4b28c5ae45762_Out_2_Float);
                        float2 _TilingAndOffset_8db4474d0ad0448796dee47ee2c0261f_Out_3_Vector2;
                        Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_0d768a99157947b690b4011919c2e0fd_Out_0_Vector2, _Vector2_ba806402a04e48e9b8ff180bc6f53dd8_Out_0_Vector2, _TilingAndOffset_8db4474d0ad0448796dee47ee2c0261f_Out_3_Vector2);
                        float4 _SampleTexture2D_d6ad14b7f7f54d7fb3ea98bfa5d465cd_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_d3f4357a037b4294a4561e4800559a98_Out_0_Texture2D.tex, _Property_d3f4357a037b4294a4561e4800559a98_Out_0_Texture2D.samplerstate, _Property_d3f4357a037b4294a4561e4800559a98_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_8db4474d0ad0448796dee47ee2c0261f_Out_3_Vector2));
                        float _SampleTexture2D_d6ad14b7f7f54d7fb3ea98bfa5d465cd_R_4_Float = _SampleTexture2D_d6ad14b7f7f54d7fb3ea98bfa5d465cd_RGBA_0_Vector4.r;
                        float _SampleTexture2D_d6ad14b7f7f54d7fb3ea98bfa5d465cd_G_5_Float = _SampleTexture2D_d6ad14b7f7f54d7fb3ea98bfa5d465cd_RGBA_0_Vector4.g;
                        float _SampleTexture2D_d6ad14b7f7f54d7fb3ea98bfa5d465cd_B_6_Float = _SampleTexture2D_d6ad14b7f7f54d7fb3ea98bfa5d465cd_RGBA_0_Vector4.b;
                        float _SampleTexture2D_d6ad14b7f7f54d7fb3ea98bfa5d465cd_A_7_Float = _SampleTexture2D_d6ad14b7f7f54d7fb3ea98bfa5d465cd_RGBA_0_Vector4.a;
                        UnityTexture2D _Property_c842ca1806df423fa653b7d9754ca8ca_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_FirstLayerMask);
                        float4 _SampleTexture2D_27e0a67c861e46c2b3b2a6e513e4f4a3_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_c842ca1806df423fa653b7d9754ca8ca_Out_0_Texture2D.tex, _Property_c842ca1806df423fa653b7d9754ca8ca_Out_0_Texture2D.samplerstate, _Property_c842ca1806df423fa653b7d9754ca8ca_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy));
                        float _SampleTexture2D_27e0a67c861e46c2b3b2a6e513e4f4a3_R_4_Float = _SampleTexture2D_27e0a67c861e46c2b3b2a6e513e4f4a3_RGBA_0_Vector4.r;
                        float _SampleTexture2D_27e0a67c861e46c2b3b2a6e513e4f4a3_G_5_Float = _SampleTexture2D_27e0a67c861e46c2b3b2a6e513e4f4a3_RGBA_0_Vector4.g;
                        float _SampleTexture2D_27e0a67c861e46c2b3b2a6e513e4f4a3_B_6_Float = _SampleTexture2D_27e0a67c861e46c2b3b2a6e513e4f4a3_RGBA_0_Vector4.b;
                        float _SampleTexture2D_27e0a67c861e46c2b3b2a6e513e4f4a3_A_7_Float = _SampleTexture2D_27e0a67c861e46c2b3b2a6e513e4f4a3_RGBA_0_Vector4.a;
                        float4 _Multiply_086d929899474eef8f9492b3df748da7_Out_2_Vector4;
                        Unity_Multiply_float4_float4(_SampleTexture2D_d6ad14b7f7f54d7fb3ea98bfa5d465cd_RGBA_0_Vector4, _SampleTexture2D_27e0a67c861e46c2b3b2a6e513e4f4a3_RGBA_0_Vector4, _Multiply_086d929899474eef8f9492b3df748da7_Out_2_Vector4);
                        float4 _Blend_22332064b1dd476eb955d1e6f0d31893_Out_2_Vector4;
                        Unity_Blend_Dodge_float4(_SampleTexture2D_dae5062bfb6345989ac4c7936bcb0325_RGBA_0_Vector4, _Multiply_086d929899474eef8f9492b3df748da7_Out_2_Vector4, _Blend_22332064b1dd476eb955d1e6f0d31893_Out_2_Vector4, 1);
                        UnityTexture2D _Property_aa17d6cddc844bbd8fffe2f3526f1d75_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_SecondLayer);
                        float _Property_5443b670d62042b0bf29b6649506a396_Out_0_Float = _Tile_X_2;
                        float _Property_e83f2ffe1d854d7cb7ce9639bef36c35_Out_0_Float = _Tile_Y_2;
                        float2 _Vector2_112aab1e2c1a4c60ac52f6ab932daaae_Out_0_Vector2 = float2(_Property_5443b670d62042b0bf29b6649506a396_Out_0_Float, _Property_e83f2ffe1d854d7cb7ce9639bef36c35_Out_0_Float);
                        float _Property_a122b213cc6049089080486d0e72dd92_Out_0_Float = _SecondLayer_Speed;
                        float _Multiply_74242c5ba0db44a2af24f02259a54654_Out_2_Float;
                        Unity_Multiply_float_float(IN.TimeParameters.x, _Property_a122b213cc6049089080486d0e72dd92_Out_0_Float, _Multiply_74242c5ba0db44a2af24f02259a54654_Out_2_Float);
                        float2 _Vector2_23a4ed409daa44ebb33e022576272145_Out_0_Vector2 = float2(1, _Multiply_74242c5ba0db44a2af24f02259a54654_Out_2_Float);
                        float2 _TilingAndOffset_259fb3e5741d40fbb9d10ab049b94707_Out_3_Vector2;
                        Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_112aab1e2c1a4c60ac52f6ab932daaae_Out_0_Vector2, _Vector2_23a4ed409daa44ebb33e022576272145_Out_0_Vector2, _TilingAndOffset_259fb3e5741d40fbb9d10ab049b94707_Out_3_Vector2);
                        float4 _SampleTexture2D_836113538fba497181d2063bdfe5dc20_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_aa17d6cddc844bbd8fffe2f3526f1d75_Out_0_Texture2D.tex, _Property_aa17d6cddc844bbd8fffe2f3526f1d75_Out_0_Texture2D.samplerstate, _Property_aa17d6cddc844bbd8fffe2f3526f1d75_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_259fb3e5741d40fbb9d10ab049b94707_Out_3_Vector2));
                        float _SampleTexture2D_836113538fba497181d2063bdfe5dc20_R_4_Float = _SampleTexture2D_836113538fba497181d2063bdfe5dc20_RGBA_0_Vector4.r;
                        float _SampleTexture2D_836113538fba497181d2063bdfe5dc20_G_5_Float = _SampleTexture2D_836113538fba497181d2063bdfe5dc20_RGBA_0_Vector4.g;
                        float _SampleTexture2D_836113538fba497181d2063bdfe5dc20_B_6_Float = _SampleTexture2D_836113538fba497181d2063bdfe5dc20_RGBA_0_Vector4.b;
                        float _SampleTexture2D_836113538fba497181d2063bdfe5dc20_A_7_Float = _SampleTexture2D_836113538fba497181d2063bdfe5dc20_RGBA_0_Vector4.a;
                        UnityTexture2D _Property_d7c528359ec04b358fe52533578ee6b9_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_SecondLayerMask);
                        float4 _SampleTexture2D_d6de786ff7b7453d9af1e36379f1e71c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_d7c528359ec04b358fe52533578ee6b9_Out_0_Texture2D.tex, _Property_d7c528359ec04b358fe52533578ee6b9_Out_0_Texture2D.samplerstate, _Property_d7c528359ec04b358fe52533578ee6b9_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy));
                        float _SampleTexture2D_d6de786ff7b7453d9af1e36379f1e71c_R_4_Float = _SampleTexture2D_d6de786ff7b7453d9af1e36379f1e71c_RGBA_0_Vector4.r;
                        float _SampleTexture2D_d6de786ff7b7453d9af1e36379f1e71c_G_5_Float = _SampleTexture2D_d6de786ff7b7453d9af1e36379f1e71c_RGBA_0_Vector4.g;
                        float _SampleTexture2D_d6de786ff7b7453d9af1e36379f1e71c_B_6_Float = _SampleTexture2D_d6de786ff7b7453d9af1e36379f1e71c_RGBA_0_Vector4.b;
                        float _SampleTexture2D_d6de786ff7b7453d9af1e36379f1e71c_A_7_Float = _SampleTexture2D_d6de786ff7b7453d9af1e36379f1e71c_RGBA_0_Vector4.a;
                        float4 _Multiply_1ea6dc267b75448e873dab9c0aba9979_Out_2_Vector4;
                        Unity_Multiply_float4_float4(_SampleTexture2D_836113538fba497181d2063bdfe5dc20_RGBA_0_Vector4, _SampleTexture2D_d6de786ff7b7453d9af1e36379f1e71c_RGBA_0_Vector4, _Multiply_1ea6dc267b75448e873dab9c0aba9979_Out_2_Vector4);
                        float4 _Property_12403b7668af40959b7e6b93ac1deb70_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_Color) : _Color;
                        float4 _Multiply_7dad164dce0f4fcaacdb934f7bd9ccaa_Out_2_Vector4;
                        Unity_Multiply_float4_float4(_Multiply_1ea6dc267b75448e873dab9c0aba9979_Out_2_Vector4, _Property_12403b7668af40959b7e6b93ac1deb70_Out_0_Vector4, _Multiply_7dad164dce0f4fcaacdb934f7bd9ccaa_Out_2_Vector4);
                        float4 _Add_160a66523e9a45d9982c0cb2001a1cd9_Out_2_Vector4;
                        Unity_Add_float4(_Multiply_086d929899474eef8f9492b3df748da7_Out_2_Vector4, _Multiply_7dad164dce0f4fcaacdb934f7bd9ccaa_Out_2_Vector4, _Add_160a66523e9a45d9982c0cb2001a1cd9_Out_2_Vector4);
                        float4 _Blend_d23b982fe8434a9ba42b28e9067ede89_Out_2_Vector4;
                        Unity_Blend_Dodge_float4(_Blend_22332064b1dd476eb955d1e6f0d31893_Out_2_Vector4, _Add_160a66523e9a45d9982c0cb2001a1cd9_Out_2_Vector4, _Blend_d23b982fe8434a9ba42b28e9067ede89_Out_2_Vector4, 0);
                        UnityTexture2D _Property_2296a933b1a044b889041aa853a7f13a_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_FlareLayer);
                        float _Property_782a0df3d6284fabae7e7ac9130de612_Out_0_Float = _Tile_X_Flare;
                        float _Property_cab0217c4db14cb08c0c11fd45bf24d0_Out_0_Float = _Tile_Y_Flare;
                        float2 _Vector2_1952ea97bee3429381dad80e93776ec2_Out_0_Vector2 = float2(_Property_782a0df3d6284fabae7e7ac9130de612_Out_0_Float, _Property_cab0217c4db14cb08c0c11fd45bf24d0_Out_0_Float);
                        float _Property_aed1ddb6d9a5427580bc310dd089f919_Out_0_Float = _Flare_Speed;
                        float _Multiply_4b4bff5c45e140bca122d3c80dc22ea7_Out_2_Float;
                        Unity_Multiply_float_float(IN.TimeParameters.x, _Property_aed1ddb6d9a5427580bc310dd089f919_Out_0_Float, _Multiply_4b4bff5c45e140bca122d3c80dc22ea7_Out_2_Float);
                        float2 _Vector2_2565b1496cd443f6b1ba17365aa447da_Out_0_Vector2 = float2(0.57, _Multiply_4b4bff5c45e140bca122d3c80dc22ea7_Out_2_Float);
                        float4 _UV_6593fae6f24d472d8d9e543f8a171b90_Out_0_Vector4 = IN.uv0;
                        float4 _Add_f71da7687c2d4a81ad17d32ca6b91452_Out_2_Vector4;
                        Unity_Add_float4((_Multiply_4b4bff5c45e140bca122d3c80dc22ea7_Out_2_Float.xxxx), _UV_6593fae6f24d472d8d9e543f8a171b90_Out_0_Vector4, _Add_f71da7687c2d4a81ad17d32ca6b91452_Out_2_Vector4);
                        float _GradientNoise_c42c53c8620e444eb353533ecb9dbac5_Out_2_Float;
                        Unity_GradientNoise_LegacyMod_float((_Add_f71da7687c2d4a81ad17d32ca6b91452_Out_2_Vector4.xy), 10, _GradientNoise_c42c53c8620e444eb353533ecb9dbac5_Out_2_Float);
                        float _Property_c5fe4c7886864818a6634886e951c3cd_Out_0_Float = _Flare_Noise;
                        float3 _NormalFromHeight_aac2a418455049acb09867e85f9521d4_Out_1_Vector3;
                        float3x3 _NormalFromHeight_aac2a418455049acb09867e85f9521d4_TangentMatrix = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
                        float3 _NormalFromHeight_aac2a418455049acb09867e85f9521d4_Position = IN.WorldSpacePosition;
                        Unity_NormalFromHeight_Tangent_float(_GradientNoise_c42c53c8620e444eb353533ecb9dbac5_Out_2_Float,_Property_c5fe4c7886864818a6634886e951c3cd_Out_0_Float,_NormalFromHeight_aac2a418455049acb09867e85f9521d4_Position,_NormalFromHeight_aac2a418455049acb09867e85f9521d4_TangentMatrix, _NormalFromHeight_aac2a418455049acb09867e85f9521d4_Out_1_Vector3);
                        float _Float_3b8429aad5284fe6ad703abf61f73644_Out_0_Float = 0.05;
                        float3 _Multiply_e0bf4aabf4f046b6af7d6e72cfdb7fe7_Out_2_Vector3;
                        Unity_Multiply_float3_float3(_NormalFromHeight_aac2a418455049acb09867e85f9521d4_Out_1_Vector3, (_Float_3b8429aad5284fe6ad703abf61f73644_Out_0_Float.xxx), _Multiply_e0bf4aabf4f046b6af7d6e72cfdb7fe7_Out_2_Vector3);
                        float2 _Add_5a53b043f4a94542b971037a99a59c9d_Out_2_Vector2;
                        Unity_Add_float2(_Vector2_2565b1496cd443f6b1ba17365aa447da_Out_0_Vector2, (_Multiply_e0bf4aabf4f046b6af7d6e72cfdb7fe7_Out_2_Vector3.xy), _Add_5a53b043f4a94542b971037a99a59c9d_Out_2_Vector2);
                        float2 _TilingAndOffset_f850fca5d6c14dd4af26c36689f98822_Out_3_Vector2;
                        Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_1952ea97bee3429381dad80e93776ec2_Out_0_Vector2, _Add_5a53b043f4a94542b971037a99a59c9d_Out_2_Vector2, _TilingAndOffset_f850fca5d6c14dd4af26c36689f98822_Out_3_Vector2);
                        float4 _SampleTexture2D_16d53b57feef4457b6511a222279c4c2_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_2296a933b1a044b889041aa853a7f13a_Out_0_Texture2D.tex, _Property_2296a933b1a044b889041aa853a7f13a_Out_0_Texture2D.samplerstate, _Property_2296a933b1a044b889041aa853a7f13a_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_f850fca5d6c14dd4af26c36689f98822_Out_3_Vector2));
                        float _SampleTexture2D_16d53b57feef4457b6511a222279c4c2_R_4_Float = _SampleTexture2D_16d53b57feef4457b6511a222279c4c2_RGBA_0_Vector4.r;
                        float _SampleTexture2D_16d53b57feef4457b6511a222279c4c2_G_5_Float = _SampleTexture2D_16d53b57feef4457b6511a222279c4c2_RGBA_0_Vector4.g;
                        float _SampleTexture2D_16d53b57feef4457b6511a222279c4c2_B_6_Float = _SampleTexture2D_16d53b57feef4457b6511a222279c4c2_RGBA_0_Vector4.b;
                        float _SampleTexture2D_16d53b57feef4457b6511a222279c4c2_A_7_Float = _SampleTexture2D_16d53b57feef4457b6511a222279c4c2_RGBA_0_Vector4.a;
                        UnityTexture2D _Property_daed62fc7e254f5291f7e8d4b4d36cc8_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_FlareLayerMask);
                        float4 _SampleTexture2D_f771449173f64fea8fadc2f2470df5a2_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_daed62fc7e254f5291f7e8d4b4d36cc8_Out_0_Texture2D.tex, _Property_daed62fc7e254f5291f7e8d4b4d36cc8_Out_0_Texture2D.samplerstate, _Property_daed62fc7e254f5291f7e8d4b4d36cc8_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy));
                        float _SampleTexture2D_f771449173f64fea8fadc2f2470df5a2_R_4_Float = _SampleTexture2D_f771449173f64fea8fadc2f2470df5a2_RGBA_0_Vector4.r;
                        float _SampleTexture2D_f771449173f64fea8fadc2f2470df5a2_G_5_Float = _SampleTexture2D_f771449173f64fea8fadc2f2470df5a2_RGBA_0_Vector4.g;
                        float _SampleTexture2D_f771449173f64fea8fadc2f2470df5a2_B_6_Float = _SampleTexture2D_f771449173f64fea8fadc2f2470df5a2_RGBA_0_Vector4.b;
                        float _SampleTexture2D_f771449173f64fea8fadc2f2470df5a2_A_7_Float = _SampleTexture2D_f771449173f64fea8fadc2f2470df5a2_RGBA_0_Vector4.a;
                        float4 _Multiply_ee41795c0bae447793edbbf2ad5d1905_Out_2_Vector4;
                        Unity_Multiply_float4_float4(_SampleTexture2D_16d53b57feef4457b6511a222279c4c2_RGBA_0_Vector4, _SampleTexture2D_f771449173f64fea8fadc2f2470df5a2_RGBA_0_Vector4, _Multiply_ee41795c0bae447793edbbf2ad5d1905_Out_2_Vector4);
                        float4 _Blend_2dd7dae929b34fe9b21b4b787d2ad749_Out_2_Vector4;
                        Unity_Blend_Screen_float4(_Blend_d23b982fe8434a9ba42b28e9067ede89_Out_2_Vector4, _Multiply_ee41795c0bae447793edbbf2ad5d1905_Out_2_Vector4, _Blend_2dd7dae929b34fe9b21b4b787d2ad749_Out_2_Vector4, 1);
                        UnityTexture2D _Property_2ceed6d28ce340449e7fbb66d0aff7e3_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(NormalMap);
                        float4 _SampleTexture2D_58392379a8634d4f86fe10f033d789c0_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_2ceed6d28ce340449e7fbb66d0aff7e3_Out_0_Texture2D.tex, _Property_2ceed6d28ce340449e7fbb66d0aff7e3_Out_0_Texture2D.samplerstate, _Property_2ceed6d28ce340449e7fbb66d0aff7e3_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy));
                        _SampleTexture2D_58392379a8634d4f86fe10f033d789c0_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_58392379a8634d4f86fe10f033d789c0_RGBA_0_Vector4);
                        float _SampleTexture2D_58392379a8634d4f86fe10f033d789c0_R_4_Float = _SampleTexture2D_58392379a8634d4f86fe10f033d789c0_RGBA_0_Vector4.r;
                        float _SampleTexture2D_58392379a8634d4f86fe10f033d789c0_G_5_Float = _SampleTexture2D_58392379a8634d4f86fe10f033d789c0_RGBA_0_Vector4.g;
                        float _SampleTexture2D_58392379a8634d4f86fe10f033d789c0_B_6_Float = _SampleTexture2D_58392379a8634d4f86fe10f033d789c0_RGBA_0_Vector4.b;
                        float _SampleTexture2D_58392379a8634d4f86fe10f033d789c0_A_7_Float = _SampleTexture2D_58392379a8634d4f86fe10f033d789c0_RGBA_0_Vector4.a;
                        float _Property_429252a545ea49e180d470c51c2ced1f_Out_0_Float = _Normal_Strength;
                        float3 _NormalStrength_89cd7be49bc94135bca418619f4f209c_Out_2_Vector3;
                        Unity_NormalStrength_float((_SampleTexture2D_58392379a8634d4f86fe10f033d789c0_RGBA_0_Vector4.xyz), _Property_429252a545ea49e180d470c51c2ced1f_Out_0_Float, _NormalStrength_89cd7be49bc94135bca418619f4f209c_Out_2_Vector3);
                        UnityTexture2D _Property_94b557a5cefd4f1cb9f8b7647e8d8d0b_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_FirstLayer);
                        float _Float_df56ec6f904545a8a767a7ba3c5dd15c_Out_0_Float = 2;
                        float3 _Multiply_fae8425b844f415b9edd050b6279c2ac_Out_2_Vector3;
                        Unity_Multiply_float3_float3((_Float_df56ec6f904545a8a767a7ba3c5dd15c_Out_0_Float.xxx), IN.TangentSpaceViewDirection, _Multiply_fae8425b844f415b9edd050b6279c2ac_Out_2_Vector3);
                        float2 _TilingAndOffset_b36424444c844f9fa22ddbb420625641_Out_3_Vector2;
                        Unity_TilingAndOffset_float(IN.uv0.xy, (_Multiply_fae8425b844f415b9edd050b6279c2ac_Out_2_Vector3.xy), (_Multiply_fae8425b844f415b9edd050b6279c2ac_Out_2_Vector3.xy), _TilingAndOffset_b36424444c844f9fa22ddbb420625641_Out_3_Vector2);
                        float4 _SampleTexture2D_600ebfe1de5d4c789cf5d509e767528c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_94b557a5cefd4f1cb9f8b7647e8d8d0b_Out_0_Texture2D.tex, _Property_94b557a5cefd4f1cb9f8b7647e8d8d0b_Out_0_Texture2D.samplerstate, _Property_94b557a5cefd4f1cb9f8b7647e8d8d0b_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_b36424444c844f9fa22ddbb420625641_Out_3_Vector2));
                        float _SampleTexture2D_600ebfe1de5d4c789cf5d509e767528c_R_4_Float = _SampleTexture2D_600ebfe1de5d4c789cf5d509e767528c_RGBA_0_Vector4.r;
                        float _SampleTexture2D_600ebfe1de5d4c789cf5d509e767528c_G_5_Float = _SampleTexture2D_600ebfe1de5d4c789cf5d509e767528c_RGBA_0_Vector4.g;
                        float _SampleTexture2D_600ebfe1de5d4c789cf5d509e767528c_B_6_Float = _SampleTexture2D_600ebfe1de5d4c789cf5d509e767528c_RGBA_0_Vector4.b;
                        float _SampleTexture2D_600ebfe1de5d4c789cf5d509e767528c_A_7_Float = _SampleTexture2D_600ebfe1de5d4c789cf5d509e767528c_RGBA_0_Vector4.a;
                        UnityTexture2D _Property_9ed80af81ecf433682e8492e8eda6983_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_FirstLayerMask);
                        float4 _SampleTexture2D_9fea3c05c65144bbabad6ef4512b2893_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_9ed80af81ecf433682e8492e8eda6983_Out_0_Texture2D.tex, _Property_9ed80af81ecf433682e8492e8eda6983_Out_0_Texture2D.samplerstate, _Property_9ed80af81ecf433682e8492e8eda6983_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy));
                        float _SampleTexture2D_9fea3c05c65144bbabad6ef4512b2893_R_4_Float = _SampleTexture2D_9fea3c05c65144bbabad6ef4512b2893_RGBA_0_Vector4.r;
                        float _SampleTexture2D_9fea3c05c65144bbabad6ef4512b2893_G_5_Float = _SampleTexture2D_9fea3c05c65144bbabad6ef4512b2893_RGBA_0_Vector4.g;
                        float _SampleTexture2D_9fea3c05c65144bbabad6ef4512b2893_B_6_Float = _SampleTexture2D_9fea3c05c65144bbabad6ef4512b2893_RGBA_0_Vector4.b;
                        float _SampleTexture2D_9fea3c05c65144bbabad6ef4512b2893_A_7_Float = _SampleTexture2D_9fea3c05c65144bbabad6ef4512b2893_RGBA_0_Vector4.a;
                        float4 _Multiply_00741ec509bb44e6b7c015c8afbd6f7b_Out_2_Vector4;
                        Unity_Multiply_float4_float4(_SampleTexture2D_600ebfe1de5d4c789cf5d509e767528c_RGBA_0_Vector4, _SampleTexture2D_9fea3c05c65144bbabad6ef4512b2893_RGBA_0_Vector4, _Multiply_00741ec509bb44e6b7c015c8afbd6f7b_Out_2_Vector4);
                        float _Property_d2a734d059ac4cdeacd546c3e4762220_Out_0_Float = _FirstLayer_Still_Opacity;
                        float _Float_4766b030743f4cbd8fcaf0ed448ca5d6_Out_0_Float = _Property_d2a734d059ac4cdeacd546c3e4762220_Out_0_Float;
                        float4 _Multiply_0d830f9ef3c74258a1fc4b496e551f55_Out_2_Vector4;
                        Unity_Multiply_float4_float4(_Multiply_00741ec509bb44e6b7c015c8afbd6f7b_Out_2_Vector4, (_Float_4766b030743f4cbd8fcaf0ed448ca5d6_Out_0_Float.xxxx), _Multiply_0d830f9ef3c74258a1fc4b496e551f55_Out_2_Vector4);
                        float _Property_2f0100c28b754ef7ad75f264ce26809b_Out_0_Float = _Layers_Opacity;
                        float _Float_464854d505d5400d94c46694778bb7e8_Out_0_Float = _Property_2f0100c28b754ef7ad75f264ce26809b_Out_0_Float;
                        UnityTexture2D _Property_11854fc2ac5e4f94a4d83e9f568c610e_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Edge_Emission);
                        float4 _SampleTexture2D_cd98119a8c1d4215b57d6099759b389d_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_11854fc2ac5e4f94a4d83e9f568c610e_Out_0_Texture2D.tex, _Property_11854fc2ac5e4f94a4d83e9f568c610e_Out_0_Texture2D.samplerstate, _Property_11854fc2ac5e4f94a4d83e9f568c610e_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy));
                        float _SampleTexture2D_cd98119a8c1d4215b57d6099759b389d_R_4_Float = _SampleTexture2D_cd98119a8c1d4215b57d6099759b389d_RGBA_0_Vector4.r;
                        float _SampleTexture2D_cd98119a8c1d4215b57d6099759b389d_G_5_Float = _SampleTexture2D_cd98119a8c1d4215b57d6099759b389d_RGBA_0_Vector4.g;
                        float _SampleTexture2D_cd98119a8c1d4215b57d6099759b389d_B_6_Float = _SampleTexture2D_cd98119a8c1d4215b57d6099759b389d_RGBA_0_Vector4.b;
                        float _SampleTexture2D_cd98119a8c1d4215b57d6099759b389d_A_7_Float = _SampleTexture2D_cd98119a8c1d4215b57d6099759b389d_RGBA_0_Vector4.a;
                        float4 _Add_b9699c2cea3a4e91aaee5df460966234_Out_2_Vector4;
                        Unity_Add_float4(_Add_160a66523e9a45d9982c0cb2001a1cd9_Out_2_Vector4, _SampleTexture2D_cd98119a8c1d4215b57d6099759b389d_RGBA_0_Vector4, _Add_b9699c2cea3a4e91aaee5df460966234_Out_2_Vector4);
                        float4 _Multiply_46c4d7cd5f3b4d8ea76dac8b7549e4d2_Out_2_Vector4;
                        Unity_Multiply_float4_float4((_Float_464854d505d5400d94c46694778bb7e8_Out_0_Float.xxxx), _Add_b9699c2cea3a4e91aaee5df460966234_Out_2_Vector4, _Multiply_46c4d7cd5f3b4d8ea76dac8b7549e4d2_Out_2_Vector4);
                        float4 _Remap_a3b4ca48973f445fb1acf58ec78cdbed_Out_3_Vector4;
                        Unity_Remap_float4(_Multiply_ee41795c0bae447793edbbf2ad5d1905_Out_2_Vector4, float2 (-1, 1), float2 (-1, 1.02), _Remap_a3b4ca48973f445fb1acf58ec78cdbed_Out_3_Vector4);
                        float _Float_20e389ee74214f3ab347f86ca4b66d9e_Out_0_Float = 0.25;
                        float4 _Multiply_b40f8c2975ce41108df7579646a56b80_Out_2_Vector4;
                        Unity_Multiply_float4_float4(_Remap_a3b4ca48973f445fb1acf58ec78cdbed_Out_3_Vector4, (_Float_20e389ee74214f3ab347f86ca4b66d9e_Out_0_Float.xxxx), _Multiply_b40f8c2975ce41108df7579646a56b80_Out_2_Vector4);
                        float4 _Add_f1dab00885fc4aaaa6c73e04985ad9a8_Out_2_Vector4;
                        Unity_Add_float4(_Multiply_46c4d7cd5f3b4d8ea76dac8b7549e4d2_Out_2_Vector4, _Multiply_b40f8c2975ce41108df7579646a56b80_Out_2_Vector4, _Add_f1dab00885fc4aaaa6c73e04985ad9a8_Out_2_Vector4);
                        float4 _Add_ec1895b218b94d6eb89e1acdc29d14bf_Out_2_Vector4;
                        Unity_Add_float4(_Multiply_0d830f9ef3c74258a1fc4b496e551f55_Out_2_Vector4, _Add_f1dab00885fc4aaaa6c73e04985ad9a8_Out_2_Vector4, _Add_ec1895b218b94d6eb89e1acdc29d14bf_Out_2_Vector4);
                        float _Property_020a39e9b25e4032b4e8beba87e6bbc6_Out_0_Float = Metallic;
                        float _Property_a93c035743944b7bad1ea38a1551869e_Out_0_Float = Smoothness;
                        surface.BaseColor = (_Blend_2dd7dae929b34fe9b21b4b787d2ad749_Out_2_Vector4.xyz);
                        surface.NormalTS = _NormalStrength_89cd7be49bc94135bca418619f4f209c_Out_2_Vector3;
                        surface.Emission = (_Add_ec1895b218b94d6eb89e1acdc29d14bf_Out_2_Vector4.xyz);
                        surface.Metallic = _Property_020a39e9b25e4032b4e8beba87e6bbc6_Out_0_Float;
                        surface.Smoothness = _Property_a93c035743944b7bad1ea38a1551869e_Out_0_Float;
                        surface.Occlusion = 0;
                        surface.Alpha = 1;
                        surface.AlphaClipThreshold = 0.5;
                        return surface;
                    }

                    // --------------------------------------------------
                    // Build Graph Inputs
                    #ifdef HAVE_VFX_MODIFICATION
                    #define VFX_SRP_ATTRIBUTES Attributes
                    #define VFX_SRP_VARYINGS Varyings
                    #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
                    #endif
                    VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                    {
                        VertexDescriptionInputs output;
                        ZERO_INITIALIZE(VertexDescriptionInputs, output);

                        output.ObjectSpaceNormal = input.normalOS;
                        output.ObjectSpaceTangent = input.tangentOS.xyz;
                        output.ObjectSpacePosition = input.positionOS;

                        return output;
                    }
                    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                    {
                        SurfaceDescriptionInputs output;
                        ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

                    #ifdef HAVE_VFX_MODIFICATION
                    #if VFX_USE_GRAPH_VALUES
                        uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
                        /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
                    #endif
                        /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

                    #endif



                        // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
                        float3 unnormalizedNormalWS = input.normalWS;
                        const float renormFactor = 1.0 / length(unnormalizedNormalWS);

                        // use bitangent on the fly like in hdrp
                        // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
                        float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0) * GetOddNegativeScale();
                        float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);

                        output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
                        output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);

                        // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
                        // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
                        output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
                        output.WorldSpaceBiTangent = renormFactor * bitang;

                        output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
                        float3x3 tangentSpaceTransform = float3x3(output.WorldSpaceTangent, output.WorldSpaceBiTangent, output.WorldSpaceNormal);
                        output.TangentSpaceViewDirection = mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                        output.WorldSpacePosition = input.positionWS;

                        #if UNITY_UV_STARTS_AT_TOP
                        #else
                        #endif


                        output.uv0 = input.texCoord0;
                        output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                    #else
                    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                    #endif
                    #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

                            return output;
                    }

                    // --------------------------------------------------
                    // Main

                    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
                    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityGBuffer.hlsl"
                    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRGBufferPass.hlsl"

                    // --------------------------------------------------
                    // Visual Effect Vertex Invocations
                    #ifdef HAVE_VFX_MODIFICATION
                    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
                    #endif

                    ENDHLSL
                    }
                    Pass
                    {
                        Name "DepthOnly"
                        Tags
                        {
                            "LightMode" = "DepthOnly"
                        }

                        // Render State
                        Cull Off
                        ZTest LEqual
                        ZWrite On
                        ColorMask R

                        // Debug
                        // <None>

                        // --------------------------------------------------
                        // Pass

                        HLSLPROGRAM

                        // Pragmas
                        #pragma target 2.0
                        #pragma multi_compile_instancing
                        #pragma vertex vert
                        #pragma fragment frag

                        // Keywords
                        // PassKeywords: <None>
                        // GraphKeywords: <None>

                        // Defines

                        #define _NORMALMAP 1
                        #define _NORMAL_DROPOFF_TS 1
                        #define ATTRIBUTES_NEED_NORMAL
                        #define ATTRIBUTES_NEED_TANGENT
                        #define FEATURES_GRAPH_VERTEX
                        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
                        #define SHADERPASS SHADERPASS_DEPTHONLY
                        #define _ALPHATEST_ON 1
                        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */


                        // custom interpolator pre-include
                        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

                        // Includes
                        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
                        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
                        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
                        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

                        // --------------------------------------------------
                        // Structs and Packing

                        // custom interpolators pre packing
                        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

                        struct Attributes
                        {
                             float3 positionOS : POSITION;
                             float3 normalOS : NORMAL;
                             float4 tangentOS : TANGENT;
                            #if UNITY_ANY_INSTANCING_ENABLED
                             uint instanceID : INSTANCEID_SEMANTIC;
                            #endif
                        };
                        struct Varyings
                        {
                             float4 positionCS : SV_POSITION;
                            #if UNITY_ANY_INSTANCING_ENABLED
                             uint instanceID : CUSTOM_INSTANCE_ID;
                            #endif
                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                            #endif
                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                            #endif
                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                            #endif
                        };
                        struct SurfaceDescriptionInputs
                        {
                        };
                        struct VertexDescriptionInputs
                        {
                             float3 ObjectSpaceNormal;
                             float3 ObjectSpaceTangent;
                             float3 ObjectSpacePosition;
                        };
                        struct PackedVaryings
                        {
                             float4 positionCS : SV_POSITION;
                            #if UNITY_ANY_INSTANCING_ENABLED
                             uint instanceID : CUSTOM_INSTANCE_ID;
                            #endif
                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                            #endif
                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                            #endif
                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                            #endif
                        };

                        PackedVaryings PackVaryings(Varyings input)
                        {
                            PackedVaryings output;
                            ZERO_INITIALIZE(PackedVaryings, output);
                            output.positionCS = input.positionCS;
                            #if UNITY_ANY_INSTANCING_ENABLED
                            output.instanceID = input.instanceID;
                            #endif
                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                            #endif
                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                            #endif
                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                            output.cullFace = input.cullFace;
                            #endif
                            return output;
                        }

                        Varyings UnpackVaryings(PackedVaryings input)
                        {
                            Varyings output;
                            output.positionCS = input.positionCS;
                            #if UNITY_ANY_INSTANCING_ENABLED
                            output.instanceID = input.instanceID;
                            #endif
                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                            #endif
                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                            #endif
                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                            output.cullFace = input.cullFace;
                            #endif
                            return output;
                        }


                        // --------------------------------------------------
                        // Graph

                        // Graph Properties
                        CBUFFER_START(UnityPerMaterial)
                        float4 MainTexture_TexelSize;
                        float4 NormalMap_TexelSize;
                        float _Normal_Strength;
                        float _SecondLayer_Speed;
                        float _Tile_X_Flare;
                        float _Tile_Y_Flare;
                        float _Layers_Opacity;
                        float _Tile_X_2;
                        float _Tile_Y_2;
                        float _Tile_Y;
                        float Metallic;
                        float Smoothness;
                        float _Flare_Speed;
                        float _FirstLayer_Speed;
                        float4 _Color;
                        float4 _Edge_Emission_TexelSize;
                        float4 _FirstLayer_TexelSize;
                        float4 _FirstLayerMask_TexelSize;
                        float4 _FlareLayer_TexelSize;
                        float4 _FlareLayerMask_TexelSize;
                        float4 _SecondLayer_TexelSize;
                        float4 _SecondLayerMask_TexelSize;
                        float _Flare_Noise;
                        float _FirstLayer_Still_Opacity;
                        float _Tile_X;
                        CBUFFER_END


                            // Object and Global properties
                            SAMPLER(SamplerState_Linear_Repeat);
                            TEXTURE2D(MainTexture);
                            SAMPLER(samplerMainTexture);
                            TEXTURE2D(NormalMap);
                            SAMPLER(samplerNormalMap);
                            TEXTURE2D(_Edge_Emission);
                            SAMPLER(sampler_Edge_Emission);
                            TEXTURE2D(_FirstLayer);
                            SAMPLER(sampler_FirstLayer);
                            TEXTURE2D(_FirstLayerMask);
                            SAMPLER(sampler_FirstLayerMask);
                            TEXTURE2D(_FlareLayer);
                            SAMPLER(sampler_FlareLayer);
                            TEXTURE2D(_FlareLayerMask);
                            SAMPLER(sampler_FlareLayerMask);
                            TEXTURE2D(_SecondLayer);
                            SAMPLER(sampler_SecondLayer);
                            TEXTURE2D(_SecondLayerMask);
                            SAMPLER(sampler_SecondLayerMask);

                            // Graph Includes
                            // GraphIncludes: <None>

                            // -- Property used by ScenePickingPass
                            #ifdef SCENEPICKINGPASS
                            float4 _SelectionID;
                            #endif

                            // -- Properties used by SceneSelectionPass
                            #ifdef SCENESELECTIONPASS
                            int _ObjectId;
                            int _PassValue;
                            #endif

                            // Graph Functions
                            // GraphFunctions: <None>

                            // Custom interpolators pre vertex
                            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

                            // Graph Vertex
                            struct VertexDescription
                            {
                                float3 Position;
                                float3 Normal;
                                float3 Tangent;
                            };

                            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                            {
                                VertexDescription description = (VertexDescription)0;
                                description.Position = IN.ObjectSpacePosition;
                                description.Normal = IN.ObjectSpaceNormal;
                                description.Tangent = IN.ObjectSpaceTangent;
                                return description;
                            }

                            // Custom interpolators, pre surface
                            #ifdef FEATURES_GRAPH_VERTEX
                            Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
                            {
                            return output;
                            }
                            #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
                            #endif

                            // Graph Pixel
                            struct SurfaceDescription
                            {
                                float Alpha;
                                float AlphaClipThreshold;
                            };

                            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                            {
                                SurfaceDescription surface = (SurfaceDescription)0;
                                surface.Alpha = 1;
                                surface.AlphaClipThreshold = 0.5;
                                return surface;
                            }

                            // --------------------------------------------------
                            // Build Graph Inputs
                            #ifdef HAVE_VFX_MODIFICATION
                            #define VFX_SRP_ATTRIBUTES Attributes
                            #define VFX_SRP_VARYINGS Varyings
                            #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
                            #endif
                            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                            {
                                VertexDescriptionInputs output;
                                ZERO_INITIALIZE(VertexDescriptionInputs, output);

                                output.ObjectSpaceNormal = input.normalOS;
                                output.ObjectSpaceTangent = input.tangentOS.xyz;
                                output.ObjectSpacePosition = input.positionOS;

                                return output;
                            }
                            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                            {
                                SurfaceDescriptionInputs output;
                                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

                            #ifdef HAVE_VFX_MODIFICATION
                            #if VFX_USE_GRAPH_VALUES
                                uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
                                /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
                            #endif
                                /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

                            #endif








                                #if UNITY_UV_STARTS_AT_TOP
                                #else
                                #endif


                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                            #else
                            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                            #endif
                            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

                                    return output;
                            }

                            // --------------------------------------------------
                            // Main

                            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
                            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

                            // --------------------------------------------------
                            // Visual Effect Vertex Invocations
                            #ifdef HAVE_VFX_MODIFICATION
                            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
                            #endif

                            ENDHLSL
                            }
                            Pass
                            {
                                Name "DepthNormals"
                                Tags
                                {
                                    "LightMode" = "DepthNormals"
                                }

                                // Render State
                                Cull Off
                                ZTest LEqual
                                ZWrite On

                                // Debug
                                // <None>

                                // --------------------------------------------------
                                // Pass

                                HLSLPROGRAM

                                // Pragmas
                                #pragma target 2.0
                                #pragma multi_compile_instancing
                                #pragma vertex vert
                                #pragma fragment frag

                                // Keywords
                                // PassKeywords: <None>
                                // GraphKeywords: <None>

                                // Defines

                                #define _NORMALMAP 1
                                #define _NORMAL_DROPOFF_TS 1
                                #define ATTRIBUTES_NEED_NORMAL
                                #define ATTRIBUTES_NEED_TANGENT
                                #define ATTRIBUTES_NEED_TEXCOORD0
                                #define ATTRIBUTES_NEED_TEXCOORD1
                                #define VARYINGS_NEED_NORMAL_WS
                                #define VARYINGS_NEED_TANGENT_WS
                                #define VARYINGS_NEED_TEXCOORD0
                                #define FEATURES_GRAPH_VERTEX
                                /* WARNING: $splice Could not find named fragment 'PassInstancing' */
                                #define SHADERPASS SHADERPASS_DEPTHNORMALS
                                #define _ALPHATEST_ON 1
                                /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */


                                // custom interpolator pre-include
                                /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

                                // Includes
                                #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
                                #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
                                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
                                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
                                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
                                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
                                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

                                // --------------------------------------------------
                                // Structs and Packing

                                // custom interpolators pre packing
                                /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

                                struct Attributes
                                {
                                     float3 positionOS : POSITION;
                                     float3 normalOS : NORMAL;
                                     float4 tangentOS : TANGENT;
                                     float4 uv0 : TEXCOORD0;
                                     float4 uv1 : TEXCOORD1;
                                    #if UNITY_ANY_INSTANCING_ENABLED
                                     uint instanceID : INSTANCEID_SEMANTIC;
                                    #endif
                                };
                                struct Varyings
                                {
                                     float4 positionCS : SV_POSITION;
                                     float3 normalWS;
                                     float4 tangentWS;
                                     float4 texCoord0;
                                    #if UNITY_ANY_INSTANCING_ENABLED
                                     uint instanceID : CUSTOM_INSTANCE_ID;
                                    #endif
                                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                    #endif
                                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                    #endif
                                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                    #endif
                                };
                                struct SurfaceDescriptionInputs
                                {
                                     float3 TangentSpaceNormal;
                                     float4 uv0;
                                };
                                struct VertexDescriptionInputs
                                {
                                     float3 ObjectSpaceNormal;
                                     float3 ObjectSpaceTangent;
                                     float3 ObjectSpacePosition;
                                };
                                struct PackedVaryings
                                {
                                     float4 positionCS : SV_POSITION;
                                     float4 tangentWS : INTERP0;
                                     float4 texCoord0 : INTERP1;
                                     float3 normalWS : INTERP2;
                                    #if UNITY_ANY_INSTANCING_ENABLED
                                     uint instanceID : CUSTOM_INSTANCE_ID;
                                    #endif
                                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                    #endif
                                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                    #endif
                                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                    #endif
                                };

                                PackedVaryings PackVaryings(Varyings input)
                                {
                                    PackedVaryings output;
                                    ZERO_INITIALIZE(PackedVaryings, output);
                                    output.positionCS = input.positionCS;
                                    output.tangentWS.xyzw = input.tangentWS;
                                    output.texCoord0.xyzw = input.texCoord0;
                                    output.normalWS.xyz = input.normalWS;
                                    #if UNITY_ANY_INSTANCING_ENABLED
                                    output.instanceID = input.instanceID;
                                    #endif
                                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                    #endif
                                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                    #endif
                                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                    output.cullFace = input.cullFace;
                                    #endif
                                    return output;
                                }

                                Varyings UnpackVaryings(PackedVaryings input)
                                {
                                    Varyings output;
                                    output.positionCS = input.positionCS;
                                    output.tangentWS = input.tangentWS.xyzw;
                                    output.texCoord0 = input.texCoord0.xyzw;
                                    output.normalWS = input.normalWS.xyz;
                                    #if UNITY_ANY_INSTANCING_ENABLED
                                    output.instanceID = input.instanceID;
                                    #endif
                                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                    #endif
                                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                    #endif
                                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                    output.cullFace = input.cullFace;
                                    #endif
                                    return output;
                                }


                                // --------------------------------------------------
                                // Graph

                                // Graph Properties
                                CBUFFER_START(UnityPerMaterial)
                                float4 MainTexture_TexelSize;
                                float4 NormalMap_TexelSize;
                                float _Normal_Strength;
                                float _SecondLayer_Speed;
                                float _Tile_X_Flare;
                                float _Tile_Y_Flare;
                                float _Layers_Opacity;
                                float _Tile_X_2;
                                float _Tile_Y_2;
                                float _Tile_Y;
                                float Metallic;
                                float Smoothness;
                                float _Flare_Speed;
                                float _FirstLayer_Speed;
                                float4 _Color;
                                float4 _Edge_Emission_TexelSize;
                                float4 _FirstLayer_TexelSize;
                                float4 _FirstLayerMask_TexelSize;
                                float4 _FlareLayer_TexelSize;
                                float4 _FlareLayerMask_TexelSize;
                                float4 _SecondLayer_TexelSize;
                                float4 _SecondLayerMask_TexelSize;
                                float _Flare_Noise;
                                float _FirstLayer_Still_Opacity;
                                float _Tile_X;
                                CBUFFER_END


                                    // Object and Global properties
                                    SAMPLER(SamplerState_Linear_Repeat);
                                    TEXTURE2D(MainTexture);
                                    SAMPLER(samplerMainTexture);
                                    TEXTURE2D(NormalMap);
                                    SAMPLER(samplerNormalMap);
                                    TEXTURE2D(_Edge_Emission);
                                    SAMPLER(sampler_Edge_Emission);
                                    TEXTURE2D(_FirstLayer);
                                    SAMPLER(sampler_FirstLayer);
                                    TEXTURE2D(_FirstLayerMask);
                                    SAMPLER(sampler_FirstLayerMask);
                                    TEXTURE2D(_FlareLayer);
                                    SAMPLER(sampler_FlareLayer);
                                    TEXTURE2D(_FlareLayerMask);
                                    SAMPLER(sampler_FlareLayerMask);
                                    TEXTURE2D(_SecondLayer);
                                    SAMPLER(sampler_SecondLayer);
                                    TEXTURE2D(_SecondLayerMask);
                                    SAMPLER(sampler_SecondLayerMask);

                                    // Graph Includes
                                    // GraphIncludes: <None>

                                    // -- Property used by ScenePickingPass
                                    #ifdef SCENEPICKINGPASS
                                    float4 _SelectionID;
                                    #endif

                                    // -- Properties used by SceneSelectionPass
                                    #ifdef SCENESELECTIONPASS
                                    int _ObjectId;
                                    int _PassValue;
                                    #endif

                                    // Graph Functions

                                    void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
                                    {
                                        Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
                                    }

                                    // Custom interpolators pre vertex
                                    /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

                                    // Graph Vertex
                                    struct VertexDescription
                                    {
                                        float3 Position;
                                        float3 Normal;
                                        float3 Tangent;
                                    };

                                    VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                                    {
                                        VertexDescription description = (VertexDescription)0;
                                        description.Position = IN.ObjectSpacePosition;
                                        description.Normal = IN.ObjectSpaceNormal;
                                        description.Tangent = IN.ObjectSpaceTangent;
                                        return description;
                                    }

                                    // Custom interpolators, pre surface
                                    #ifdef FEATURES_GRAPH_VERTEX
                                    Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
                                    {
                                    return output;
                                    }
                                    #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
                                    #endif

                                    // Graph Pixel
                                    struct SurfaceDescription
                                    {
                                        float3 NormalTS;
                                        float Alpha;
                                        float AlphaClipThreshold;
                                    };

                                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                                    {
                                        SurfaceDescription surface = (SurfaceDescription)0;
                                        UnityTexture2D _Property_2ceed6d28ce340449e7fbb66d0aff7e3_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(NormalMap);
                                        float4 _SampleTexture2D_58392379a8634d4f86fe10f033d789c0_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_2ceed6d28ce340449e7fbb66d0aff7e3_Out_0_Texture2D.tex, _Property_2ceed6d28ce340449e7fbb66d0aff7e3_Out_0_Texture2D.samplerstate, _Property_2ceed6d28ce340449e7fbb66d0aff7e3_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy));
                                        _SampleTexture2D_58392379a8634d4f86fe10f033d789c0_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_58392379a8634d4f86fe10f033d789c0_RGBA_0_Vector4);
                                        float _SampleTexture2D_58392379a8634d4f86fe10f033d789c0_R_4_Float = _SampleTexture2D_58392379a8634d4f86fe10f033d789c0_RGBA_0_Vector4.r;
                                        float _SampleTexture2D_58392379a8634d4f86fe10f033d789c0_G_5_Float = _SampleTexture2D_58392379a8634d4f86fe10f033d789c0_RGBA_0_Vector4.g;
                                        float _SampleTexture2D_58392379a8634d4f86fe10f033d789c0_B_6_Float = _SampleTexture2D_58392379a8634d4f86fe10f033d789c0_RGBA_0_Vector4.b;
                                        float _SampleTexture2D_58392379a8634d4f86fe10f033d789c0_A_7_Float = _SampleTexture2D_58392379a8634d4f86fe10f033d789c0_RGBA_0_Vector4.a;
                                        float _Property_429252a545ea49e180d470c51c2ced1f_Out_0_Float = _Normal_Strength;
                                        float3 _NormalStrength_89cd7be49bc94135bca418619f4f209c_Out_2_Vector3;
                                        Unity_NormalStrength_float((_SampleTexture2D_58392379a8634d4f86fe10f033d789c0_RGBA_0_Vector4.xyz), _Property_429252a545ea49e180d470c51c2ced1f_Out_0_Float, _NormalStrength_89cd7be49bc94135bca418619f4f209c_Out_2_Vector3);
                                        surface.NormalTS = _NormalStrength_89cd7be49bc94135bca418619f4f209c_Out_2_Vector3;
                                        surface.Alpha = 1;
                                        surface.AlphaClipThreshold = 0.5;
                                        return surface;
                                    }

                                    // --------------------------------------------------
                                    // Build Graph Inputs
                                    #ifdef HAVE_VFX_MODIFICATION
                                    #define VFX_SRP_ATTRIBUTES Attributes
                                    #define VFX_SRP_VARYINGS Varyings
                                    #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
                                    #endif
                                    VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                                    {
                                        VertexDescriptionInputs output;
                                        ZERO_INITIALIZE(VertexDescriptionInputs, output);

                                        output.ObjectSpaceNormal = input.normalOS;
                                        output.ObjectSpaceTangent = input.tangentOS.xyz;
                                        output.ObjectSpacePosition = input.positionOS;

                                        return output;
                                    }
                                    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                                    {
                                        SurfaceDescriptionInputs output;
                                        ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

                                    #ifdef HAVE_VFX_MODIFICATION
                                    #if VFX_USE_GRAPH_VALUES
                                        uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
                                        /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
                                    #endif
                                        /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

                                    #endif





                                        output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);



                                        #if UNITY_UV_STARTS_AT_TOP
                                        #else
                                        #endif


                                        output.uv0 = input.texCoord0;
                                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                                    #else
                                    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                                    #endif
                                    #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

                                            return output;
                                    }

                                    // --------------------------------------------------
                                    // Main

                                    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
                                    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"

                                    // --------------------------------------------------
                                    // Visual Effect Vertex Invocations
                                    #ifdef HAVE_VFX_MODIFICATION
                                    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
                                    #endif

                                    ENDHLSL
                                    }
                                    Pass
                                    {
                                        Name "Meta"
                                        Tags
                                        {
                                            "LightMode" = "Meta"
                                        }

                                        // Render State
                                        Cull Off

                                        // Debug
                                        // <None>

                                        // --------------------------------------------------
                                        // Pass

                                        HLSLPROGRAM

                                        // Pragmas
                                        #pragma target 2.0
                                        #pragma vertex vert
                                        #pragma fragment frag

                                        // Keywords
                                        #pragma shader_feature _ EDITOR_VISUALIZATION
                                        // GraphKeywords: <None>

                                        // Defines

                                        #define _NORMALMAP 1
                                        #define _NORMAL_DROPOFF_TS 1
                                        #define ATTRIBUTES_NEED_NORMAL
                                        #define ATTRIBUTES_NEED_TANGENT
                                        #define ATTRIBUTES_NEED_TEXCOORD0
                                        #define ATTRIBUTES_NEED_TEXCOORD1
                                        #define ATTRIBUTES_NEED_TEXCOORD2
                                        #define VARYINGS_NEED_POSITION_WS
                                        #define VARYINGS_NEED_NORMAL_WS
                                        #define VARYINGS_NEED_TANGENT_WS
                                        #define VARYINGS_NEED_TEXCOORD0
                                        #define VARYINGS_NEED_TEXCOORD1
                                        #define VARYINGS_NEED_TEXCOORD2
                                        #define FEATURES_GRAPH_VERTEX
                                        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
                                        #define SHADERPASS SHADERPASS_META
                                        #define _FOG_FRAGMENT 1
                                        #define _ALPHATEST_ON 1
                                        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */


                                        // custom interpolator pre-include
                                        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

                                        // Includes
                                        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                                        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
                                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
                                        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
                                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
                                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
                                        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

                                        // --------------------------------------------------
                                        // Structs and Packing

                                        // custom interpolators pre packing
                                        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

                                        struct Attributes
                                        {
                                             float3 positionOS : POSITION;
                                             float3 normalOS : NORMAL;
                                             float4 tangentOS : TANGENT;
                                             float4 uv0 : TEXCOORD0;
                                             float4 uv1 : TEXCOORD1;
                                             float4 uv2 : TEXCOORD2;
                                            #if UNITY_ANY_INSTANCING_ENABLED
                                             uint instanceID : INSTANCEID_SEMANTIC;
                                            #endif
                                        };
                                        struct Varyings
                                        {
                                             float4 positionCS : SV_POSITION;
                                             float3 positionWS;
                                             float3 normalWS;
                                             float4 tangentWS;
                                             float4 texCoord0;
                                             float4 texCoord1;
                                             float4 texCoord2;
                                            #if UNITY_ANY_INSTANCING_ENABLED
                                             uint instanceID : CUSTOM_INSTANCE_ID;
                                            #endif
                                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                            #endif
                                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                            #endif
                                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                            #endif
                                        };
                                        struct SurfaceDescriptionInputs
                                        {
                                             float3 WorldSpaceNormal;
                                             float3 WorldSpaceTangent;
                                             float3 WorldSpaceBiTangent;
                                             float3 WorldSpaceViewDirection;
                                             float3 TangentSpaceViewDirection;
                                             float3 WorldSpacePosition;
                                             float4 uv0;
                                             float3 TimeParameters;
                                        };
                                        struct VertexDescriptionInputs
                                        {
                                             float3 ObjectSpaceNormal;
                                             float3 ObjectSpaceTangent;
                                             float3 ObjectSpacePosition;
                                        };
                                        struct PackedVaryings
                                        {
                                             float4 positionCS : SV_POSITION;
                                             float4 tangentWS : INTERP0;
                                             float4 texCoord0 : INTERP1;
                                             float4 texCoord1 : INTERP2;
                                             float4 texCoord2 : INTERP3;
                                             float3 positionWS : INTERP4;
                                             float3 normalWS : INTERP5;
                                            #if UNITY_ANY_INSTANCING_ENABLED
                                             uint instanceID : CUSTOM_INSTANCE_ID;
                                            #endif
                                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                            #endif
                                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                            #endif
                                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                            #endif
                                        };

                                        PackedVaryings PackVaryings(Varyings input)
                                        {
                                            PackedVaryings output;
                                            ZERO_INITIALIZE(PackedVaryings, output);
                                            output.positionCS = input.positionCS;
                                            output.tangentWS.xyzw = input.tangentWS;
                                            output.texCoord0.xyzw = input.texCoord0;
                                            output.texCoord1.xyzw = input.texCoord1;
                                            output.texCoord2.xyzw = input.texCoord2;
                                            output.positionWS.xyz = input.positionWS;
                                            output.normalWS.xyz = input.normalWS;
                                            #if UNITY_ANY_INSTANCING_ENABLED
                                            output.instanceID = input.instanceID;
                                            #endif
                                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                            #endif
                                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                            #endif
                                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                            output.cullFace = input.cullFace;
                                            #endif
                                            return output;
                                        }

                                        Varyings UnpackVaryings(PackedVaryings input)
                                        {
                                            Varyings output;
                                            output.positionCS = input.positionCS;
                                            output.tangentWS = input.tangentWS.xyzw;
                                            output.texCoord0 = input.texCoord0.xyzw;
                                            output.texCoord1 = input.texCoord1.xyzw;
                                            output.texCoord2 = input.texCoord2.xyzw;
                                            output.positionWS = input.positionWS.xyz;
                                            output.normalWS = input.normalWS.xyz;
                                            #if UNITY_ANY_INSTANCING_ENABLED
                                            output.instanceID = input.instanceID;
                                            #endif
                                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                            #endif
                                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                            #endif
                                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                            output.cullFace = input.cullFace;
                                            #endif
                                            return output;
                                        }


                                        // --------------------------------------------------
                                        // Graph

                                        // Graph Properties
                                        CBUFFER_START(UnityPerMaterial)
                                        float4 MainTexture_TexelSize;
                                        float4 NormalMap_TexelSize;
                                        float _Normal_Strength;
                                        float _SecondLayer_Speed;
                                        float _Tile_X_Flare;
                                        float _Tile_Y_Flare;
                                        float _Layers_Opacity;
                                        float _Tile_X_2;
                                        float _Tile_Y_2;
                                        float _Tile_Y;
                                        float Metallic;
                                        float Smoothness;
                                        float _Flare_Speed;
                                        float _FirstLayer_Speed;
                                        float4 _Color;
                                        float4 _Edge_Emission_TexelSize;
                                        float4 _FirstLayer_TexelSize;
                                        float4 _FirstLayerMask_TexelSize;
                                        float4 _FlareLayer_TexelSize;
                                        float4 _FlareLayerMask_TexelSize;
                                        float4 _SecondLayer_TexelSize;
                                        float4 _SecondLayerMask_TexelSize;
                                        float _Flare_Noise;
                                        float _FirstLayer_Still_Opacity;
                                        float _Tile_X;
                                        CBUFFER_END


                                            // Object and Global properties
                                            SAMPLER(SamplerState_Linear_Repeat);
                                            TEXTURE2D(MainTexture);
                                            SAMPLER(samplerMainTexture);
                                            TEXTURE2D(NormalMap);
                                            SAMPLER(samplerNormalMap);
                                            TEXTURE2D(_Edge_Emission);
                                            SAMPLER(sampler_Edge_Emission);
                                            TEXTURE2D(_FirstLayer);
                                            SAMPLER(sampler_FirstLayer);
                                            TEXTURE2D(_FirstLayerMask);
                                            SAMPLER(sampler_FirstLayerMask);
                                            TEXTURE2D(_FlareLayer);
                                            SAMPLER(sampler_FlareLayer);
                                            TEXTURE2D(_FlareLayerMask);
                                            SAMPLER(sampler_FlareLayerMask);
                                            TEXTURE2D(_SecondLayer);
                                            SAMPLER(sampler_SecondLayer);
                                            TEXTURE2D(_SecondLayerMask);
                                            SAMPLER(sampler_SecondLayerMask);

                                            // Graph Includes
                                            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"

                                            // -- Property used by ScenePickingPass
                                            #ifdef SCENEPICKINGPASS
                                            float4 _SelectionID;
                                            #endif

                                            // -- Properties used by SceneSelectionPass
                                            #ifdef SCENESELECTIONPASS
                                            int _ObjectId;
                                            int _PassValue;
                                            #endif

                                            // Graph Functions

                                            void Unity_Multiply_float_float(float A, float B, out float Out)
                                            {
                                                Out = A * B;
                                            }

                                            void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                                            {
                                                Out = UV * Tiling + Offset;
                                            }

                                            void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
                                            {
                                                Out = A * B;
                                            }

                                            void Unity_Blend_Dodge_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
                                            {
                                                Out = Base / (1.0 - clamp(Blend, 0.000001, 0.999999));
                                                Out = lerp(Base, Out, Opacity);
                                            }

                                            void Unity_Add_float4(float4 A, float4 B, out float4 Out)
                                            {
                                                Out = A + B;
                                            }

                                            float2 Unity_GradientNoise_LegacyMod_Dir_float(float2 p)
                                            {
                                                float x; Hash_LegacyMod_2_1_float(p, x);
                                                return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                                            }

                                            void Unity_GradientNoise_LegacyMod_float(float2 UV, float3 Scale, out float Out)
                                            {
                                                float2 p = UV * Scale.xy;
                                                float2 ip = floor(p);
                                                float2 fp = frac(p);
                                                float d00 = dot(Unity_GradientNoise_LegacyMod_Dir_float(ip), fp);
                                                float d01 = dot(Unity_GradientNoise_LegacyMod_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                                                float d10 = dot(Unity_GradientNoise_LegacyMod_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                                                float d11 = dot(Unity_GradientNoise_LegacyMod_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                                                fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                                                Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                                            }

                                            void Unity_NormalFromHeight_Tangent_float(float In, float Strength, float3 Position, float3x3 TangentMatrix, out float3 Out)
                                            {

                                                        #if defined(SHADER_STAGE_RAY_TRACING) && defined(RAYTRACING_SHADER_GRAPH_DEFAULT)
                                                        #error 'Normal From Height' node is not supported in ray tracing, please provide an alternate implementation, relying for instance on the 'Raytracing Quality' keyword
                                                        #endif
                                                float3 worldDerivativeX = ddx(Position);
                                                float3 worldDerivativeY = ddy(Position);

                                                float3 crossX = cross(TangentMatrix[2].xyz, worldDerivativeX);
                                                float3 crossY = cross(worldDerivativeY, TangentMatrix[2].xyz);
                                                float d = dot(worldDerivativeX, crossY);
                                                float sgn = d < 0.0 ? (-1.0f) : 1.0f;
                                                float surface = sgn / max(0.000000000000001192093f, abs(d));

                                                float dHdx = ddx(In);
                                                float dHdy = ddy(In);
                                                float3 surfGrad = surface * (dHdx * crossY + dHdy * crossX);
                                                Out = SafeNormalize(TangentMatrix[2].xyz - (Strength * surfGrad));
                                                Out = TransformWorldToTangent(Out, TangentMatrix);
                                            }

                                            void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
                                            {
                                                Out = A * B;
                                            }

                                            void Unity_Add_float2(float2 A, float2 B, out float2 Out)
                                            {
                                                Out = A + B;
                                            }

                                            void Unity_Blend_Screen_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
                                            {
                                                Out = 1.0 - (1.0 - Blend) * (1.0 - Base);
                                                Out = lerp(Base, Out, Opacity);
                                            }

                                            void Unity_Remap_float4(float4 In, float2 InMinMax, float2 OutMinMax, out float4 Out)
                                            {
                                                Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
                                            }

                                            // Custom interpolators pre vertex
                                            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

                                            // Graph Vertex
                                            struct VertexDescription
                                            {
                                                float3 Position;
                                                float3 Normal;
                                                float3 Tangent;
                                            };

                                            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                                            {
                                                VertexDescription description = (VertexDescription)0;
                                                description.Position = IN.ObjectSpacePosition;
                                                description.Normal = IN.ObjectSpaceNormal;
                                                description.Tangent = IN.ObjectSpaceTangent;
                                                return description;
                                            }

                                            // Custom interpolators, pre surface
                                            #ifdef FEATURES_GRAPH_VERTEX
                                            Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
                                            {
                                            return output;
                                            }
                                            #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
                                            #endif

                                            // Graph Pixel
                                            struct SurfaceDescription
                                            {
                                                float3 BaseColor;
                                                float3 Emission;
                                                float Alpha;
                                                float AlphaClipThreshold;
                                            };

                                            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                                            {
                                                SurfaceDescription surface = (SurfaceDescription)0;
                                                UnityTexture2D _Property_25d58f61f8a745f69d9bc5b84ec4ca18_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(MainTexture);
                                                float4 _SampleTexture2D_dae5062bfb6345989ac4c7936bcb0325_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_25d58f61f8a745f69d9bc5b84ec4ca18_Out_0_Texture2D.tex, _Property_25d58f61f8a745f69d9bc5b84ec4ca18_Out_0_Texture2D.samplerstate, _Property_25d58f61f8a745f69d9bc5b84ec4ca18_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy));
                                                float _SampleTexture2D_dae5062bfb6345989ac4c7936bcb0325_R_4_Float = _SampleTexture2D_dae5062bfb6345989ac4c7936bcb0325_RGBA_0_Vector4.r;
                                                float _SampleTexture2D_dae5062bfb6345989ac4c7936bcb0325_G_5_Float = _SampleTexture2D_dae5062bfb6345989ac4c7936bcb0325_RGBA_0_Vector4.g;
                                                float _SampleTexture2D_dae5062bfb6345989ac4c7936bcb0325_B_6_Float = _SampleTexture2D_dae5062bfb6345989ac4c7936bcb0325_RGBA_0_Vector4.b;
                                                float _SampleTexture2D_dae5062bfb6345989ac4c7936bcb0325_A_7_Float = _SampleTexture2D_dae5062bfb6345989ac4c7936bcb0325_RGBA_0_Vector4.a;
                                                UnityTexture2D _Property_d3f4357a037b4294a4561e4800559a98_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_FirstLayer);
                                                float _Property_28841e4c56c449d699ce8655774bfb45_Out_0_Float = _Tile_X;
                                                float _Property_93952c7a35224f899e2b661de6d28d11_Out_0_Float = _Tile_Y;
                                                float2 _Vector2_0d768a99157947b690b4011919c2e0fd_Out_0_Vector2 = float2(_Property_28841e4c56c449d699ce8655774bfb45_Out_0_Float, _Property_93952c7a35224f899e2b661de6d28d11_Out_0_Float);
                                                float _Property_f8ada8ccabc84c0fba96d3bdfcfa3418_Out_0_Float = _FirstLayer_Speed;
                                                float _Multiply_b6f87bb7270344abbfb4b28c5ae45762_Out_2_Float;
                                                Unity_Multiply_float_float(IN.TimeParameters.x, _Property_f8ada8ccabc84c0fba96d3bdfcfa3418_Out_0_Float, _Multiply_b6f87bb7270344abbfb4b28c5ae45762_Out_2_Float);
                                                float2 _Vector2_ba806402a04e48e9b8ff180bc6f53dd8_Out_0_Vector2 = float2(1, _Multiply_b6f87bb7270344abbfb4b28c5ae45762_Out_2_Float);
                                                float2 _TilingAndOffset_8db4474d0ad0448796dee47ee2c0261f_Out_3_Vector2;
                                                Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_0d768a99157947b690b4011919c2e0fd_Out_0_Vector2, _Vector2_ba806402a04e48e9b8ff180bc6f53dd8_Out_0_Vector2, _TilingAndOffset_8db4474d0ad0448796dee47ee2c0261f_Out_3_Vector2);
                                                float4 _SampleTexture2D_d6ad14b7f7f54d7fb3ea98bfa5d465cd_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_d3f4357a037b4294a4561e4800559a98_Out_0_Texture2D.tex, _Property_d3f4357a037b4294a4561e4800559a98_Out_0_Texture2D.samplerstate, _Property_d3f4357a037b4294a4561e4800559a98_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_8db4474d0ad0448796dee47ee2c0261f_Out_3_Vector2));
                                                float _SampleTexture2D_d6ad14b7f7f54d7fb3ea98bfa5d465cd_R_4_Float = _SampleTexture2D_d6ad14b7f7f54d7fb3ea98bfa5d465cd_RGBA_0_Vector4.r;
                                                float _SampleTexture2D_d6ad14b7f7f54d7fb3ea98bfa5d465cd_G_5_Float = _SampleTexture2D_d6ad14b7f7f54d7fb3ea98bfa5d465cd_RGBA_0_Vector4.g;
                                                float _SampleTexture2D_d6ad14b7f7f54d7fb3ea98bfa5d465cd_B_6_Float = _SampleTexture2D_d6ad14b7f7f54d7fb3ea98bfa5d465cd_RGBA_0_Vector4.b;
                                                float _SampleTexture2D_d6ad14b7f7f54d7fb3ea98bfa5d465cd_A_7_Float = _SampleTexture2D_d6ad14b7f7f54d7fb3ea98bfa5d465cd_RGBA_0_Vector4.a;
                                                UnityTexture2D _Property_c842ca1806df423fa653b7d9754ca8ca_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_FirstLayerMask);
                                                float4 _SampleTexture2D_27e0a67c861e46c2b3b2a6e513e4f4a3_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_c842ca1806df423fa653b7d9754ca8ca_Out_0_Texture2D.tex, _Property_c842ca1806df423fa653b7d9754ca8ca_Out_0_Texture2D.samplerstate, _Property_c842ca1806df423fa653b7d9754ca8ca_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy));
                                                float _SampleTexture2D_27e0a67c861e46c2b3b2a6e513e4f4a3_R_4_Float = _SampleTexture2D_27e0a67c861e46c2b3b2a6e513e4f4a3_RGBA_0_Vector4.r;
                                                float _SampleTexture2D_27e0a67c861e46c2b3b2a6e513e4f4a3_G_5_Float = _SampleTexture2D_27e0a67c861e46c2b3b2a6e513e4f4a3_RGBA_0_Vector4.g;
                                                float _SampleTexture2D_27e0a67c861e46c2b3b2a6e513e4f4a3_B_6_Float = _SampleTexture2D_27e0a67c861e46c2b3b2a6e513e4f4a3_RGBA_0_Vector4.b;
                                                float _SampleTexture2D_27e0a67c861e46c2b3b2a6e513e4f4a3_A_7_Float = _SampleTexture2D_27e0a67c861e46c2b3b2a6e513e4f4a3_RGBA_0_Vector4.a;
                                                float4 _Multiply_086d929899474eef8f9492b3df748da7_Out_2_Vector4;
                                                Unity_Multiply_float4_float4(_SampleTexture2D_d6ad14b7f7f54d7fb3ea98bfa5d465cd_RGBA_0_Vector4, _SampleTexture2D_27e0a67c861e46c2b3b2a6e513e4f4a3_RGBA_0_Vector4, _Multiply_086d929899474eef8f9492b3df748da7_Out_2_Vector4);
                                                float4 _Blend_22332064b1dd476eb955d1e6f0d31893_Out_2_Vector4;
                                                Unity_Blend_Dodge_float4(_SampleTexture2D_dae5062bfb6345989ac4c7936bcb0325_RGBA_0_Vector4, _Multiply_086d929899474eef8f9492b3df748da7_Out_2_Vector4, _Blend_22332064b1dd476eb955d1e6f0d31893_Out_2_Vector4, 1);
                                                UnityTexture2D _Property_aa17d6cddc844bbd8fffe2f3526f1d75_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_SecondLayer);
                                                float _Property_5443b670d62042b0bf29b6649506a396_Out_0_Float = _Tile_X_2;
                                                float _Property_e83f2ffe1d854d7cb7ce9639bef36c35_Out_0_Float = _Tile_Y_2;
                                                float2 _Vector2_112aab1e2c1a4c60ac52f6ab932daaae_Out_0_Vector2 = float2(_Property_5443b670d62042b0bf29b6649506a396_Out_0_Float, _Property_e83f2ffe1d854d7cb7ce9639bef36c35_Out_0_Float);
                                                float _Property_a122b213cc6049089080486d0e72dd92_Out_0_Float = _SecondLayer_Speed;
                                                float _Multiply_74242c5ba0db44a2af24f02259a54654_Out_2_Float;
                                                Unity_Multiply_float_float(IN.TimeParameters.x, _Property_a122b213cc6049089080486d0e72dd92_Out_0_Float, _Multiply_74242c5ba0db44a2af24f02259a54654_Out_2_Float);
                                                float2 _Vector2_23a4ed409daa44ebb33e022576272145_Out_0_Vector2 = float2(1, _Multiply_74242c5ba0db44a2af24f02259a54654_Out_2_Float);
                                                float2 _TilingAndOffset_259fb3e5741d40fbb9d10ab049b94707_Out_3_Vector2;
                                                Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_112aab1e2c1a4c60ac52f6ab932daaae_Out_0_Vector2, _Vector2_23a4ed409daa44ebb33e022576272145_Out_0_Vector2, _TilingAndOffset_259fb3e5741d40fbb9d10ab049b94707_Out_3_Vector2);
                                                float4 _SampleTexture2D_836113538fba497181d2063bdfe5dc20_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_aa17d6cddc844bbd8fffe2f3526f1d75_Out_0_Texture2D.tex, _Property_aa17d6cddc844bbd8fffe2f3526f1d75_Out_0_Texture2D.samplerstate, _Property_aa17d6cddc844bbd8fffe2f3526f1d75_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_259fb3e5741d40fbb9d10ab049b94707_Out_3_Vector2));
                                                float _SampleTexture2D_836113538fba497181d2063bdfe5dc20_R_4_Float = _SampleTexture2D_836113538fba497181d2063bdfe5dc20_RGBA_0_Vector4.r;
                                                float _SampleTexture2D_836113538fba497181d2063bdfe5dc20_G_5_Float = _SampleTexture2D_836113538fba497181d2063bdfe5dc20_RGBA_0_Vector4.g;
                                                float _SampleTexture2D_836113538fba497181d2063bdfe5dc20_B_6_Float = _SampleTexture2D_836113538fba497181d2063bdfe5dc20_RGBA_0_Vector4.b;
                                                float _SampleTexture2D_836113538fba497181d2063bdfe5dc20_A_7_Float = _SampleTexture2D_836113538fba497181d2063bdfe5dc20_RGBA_0_Vector4.a;
                                                UnityTexture2D _Property_d7c528359ec04b358fe52533578ee6b9_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_SecondLayerMask);
                                                float4 _SampleTexture2D_d6de786ff7b7453d9af1e36379f1e71c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_d7c528359ec04b358fe52533578ee6b9_Out_0_Texture2D.tex, _Property_d7c528359ec04b358fe52533578ee6b9_Out_0_Texture2D.samplerstate, _Property_d7c528359ec04b358fe52533578ee6b9_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy));
                                                float _SampleTexture2D_d6de786ff7b7453d9af1e36379f1e71c_R_4_Float = _SampleTexture2D_d6de786ff7b7453d9af1e36379f1e71c_RGBA_0_Vector4.r;
                                                float _SampleTexture2D_d6de786ff7b7453d9af1e36379f1e71c_G_5_Float = _SampleTexture2D_d6de786ff7b7453d9af1e36379f1e71c_RGBA_0_Vector4.g;
                                                float _SampleTexture2D_d6de786ff7b7453d9af1e36379f1e71c_B_6_Float = _SampleTexture2D_d6de786ff7b7453d9af1e36379f1e71c_RGBA_0_Vector4.b;
                                                float _SampleTexture2D_d6de786ff7b7453d9af1e36379f1e71c_A_7_Float = _SampleTexture2D_d6de786ff7b7453d9af1e36379f1e71c_RGBA_0_Vector4.a;
                                                float4 _Multiply_1ea6dc267b75448e873dab9c0aba9979_Out_2_Vector4;
                                                Unity_Multiply_float4_float4(_SampleTexture2D_836113538fba497181d2063bdfe5dc20_RGBA_0_Vector4, _SampleTexture2D_d6de786ff7b7453d9af1e36379f1e71c_RGBA_0_Vector4, _Multiply_1ea6dc267b75448e873dab9c0aba9979_Out_2_Vector4);
                                                float4 _Property_12403b7668af40959b7e6b93ac1deb70_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_Color) : _Color;
                                                float4 _Multiply_7dad164dce0f4fcaacdb934f7bd9ccaa_Out_2_Vector4;
                                                Unity_Multiply_float4_float4(_Multiply_1ea6dc267b75448e873dab9c0aba9979_Out_2_Vector4, _Property_12403b7668af40959b7e6b93ac1deb70_Out_0_Vector4, _Multiply_7dad164dce0f4fcaacdb934f7bd9ccaa_Out_2_Vector4);
                                                float4 _Add_160a66523e9a45d9982c0cb2001a1cd9_Out_2_Vector4;
                                                Unity_Add_float4(_Multiply_086d929899474eef8f9492b3df748da7_Out_2_Vector4, _Multiply_7dad164dce0f4fcaacdb934f7bd9ccaa_Out_2_Vector4, _Add_160a66523e9a45d9982c0cb2001a1cd9_Out_2_Vector4);
                                                float4 _Blend_d23b982fe8434a9ba42b28e9067ede89_Out_2_Vector4;
                                                Unity_Blend_Dodge_float4(_Blend_22332064b1dd476eb955d1e6f0d31893_Out_2_Vector4, _Add_160a66523e9a45d9982c0cb2001a1cd9_Out_2_Vector4, _Blend_d23b982fe8434a9ba42b28e9067ede89_Out_2_Vector4, 0);
                                                UnityTexture2D _Property_2296a933b1a044b889041aa853a7f13a_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_FlareLayer);
                                                float _Property_782a0df3d6284fabae7e7ac9130de612_Out_0_Float = _Tile_X_Flare;
                                                float _Property_cab0217c4db14cb08c0c11fd45bf24d0_Out_0_Float = _Tile_Y_Flare;
                                                float2 _Vector2_1952ea97bee3429381dad80e93776ec2_Out_0_Vector2 = float2(_Property_782a0df3d6284fabae7e7ac9130de612_Out_0_Float, _Property_cab0217c4db14cb08c0c11fd45bf24d0_Out_0_Float);
                                                float _Property_aed1ddb6d9a5427580bc310dd089f919_Out_0_Float = _Flare_Speed;
                                                float _Multiply_4b4bff5c45e140bca122d3c80dc22ea7_Out_2_Float;
                                                Unity_Multiply_float_float(IN.TimeParameters.x, _Property_aed1ddb6d9a5427580bc310dd089f919_Out_0_Float, _Multiply_4b4bff5c45e140bca122d3c80dc22ea7_Out_2_Float);
                                                float2 _Vector2_2565b1496cd443f6b1ba17365aa447da_Out_0_Vector2 = float2(0.57, _Multiply_4b4bff5c45e140bca122d3c80dc22ea7_Out_2_Float);
                                                float4 _UV_6593fae6f24d472d8d9e543f8a171b90_Out_0_Vector4 = IN.uv0;
                                                float4 _Add_f71da7687c2d4a81ad17d32ca6b91452_Out_2_Vector4;
                                                Unity_Add_float4((_Multiply_4b4bff5c45e140bca122d3c80dc22ea7_Out_2_Float.xxxx), _UV_6593fae6f24d472d8d9e543f8a171b90_Out_0_Vector4, _Add_f71da7687c2d4a81ad17d32ca6b91452_Out_2_Vector4);
                                                float _GradientNoise_c42c53c8620e444eb353533ecb9dbac5_Out_2_Float;
                                                Unity_GradientNoise_LegacyMod_float((_Add_f71da7687c2d4a81ad17d32ca6b91452_Out_2_Vector4.xy), 10, _GradientNoise_c42c53c8620e444eb353533ecb9dbac5_Out_2_Float);
                                                float _Property_c5fe4c7886864818a6634886e951c3cd_Out_0_Float = _Flare_Noise;
                                                float3 _NormalFromHeight_aac2a418455049acb09867e85f9521d4_Out_1_Vector3;
                                                float3x3 _NormalFromHeight_aac2a418455049acb09867e85f9521d4_TangentMatrix = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
                                                float3 _NormalFromHeight_aac2a418455049acb09867e85f9521d4_Position = IN.WorldSpacePosition;
                                                Unity_NormalFromHeight_Tangent_float(_GradientNoise_c42c53c8620e444eb353533ecb9dbac5_Out_2_Float,_Property_c5fe4c7886864818a6634886e951c3cd_Out_0_Float,_NormalFromHeight_aac2a418455049acb09867e85f9521d4_Position,_NormalFromHeight_aac2a418455049acb09867e85f9521d4_TangentMatrix, _NormalFromHeight_aac2a418455049acb09867e85f9521d4_Out_1_Vector3);
                                                float _Float_3b8429aad5284fe6ad703abf61f73644_Out_0_Float = 0.05;
                                                float3 _Multiply_e0bf4aabf4f046b6af7d6e72cfdb7fe7_Out_2_Vector3;
                                                Unity_Multiply_float3_float3(_NormalFromHeight_aac2a418455049acb09867e85f9521d4_Out_1_Vector3, (_Float_3b8429aad5284fe6ad703abf61f73644_Out_0_Float.xxx), _Multiply_e0bf4aabf4f046b6af7d6e72cfdb7fe7_Out_2_Vector3);
                                                float2 _Add_5a53b043f4a94542b971037a99a59c9d_Out_2_Vector2;
                                                Unity_Add_float2(_Vector2_2565b1496cd443f6b1ba17365aa447da_Out_0_Vector2, (_Multiply_e0bf4aabf4f046b6af7d6e72cfdb7fe7_Out_2_Vector3.xy), _Add_5a53b043f4a94542b971037a99a59c9d_Out_2_Vector2);
                                                float2 _TilingAndOffset_f850fca5d6c14dd4af26c36689f98822_Out_3_Vector2;
                                                Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_1952ea97bee3429381dad80e93776ec2_Out_0_Vector2, _Add_5a53b043f4a94542b971037a99a59c9d_Out_2_Vector2, _TilingAndOffset_f850fca5d6c14dd4af26c36689f98822_Out_3_Vector2);
                                                float4 _SampleTexture2D_16d53b57feef4457b6511a222279c4c2_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_2296a933b1a044b889041aa853a7f13a_Out_0_Texture2D.tex, _Property_2296a933b1a044b889041aa853a7f13a_Out_0_Texture2D.samplerstate, _Property_2296a933b1a044b889041aa853a7f13a_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_f850fca5d6c14dd4af26c36689f98822_Out_3_Vector2));
                                                float _SampleTexture2D_16d53b57feef4457b6511a222279c4c2_R_4_Float = _SampleTexture2D_16d53b57feef4457b6511a222279c4c2_RGBA_0_Vector4.r;
                                                float _SampleTexture2D_16d53b57feef4457b6511a222279c4c2_G_5_Float = _SampleTexture2D_16d53b57feef4457b6511a222279c4c2_RGBA_0_Vector4.g;
                                                float _SampleTexture2D_16d53b57feef4457b6511a222279c4c2_B_6_Float = _SampleTexture2D_16d53b57feef4457b6511a222279c4c2_RGBA_0_Vector4.b;
                                                float _SampleTexture2D_16d53b57feef4457b6511a222279c4c2_A_7_Float = _SampleTexture2D_16d53b57feef4457b6511a222279c4c2_RGBA_0_Vector4.a;
                                                UnityTexture2D _Property_daed62fc7e254f5291f7e8d4b4d36cc8_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_FlareLayerMask);
                                                float4 _SampleTexture2D_f771449173f64fea8fadc2f2470df5a2_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_daed62fc7e254f5291f7e8d4b4d36cc8_Out_0_Texture2D.tex, _Property_daed62fc7e254f5291f7e8d4b4d36cc8_Out_0_Texture2D.samplerstate, _Property_daed62fc7e254f5291f7e8d4b4d36cc8_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy));
                                                float _SampleTexture2D_f771449173f64fea8fadc2f2470df5a2_R_4_Float = _SampleTexture2D_f771449173f64fea8fadc2f2470df5a2_RGBA_0_Vector4.r;
                                                float _SampleTexture2D_f771449173f64fea8fadc2f2470df5a2_G_5_Float = _SampleTexture2D_f771449173f64fea8fadc2f2470df5a2_RGBA_0_Vector4.g;
                                                float _SampleTexture2D_f771449173f64fea8fadc2f2470df5a2_B_6_Float = _SampleTexture2D_f771449173f64fea8fadc2f2470df5a2_RGBA_0_Vector4.b;
                                                float _SampleTexture2D_f771449173f64fea8fadc2f2470df5a2_A_7_Float = _SampleTexture2D_f771449173f64fea8fadc2f2470df5a2_RGBA_0_Vector4.a;
                                                float4 _Multiply_ee41795c0bae447793edbbf2ad5d1905_Out_2_Vector4;
                                                Unity_Multiply_float4_float4(_SampleTexture2D_16d53b57feef4457b6511a222279c4c2_RGBA_0_Vector4, _SampleTexture2D_f771449173f64fea8fadc2f2470df5a2_RGBA_0_Vector4, _Multiply_ee41795c0bae447793edbbf2ad5d1905_Out_2_Vector4);
                                                float4 _Blend_2dd7dae929b34fe9b21b4b787d2ad749_Out_2_Vector4;
                                                Unity_Blend_Screen_float4(_Blend_d23b982fe8434a9ba42b28e9067ede89_Out_2_Vector4, _Multiply_ee41795c0bae447793edbbf2ad5d1905_Out_2_Vector4, _Blend_2dd7dae929b34fe9b21b4b787d2ad749_Out_2_Vector4, 1);
                                                UnityTexture2D _Property_94b557a5cefd4f1cb9f8b7647e8d8d0b_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_FirstLayer);
                                                float _Float_df56ec6f904545a8a767a7ba3c5dd15c_Out_0_Float = 2;
                                                float3 _Multiply_fae8425b844f415b9edd050b6279c2ac_Out_2_Vector3;
                                                Unity_Multiply_float3_float3((_Float_df56ec6f904545a8a767a7ba3c5dd15c_Out_0_Float.xxx), IN.TangentSpaceViewDirection, _Multiply_fae8425b844f415b9edd050b6279c2ac_Out_2_Vector3);
                                                float2 _TilingAndOffset_b36424444c844f9fa22ddbb420625641_Out_3_Vector2;
                                                Unity_TilingAndOffset_float(IN.uv0.xy, (_Multiply_fae8425b844f415b9edd050b6279c2ac_Out_2_Vector3.xy), (_Multiply_fae8425b844f415b9edd050b6279c2ac_Out_2_Vector3.xy), _TilingAndOffset_b36424444c844f9fa22ddbb420625641_Out_3_Vector2);
                                                float4 _SampleTexture2D_600ebfe1de5d4c789cf5d509e767528c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_94b557a5cefd4f1cb9f8b7647e8d8d0b_Out_0_Texture2D.tex, _Property_94b557a5cefd4f1cb9f8b7647e8d8d0b_Out_0_Texture2D.samplerstate, _Property_94b557a5cefd4f1cb9f8b7647e8d8d0b_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_b36424444c844f9fa22ddbb420625641_Out_3_Vector2));
                                                float _SampleTexture2D_600ebfe1de5d4c789cf5d509e767528c_R_4_Float = _SampleTexture2D_600ebfe1de5d4c789cf5d509e767528c_RGBA_0_Vector4.r;
                                                float _SampleTexture2D_600ebfe1de5d4c789cf5d509e767528c_G_5_Float = _SampleTexture2D_600ebfe1de5d4c789cf5d509e767528c_RGBA_0_Vector4.g;
                                                float _SampleTexture2D_600ebfe1de5d4c789cf5d509e767528c_B_6_Float = _SampleTexture2D_600ebfe1de5d4c789cf5d509e767528c_RGBA_0_Vector4.b;
                                                float _SampleTexture2D_600ebfe1de5d4c789cf5d509e767528c_A_7_Float = _SampleTexture2D_600ebfe1de5d4c789cf5d509e767528c_RGBA_0_Vector4.a;
                                                UnityTexture2D _Property_9ed80af81ecf433682e8492e8eda6983_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_FirstLayerMask);
                                                float4 _SampleTexture2D_9fea3c05c65144bbabad6ef4512b2893_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_9ed80af81ecf433682e8492e8eda6983_Out_0_Texture2D.tex, _Property_9ed80af81ecf433682e8492e8eda6983_Out_0_Texture2D.samplerstate, _Property_9ed80af81ecf433682e8492e8eda6983_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy));
                                                float _SampleTexture2D_9fea3c05c65144bbabad6ef4512b2893_R_4_Float = _SampleTexture2D_9fea3c05c65144bbabad6ef4512b2893_RGBA_0_Vector4.r;
                                                float _SampleTexture2D_9fea3c05c65144bbabad6ef4512b2893_G_5_Float = _SampleTexture2D_9fea3c05c65144bbabad6ef4512b2893_RGBA_0_Vector4.g;
                                                float _SampleTexture2D_9fea3c05c65144bbabad6ef4512b2893_B_6_Float = _SampleTexture2D_9fea3c05c65144bbabad6ef4512b2893_RGBA_0_Vector4.b;
                                                float _SampleTexture2D_9fea3c05c65144bbabad6ef4512b2893_A_7_Float = _SampleTexture2D_9fea3c05c65144bbabad6ef4512b2893_RGBA_0_Vector4.a;
                                                float4 _Multiply_00741ec509bb44e6b7c015c8afbd6f7b_Out_2_Vector4;
                                                Unity_Multiply_float4_float4(_SampleTexture2D_600ebfe1de5d4c789cf5d509e767528c_RGBA_0_Vector4, _SampleTexture2D_9fea3c05c65144bbabad6ef4512b2893_RGBA_0_Vector4, _Multiply_00741ec509bb44e6b7c015c8afbd6f7b_Out_2_Vector4);
                                                float _Property_d2a734d059ac4cdeacd546c3e4762220_Out_0_Float = _FirstLayer_Still_Opacity;
                                                float _Float_4766b030743f4cbd8fcaf0ed448ca5d6_Out_0_Float = _Property_d2a734d059ac4cdeacd546c3e4762220_Out_0_Float;
                                                float4 _Multiply_0d830f9ef3c74258a1fc4b496e551f55_Out_2_Vector4;
                                                Unity_Multiply_float4_float4(_Multiply_00741ec509bb44e6b7c015c8afbd6f7b_Out_2_Vector4, (_Float_4766b030743f4cbd8fcaf0ed448ca5d6_Out_0_Float.xxxx), _Multiply_0d830f9ef3c74258a1fc4b496e551f55_Out_2_Vector4);
                                                float _Property_2f0100c28b754ef7ad75f264ce26809b_Out_0_Float = _Layers_Opacity;
                                                float _Float_464854d505d5400d94c46694778bb7e8_Out_0_Float = _Property_2f0100c28b754ef7ad75f264ce26809b_Out_0_Float;
                                                UnityTexture2D _Property_11854fc2ac5e4f94a4d83e9f568c610e_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Edge_Emission);
                                                float4 _SampleTexture2D_cd98119a8c1d4215b57d6099759b389d_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_11854fc2ac5e4f94a4d83e9f568c610e_Out_0_Texture2D.tex, _Property_11854fc2ac5e4f94a4d83e9f568c610e_Out_0_Texture2D.samplerstate, _Property_11854fc2ac5e4f94a4d83e9f568c610e_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy));
                                                float _SampleTexture2D_cd98119a8c1d4215b57d6099759b389d_R_4_Float = _SampleTexture2D_cd98119a8c1d4215b57d6099759b389d_RGBA_0_Vector4.r;
                                                float _SampleTexture2D_cd98119a8c1d4215b57d6099759b389d_G_5_Float = _SampleTexture2D_cd98119a8c1d4215b57d6099759b389d_RGBA_0_Vector4.g;
                                                float _SampleTexture2D_cd98119a8c1d4215b57d6099759b389d_B_6_Float = _SampleTexture2D_cd98119a8c1d4215b57d6099759b389d_RGBA_0_Vector4.b;
                                                float _SampleTexture2D_cd98119a8c1d4215b57d6099759b389d_A_7_Float = _SampleTexture2D_cd98119a8c1d4215b57d6099759b389d_RGBA_0_Vector4.a;
                                                float4 _Add_b9699c2cea3a4e91aaee5df460966234_Out_2_Vector4;
                                                Unity_Add_float4(_Add_160a66523e9a45d9982c0cb2001a1cd9_Out_2_Vector4, _SampleTexture2D_cd98119a8c1d4215b57d6099759b389d_RGBA_0_Vector4, _Add_b9699c2cea3a4e91aaee5df460966234_Out_2_Vector4);
                                                float4 _Multiply_46c4d7cd5f3b4d8ea76dac8b7549e4d2_Out_2_Vector4;
                                                Unity_Multiply_float4_float4((_Float_464854d505d5400d94c46694778bb7e8_Out_0_Float.xxxx), _Add_b9699c2cea3a4e91aaee5df460966234_Out_2_Vector4, _Multiply_46c4d7cd5f3b4d8ea76dac8b7549e4d2_Out_2_Vector4);
                                                float4 _Remap_a3b4ca48973f445fb1acf58ec78cdbed_Out_3_Vector4;
                                                Unity_Remap_float4(_Multiply_ee41795c0bae447793edbbf2ad5d1905_Out_2_Vector4, float2 (-1, 1), float2 (-1, 1.02), _Remap_a3b4ca48973f445fb1acf58ec78cdbed_Out_3_Vector4);
                                                float _Float_20e389ee74214f3ab347f86ca4b66d9e_Out_0_Float = 0.25;
                                                float4 _Multiply_b40f8c2975ce41108df7579646a56b80_Out_2_Vector4;
                                                Unity_Multiply_float4_float4(_Remap_a3b4ca48973f445fb1acf58ec78cdbed_Out_3_Vector4, (_Float_20e389ee74214f3ab347f86ca4b66d9e_Out_0_Float.xxxx), _Multiply_b40f8c2975ce41108df7579646a56b80_Out_2_Vector4);
                                                float4 _Add_f1dab00885fc4aaaa6c73e04985ad9a8_Out_2_Vector4;
                                                Unity_Add_float4(_Multiply_46c4d7cd5f3b4d8ea76dac8b7549e4d2_Out_2_Vector4, _Multiply_b40f8c2975ce41108df7579646a56b80_Out_2_Vector4, _Add_f1dab00885fc4aaaa6c73e04985ad9a8_Out_2_Vector4);
                                                float4 _Add_ec1895b218b94d6eb89e1acdc29d14bf_Out_2_Vector4;
                                                Unity_Add_float4(_Multiply_0d830f9ef3c74258a1fc4b496e551f55_Out_2_Vector4, _Add_f1dab00885fc4aaaa6c73e04985ad9a8_Out_2_Vector4, _Add_ec1895b218b94d6eb89e1acdc29d14bf_Out_2_Vector4);
                                                surface.BaseColor = (_Blend_2dd7dae929b34fe9b21b4b787d2ad749_Out_2_Vector4.xyz);
                                                surface.Emission = (_Add_ec1895b218b94d6eb89e1acdc29d14bf_Out_2_Vector4.xyz);
                                                surface.Alpha = 1;
                                                surface.AlphaClipThreshold = 0.5;
                                                return surface;
                                            }

                                            // --------------------------------------------------
                                            // Build Graph Inputs
                                            #ifdef HAVE_VFX_MODIFICATION
                                            #define VFX_SRP_ATTRIBUTES Attributes
                                            #define VFX_SRP_VARYINGS Varyings
                                            #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
                                            #endif
                                            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                                            {
                                                VertexDescriptionInputs output;
                                                ZERO_INITIALIZE(VertexDescriptionInputs, output);

                                                output.ObjectSpaceNormal = input.normalOS;
                                                output.ObjectSpaceTangent = input.tangentOS.xyz;
                                                output.ObjectSpacePosition = input.positionOS;

                                                return output;
                                            }
                                            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                                            {
                                                SurfaceDescriptionInputs output;
                                                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

                                            #ifdef HAVE_VFX_MODIFICATION
                                            #if VFX_USE_GRAPH_VALUES
                                                uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
                                                /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
                                            #endif
                                                /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

                                            #endif



                                                // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
                                                float3 unnormalizedNormalWS = input.normalWS;
                                                const float renormFactor = 1.0 / length(unnormalizedNormalWS);

                                                // use bitangent on the fly like in hdrp
                                                // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
                                                float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0) * GetOddNegativeScale();
                                                float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);

                                                output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph

                                                // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
                                                // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
                                                output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
                                                output.WorldSpaceBiTangent = renormFactor * bitang;

                                                output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
                                                float3x3 tangentSpaceTransform = float3x3(output.WorldSpaceTangent, output.WorldSpaceBiTangent, output.WorldSpaceNormal);
                                                output.TangentSpaceViewDirection = mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                                                output.WorldSpacePosition = input.positionWS;

                                                #if UNITY_UV_STARTS_AT_TOP
                                                #else
                                                #endif


                                                output.uv0 = input.texCoord0;
                                                output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
                                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                                            #else
                                            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                                            #endif
                                            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

                                                    return output;
                                            }

                                            // --------------------------------------------------
                                            // Main

                                            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
                                            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"

                                            // --------------------------------------------------
                                            // Visual Effect Vertex Invocations
                                            #ifdef HAVE_VFX_MODIFICATION
                                            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
                                            #endif

                                            ENDHLSL
                                            }
                                            Pass
                                            {
                                                Name "SceneSelectionPass"
                                                Tags
                                                {
                                                    "LightMode" = "SceneSelectionPass"
                                                }

                                                // Render State
                                                Cull Off

                                                // Debug
                                                // <None>

                                                // --------------------------------------------------
                                                // Pass

                                                HLSLPROGRAM

                                                // Pragmas
                                                #pragma target 2.0
                                                #pragma vertex vert
                                                #pragma fragment frag

                                                // Keywords
                                                // PassKeywords: <None>
                                                // GraphKeywords: <None>

                                                // Defines

                                                #define _NORMALMAP 1
                                                #define _NORMAL_DROPOFF_TS 1
                                                #define ATTRIBUTES_NEED_NORMAL
                                                #define ATTRIBUTES_NEED_TANGENT
                                                #define FEATURES_GRAPH_VERTEX
                                                /* WARNING: $splice Could not find named fragment 'PassInstancing' */
                                                #define SHADERPASS SHADERPASS_DEPTHONLY
                                                #define SCENESELECTIONPASS 1
                                                #define ALPHA_CLIP_THRESHOLD 1
                                                #define _ALPHATEST_ON 1
                                                /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */


                                                // custom interpolator pre-include
                                                /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

                                                // Includes
                                                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                                                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
                                                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                                                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                                                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
                                                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
                                                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
                                                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

                                                // --------------------------------------------------
                                                // Structs and Packing

                                                // custom interpolators pre packing
                                                /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

                                                struct Attributes
                                                {
                                                     float3 positionOS : POSITION;
                                                     float3 normalOS : NORMAL;
                                                     float4 tangentOS : TANGENT;
                                                    #if UNITY_ANY_INSTANCING_ENABLED
                                                     uint instanceID : INSTANCEID_SEMANTIC;
                                                    #endif
                                                };
                                                struct Varyings
                                                {
                                                     float4 positionCS : SV_POSITION;
                                                    #if UNITY_ANY_INSTANCING_ENABLED
                                                     uint instanceID : CUSTOM_INSTANCE_ID;
                                                    #endif
                                                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                                    #endif
                                                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                                    #endif
                                                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                                    #endif
                                                };
                                                struct SurfaceDescriptionInputs
                                                {
                                                };
                                                struct VertexDescriptionInputs
                                                {
                                                     float3 ObjectSpaceNormal;
                                                     float3 ObjectSpaceTangent;
                                                     float3 ObjectSpacePosition;
                                                };
                                                struct PackedVaryings
                                                {
                                                     float4 positionCS : SV_POSITION;
                                                    #if UNITY_ANY_INSTANCING_ENABLED
                                                     uint instanceID : CUSTOM_INSTANCE_ID;
                                                    #endif
                                                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                                    #endif
                                                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                                    #endif
                                                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                                    #endif
                                                };

                                                PackedVaryings PackVaryings(Varyings input)
                                                {
                                                    PackedVaryings output;
                                                    ZERO_INITIALIZE(PackedVaryings, output);
                                                    output.positionCS = input.positionCS;
                                                    #if UNITY_ANY_INSTANCING_ENABLED
                                                    output.instanceID = input.instanceID;
                                                    #endif
                                                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                                    #endif
                                                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                                    #endif
                                                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                    output.cullFace = input.cullFace;
                                                    #endif
                                                    return output;
                                                }

                                                Varyings UnpackVaryings(PackedVaryings input)
                                                {
                                                    Varyings output;
                                                    output.positionCS = input.positionCS;
                                                    #if UNITY_ANY_INSTANCING_ENABLED
                                                    output.instanceID = input.instanceID;
                                                    #endif
                                                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                                    #endif
                                                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                                    #endif
                                                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                    output.cullFace = input.cullFace;
                                                    #endif
                                                    return output;
                                                }


                                                // --------------------------------------------------
                                                // Graph

                                                // Graph Properties
                                                CBUFFER_START(UnityPerMaterial)
                                                float4 MainTexture_TexelSize;
                                                float4 NormalMap_TexelSize;
                                                float _Normal_Strength;
                                                float _SecondLayer_Speed;
                                                float _Tile_X_Flare;
                                                float _Tile_Y_Flare;
                                                float _Layers_Opacity;
                                                float _Tile_X_2;
                                                float _Tile_Y_2;
                                                float _Tile_Y;
                                                float Metallic;
                                                float Smoothness;
                                                float _Flare_Speed;
                                                float _FirstLayer_Speed;
                                                float4 _Color;
                                                float4 _Edge_Emission_TexelSize;
                                                float4 _FirstLayer_TexelSize;
                                                float4 _FirstLayerMask_TexelSize;
                                                float4 _FlareLayer_TexelSize;
                                                float4 _FlareLayerMask_TexelSize;
                                                float4 _SecondLayer_TexelSize;
                                                float4 _SecondLayerMask_TexelSize;
                                                float _Flare_Noise;
                                                float _FirstLayer_Still_Opacity;
                                                float _Tile_X;
                                                CBUFFER_END


                                                    // Object and Global properties
                                                    SAMPLER(SamplerState_Linear_Repeat);
                                                    TEXTURE2D(MainTexture);
                                                    SAMPLER(samplerMainTexture);
                                                    TEXTURE2D(NormalMap);
                                                    SAMPLER(samplerNormalMap);
                                                    TEXTURE2D(_Edge_Emission);
                                                    SAMPLER(sampler_Edge_Emission);
                                                    TEXTURE2D(_FirstLayer);
                                                    SAMPLER(sampler_FirstLayer);
                                                    TEXTURE2D(_FirstLayerMask);
                                                    SAMPLER(sampler_FirstLayerMask);
                                                    TEXTURE2D(_FlareLayer);
                                                    SAMPLER(sampler_FlareLayer);
                                                    TEXTURE2D(_FlareLayerMask);
                                                    SAMPLER(sampler_FlareLayerMask);
                                                    TEXTURE2D(_SecondLayer);
                                                    SAMPLER(sampler_SecondLayer);
                                                    TEXTURE2D(_SecondLayerMask);
                                                    SAMPLER(sampler_SecondLayerMask);

                                                    // Graph Includes
                                                    // GraphIncludes: <None>

                                                    // -- Property used by ScenePickingPass
                                                    #ifdef SCENEPICKINGPASS
                                                    float4 _SelectionID;
                                                    #endif

                                                    // -- Properties used by SceneSelectionPass
                                                    #ifdef SCENESELECTIONPASS
                                                    int _ObjectId;
                                                    int _PassValue;
                                                    #endif

                                                    // Graph Functions
                                                    // GraphFunctions: <None>

                                                    // Custom interpolators pre vertex
                                                    /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

                                                    // Graph Vertex
                                                    struct VertexDescription
                                                    {
                                                        float3 Position;
                                                        float3 Normal;
                                                        float3 Tangent;
                                                    };

                                                    VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                                                    {
                                                        VertexDescription description = (VertexDescription)0;
                                                        description.Position = IN.ObjectSpacePosition;
                                                        description.Normal = IN.ObjectSpaceNormal;
                                                        description.Tangent = IN.ObjectSpaceTangent;
                                                        return description;
                                                    }

                                                    // Custom interpolators, pre surface
                                                    #ifdef FEATURES_GRAPH_VERTEX
                                                    Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
                                                    {
                                                    return output;
                                                    }
                                                    #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
                                                    #endif

                                                    // Graph Pixel
                                                    struct SurfaceDescription
                                                    {
                                                        float Alpha;
                                                        float AlphaClipThreshold;
                                                    };

                                                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                                                    {
                                                        SurfaceDescription surface = (SurfaceDescription)0;
                                                        surface.Alpha = 1;
                                                        surface.AlphaClipThreshold = 0.5;
                                                        return surface;
                                                    }

                                                    // --------------------------------------------------
                                                    // Build Graph Inputs
                                                    #ifdef HAVE_VFX_MODIFICATION
                                                    #define VFX_SRP_ATTRIBUTES Attributes
                                                    #define VFX_SRP_VARYINGS Varyings
                                                    #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
                                                    #endif
                                                    VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                                                    {
                                                        VertexDescriptionInputs output;
                                                        ZERO_INITIALIZE(VertexDescriptionInputs, output);

                                                        output.ObjectSpaceNormal = input.normalOS;
                                                        output.ObjectSpaceTangent = input.tangentOS.xyz;
                                                        output.ObjectSpacePosition = input.positionOS;

                                                        return output;
                                                    }
                                                    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                                                    {
                                                        SurfaceDescriptionInputs output;
                                                        ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

                                                    #ifdef HAVE_VFX_MODIFICATION
                                                    #if VFX_USE_GRAPH_VALUES
                                                        uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
                                                        /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
                                                    #endif
                                                        /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

                                                    #endif








                                                        #if UNITY_UV_STARTS_AT_TOP
                                                        #else
                                                        #endif


                                                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                                                    #else
                                                    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                                                    #endif
                                                    #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

                                                            return output;
                                                    }

                                                    // --------------------------------------------------
                                                    // Main

                                                    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
                                                    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"

                                                    // --------------------------------------------------
                                                    // Visual Effect Vertex Invocations
                                                    #ifdef HAVE_VFX_MODIFICATION
                                                    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
                                                    #endif

                                                    ENDHLSL
                                                    }
                                                    Pass
                                                    {
                                                        Name "ScenePickingPass"
                                                        Tags
                                                        {
                                                            "LightMode" = "Picking"
                                                        }

                                                        // Render State
                                                        Cull Off

                                                        // Debug
                                                        // <None>

                                                        // --------------------------------------------------
                                                        // Pass

                                                        HLSLPROGRAM

                                                        // Pragmas
                                                        #pragma target 2.0
                                                        #pragma vertex vert
                                                        #pragma fragment frag

                                                        // Keywords
                                                        // PassKeywords: <None>
                                                        // GraphKeywords: <None>

                                                        // Defines

                                                        #define _NORMALMAP 1
                                                        #define _NORMAL_DROPOFF_TS 1
                                                        #define ATTRIBUTES_NEED_NORMAL
                                                        #define ATTRIBUTES_NEED_TANGENT
                                                        #define FEATURES_GRAPH_VERTEX
                                                        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
                                                        #define SHADERPASS SHADERPASS_DEPTHONLY
                                                        #define SCENEPICKINGPASS 1
                                                        #define ALPHA_CLIP_THRESHOLD 1
                                                        #define _ALPHATEST_ON 1
                                                        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */


                                                        // custom interpolator pre-include
                                                        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

                                                        // Includes
                                                        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                                                        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
                                                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                                                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                                                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
                                                        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
                                                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
                                                        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

                                                        // --------------------------------------------------
                                                        // Structs and Packing

                                                        // custom interpolators pre packing
                                                        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

                                                        struct Attributes
                                                        {
                                                             float3 positionOS : POSITION;
                                                             float3 normalOS : NORMAL;
                                                             float4 tangentOS : TANGENT;
                                                            #if UNITY_ANY_INSTANCING_ENABLED
                                                             uint instanceID : INSTANCEID_SEMANTIC;
                                                            #endif
                                                        };
                                                        struct Varyings
                                                        {
                                                             float4 positionCS : SV_POSITION;
                                                            #if UNITY_ANY_INSTANCING_ENABLED
                                                             uint instanceID : CUSTOM_INSTANCE_ID;
                                                            #endif
                                                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                                            #endif
                                                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                                            #endif
                                                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                                            #endif
                                                        };
                                                        struct SurfaceDescriptionInputs
                                                        {
                                                        };
                                                        struct VertexDescriptionInputs
                                                        {
                                                             float3 ObjectSpaceNormal;
                                                             float3 ObjectSpaceTangent;
                                                             float3 ObjectSpacePosition;
                                                        };
                                                        struct PackedVaryings
                                                        {
                                                             float4 positionCS : SV_POSITION;
                                                            #if UNITY_ANY_INSTANCING_ENABLED
                                                             uint instanceID : CUSTOM_INSTANCE_ID;
                                                            #endif
                                                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                                            #endif
                                                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                                            #endif
                                                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                                            #endif
                                                        };

                                                        PackedVaryings PackVaryings(Varyings input)
                                                        {
                                                            PackedVaryings output;
                                                            ZERO_INITIALIZE(PackedVaryings, output);
                                                            output.positionCS = input.positionCS;
                                                            #if UNITY_ANY_INSTANCING_ENABLED
                                                            output.instanceID = input.instanceID;
                                                            #endif
                                                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                                            #endif
                                                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                                            #endif
                                                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                            output.cullFace = input.cullFace;
                                                            #endif
                                                            return output;
                                                        }

                                                        Varyings UnpackVaryings(PackedVaryings input)
                                                        {
                                                            Varyings output;
                                                            output.positionCS = input.positionCS;
                                                            #if UNITY_ANY_INSTANCING_ENABLED
                                                            output.instanceID = input.instanceID;
                                                            #endif
                                                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                                            #endif
                                                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                                            #endif
                                                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                            output.cullFace = input.cullFace;
                                                            #endif
                                                            return output;
                                                        }


                                                        // --------------------------------------------------
                                                        // Graph

                                                        // Graph Properties
                                                        CBUFFER_START(UnityPerMaterial)
                                                        float4 MainTexture_TexelSize;
                                                        float4 NormalMap_TexelSize;
                                                        float _Normal_Strength;
                                                        float _SecondLayer_Speed;
                                                        float _Tile_X_Flare;
                                                        float _Tile_Y_Flare;
                                                        float _Layers_Opacity;
                                                        float _Tile_X_2;
                                                        float _Tile_Y_2;
                                                        float _Tile_Y;
                                                        float Metallic;
                                                        float Smoothness;
                                                        float _Flare_Speed;
                                                        float _FirstLayer_Speed;
                                                        float4 _Color;
                                                        float4 _Edge_Emission_TexelSize;
                                                        float4 _FirstLayer_TexelSize;
                                                        float4 _FirstLayerMask_TexelSize;
                                                        float4 _FlareLayer_TexelSize;
                                                        float4 _FlareLayerMask_TexelSize;
                                                        float4 _SecondLayer_TexelSize;
                                                        float4 _SecondLayerMask_TexelSize;
                                                        float _Flare_Noise;
                                                        float _FirstLayer_Still_Opacity;
                                                        float _Tile_X;
                                                        CBUFFER_END


                                                            // Object and Global properties
                                                            SAMPLER(SamplerState_Linear_Repeat);
                                                            TEXTURE2D(MainTexture);
                                                            SAMPLER(samplerMainTexture);
                                                            TEXTURE2D(NormalMap);
                                                            SAMPLER(samplerNormalMap);
                                                            TEXTURE2D(_Edge_Emission);
                                                            SAMPLER(sampler_Edge_Emission);
                                                            TEXTURE2D(_FirstLayer);
                                                            SAMPLER(sampler_FirstLayer);
                                                            TEXTURE2D(_FirstLayerMask);
                                                            SAMPLER(sampler_FirstLayerMask);
                                                            TEXTURE2D(_FlareLayer);
                                                            SAMPLER(sampler_FlareLayer);
                                                            TEXTURE2D(_FlareLayerMask);
                                                            SAMPLER(sampler_FlareLayerMask);
                                                            TEXTURE2D(_SecondLayer);
                                                            SAMPLER(sampler_SecondLayer);
                                                            TEXTURE2D(_SecondLayerMask);
                                                            SAMPLER(sampler_SecondLayerMask);

                                                            // Graph Includes
                                                            // GraphIncludes: <None>

                                                            // -- Property used by ScenePickingPass
                                                            #ifdef SCENEPICKINGPASS
                                                            float4 _SelectionID;
                                                            #endif

                                                            // -- Properties used by SceneSelectionPass
                                                            #ifdef SCENESELECTIONPASS
                                                            int _ObjectId;
                                                            int _PassValue;
                                                            #endif

                                                            // Graph Functions
                                                            // GraphFunctions: <None>

                                                            // Custom interpolators pre vertex
                                                            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

                                                            // Graph Vertex
                                                            struct VertexDescription
                                                            {
                                                                float3 Position;
                                                                float3 Normal;
                                                                float3 Tangent;
                                                            };

                                                            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                                                            {
                                                                VertexDescription description = (VertexDescription)0;
                                                                description.Position = IN.ObjectSpacePosition;
                                                                description.Normal = IN.ObjectSpaceNormal;
                                                                description.Tangent = IN.ObjectSpaceTangent;
                                                                return description;
                                                            }

                                                            // Custom interpolators, pre surface
                                                            #ifdef FEATURES_GRAPH_VERTEX
                                                            Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
                                                            {
                                                            return output;
                                                            }
                                                            #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
                                                            #endif

                                                            // Graph Pixel
                                                            struct SurfaceDescription
                                                            {
                                                                float Alpha;
                                                                float AlphaClipThreshold;
                                                            };

                                                            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                                                            {
                                                                SurfaceDescription surface = (SurfaceDescription)0;
                                                                surface.Alpha = 1;
                                                                surface.AlphaClipThreshold = 0.5;
                                                                return surface;
                                                            }

                                                            // --------------------------------------------------
                                                            // Build Graph Inputs
                                                            #ifdef HAVE_VFX_MODIFICATION
                                                            #define VFX_SRP_ATTRIBUTES Attributes
                                                            #define VFX_SRP_VARYINGS Varyings
                                                            #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
                                                            #endif
                                                            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                                                            {
                                                                VertexDescriptionInputs output;
                                                                ZERO_INITIALIZE(VertexDescriptionInputs, output);

                                                                output.ObjectSpaceNormal = input.normalOS;
                                                                output.ObjectSpaceTangent = input.tangentOS.xyz;
                                                                output.ObjectSpacePosition = input.positionOS;

                                                                return output;
                                                            }
                                                            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                                                            {
                                                                SurfaceDescriptionInputs output;
                                                                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

                                                            #ifdef HAVE_VFX_MODIFICATION
                                                            #if VFX_USE_GRAPH_VALUES
                                                                uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
                                                                /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
                                                            #endif
                                                                /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

                                                            #endif








                                                                #if UNITY_UV_STARTS_AT_TOP
                                                                #else
                                                                #endif


                                                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                                                            #else
                                                            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                                                            #endif
                                                            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

                                                                    return output;
                                                            }

                                                            // --------------------------------------------------
                                                            // Main

                                                            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
                                                            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"

                                                            // --------------------------------------------------
                                                            // Visual Effect Vertex Invocations
                                                            #ifdef HAVE_VFX_MODIFICATION
                                                            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
                                                            #endif

                                                            ENDHLSL
                                                            }
                                                            Pass
                                                            {
                                                                // Name: <None>
                                                                Tags
                                                                {
                                                                    "LightMode" = "Universal2D"
                                                                }

                                                                // Render State
                                                                Cull Off
                                                                Blend One Zero
                                                                ZTest LEqual
                                                                ZWrite On

                                                                // Debug
                                                                // <None>

                                                                // --------------------------------------------------
                                                                // Pass

                                                                HLSLPROGRAM

                                                                // Pragmas
                                                                #pragma target 2.0
                                                                #pragma vertex vert
                                                                #pragma fragment frag

                                                                // Keywords
                                                                // PassKeywords: <None>
                                                                // GraphKeywords: <None>

                                                                // Defines

                                                                #define _NORMALMAP 1
                                                                #define _NORMAL_DROPOFF_TS 1
                                                                #define ATTRIBUTES_NEED_NORMAL
                                                                #define ATTRIBUTES_NEED_TANGENT
                                                                #define ATTRIBUTES_NEED_TEXCOORD0
                                                                #define VARYINGS_NEED_POSITION_WS
                                                                #define VARYINGS_NEED_NORMAL_WS
                                                                #define VARYINGS_NEED_TANGENT_WS
                                                                #define VARYINGS_NEED_TEXCOORD0
                                                                #define FEATURES_GRAPH_VERTEX
                                                                /* WARNING: $splice Could not find named fragment 'PassInstancing' */
                                                                #define SHADERPASS SHADERPASS_2D
                                                                #define _ALPHATEST_ON 1
                                                                /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */


                                                                // custom interpolator pre-include
                                                                /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

                                                                // Includes
                                                                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                                                                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
                                                                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                                                                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                                                                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
                                                                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
                                                                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
                                                                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

                                                                // --------------------------------------------------
                                                                // Structs and Packing

                                                                // custom interpolators pre packing
                                                                /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

                                                                struct Attributes
                                                                {
                                                                     float3 positionOS : POSITION;
                                                                     float3 normalOS : NORMAL;
                                                                     float4 tangentOS : TANGENT;
                                                                     float4 uv0 : TEXCOORD0;
                                                                    #if UNITY_ANY_INSTANCING_ENABLED
                                                                     uint instanceID : INSTANCEID_SEMANTIC;
                                                                    #endif
                                                                };
                                                                struct Varyings
                                                                {
                                                                     float4 positionCS : SV_POSITION;
                                                                     float3 positionWS;
                                                                     float3 normalWS;
                                                                     float4 tangentWS;
                                                                     float4 texCoord0;
                                                                    #if UNITY_ANY_INSTANCING_ENABLED
                                                                     uint instanceID : CUSTOM_INSTANCE_ID;
                                                                    #endif
                                                                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                                                    #endif
                                                                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                                                    #endif
                                                                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                                                    #endif
                                                                };
                                                                struct SurfaceDescriptionInputs
                                                                {
                                                                     float3 WorldSpaceNormal;
                                                                     float3 WorldSpaceTangent;
                                                                     float3 WorldSpaceBiTangent;
                                                                     float3 WorldSpacePosition;
                                                                     float4 uv0;
                                                                     float3 TimeParameters;
                                                                };
                                                                struct VertexDescriptionInputs
                                                                {
                                                                     float3 ObjectSpaceNormal;
                                                                     float3 ObjectSpaceTangent;
                                                                     float3 ObjectSpacePosition;
                                                                };
                                                                struct PackedVaryings
                                                                {
                                                                     float4 positionCS : SV_POSITION;
                                                                     float4 tangentWS : INTERP0;
                                                                     float4 texCoord0 : INTERP1;
                                                                     float3 positionWS : INTERP2;
                                                                     float3 normalWS : INTERP3;
                                                                    #if UNITY_ANY_INSTANCING_ENABLED
                                                                     uint instanceID : CUSTOM_INSTANCE_ID;
                                                                    #endif
                                                                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                                                    #endif
                                                                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                                                    #endif
                                                                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                                                    #endif
                                                                };

                                                                PackedVaryings PackVaryings(Varyings input)
                                                                {
                                                                    PackedVaryings output;
                                                                    ZERO_INITIALIZE(PackedVaryings, output);
                                                                    output.positionCS = input.positionCS;
                                                                    output.tangentWS.xyzw = input.tangentWS;
                                                                    output.texCoord0.xyzw = input.texCoord0;
                                                                    output.positionWS.xyz = input.positionWS;
                                                                    output.normalWS.xyz = input.normalWS;
                                                                    #if UNITY_ANY_INSTANCING_ENABLED
                                                                    output.instanceID = input.instanceID;
                                                                    #endif
                                                                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                                                    #endif
                                                                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                                                    #endif
                                                                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                                    output.cullFace = input.cullFace;
                                                                    #endif
                                                                    return output;
                                                                }

                                                                Varyings UnpackVaryings(PackedVaryings input)
                                                                {
                                                                    Varyings output;
                                                                    output.positionCS = input.positionCS;
                                                                    output.tangentWS = input.tangentWS.xyzw;
                                                                    output.texCoord0 = input.texCoord0.xyzw;
                                                                    output.positionWS = input.positionWS.xyz;
                                                                    output.normalWS = input.normalWS.xyz;
                                                                    #if UNITY_ANY_INSTANCING_ENABLED
                                                                    output.instanceID = input.instanceID;
                                                                    #endif
                                                                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                                                    #endif
                                                                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                                                    #endif
                                                                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                                    output.cullFace = input.cullFace;
                                                                    #endif
                                                                    return output;
                                                                }


                                                                // --------------------------------------------------
                                                                // Graph

                                                                // Graph Properties
                                                                CBUFFER_START(UnityPerMaterial)
                                                                float4 MainTexture_TexelSize;
                                                                float4 NormalMap_TexelSize;
                                                                float _Normal_Strength;
                                                                float _SecondLayer_Speed;
                                                                float _Tile_X_Flare;
                                                                float _Tile_Y_Flare;
                                                                float _Layers_Opacity;
                                                                float _Tile_X_2;
                                                                float _Tile_Y_2;
                                                                float _Tile_Y;
                                                                float Metallic;
                                                                float Smoothness;
                                                                float _Flare_Speed;
                                                                float _FirstLayer_Speed;
                                                                float4 _Color;
                                                                float4 _Edge_Emission_TexelSize;
                                                                float4 _FirstLayer_TexelSize;
                                                                float4 _FirstLayerMask_TexelSize;
                                                                float4 _FlareLayer_TexelSize;
                                                                float4 _FlareLayerMask_TexelSize;
                                                                float4 _SecondLayer_TexelSize;
                                                                float4 _SecondLayerMask_TexelSize;
                                                                float _Flare_Noise;
                                                                float _FirstLayer_Still_Opacity;
                                                                float _Tile_X;
                                                                CBUFFER_END


                                                                    // Object and Global properties
                                                                    SAMPLER(SamplerState_Linear_Repeat);
                                                                    TEXTURE2D(MainTexture);
                                                                    SAMPLER(samplerMainTexture);
                                                                    TEXTURE2D(NormalMap);
                                                                    SAMPLER(samplerNormalMap);
                                                                    TEXTURE2D(_Edge_Emission);
                                                                    SAMPLER(sampler_Edge_Emission);
                                                                    TEXTURE2D(_FirstLayer);
                                                                    SAMPLER(sampler_FirstLayer);
                                                                    TEXTURE2D(_FirstLayerMask);
                                                                    SAMPLER(sampler_FirstLayerMask);
                                                                    TEXTURE2D(_FlareLayer);
                                                                    SAMPLER(sampler_FlareLayer);
                                                                    TEXTURE2D(_FlareLayerMask);
                                                                    SAMPLER(sampler_FlareLayerMask);
                                                                    TEXTURE2D(_SecondLayer);
                                                                    SAMPLER(sampler_SecondLayer);
                                                                    TEXTURE2D(_SecondLayerMask);
                                                                    SAMPLER(sampler_SecondLayerMask);

                                                                    // Graph Includes
                                                                    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"

                                                                    // -- Property used by ScenePickingPass
                                                                    #ifdef SCENEPICKINGPASS
                                                                    float4 _SelectionID;
                                                                    #endif

                                                                    // -- Properties used by SceneSelectionPass
                                                                    #ifdef SCENESELECTIONPASS
                                                                    int _ObjectId;
                                                                    int _PassValue;
                                                                    #endif

                                                                    // Graph Functions

                                                                    void Unity_Multiply_float_float(float A, float B, out float Out)
                                                                    {
                                                                        Out = A * B;
                                                                    }

                                                                    void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                                                                    {
                                                                        Out = UV * Tiling + Offset;
                                                                    }

                                                                    void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
                                                                    {
                                                                        Out = A * B;
                                                                    }

                                                                    void Unity_Blend_Dodge_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
                                                                    {
                                                                        Out = Base / (1.0 - clamp(Blend, 0.000001, 0.999999));
                                                                        Out = lerp(Base, Out, Opacity);
                                                                    }

                                                                    void Unity_Add_float4(float4 A, float4 B, out float4 Out)
                                                                    {
                                                                        Out = A + B;
                                                                    }

                                                                    float2 Unity_GradientNoise_LegacyMod_Dir_float(float2 p)
                                                                    {
                                                                        float x; Hash_LegacyMod_2_1_float(p, x);
                                                                        return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                                                                    }

                                                                    void Unity_GradientNoise_LegacyMod_float(float2 UV, float3 Scale, out float Out)
                                                                    {
                                                                        float2 p = UV * Scale.xy;
                                                                        float2 ip = floor(p);
                                                                        float2 fp = frac(p);
                                                                        float d00 = dot(Unity_GradientNoise_LegacyMod_Dir_float(ip), fp);
                                                                        float d01 = dot(Unity_GradientNoise_LegacyMod_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                                                                        float d10 = dot(Unity_GradientNoise_LegacyMod_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                                                                        float d11 = dot(Unity_GradientNoise_LegacyMod_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                                                                        fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                                                                        Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                                                                    }

                                                                    void Unity_NormalFromHeight_Tangent_float(float In, float Strength, float3 Position, float3x3 TangentMatrix, out float3 Out)
                                                                    {

                                                                                #if defined(SHADER_STAGE_RAY_TRACING) && defined(RAYTRACING_SHADER_GRAPH_DEFAULT)
                                                                                #error 'Normal From Height' node is not supported in ray tracing, please provide an alternate implementation, relying for instance on the 'Raytracing Quality' keyword
                                                                                #endif
                                                                        float3 worldDerivativeX = ddx(Position);
                                                                        float3 worldDerivativeY = ddy(Position);

                                                                        float3 crossX = cross(TangentMatrix[2].xyz, worldDerivativeX);
                                                                        float3 crossY = cross(worldDerivativeY, TangentMatrix[2].xyz);
                                                                        float d = dot(worldDerivativeX, crossY);
                                                                        float sgn = d < 0.0 ? (-1.0f) : 1.0f;
                                                                        float surface = sgn / max(0.000000000000001192093f, abs(d));

                                                                        float dHdx = ddx(In);
                                                                        float dHdy = ddy(In);
                                                                        float3 surfGrad = surface * (dHdx * crossY + dHdy * crossX);
                                                                        Out = SafeNormalize(TangentMatrix[2].xyz - (Strength * surfGrad));
                                                                        Out = TransformWorldToTangent(Out, TangentMatrix);
                                                                    }

                                                                    void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
                                                                    {
                                                                        Out = A * B;
                                                                    }

                                                                    void Unity_Add_float2(float2 A, float2 B, out float2 Out)
                                                                    {
                                                                        Out = A + B;
                                                                    }

                                                                    void Unity_Blend_Screen_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
                                                                    {
                                                                        Out = 1.0 - (1.0 - Blend) * (1.0 - Base);
                                                                        Out = lerp(Base, Out, Opacity);
                                                                    }

                                                                    // Custom interpolators pre vertex
                                                                    /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

                                                                    // Graph Vertex
                                                                    struct VertexDescription
                                                                    {
                                                                        float3 Position;
                                                                        float3 Normal;
                                                                        float3 Tangent;
                                                                    };

                                                                    VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                                                                    {
                                                                        VertexDescription description = (VertexDescription)0;
                                                                        description.Position = IN.ObjectSpacePosition;
                                                                        description.Normal = IN.ObjectSpaceNormal;
                                                                        description.Tangent = IN.ObjectSpaceTangent;
                                                                        return description;
                                                                    }

                                                                    // Custom interpolators, pre surface
                                                                    #ifdef FEATURES_GRAPH_VERTEX
                                                                    Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
                                                                    {
                                                                    return output;
                                                                    }
                                                                    #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
                                                                    #endif

                                                                    // Graph Pixel
                                                                    struct SurfaceDescription
                                                                    {
                                                                        float3 BaseColor;
                                                                        float Alpha;
                                                                        float AlphaClipThreshold;
                                                                    };

                                                                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                                                                    {
                                                                        SurfaceDescription surface = (SurfaceDescription)0;
                                                                        UnityTexture2D _Property_25d58f61f8a745f69d9bc5b84ec4ca18_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(MainTexture);
                                                                        float4 _SampleTexture2D_dae5062bfb6345989ac4c7936bcb0325_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_25d58f61f8a745f69d9bc5b84ec4ca18_Out_0_Texture2D.tex, _Property_25d58f61f8a745f69d9bc5b84ec4ca18_Out_0_Texture2D.samplerstate, _Property_25d58f61f8a745f69d9bc5b84ec4ca18_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy));
                                                                        float _SampleTexture2D_dae5062bfb6345989ac4c7936bcb0325_R_4_Float = _SampleTexture2D_dae5062bfb6345989ac4c7936bcb0325_RGBA_0_Vector4.r;
                                                                        float _SampleTexture2D_dae5062bfb6345989ac4c7936bcb0325_G_5_Float = _SampleTexture2D_dae5062bfb6345989ac4c7936bcb0325_RGBA_0_Vector4.g;
                                                                        float _SampleTexture2D_dae5062bfb6345989ac4c7936bcb0325_B_6_Float = _SampleTexture2D_dae5062bfb6345989ac4c7936bcb0325_RGBA_0_Vector4.b;
                                                                        float _SampleTexture2D_dae5062bfb6345989ac4c7936bcb0325_A_7_Float = _SampleTexture2D_dae5062bfb6345989ac4c7936bcb0325_RGBA_0_Vector4.a;
                                                                        UnityTexture2D _Property_d3f4357a037b4294a4561e4800559a98_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_FirstLayer);
                                                                        float _Property_28841e4c56c449d699ce8655774bfb45_Out_0_Float = _Tile_X;
                                                                        float _Property_93952c7a35224f899e2b661de6d28d11_Out_0_Float = _Tile_Y;
                                                                        float2 _Vector2_0d768a99157947b690b4011919c2e0fd_Out_0_Vector2 = float2(_Property_28841e4c56c449d699ce8655774bfb45_Out_0_Float, _Property_93952c7a35224f899e2b661de6d28d11_Out_0_Float);
                                                                        float _Property_f8ada8ccabc84c0fba96d3bdfcfa3418_Out_0_Float = _FirstLayer_Speed;
                                                                        float _Multiply_b6f87bb7270344abbfb4b28c5ae45762_Out_2_Float;
                                                                        Unity_Multiply_float_float(IN.TimeParameters.x, _Property_f8ada8ccabc84c0fba96d3bdfcfa3418_Out_0_Float, _Multiply_b6f87bb7270344abbfb4b28c5ae45762_Out_2_Float);
                                                                        float2 _Vector2_ba806402a04e48e9b8ff180bc6f53dd8_Out_0_Vector2 = float2(1, _Multiply_b6f87bb7270344abbfb4b28c5ae45762_Out_2_Float);
                                                                        float2 _TilingAndOffset_8db4474d0ad0448796dee47ee2c0261f_Out_3_Vector2;
                                                                        Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_0d768a99157947b690b4011919c2e0fd_Out_0_Vector2, _Vector2_ba806402a04e48e9b8ff180bc6f53dd8_Out_0_Vector2, _TilingAndOffset_8db4474d0ad0448796dee47ee2c0261f_Out_3_Vector2);
                                                                        float4 _SampleTexture2D_d6ad14b7f7f54d7fb3ea98bfa5d465cd_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_d3f4357a037b4294a4561e4800559a98_Out_0_Texture2D.tex, _Property_d3f4357a037b4294a4561e4800559a98_Out_0_Texture2D.samplerstate, _Property_d3f4357a037b4294a4561e4800559a98_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_8db4474d0ad0448796dee47ee2c0261f_Out_3_Vector2));
                                                                        float _SampleTexture2D_d6ad14b7f7f54d7fb3ea98bfa5d465cd_R_4_Float = _SampleTexture2D_d6ad14b7f7f54d7fb3ea98bfa5d465cd_RGBA_0_Vector4.r;
                                                                        float _SampleTexture2D_d6ad14b7f7f54d7fb3ea98bfa5d465cd_G_5_Float = _SampleTexture2D_d6ad14b7f7f54d7fb3ea98bfa5d465cd_RGBA_0_Vector4.g;
                                                                        float _SampleTexture2D_d6ad14b7f7f54d7fb3ea98bfa5d465cd_B_6_Float = _SampleTexture2D_d6ad14b7f7f54d7fb3ea98bfa5d465cd_RGBA_0_Vector4.b;
                                                                        float _SampleTexture2D_d6ad14b7f7f54d7fb3ea98bfa5d465cd_A_7_Float = _SampleTexture2D_d6ad14b7f7f54d7fb3ea98bfa5d465cd_RGBA_0_Vector4.a;
                                                                        UnityTexture2D _Property_c842ca1806df423fa653b7d9754ca8ca_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_FirstLayerMask);
                                                                        float4 _SampleTexture2D_27e0a67c861e46c2b3b2a6e513e4f4a3_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_c842ca1806df423fa653b7d9754ca8ca_Out_0_Texture2D.tex, _Property_c842ca1806df423fa653b7d9754ca8ca_Out_0_Texture2D.samplerstate, _Property_c842ca1806df423fa653b7d9754ca8ca_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy));
                                                                        float _SampleTexture2D_27e0a67c861e46c2b3b2a6e513e4f4a3_R_4_Float = _SampleTexture2D_27e0a67c861e46c2b3b2a6e513e4f4a3_RGBA_0_Vector4.r;
                                                                        float _SampleTexture2D_27e0a67c861e46c2b3b2a6e513e4f4a3_G_5_Float = _SampleTexture2D_27e0a67c861e46c2b3b2a6e513e4f4a3_RGBA_0_Vector4.g;
                                                                        float _SampleTexture2D_27e0a67c861e46c2b3b2a6e513e4f4a3_B_6_Float = _SampleTexture2D_27e0a67c861e46c2b3b2a6e513e4f4a3_RGBA_0_Vector4.b;
                                                                        float _SampleTexture2D_27e0a67c861e46c2b3b2a6e513e4f4a3_A_7_Float = _SampleTexture2D_27e0a67c861e46c2b3b2a6e513e4f4a3_RGBA_0_Vector4.a;
                                                                        float4 _Multiply_086d929899474eef8f9492b3df748da7_Out_2_Vector4;
                                                                        Unity_Multiply_float4_float4(_SampleTexture2D_d6ad14b7f7f54d7fb3ea98bfa5d465cd_RGBA_0_Vector4, _SampleTexture2D_27e0a67c861e46c2b3b2a6e513e4f4a3_RGBA_0_Vector4, _Multiply_086d929899474eef8f9492b3df748da7_Out_2_Vector4);
                                                                        float4 _Blend_22332064b1dd476eb955d1e6f0d31893_Out_2_Vector4;
                                                                        Unity_Blend_Dodge_float4(_SampleTexture2D_dae5062bfb6345989ac4c7936bcb0325_RGBA_0_Vector4, _Multiply_086d929899474eef8f9492b3df748da7_Out_2_Vector4, _Blend_22332064b1dd476eb955d1e6f0d31893_Out_2_Vector4, 1);
                                                                        UnityTexture2D _Property_aa17d6cddc844bbd8fffe2f3526f1d75_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_SecondLayer);
                                                                        float _Property_5443b670d62042b0bf29b6649506a396_Out_0_Float = _Tile_X_2;
                                                                        float _Property_e83f2ffe1d854d7cb7ce9639bef36c35_Out_0_Float = _Tile_Y_2;
                                                                        float2 _Vector2_112aab1e2c1a4c60ac52f6ab932daaae_Out_0_Vector2 = float2(_Property_5443b670d62042b0bf29b6649506a396_Out_0_Float, _Property_e83f2ffe1d854d7cb7ce9639bef36c35_Out_0_Float);
                                                                        float _Property_a122b213cc6049089080486d0e72dd92_Out_0_Float = _SecondLayer_Speed;
                                                                        float _Multiply_74242c5ba0db44a2af24f02259a54654_Out_2_Float;
                                                                        Unity_Multiply_float_float(IN.TimeParameters.x, _Property_a122b213cc6049089080486d0e72dd92_Out_0_Float, _Multiply_74242c5ba0db44a2af24f02259a54654_Out_2_Float);
                                                                        float2 _Vector2_23a4ed409daa44ebb33e022576272145_Out_0_Vector2 = float2(1, _Multiply_74242c5ba0db44a2af24f02259a54654_Out_2_Float);
                                                                        float2 _TilingAndOffset_259fb3e5741d40fbb9d10ab049b94707_Out_3_Vector2;
                                                                        Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_112aab1e2c1a4c60ac52f6ab932daaae_Out_0_Vector2, _Vector2_23a4ed409daa44ebb33e022576272145_Out_0_Vector2, _TilingAndOffset_259fb3e5741d40fbb9d10ab049b94707_Out_3_Vector2);
                                                                        float4 _SampleTexture2D_836113538fba497181d2063bdfe5dc20_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_aa17d6cddc844bbd8fffe2f3526f1d75_Out_0_Texture2D.tex, _Property_aa17d6cddc844bbd8fffe2f3526f1d75_Out_0_Texture2D.samplerstate, _Property_aa17d6cddc844bbd8fffe2f3526f1d75_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_259fb3e5741d40fbb9d10ab049b94707_Out_3_Vector2));
                                                                        float _SampleTexture2D_836113538fba497181d2063bdfe5dc20_R_4_Float = _SampleTexture2D_836113538fba497181d2063bdfe5dc20_RGBA_0_Vector4.r;
                                                                        float _SampleTexture2D_836113538fba497181d2063bdfe5dc20_G_5_Float = _SampleTexture2D_836113538fba497181d2063bdfe5dc20_RGBA_0_Vector4.g;
                                                                        float _SampleTexture2D_836113538fba497181d2063bdfe5dc20_B_6_Float = _SampleTexture2D_836113538fba497181d2063bdfe5dc20_RGBA_0_Vector4.b;
                                                                        float _SampleTexture2D_836113538fba497181d2063bdfe5dc20_A_7_Float = _SampleTexture2D_836113538fba497181d2063bdfe5dc20_RGBA_0_Vector4.a;
                                                                        UnityTexture2D _Property_d7c528359ec04b358fe52533578ee6b9_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_SecondLayerMask);
                                                                        float4 _SampleTexture2D_d6de786ff7b7453d9af1e36379f1e71c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_d7c528359ec04b358fe52533578ee6b9_Out_0_Texture2D.tex, _Property_d7c528359ec04b358fe52533578ee6b9_Out_0_Texture2D.samplerstate, _Property_d7c528359ec04b358fe52533578ee6b9_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy));
                                                                        float _SampleTexture2D_d6de786ff7b7453d9af1e36379f1e71c_R_4_Float = _SampleTexture2D_d6de786ff7b7453d9af1e36379f1e71c_RGBA_0_Vector4.r;
                                                                        float _SampleTexture2D_d6de786ff7b7453d9af1e36379f1e71c_G_5_Float = _SampleTexture2D_d6de786ff7b7453d9af1e36379f1e71c_RGBA_0_Vector4.g;
                                                                        float _SampleTexture2D_d6de786ff7b7453d9af1e36379f1e71c_B_6_Float = _SampleTexture2D_d6de786ff7b7453d9af1e36379f1e71c_RGBA_0_Vector4.b;
                                                                        float _SampleTexture2D_d6de786ff7b7453d9af1e36379f1e71c_A_7_Float = _SampleTexture2D_d6de786ff7b7453d9af1e36379f1e71c_RGBA_0_Vector4.a;
                                                                        float4 _Multiply_1ea6dc267b75448e873dab9c0aba9979_Out_2_Vector4;
                                                                        Unity_Multiply_float4_float4(_SampleTexture2D_836113538fba497181d2063bdfe5dc20_RGBA_0_Vector4, _SampleTexture2D_d6de786ff7b7453d9af1e36379f1e71c_RGBA_0_Vector4, _Multiply_1ea6dc267b75448e873dab9c0aba9979_Out_2_Vector4);
                                                                        float4 _Property_12403b7668af40959b7e6b93ac1deb70_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_Color) : _Color;
                                                                        float4 _Multiply_7dad164dce0f4fcaacdb934f7bd9ccaa_Out_2_Vector4;
                                                                        Unity_Multiply_float4_float4(_Multiply_1ea6dc267b75448e873dab9c0aba9979_Out_2_Vector4, _Property_12403b7668af40959b7e6b93ac1deb70_Out_0_Vector4, _Multiply_7dad164dce0f4fcaacdb934f7bd9ccaa_Out_2_Vector4);
                                                                        float4 _Add_160a66523e9a45d9982c0cb2001a1cd9_Out_2_Vector4;
                                                                        Unity_Add_float4(_Multiply_086d929899474eef8f9492b3df748da7_Out_2_Vector4, _Multiply_7dad164dce0f4fcaacdb934f7bd9ccaa_Out_2_Vector4, _Add_160a66523e9a45d9982c0cb2001a1cd9_Out_2_Vector4);
                                                                        float4 _Blend_d23b982fe8434a9ba42b28e9067ede89_Out_2_Vector4;
                                                                        Unity_Blend_Dodge_float4(_Blend_22332064b1dd476eb955d1e6f0d31893_Out_2_Vector4, _Add_160a66523e9a45d9982c0cb2001a1cd9_Out_2_Vector4, _Blend_d23b982fe8434a9ba42b28e9067ede89_Out_2_Vector4, 0);
                                                                        UnityTexture2D _Property_2296a933b1a044b889041aa853a7f13a_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_FlareLayer);
                                                                        float _Property_782a0df3d6284fabae7e7ac9130de612_Out_0_Float = _Tile_X_Flare;
                                                                        float _Property_cab0217c4db14cb08c0c11fd45bf24d0_Out_0_Float = _Tile_Y_Flare;
                                                                        float2 _Vector2_1952ea97bee3429381dad80e93776ec2_Out_0_Vector2 = float2(_Property_782a0df3d6284fabae7e7ac9130de612_Out_0_Float, _Property_cab0217c4db14cb08c0c11fd45bf24d0_Out_0_Float);
                                                                        float _Property_aed1ddb6d9a5427580bc310dd089f919_Out_0_Float = _Flare_Speed;
                                                                        float _Multiply_4b4bff5c45e140bca122d3c80dc22ea7_Out_2_Float;
                                                                        Unity_Multiply_float_float(IN.TimeParameters.x, _Property_aed1ddb6d9a5427580bc310dd089f919_Out_0_Float, _Multiply_4b4bff5c45e140bca122d3c80dc22ea7_Out_2_Float);
                                                                        float2 _Vector2_2565b1496cd443f6b1ba17365aa447da_Out_0_Vector2 = float2(0.57, _Multiply_4b4bff5c45e140bca122d3c80dc22ea7_Out_2_Float);
                                                                        float4 _UV_6593fae6f24d472d8d9e543f8a171b90_Out_0_Vector4 = IN.uv0;
                                                                        float4 _Add_f71da7687c2d4a81ad17d32ca6b91452_Out_2_Vector4;
                                                                        Unity_Add_float4((_Multiply_4b4bff5c45e140bca122d3c80dc22ea7_Out_2_Float.xxxx), _UV_6593fae6f24d472d8d9e543f8a171b90_Out_0_Vector4, _Add_f71da7687c2d4a81ad17d32ca6b91452_Out_2_Vector4);
                                                                        float _GradientNoise_c42c53c8620e444eb353533ecb9dbac5_Out_2_Float;
                                                                        Unity_GradientNoise_LegacyMod_float((_Add_f71da7687c2d4a81ad17d32ca6b91452_Out_2_Vector4.xy), 10, _GradientNoise_c42c53c8620e444eb353533ecb9dbac5_Out_2_Float);
                                                                        float _Property_c5fe4c7886864818a6634886e951c3cd_Out_0_Float = _Flare_Noise;
                                                                        float3 _NormalFromHeight_aac2a418455049acb09867e85f9521d4_Out_1_Vector3;
                                                                        float3x3 _NormalFromHeight_aac2a418455049acb09867e85f9521d4_TangentMatrix = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
                                                                        float3 _NormalFromHeight_aac2a418455049acb09867e85f9521d4_Position = IN.WorldSpacePosition;
                                                                        Unity_NormalFromHeight_Tangent_float(_GradientNoise_c42c53c8620e444eb353533ecb9dbac5_Out_2_Float,_Property_c5fe4c7886864818a6634886e951c3cd_Out_0_Float,_NormalFromHeight_aac2a418455049acb09867e85f9521d4_Position,_NormalFromHeight_aac2a418455049acb09867e85f9521d4_TangentMatrix, _NormalFromHeight_aac2a418455049acb09867e85f9521d4_Out_1_Vector3);
                                                                        float _Float_3b8429aad5284fe6ad703abf61f73644_Out_0_Float = 0.05;
                                                                        float3 _Multiply_e0bf4aabf4f046b6af7d6e72cfdb7fe7_Out_2_Vector3;
                                                                        Unity_Multiply_float3_float3(_NormalFromHeight_aac2a418455049acb09867e85f9521d4_Out_1_Vector3, (_Float_3b8429aad5284fe6ad703abf61f73644_Out_0_Float.xxx), _Multiply_e0bf4aabf4f046b6af7d6e72cfdb7fe7_Out_2_Vector3);
                                                                        float2 _Add_5a53b043f4a94542b971037a99a59c9d_Out_2_Vector2;
                                                                        Unity_Add_float2(_Vector2_2565b1496cd443f6b1ba17365aa447da_Out_0_Vector2, (_Multiply_e0bf4aabf4f046b6af7d6e72cfdb7fe7_Out_2_Vector3.xy), _Add_5a53b043f4a94542b971037a99a59c9d_Out_2_Vector2);
                                                                        float2 _TilingAndOffset_f850fca5d6c14dd4af26c36689f98822_Out_3_Vector2;
                                                                        Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_1952ea97bee3429381dad80e93776ec2_Out_0_Vector2, _Add_5a53b043f4a94542b971037a99a59c9d_Out_2_Vector2, _TilingAndOffset_f850fca5d6c14dd4af26c36689f98822_Out_3_Vector2);
                                                                        float4 _SampleTexture2D_16d53b57feef4457b6511a222279c4c2_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_2296a933b1a044b889041aa853a7f13a_Out_0_Texture2D.tex, _Property_2296a933b1a044b889041aa853a7f13a_Out_0_Texture2D.samplerstate, _Property_2296a933b1a044b889041aa853a7f13a_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_f850fca5d6c14dd4af26c36689f98822_Out_3_Vector2));
                                                                        float _SampleTexture2D_16d53b57feef4457b6511a222279c4c2_R_4_Float = _SampleTexture2D_16d53b57feef4457b6511a222279c4c2_RGBA_0_Vector4.r;
                                                                        float _SampleTexture2D_16d53b57feef4457b6511a222279c4c2_G_5_Float = _SampleTexture2D_16d53b57feef4457b6511a222279c4c2_RGBA_0_Vector4.g;
                                                                        float _SampleTexture2D_16d53b57feef4457b6511a222279c4c2_B_6_Float = _SampleTexture2D_16d53b57feef4457b6511a222279c4c2_RGBA_0_Vector4.b;
                                                                        float _SampleTexture2D_16d53b57feef4457b6511a222279c4c2_A_7_Float = _SampleTexture2D_16d53b57feef4457b6511a222279c4c2_RGBA_0_Vector4.a;
                                                                        UnityTexture2D _Property_daed62fc7e254f5291f7e8d4b4d36cc8_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_FlareLayerMask);
                                                                        float4 _SampleTexture2D_f771449173f64fea8fadc2f2470df5a2_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_daed62fc7e254f5291f7e8d4b4d36cc8_Out_0_Texture2D.tex, _Property_daed62fc7e254f5291f7e8d4b4d36cc8_Out_0_Texture2D.samplerstate, _Property_daed62fc7e254f5291f7e8d4b4d36cc8_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy));
                                                                        float _SampleTexture2D_f771449173f64fea8fadc2f2470df5a2_R_4_Float = _SampleTexture2D_f771449173f64fea8fadc2f2470df5a2_RGBA_0_Vector4.r;
                                                                        float _SampleTexture2D_f771449173f64fea8fadc2f2470df5a2_G_5_Float = _SampleTexture2D_f771449173f64fea8fadc2f2470df5a2_RGBA_0_Vector4.g;
                                                                        float _SampleTexture2D_f771449173f64fea8fadc2f2470df5a2_B_6_Float = _SampleTexture2D_f771449173f64fea8fadc2f2470df5a2_RGBA_0_Vector4.b;
                                                                        float _SampleTexture2D_f771449173f64fea8fadc2f2470df5a2_A_7_Float = _SampleTexture2D_f771449173f64fea8fadc2f2470df5a2_RGBA_0_Vector4.a;
                                                                        float4 _Multiply_ee41795c0bae447793edbbf2ad5d1905_Out_2_Vector4;
                                                                        Unity_Multiply_float4_float4(_SampleTexture2D_16d53b57feef4457b6511a222279c4c2_RGBA_0_Vector4, _SampleTexture2D_f771449173f64fea8fadc2f2470df5a2_RGBA_0_Vector4, _Multiply_ee41795c0bae447793edbbf2ad5d1905_Out_2_Vector4);
                                                                        float4 _Blend_2dd7dae929b34fe9b21b4b787d2ad749_Out_2_Vector4;
                                                                        Unity_Blend_Screen_float4(_Blend_d23b982fe8434a9ba42b28e9067ede89_Out_2_Vector4, _Multiply_ee41795c0bae447793edbbf2ad5d1905_Out_2_Vector4, _Blend_2dd7dae929b34fe9b21b4b787d2ad749_Out_2_Vector4, 1);
                                                                        surface.BaseColor = (_Blend_2dd7dae929b34fe9b21b4b787d2ad749_Out_2_Vector4.xyz);
                                                                        surface.Alpha = 1;
                                                                        surface.AlphaClipThreshold = 0.5;
                                                                        return surface;
                                                                    }

                                                                    // --------------------------------------------------
                                                                    // Build Graph Inputs
                                                                    #ifdef HAVE_VFX_MODIFICATION
                                                                    #define VFX_SRP_ATTRIBUTES Attributes
                                                                    #define VFX_SRP_VARYINGS Varyings
                                                                    #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
                                                                    #endif
                                                                    VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                                                                    {
                                                                        VertexDescriptionInputs output;
                                                                        ZERO_INITIALIZE(VertexDescriptionInputs, output);

                                                                        output.ObjectSpaceNormal = input.normalOS;
                                                                        output.ObjectSpaceTangent = input.tangentOS.xyz;
                                                                        output.ObjectSpacePosition = input.positionOS;

                                                                        return output;
                                                                    }
                                                                    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                                                                    {
                                                                        SurfaceDescriptionInputs output;
                                                                        ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

                                                                    #ifdef HAVE_VFX_MODIFICATION
                                                                    #if VFX_USE_GRAPH_VALUES
                                                                        uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
                                                                        /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
                                                                    #endif
                                                                        /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

                                                                    #endif



                                                                        // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
                                                                        float3 unnormalizedNormalWS = input.normalWS;
                                                                        const float renormFactor = 1.0 / length(unnormalizedNormalWS);

                                                                        // use bitangent on the fly like in hdrp
                                                                        // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
                                                                        float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0) * GetOddNegativeScale();
                                                                        float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);

                                                                        output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph

                                                                        // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
                                                                        // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
                                                                        output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
                                                                        output.WorldSpaceBiTangent = renormFactor * bitang;

                                                                        output.WorldSpacePosition = input.positionWS;

                                                                        #if UNITY_UV_STARTS_AT_TOP
                                                                        #else
                                                                        #endif


                                                                        output.uv0 = input.texCoord0;
                                                                        output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
                                                                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                                    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                                                                    #else
                                                                    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                                                                    #endif
                                                                    #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

                                                                            return output;
                                                                    }

                                                                    // --------------------------------------------------
                                                                    // Main

                                                                    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
                                                                    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"

                                                                    // --------------------------------------------------
                                                                    // Visual Effect Vertex Invocations
                                                                    #ifdef HAVE_VFX_MODIFICATION
                                                                    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
                                                                    #endif

                                                                    ENDHLSL
                                                                    }
    }
        CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
        CustomEditorForRenderPipeline "NekoLegends.GalaxyShaderInspector" "UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset"
                                                                        
}
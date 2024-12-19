#if UNITY_2020_1_OR_NEWER
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Experimental.Rendering;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class UASSRendererFeature : ScriptableRendererFeature
{
    #if UNITY_2022_1_OR_NEWER
    RTHandle nothingHandle;
    #endif

    public override void Create()
    {
        name = "UASS Renderer Feature";
        #if UNITY_2022_1_OR_NEWER
        nothingHandle = RTHandles.Alloc(BuiltinRenderTextureType.None);
        #endif
    }

    //Called for every camera every frame
    List<UASS> components = new List<UASS>();
    public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
    {
        renderingData.cameraData.camera.GetComponents(components);
        for (int i = 0; i < components.Count; i++)
        {
            UASS component = components[i];
            // github.com/Unity-Technologies/Graphics/blob/57e1ed25ced552cd3bb59126f3e7fd1db85e11f1/Packages/com.unity.render-pipelines.universal/Runtime/UniversalRenderPipeline.cs#L1225
            bool dontRenderScale = renderingData.cameraData.cameraType == CameraType.SceneView || renderingData.cameraData.cameraType == CameraType.Preview || renderingData.cameraData.cameraType == CameraType.Reflection;
            if (component != null && component.isActiveAndEnabled) component.OnPreRenderScriptablePipeline(dontRenderScale ? 1f : renderingData.cameraData.renderScale);
        }

        var buffers = renderingData.cameraData.camera.GetCommandBuffers(CameraEvent.BeforeLighting); //Camera:GetCommandBuffers() allocates ~64bytes and theres nothing really to do about it
        if (buffers.Length > 0)
        {
            var camData = renderingData.cameraData.camera.GetUniversalAdditionalCameraData();
            camData.requiresDepthOption = CameraOverrideOption.On;
            camData.requiresDepthTexture = true;
        }
        bool first = true;
        for (int i = 0; i < buffers.Length; i++)
        {
            CommandBuffer buffer = buffers[i];
            if (buffer != null)
            {
                //var pass = new UASSRenderPass();
                var pass = GenericPool<UASSRenderPass>.Get();
                
                pass.renderPassEvent = RenderPassEvent.BeforeRenderingOpaques;
                pass.commandBuffer = buffer;
                pass.firstRenderPassSetupTexture = first;
                first = false;
                pass.ConfigureInput(ScriptableRenderPassInput.Depth);
                
                #if UNITY_2022_1_OR_NEWER
                pass.ConfigureTarget(nothingHandle);
                #else
                pass.ConfigureTarget(BuiltinRenderTextureType.None);
                #endif
                
                renderer.EnqueuePass(pass);
            }
        }
    }
    
    class UASSRenderPass : ScriptableRenderPass
    {
        public CommandBuffer commandBuffer;
        public bool firstRenderPassSetupTexture = false;
        
        public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
        {
            if (commandBuffer != null)
            {
                if (firstRenderPassSetupTexture)
                {
                    var buf = CommandBufferPool.Get("Analytic Soft Shadows");

                    int _analyicShadowsTexture = Shader.PropertyToID("_UASSTexture");
                    buf.ReleaseTemporaryRT(_analyicShadowsTexture);
                    buf.GetTemporaryRT(_analyicShadowsTexture, renderingData.cameraData.camera.pixelWidth, renderingData.cameraData.camera.pixelHeight, 0, FilterMode.Bilinear, GraphicsFormat.R16G16B16A16_SFloat);
                    buf.SetGlobalTexture(_analyicShadowsTexture, new RenderTargetIdentifier(_analyicShadowsTexture, 0, CubemapFace.Unknown, -1));
                    buf.SetRenderTarget(_analyicShadowsTexture);
                    buf.ClearRenderTarget(false, true, Color.white);

                    context.ExecuteCommandBuffer(buf);
                    CommandBufferPool.Release(buf);
                }

                context.ExecuteCommandBuffer(commandBuffer);
            }
            
            GenericPool<UASSRenderPass>.Release(this);
        }
        
    }
}
#endif
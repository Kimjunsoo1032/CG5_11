using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.RenderGraphModule;
using UnityEngine.Rendering.RenderGraphModule.Util;
using UnityEngine.Rendering.Universal;

public class PostEffectRenderPass : ScriptableRenderPass
{
    private Material blurMaterial_;
    private Material passThroughMaterial_;

    public PostEffectRenderPass(
        Material blurMaterial,
        Material passThroughMaterial)
    {
        blurMaterial_ = blurMaterial;
        passThroughMaterial_ = passThroughMaterial;
    }

    public override void RecordRenderGraph(
        RenderGraph renderGraph,
        ContextContainer frameData)
    {
        if (blurMaterial_ == null || passThroughMaterial_ == null)
        {
            return;
        }

        UniversalResourceData resourceData =
            frameData.Get<UniversalResourceData>();

        if (resourceData.isActiveTargetBackBuffer)
        {
            return;
        }

        TextureHandle cameraTexture =
            resourceData.activeColorTexture;

        TextureDesc tempDesc =
            renderGraph.GetTextureDesc(cameraTexture);

        tempDesc.depthBufferBits = 0;

        tempDesc.name = "_OrigTempTexture";
        TextureHandle origTempTexture =
            renderGraph.CreateTexture(tempDesc);

        tempDesc.name = "_SmallTempTexture";
        int div = 2;
        tempDesc.width /= div;
        tempDesc.height /= div;

        TextureHandle smallTempTexture =
            renderGraph.CreateTexture(tempDesc);

        RenderGraphUtils.BlitMaterialParameters downSampleParams =
            new RenderGraphUtils.BlitMaterialParameters(
                cameraTexture,
                smallTempTexture,
                blurMaterial_,
                0);

        renderGraph.AddBlitPass(
            downSampleParams,
            "DownSamplingBlur");

        RenderGraphUtils.BlitMaterialParameters upSampleParams =
            new RenderGraphUtils.BlitMaterialParameters(
                smallTempTexture,
                origTempTexture,
                passThroughMaterial_,
                0);

        renderGraph.AddBlitPass(
            upSampleParams,
            "UpSamplingBlur");

        renderGraph.AddCopyPass(
            origTempTexture,
            cameraTexture,
            "CopyBlurResult");
    }
}

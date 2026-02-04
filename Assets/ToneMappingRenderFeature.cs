using UnityEngine;
using UnityEngine.Rendering.Universal;

public class ToneMappingRenderFeature : ScriptableRendererFeature
{
    [SerializeField]
    private Material postEffectMaterial_;

    private ToneMappingRenderPass renderPass_;

    public override void Create()
    {
        renderPass_ = new ToneMappingRenderPass(postEffectMaterial_);
        renderPass_.renderPassEvent = RenderPassEvent.BeforeRenderingPostProcessing;
    }

    public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
    {
        if (renderer != null)
        {
            renderer.EnqueuePass(renderPass_);
        }
    }
}
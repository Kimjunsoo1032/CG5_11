using UnityEngine;
using UnityEngine.Rendering.Universal;

public class PostEffectRenderFeature : ScriptableRendererFeature
{
    [SerializeField]
    private Material blurMaterial_;

    [SerializeField]
    private Material passThroughMaterial_;

    private PostEffectRenderPass renderPass_;

    public override void Create()
    {
        renderPass_ = new PostEffectRenderPass(
            blurMaterial_,
            passThroughMaterial_);

        renderPass_.renderPassEvent =
            RenderPassEvent.BeforeRenderingPostProcessing;
    }

    public override void AddRenderPasses(
        ScriptableRenderer renderer,
        ref RenderingData renderingData)
    {
        if (renderPass_ != null)
        {
            renderer.EnqueuePass(renderPass_);
        }
    }
}

Shader "Custom/PE_PassThrough"
{
    SubShader
    {
        Tags { "RenderPipeline" = "UniversalPipeline" }

        Pass
        {
            HLSLPROGRAM
            #pragma vertex Vert
            #pragma fragment Frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.core/Runtime/Utilities/Blit.hlsl"

            CBUFFER_START(UnityPerMaterial)
                float _StepWidth;
                float _StepNums;
            CBUFFER_END

            half4 Frag(Varyings IN) : SV_Target
            {
                half4 output = SAMPLE_TEXTURE2D(
                    _BlitTexture,
                    sampler_LinearRepeat,
                    IN.texcoord
                    );
                return output;
            }
            ENDHLSL
        }
    }
}

Shader "Custom/13_02GaussianBlur"
{
    Properties
    {
        _StepWidth ("ブラー密度", Range(0.001, 0.2)) = 0.05
        _Sigma     ("ブラー強度", Range(0.001, 0.1)) = 0.01
    }

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
                float _Sigma;
            CBUFFER_END
            
            float Gaussian(float x, float sigma)
            {
             sigma = max(sigma, 0.0001);
             return exp(-(x * x) / (2.0 * sigma * sigma));
            }
            half4 Frag(Varyings IN) : SV_Target
            {
                half4 output = half4(0, 0, 0, 0);
                float totalWeight = 0.0;

                float kernelWidth = 3.0 * _Sigma;
                float2 margin = _BlitTexture_TexelSize.xy * 0.5;

                for (float y = -kernelWidth * 0.5; y <= kernelWidth * 0.5; y += _StepWidth)
                {
                    for (float x = -kernelWidth * 0.5; x <= kernelWidth * 0.5; x += _StepWidth)
                    {
                        float2 drawUV = IN.texcoord;
                        float2 pickUV = IN.texcoord + float2(x, y);
                        pickUV = clamp(pickUV, margin, 1.0 - margin);

                        float d = distance(drawUV, pickUV);
                        float weight = Gaussian(d, _Sigma);

                        half4 color = SAMPLE_TEXTURE2D(
                            _BlitTexture,
                            sampler_LinearClamp,
                            pickUV
                        );

                        output += color * weight;
                        totalWeight += weight;
                    }
                }

                output /= max(totalWeight, 0.0001);
                output.a = 1.0;
                return output;
            }
            ENDHLSL
        }
    }
}

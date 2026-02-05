Shader "Custom/13_01AverageBlur"
{
    Properties
    {
        _StepWidth ("ブラー密度", Range(0, 0.1)) = 0.01
        _StepNums  ("ブラー強度", Range(0, 5))   = 3
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
                float _StepNums;
            CBUFFER_END

            half4 Frag(Varyings IN) : SV_Target
            {
                half4 output = half4(0,0,0,0);
                float loopCount = 0.0;

                float stepNums = floor(_StepNums);
                float2 margin = _BlitTexture_TexelSize.xy * 0.5;

                for (float y = -stepNums * 0.5; y <= stepNums * 0.5; y += 1.0)
                {
                    for (float x = -stepNums * 0.5; x <= stepNums * 0.5; x += 1.0)
                    {
                        float2 uv = IN.texcoord + float2(x, y) * _StepWidth;
                        uv = clamp(uv, margin, 1.0 - margin);

                        output += SAMPLE_TEXTURE2D(
                            _BlitTexture,
                            sampler_LinearClamp,
                            uv
                        );

                        loopCount += 1.0;
                    }
                }

                output /= loopCount;
                output.a = 1.0;
                return output;
            }
            ENDHLSL
        }
    }
}

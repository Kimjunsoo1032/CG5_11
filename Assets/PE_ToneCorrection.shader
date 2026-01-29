Shader "PostEffect/PE_ToneCorrection"
{
    Properties
    {
        _saturation ("彩度", Range(0,1)) = 1
        _contrast   ("コントラスト", Range(0,2)) = 1
    }

    SubShader
    {
        Tags { "RenderPipeline" = "UniversalPipeline" }

        Pass
        {
            ZWrite Off
            ZTest Always
            Blend Off
            Cull Off

            HLSLPROGRAM
            #pragma vertex Vert
            #pragma fragment Frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.core/Runtime/Utilities/Blit.hlsl"

            half _saturation;
            half _contrast;

            half4 Frag(Varyings input) : SV_Target
            {
                half4 output =
                    SAMPLE_TEXTURE2D(_BlitTexture, sampler_LinearRepeat, input.texcoord);

                half grayscale =
                    0.2126 * output.r +
                    0.7152 * output.g +
                    0.0722 * output.b;

                half4 monochromeColor =
                    half4(grayscale, grayscale, grayscale, 1);

                half4 outputColor =
                    lerp(monochromeColor, output, _saturation);

                outputColor.rgb =
                    (outputColor.rgb - 0.5) * _contrast + 0.5;

                return outputColor;
            }
            ENDHLSL
        }
    }
}

Shader "Unlit/HealthBar"
{
    Properties
    {
        _Health ("Health", Range(0, 1)) = 0
        _StartColor("Start Color", Color) = (1,1,1,1)
        _EndColor("End Color", Color) = (1,1,1,1)
        _Background ("Background", Color) = (1,1,1,1)

        _FirstThreshold ("First threshold", Range(0,1))= 0
        _SecondThreshold ("Second threshold", Range(0,1))= 0

        _HealthBar ("Health bar", 2D) = "bump" {}

    }
    SubShader
    {
        Tags
        {
            "RenderType"="Transparent"
        }
        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #define TAU 6.28318530718


            float _Health;
            float4 _StartColor;
            float4 _EndColor;
            float4 _Background;

            float _FirstThreshold;
            float _SecondThreshold;

            sampler2D _HealthBar;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 worldPos : TEXTCOORD1;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.worldPos = mul(UNITY_MATRIX_M, v.vertex);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float2 InverseLerp(float a, float b, float v)
            {
                return (v - a) / (b - a);
            }

            float GetWave(float coord)
            {
                float yUv = coord;
                float wave = (yUv - _Time.y * 0.1) * TAU * 5;
                wave = cos(wave) * 0.5 + 0.5;
                wave *= coord;
                return wave;
            }

            float4 frag(v2f i) : SV_Target
            {
                float2 topDownProjection = i.uv.x;

                float4 finalColor = 0;
                float4 healthBarTex = tex2D(_HealthBar, topDownProjection);

                if (i.uv.x <= _Health)
                {
                    float t = InverseLerp(_FirstThreshold, _SecondThreshold, _Health);
                    // finalColor = lerp(_StartColor, _EndColor, t);
                    finalColor = healthBarTex;

                    if (_Health < 0.2)
                    {
                        float pulsate = cos(_Time.y * 3) * 0.5 + 0.5;
                        finalColor = lerp(float4(1, 0, 0, 1), finalColor, pulsate); //* (1 - i.uv.x);
                    }
                }

                return finalColor;
            }
            ENDCG
        }
    }
}
Shader "Unlit/Textured"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Rock ("Rock", 2D) = "white" {}
        _Pattern ("Patern", 2D) = "bump" {}
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #define TAU 6.28318530718


            struct MeshData
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

            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _Pattern;
            sampler2D _Rock;

            float GetWave(float coord)
            {
                float yUv = coord;
                float wave = (yUv - _Time.y * 0.1) * TAU * 5;
                wave = cos(wave) * 0.5 + 0.5;
                wave *= coord;
                return wave;
            }

            v2f vert(MeshData v)
            {
                v2f o;
                o.worldPos = mul(UNITY_MATRIX_M, v.vertex);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                // o.uv += _Time * 0.1;
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                float2 topDownProjection = i.worldPos.xz;
                float4 moss = tex2D(_MainTex, topDownProjection);

                float pattern = tex2D(_Pattern, i.uv).x;
                float rock = tex2D(_Rock, topDownProjection).x;

                float4 finalColor = lerp(rock, moss, pattern);

                return moss;
            }
            ENDCG
        }
    }
}
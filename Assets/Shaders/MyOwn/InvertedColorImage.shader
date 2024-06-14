Shader "Unlit/InvertedColorImage"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _InvertedFactor ("Inverted Factor", Range(0, 1)) = 1
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Transparent"
            "Queue"="Transparent"
        }
        Pass
        {
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct MeshData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _InvertedFactor;

            v2f vert(MeshData v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                float4 col = tex2D(_MainTex, i.uv);
                // at inverted factor 1, the color will be inverted, and at 0, the color will be the same
                float3 invertedColor = lerp(col.rgb, 1 - col.rgb, _InvertedFactor);

                return float4(invertedColor, col.a);
            }
            ENDCG
        }
    }
}
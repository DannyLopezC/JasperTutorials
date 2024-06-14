Shader "Unlit/Vertex Offset"
{
    Properties //input data
    {
        _BlueColor ("Blue Color", Color) = (1,1,1,1)
        _BlueColorB ("Blue Color B", Color) = (1,1,1,1)
        _ColorStart ("Color Start", Range(0,1) ) = 1
        _ColorEnd ("Color end", Range(0,1)) = 0
        _WaveAmp ("Wave Amplitude", Range(0,0.2)) = 0
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

            float4 _BlueColor;
            float4 _BlueColorB;

            float _ColorStart;
            float _ColorEnd;

            float _WaveAmp;

            struct MeshData // per-vertex mesh data
            {
                float4 vertex : POSITION; // vertex position

                float3 normals : NORMAL;
                // float4 color: COLOR;
                // float4 tangent: TANGENT;

                float4 uv0 : TEXCOORD0; // uv0 coordinates
                // float4 uv1 : TEXCOORD1; // uv1 coordinates
            };

            struct v2f
            {
                float4 vertex : SV_POSITION; // clip space position (normalized)
                float3 normal : TEXCOORD0;
                float2 uv : TEXCOORD1; // passing any data
            };

            float GetWave(float2 uv, bool negative)
            {
                float2 uvsCentered = uv * 2 - 1;
                float radialDistance = length(uvsCentered);

                float yUv = radialDistance;
                float wave = (yUv - _Time.y * 0.2) * TAU * 5;
                wave = cos(wave);

                return (negative ? wave : wave * 0.5 + 0.5) * (1 - radialDistance);
            }

            v2f vert(MeshData v)
            {
                v2f o;
                v.vertex.y = GetWave(v.uv0, true) * _WaveAmp;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normals);
                o.uv = v.uv0; //(v.uv0 + _Offset) * _Scale;
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                // Obtiene el valor de onda entre 0 y 1
                float waveValue = GetWave(i.uv, false);

                // Mapea el valor de la onda al rango de color entre azul y blanco
                float4 finalColor = lerp(_BlueColor, _BlueColorB, waveValue);
                //Change color for red
                return finalColor;
            }
            ENDCG
        }
    }
}
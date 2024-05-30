Shader "Unlit/UnlitPointSurface"
{
    Properties //input data
    {
        _ColorA ("Color A", Color) = (1,1,1,1)
        _ColorB ("Color B", Color) = (1,1,1,1)
        _ColorStart ("Color Start", Range(0,1) ) = 1
        _ColorEnd ("Color end", Range(0,1)) = 0
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Transparent"
            "Queue" ="Transparent"
        }

        Pass
        {
            Cull Off
            Zwrite Off
            Blend One One // additive
            //Blend DstColor Zero // additive 

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            #define TAU 6.28318530718

            float4 _ColorA;
            float4 _ColorB;

            float _ColorStart;
            float _ColorEnd;

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

            v2f vert(MeshData v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normals);
                o.uv = v.uv0; //(v.uv0 + _Offset) * _Scale;
                // manually
                // o.normal = mul((float3x3)unity_ObjectToWorld, v.normals);
                return o;
            }

            float2 InverseLerp(float a, float b, float v)
            {
                return (v - a) / (b - a);
            }

            // bool 0 1
            // float (32 bit)
            // half (16 bit)
            // fixed (lower precision) -1 to 1
            // float4 -> half4 -> fixed4
            // float4x4 (matrix)

            float4 frag(v2f i) : SV_Target
            {
                float4 myColor;

                float4 greyScaleMyColor = myColor.xxxx;

                // float t = saturate(InverseLerp(_ColorStart, _ColorEnd, i.uv.x));

                // t = frac(t);

                // return t;

                float x = i.uv.y;
                float xOffset = cos(i.uv.x * TAU * 8) * 0.01;

                x = (x + xOffset + _Time.y * -0.5) * TAU * 5;
                // x = frac(x); // getting x segments
                //
                // x = abs(x * 2 - 1);

                x = cos(x) * 0.5 + 0.5;

                float t = x;
                t *= 1 - (i.uv.y * 2);

                float topBottomRemover = (abs(i.normal.y) < 0.999);

                float4 gradient = lerp(_ColorA, _ColorB, x);

                return t * topBottomRemover * gradient;
                // lerp
            }
            ENDCG
        }
    }
}
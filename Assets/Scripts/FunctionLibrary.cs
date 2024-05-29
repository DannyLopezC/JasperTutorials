using System;
using UnityEngine;
using static UnityEngine.Mathf;

public enum WaveType
{
    Sin,
    Cos,
    Tan,
    Csc
}

public enum WaveFunction
{
    Wave,
    MultiWave,
    Ripple
}

public static class FunctionLibrary
{
    public delegate float Function(float x, float z, float t, WaveType type);

    private static Function[] _functions = { Wave, MultiWave, Ripple };

    public static Function GetFunction(WaveFunction index)
    {
        return _functions[(int)index];
    }

    public static float Wave(float x, float z, float t, WaveType type)
    {
        float valueOnTheFunction = PI * (x + z + t);

        switch (type)
        {
            case WaveType.Sin:
                return Sin(valueOnTheFunction);
            case WaveType.Cos:
                return Cos(valueOnTheFunction);
            case WaveType.Tan:
                return Tan(valueOnTheFunction);
            case WaveType.Csc:
                return 1 / Sin(valueOnTheFunction);
            default:
                throw new ArgumentOutOfRangeException(nameof(type), type, null);
        }
    }

    public static float MultiWave(float x, float z, float t, WaveType type)
    {
        float y = 0;
        float valueOnTheFunction = PI * (x + 0.5f * t);
        float valueOnTheAddedFunction = 2f * PI * (z + t);
        float addedFunctionMultiplier = 0.5f;
        float normalization = 1f / 2.5f;

        switch (type)
        {
            case WaveType.Sin:
                y = Sin(valueOnTheFunction);
                y += Sin(valueOnTheAddedFunction) * addedFunctionMultiplier;
                y += Sin(PI * (x + z + 0.25f * t));
                return y * normalization;
            case WaveType.Cos:
                y = Cos(valueOnTheFunction);
                y += Cos(valueOnTheAddedFunction) * addedFunctionMultiplier;
                y += Cos(PI * (x + z + 0.25f * t));
                return y * normalization;
            case WaveType.Tan:
                y = Tan(valueOnTheFunction);
                y += Tan(valueOnTheAddedFunction) * addedFunctionMultiplier;
                y += Tan(PI * (x + z + 0.25f * t));
                return y * normalization;
            case WaveType.Csc:
                y = 1 / Sin(valueOnTheFunction);
                y += 1 / (Sin(valueOnTheAddedFunction) * addedFunctionMultiplier);
                y += Sin(PI * (x + z + 0.25f * t));
                return y * normalization;
            default:
                throw new ArgumentOutOfRangeException(nameof(type), type, null);
        }
    }

    public static float Ripple(float x, float z, float t, WaveType type)
    {
        float d = Sqrt(x * x + z * z);
        float y = 0;

        switch (type)
        {
            case WaveType.Sin:
                y = Sin(PI * (4f * d - (t * 1.5f)));
                break;
            case WaveType.Cos:
                y = Cos(PI * (4f * d - (t * 1.5f)));
                break;
            case WaveType.Tan:
                y = Tan(PI * (4f * d - (t * 1.5f)));
                break;
            case WaveType.Csc:
                y = 1 / Sin(PI * (4f * d - (t * 1.5f)));
                break;
            default:
                throw new ArgumentOutOfRangeException(nameof(type), type, null);
        }

        return y / (1f + 10f * d);
    }
}
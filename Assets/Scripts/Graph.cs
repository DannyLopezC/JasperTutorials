using System;
using Sirenix.OdinInspector;
using UnityEngine;

public class Graph : MonoBehaviour
{
    [SerializeField] private Transform pointPrefab;
    [SerializeField] private float pointSizeMultiplayer;

    [SerializeField] private float originRadius = 1f;
    [SerializeField] [Range(10, 1000)] private int resolution;
    private Transform[] _points;

    [SerializeField] private WaveType waveType;
    [SerializeField] private WaveFunction waveFunction;

    private void Awake()
    {
        DrawGraph();

        // point = Instantiate(pointPrefab);
        // point.localPosition = Vector3.right * 2f;
    }

    private void Update()
    {
        float time = Time.time;
        for (var i = 0; i < _points.Length; i++)
        {
            Transform point = _points[i];
            Vector3 position = point.localPosition;
            FunctionLibrary.Function f = FunctionLibrary.GetFunction(waveFunction);
            position.y = f(position.x, position.z, time, waveType);
            point.localPosition = position;
        }
    }

    [Button]
    public void DrawGraph()
    {
        if (_points != null && _points.Length > 0)
        {
            foreach (Transform point in _points)
            {
                Destroy(point.gameObject);
            }
        }

        float step = 2f / resolution;
        var position = Vector3.zero;
        var scale = Vector3.one * step * pointSizeMultiplayer;

        _points = new Transform[resolution * resolution];
        for (int i = 0, x = 0, z = 0; i < _points.Length; i++, x++)
        {
            if (x == resolution)
            {
                x = 0;
                z += 1;
            }

            var point = Instantiate(pointPrefab, transform, false);
            _points[i] = point;
            position.x = (x + 0.5f) * step - 1f;
            position.z = (z + 0.5f) * step - 1f;
            point.localPosition = position;
            point.localScale = scale;
        }
    }

    private void OnDrawGizmos()
    {
        Gizmos.DrawSphere(Vector3.zero, originRadius);
    }
}
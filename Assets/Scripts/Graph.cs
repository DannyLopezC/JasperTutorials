using Sirenix.OdinInspector;
using UnityEngine;

public class Graph : MonoBehaviour
{
    [SerializeField] private Transform pointPrefab;

    [SerializeField] private float originRadius = 1f;
    [SerializeField] [Range(10, 1000)] private int resolution;

    private void Awake()
    {
        DrawGraph();

        // point = Instantiate(pointPrefab);
        // point.localPosition = Vector3.right * 2f;
    }

    [Button]
    public void DrawGraph()
    {
        float step = 2f / resolution;
        var position = Vector3.zero;
        var scale = Vector3.one * step * 10;

        for (var i = 0; i < resolution; i++)
        {
            var point = Instantiate(pointPrefab, transform, false);
            position.x = (i + 0.5f) * step - 1f;
            position.y = position.x * position.x * position.x;
            point.localPosition = position;
            point.localScale = scale;
        }
    }

    private void OnDrawGizmos()
    {
        Gizmos.DrawSphere(Vector3.zero, originRadius);
    }
}
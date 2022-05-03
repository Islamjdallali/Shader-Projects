using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ScanEffect : MonoBehaviour
{
    public Material mat;
    public float scanDistance;
    public float scanWidth;

    void Start()
    {
        GetComponent<Camera>().depthTextureMode = DepthTextureMode.Depth;
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        mat.SetFloat("_ScanDistance", scanDistance);
        mat.SetFloat("_ScanWidth", scanWidth);
        Graphics.Blit(src, dest, mat);
    }
}

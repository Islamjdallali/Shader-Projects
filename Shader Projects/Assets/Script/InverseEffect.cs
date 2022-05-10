using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class InverseEffect : MonoBehaviour
{
    public Material mat;
    public float InverseRadius;
    public float WarpRadius;
    public Transform ObjectPos;

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        mat.SetFloat("_InverseRadius", InverseRadius);
        mat.SetFloat("_WarpRadius", WarpRadius);
        mat.SetVector("_ObjectPos",ObjectPos.position);
        Graphics.Blit(src, dest, mat);
    }
}

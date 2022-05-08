using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InverseEffect : MonoBehaviour
{
    public Material mat;
    public float InverseRadius;
    public Transform ObjectPos;

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        mat.SetFloat("_InverseRadius", InverseRadius);
        mat.SetVector("_ObjectPos",ObjectPos.position);
        Graphics.Blit(src, dest, mat);
    }
}

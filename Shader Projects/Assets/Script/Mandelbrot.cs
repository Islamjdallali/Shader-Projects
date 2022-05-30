using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Mandelbrot : MonoBehaviour
{
    public Material mat;
    public Vector2 pos;
    public Vector2 scale;

    public float aspect;

    private void Start()
    {
        scale = new Vector2(4, 4);
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        mat.SetVector("_Area", new Vector4(pos.x, pos.y, scale.x, scale.y / aspect));
        Graphics.Blit(src, dest, mat);
    }

    private void FixedUpdate()
    {
        aspect = (float)Screen.width / (float)Screen.height;

        if (Input.GetKey(KeyCode.KeypadPlus))
        {
            scale *= 0.99f;
        }
        if (Input.GetKey(KeyCode.KeypadMinus))
        {
            scale *= 1.01f;
        }

        if (Input.GetKey(KeyCode.D))
        {
            pos.x += 0.01f * scale.x;
        }

        if (Input.GetKey(KeyCode.A))
        {
            pos.x -= 0.01f * scale.x;
        }

        if (Input.GetKey(KeyCode.W))
        {
            pos.y += 0.01f * scale.x;
        }

        if (Input.GetKey(KeyCode.S))
        {
            pos.y -= 0.01f * scale.x;
        }
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PaletteSwap : MonoBehaviour
{
    public Material mat;

    public void Palette1()
    {
        mat.SetFloat("_PaletteNumber", 0);
    }

    public void Palette2()
    {
        mat.SetFloat("_PaletteNumber", 0.5f);
    }

    public void Palette3()
    {
        mat.SetFloat("_PaletteNumber", 1);
    }
}

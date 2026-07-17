using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PortalEffect1 : MonoBehaviour
{
public Material material;

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        // Si le asignamos un material, aplica el efecto (Blit)
        if (material != null)
        {
            Graphics.Blit(source, destination, material);
        }
        else
        {
            // Si no hay material, renderiza la cámara normal
            Graphics.Blit(source, destination);
        }
    }
}

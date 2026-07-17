using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PortalController : MonoBehaviour
{
[Header("Configuración del Efecto")]
    [Tooltip("Arrastrá acá tu material de Amplify (el del post-proceso)")]
    public Material postProcessMaterial; 
    public float transitionSpeed = 2f;

    private float currentIntensity = 0f;
    private float targetIntensity = 0f;

    void Start()
    {
        // Nos aseguramos de que el material arranque apagado al darle Play
        if (postProcessMaterial != null)
        {
            postProcessMaterial.SetFloat("_Intensity", 0f);
        }
    }

    void Update()
    {
        // Si nos olvidamos de asignar el material, no hacemos nada para evitar errores
        if (postProcessMaterial == null) return;

        // Detectar si apretamos la barra espaciadora
        if (Input.GetKeyDown(KeyCode.Space))
        {
            // Toggle: Si el objetivo es 0, lo pasamos a 1. Si es 1, lo pasamos a 0.
            targetIntensity = (targetIntensity == 0f) ? 1f : 0f;
        }

        // Transición suave usando la misma matemática de antes
        if (currentIntensity != targetIntensity)
        {
            currentIntensity = Mathf.MoveTowards(currentIntensity, targetIntensity, Time.deltaTime * transitionSpeed);
            postProcessMaterial.SetFloat("_Intensity", currentIntensity);
        }
    }

    // ¡SÚPER IMPORTANTE para efectos globales!
    // Cuando le das Stop al juego en Unity, los materiales globales guardan su último estado.
    // Esto asegura que al frenar el test, la pantalla vuelva a la normalidad.
    private void OnDisable()
    {
        if (postProcessMaterial != null)
        {
            postProcessMaterial.SetFloat("_Intensity", 0f);
        }
    }
}

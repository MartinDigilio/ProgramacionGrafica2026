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
        if (postProcessMaterial != null)
        {
            postProcessMaterial.SetFloat("_Intensity", 0f);
        }
    }

    void Update()
    {
        if (postProcessMaterial == null) return;

        if (currentIntensity != targetIntensity)
        {
            currentIntensity = Mathf.MoveTowards(currentIntensity, targetIntensity, Time.deltaTime * transitionSpeed);
            postProcessMaterial.SetFloat("_Intensity", currentIntensity);
        }
    }

    public void SetTarget(bool active)
    {
        targetIntensity = active ? 1f : 0f;
    }

    private void OnDisable()
    {
        if (postProcessMaterial != null)
        {
            postProcessMaterial.SetFloat("_Intensity", 0f);
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            SetTarget(true);
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            SetTarget(false);
        }
    }
}
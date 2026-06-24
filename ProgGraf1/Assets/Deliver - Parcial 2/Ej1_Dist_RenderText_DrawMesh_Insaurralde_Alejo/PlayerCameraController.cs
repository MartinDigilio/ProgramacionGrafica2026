using UnityEngine;

public class PlayerCameraController : MonoBehaviour
{
    [Header("Componentes de Cámara")]
    public Camera camaraNormal;
    public Camera camaraBinoculares;

    [Header("UI - Canvas Alternativo")]
    [Tooltip("Asigna aquí el componente Canvas que quieres activar con TAB.")]
    public Canvas canvasMenu;

    // Propiedad pública para que el script de control de la escena sepa el estado
    public bool UsandoBinoculares { get; private set; } = false;

    void Start()
    {
        if (camaraNormal != null && camaraBinoculares != null)
        {
            camaraNormal.enabled = true;
            camaraBinoculares.enabled = false;
        }

        // Nos aseguramos de que el canvas empiece apagado al iniciar
        if (canvasMenu != null)
        {
            canvasMenu.enabled = false;
        }
    }

    void Update()
    {
        // REQUISITO 1: Controlar el Canvas con la tecla TAB (Solo si no está en binoculares)
        if (Input.GetKeyDown(KeyCode.Tab) && !UsandoBinoculares)
        {
            if (canvasMenu != null)
            {
                // Invierte el estado actual del canvas (.enabled activa/desactiva el Canvas sin apagar su GameObject)
                canvasMenu.enabled = !canvasMenu.enabled;
            }
        }

        // Cambiar entre cámaras con Clic Derecho (Solo si el menú de TAB está cerrado)
        if (Input.GetMouseButtonDown(1))
        {
            if (canvasMenu != null && canvasMenu.enabled)
            {
                // Si el menú está abierto, ignoramos el clic derecho para que no se superpongan
                return;
            }

            AlternarCamaras();
        }
    }

    void AlternarCamaras()
    {
        UsandoBinoculares = !UsandoBinoculares;

        camaraNormal.enabled = !UsandoBinoculares;
        camaraBinoculares.enabled = UsandoBinoculares;
    }
}
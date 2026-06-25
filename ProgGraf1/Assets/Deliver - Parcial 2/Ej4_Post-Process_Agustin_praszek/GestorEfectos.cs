using UnityEngine;
using UnityEngine.UI;

public class GestorEfectos : MonoBehaviour
{
    [Header("Tu Imagen del Canvas")]
    public Image pantallaOverlay;

    [Header("Los 3 Materiales")]
    public Material matFlashbang;
    public Material matNightVision;
    public Material matBorracho;

    [Header("Configuración Flashbang")]
    public float velocidadRecuperacion = 1.5f;
    private float intensidadFlash = 0f;

    // 0 = Apagado, 1 = Flashbang, 2 = Night Vision, 3 = Borracho
    private int estadoActual = 0; 

    void Start()
    {
        ApagarEfecto();
    }

    void Update()
    {
        // Al hacer clic o apretar espacio, pasamos al siguiente efecto
        if (Input.GetKeyDown(KeyCode.Space) || Input.GetMouseButtonDown(0))
        {
            estadoActual++;
            
            // Si nos pasamos de 3, volvemos a 0 (apagado)
            if (estadoActual > 3) 
            {
                estadoActual = 0;
            }

            CambiarMaterial(estadoActual);
        }

        // Si el estado actual es el Flashbang (1), hacemos que se vaya degradando
        if (estadoActual == 1 && intensidadFlash > 0f)
        {
            intensidadFlash -= Time.deltaTime * velocidadRecuperacion;
            if (intensidadFlash < 0f) intensidadFlash = 0f;
            
            matFlashbang.SetFloat("_Intensidad_Ceguera", intensidadFlash);
        }
    }

    void CambiarMaterial(int nuevoEstado)
    {
        switch (nuevoEstado)
        {
            case 0: // Apagado
                ApagarEfecto();
                break;

            case 1: // Flashbang
                pantallaOverlay.enabled = true;
                pantallaOverlay.material = matFlashbang;
                intensidadFlash = 1f; // Dispara el fogonazo al 100%
                matFlashbang.SetFloat("_Intensidad_Ceguera", intensidadFlash);
                break;

            case 2: // Night Vision
                pantallaOverlay.enabled = true;
                pantallaOverlay.material = matNightVision;
                break;

            case 3: // Borracho (Para cuando lo armes)
                pantallaOverlay.enabled = true;
                pantallaOverlay.material = matBorracho;
                break;
        }
    }

    void ApagarEfecto()
    {
        // Apaga la imagen para que el juego se vea normal y no consuma recursos
        pantallaOverlay.enabled = false; 
    }
}
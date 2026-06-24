using Benjathemaker;
using System.Collections.Generic;
using UnityEngine;

public class ControladorProyecto : MonoBehaviour
{
    [Header("Referencias del Player")]
    public PlayerCameraController scriptCamarasPlayer;

    [Header("Configuración de Spawns")]
    public List<Transform> puntosDeAnclaje = new List<Transform>();
    public GameObject prefabObjeto;

    [Header("Material del Objetivo")]
    public Material materialEmisivoBrillante;

    [Header("Álbum de Capturas (Máx 6)")]
    [Tooltip("Arrastra aquí exactamente 6 Render Textures diferentes.")]
    public RenderTexture[] renderTexturesAlbum = new RenderTexture[6];

    public Camera camaraBinoculares;

    // Control de la foto más vieja
    private int indiceCapturaActual = 0;

    // Listas internas de control de ronda
    private List<GameObject> hijosInstanciados = new List<GameObject>();
    private GameObject hijoObjetivoActual;
    private Renderer rendererDelObjetivoActual;
    private Material[] materialesOriginalesGuardados;
    private SimpleGemsAnim scriptRotacionActual;

    void Start()
    {
        LimpiarTodoElAlbum();
        GenerarYConfigurarObjetos();
    }

    void Update()
    {
        // Al presionar Espacio, verifica si está usando los binoculares
        if (Input.GetKeyDown(KeyCode.Space))
        {
            if (scriptCamarasPlayer != null && scriptCamarasPlayer.UsandoBinoculares)
            {
                // REQUISITO 2: Captura en la Render Texture correspondiente (sobrescribiendo la más vieja)
                CapturarPantallaEnRT();

                // Avanzamos al siguiente slot (0, 1, 2, 3, 4, 5 y vuelve a 0)
                indiceCapturaActual = (indiceCapturaActual + 1) % renderTexturesAlbum.Length;

                GenerarYConfigurarObjetos();
            }
            else if (scriptCamarasPlayer == null)
            {
                Debug.LogError("No se ha asignado el script del Player en el Controlador.");
            }
        }
    }

    void GenerarYConfigurarObjetos()
    {
        // Limpieza de ronda anterior
        foreach (GameObject hijo in hijosInstanciados)
        {
            if (hijo != null) Destroy(hijo);
        }
        hijosInstanciados.Clear();
        hijoObjetivoActual = null;

        if (puntosDeAnclaje == null || puntosDeAnclaje.Count == 0 || prefabObjeto == null) return;

        // Generar prefabs en los anclajes vacíos
        for (int i = 0; i < puntosDeAnclaje.Count; i++)
        {
            Transform anclaje = puntosDeAnclaje[i];
            if (anclaje == null) continue;

            GameObject nuevoHijo = Instantiate(prefabObjeto, anclaje.position, anclaje.rotation, anclaje);
            hijosInstanciados.Add(nuevoHijo);

            SimpleGemsAnim scriptRotacion = nuevoHijo.GetComponent<SimpleGemsAnim>();
            if (scriptRotacion != null) scriptRotacion.enabled = false;
        }

        // Seleccionar el objetivo brillante que rota
        int indiceAleatorio = Random.Range(0, hijosInstanciados.Count);
        hijoObjetivoActual = hijosInstanciados[indiceAleatorio];

        if (hijoObjetivoActual != null)
        {
            hijoObjetivoActual.name += "_OBJETIVO_BRILLANTE";

            scriptRotacionActual = hijoObjetivoActual.GetComponent<SimpleGemsAnim>();
            if (scriptRotacionActual != null) scriptRotacionActual.enabled = true;

            rendererDelObjetivoActual = hijoObjetivoActual.GetComponentInChildren<Renderer>();
            if (rendererDelObjetivoActual != null && materialEmisivoBrillante != null)
            {
                materialesOriginalesGuardados = rendererDelObjetivoActual.sharedMaterials;

                Material[] materialesBrillantes = new Material[materialesOriginalesGuardados.Length];
                for (int j = 0; j < materialesBrillantes.Length; j++)
                {
                    materialesBrillantes[j] = materialEmisivoBrillante;
                }
                rendererDelObjetivoActual.materials = materialesBrillantes;
            }
        }
    }

    void LimpiarTodoElAlbum()
    {
        // Recorremos las 6 texturas para dejarlas limpias al dar Play
        foreach (RenderTexture rt in renderTexturesAlbum)
        {
            if (rt != null)
            {
                RenderTexture rtActual = RenderTexture.active;
                RenderTexture.active = rt;
                GL.Clear(true, true, Color.clear);
                RenderTexture.active = rtActual;
            }
        }
        indiceCapturaActual = 0; // Reseteamos el puntero al primer slot
    }

    void CapturarPantallaEnRT()
    {
        // Verificamos que el slot actual del álbum tenga una RT asignada
        RenderTexture rtDestino = renderTexturesAlbum[indiceCapturaActual];

        if (camaraBinoculares != null && rtDestino != null)
        {
            // Apuntamos la cámara a la Render Texture que le toca según el turno
            camaraBinoculares.targetTexture = rtDestino;
            camaraBinoculares.Render();
            camaraBinoculares.targetTexture = null;
        }
        else
        {
            Debug.LogWarning($"Falta asignar la Render Texture en el índice {indiceCapturaActual} del álbum.");
        }
    }
}
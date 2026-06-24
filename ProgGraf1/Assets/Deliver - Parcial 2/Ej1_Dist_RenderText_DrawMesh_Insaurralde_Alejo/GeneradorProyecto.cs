using UnityEngine;

public class GeneradorProyecto : MonoBehaviour
{
    public Mesh[] meshesVariados; // Asigna aquí diferentes figuras 3D
    public Material materialInstanciado; // El shader de ASE con GPU Instancing activo
    public RenderTexture renderTextureCaptura;
    public Camera camaraBinoculares;

    private int cantidadObjetos = 200;
    private Matrix4x4[] matrices;
    private MaterialPropertyBlock propiedadBloque;
    private Vector4[] coloresInstancia;

    void Start()
    {
        GenerarNuevosObjetos();
    }

    void GenerarNuevosObjetos()
    {
        matrices = new Matrix4x4[cantidadObjetos];
        coloresInstancia = new Vector4[cantidadObjetos];
        propiedadBloque = new MaterialPropertyBlock();

        for (int i = 0; i < cantidadObjetos; i++)
        {
            // Posición aleatoria en la pantalla/espacio
            Vector3 pos = new Vector3(Random.Range(-5f, 5f), Random.Range(-5f, 5f), Random.Range(10f, 20f));
            // Escala variada
            Vector3 escala = Vector3.one * Random.Range(0.5f, 1.5f);

            // Creamos la matriz de transformación
            matrices[i] = Matrix4x4.TRS(pos, Quaternion.identity, escala);

            // Color aleatorio para cada uno
            coloresInstancia[i] = new Vector4(Random.value, Random.value, Random.value, 1f);
        }
    }

    void Update()
    {
        // Dibujar de forma ultra-eficiente todos los objetos en cada frame
        propiedadBloque.SetVectorArray("_ObjectColor", coloresInstancia);

        // Asumiendo que usas el primer mesh para el ejemplo general
        Graphics.DrawMeshInstanced(meshesVariados[0], 0, materialInstanciado, matrices, cantidadObjetos, propiedadBloque);

        // Lógica de captura (Ejemplo al presionar espacio tras "encontrar" el objeto)
        if (Input.GetKeyDown(KeyCode.Space))
        {
            CapturarPantallaEnRT();
            GenerarNuevosObjetos(); // Re-poblar pantalla
        }
    }

    void CapturarPantallaEnRT()
    {
        // Forzar a la cámara a renderizar la vista actual dentro de tu Render Texture
        camaraBinoculares.targetTexture = renderTextureCaptura;
        camaraBinoculares.Render();
        camaraBinoculares.targetTexture = null; // Liberar cámara
    }
}
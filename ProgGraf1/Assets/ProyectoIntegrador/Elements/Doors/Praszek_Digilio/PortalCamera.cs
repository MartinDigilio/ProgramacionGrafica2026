using UnityEngine;

public class PortalCamera : MonoBehaviour
{
    [Header("Referencias")]
    public Transform portalIn;   // El portal que el jugador está mirando
    public Transform portalOut;  // El portal "destino" (donde está el otro mundo)
    public Transform playerCamera; // La cámara principal del jugador
    public Camera portalRenderCamera; // La cámara que renderiza a la RenderTexture
    public Camera playerCameraComponent; // La cámara (componente) del jugador

    void LateUpdate()
    {
        // Matriz de rotación de 180° en Y para invertir la orientación
        Matrix4x4 flipMatrix = Matrix4x4.TRS(Vector3.zero, Quaternion.Euler(0, 180, 0), Vector3.one);

        // 1. Posición y rotación del jugador relativas al portal de entrada
        Matrix4x4 playerToPortalIn = portalIn.worldToLocalMatrix * playerCamera.localToWorldMatrix;

        // 2. Aplicar el flip antes de proyectar al portal de salida
        Matrix4x4 finalMatrix = portalOut.localToWorldMatrix * flipMatrix * playerToPortalIn;

        // 3. Extraer posición y rotación
        portalRenderCamera.transform.SetPositionAndRotation(
            finalMatrix.GetColumn(3),
            finalMatrix.rotation
        );

        portalRenderCamera.fieldOfView = playerCameraComponent.fieldOfView;
    }
}
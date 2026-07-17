using UnityEngine;

public class PortalCamera : MonoBehaviour
{
    [Header("Referencias")]
    public Transform portalIn;
    public Transform portalOut;
    public Transform playerCamera;
    public Camera portalRenderCamera;
    public Camera playerCameraComponent;

    void LateUpdate()
    {
        Matrix4x4 flipMatrix = Matrix4x4.TRS(Vector3.zero, Quaternion.Euler(0, 180, 0), Vector3.one);

        //Posicion y rotacion del player relativas al portal de entrada
        Matrix4x4 playerToPortalIn = portalIn.worldToLocalMatrix * playerCamera.localToWorldMatrix;

        //Aplicar el flip antes de proyectar al portal de salida
        Matrix4x4 finalMatrix = portalOut.localToWorldMatrix * flipMatrix * playerToPortalIn;

        portalRenderCamera.transform.SetPositionAndRotation(finalMatrix.GetColumn(3),finalMatrix.rotation);

        portalRenderCamera.fieldOfView = playerCameraComponent.fieldOfView;
    }
}
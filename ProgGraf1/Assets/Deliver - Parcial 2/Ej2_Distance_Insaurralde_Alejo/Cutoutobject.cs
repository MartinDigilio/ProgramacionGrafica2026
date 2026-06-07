using System.Collections;
using System.Collections.Generic;
using System.Runtime.ExceptionServices;
using UnityEngine;

public class Cutoutobject : MonoBehaviour
{
    [SerializeField]
    private Transform targetObject;

    [SerializeField]
    private LayerMask wallMask;

    private Camera mainCamera;

    private void Awake()
    {
        mainCamera = GetComponent<Camera>();
    }

    private void Update()
    {
        Vector2 cutoutPos = mainCamera.WorldToViewportPoint(targetObject.position);
        cutoutPos.y /= ((float)Screen.width / Screen.height);

        // Use SetGlobalVector since CutoutPos is a Global variable in ASE
        Shader.SetGlobalVector("CutoutPos", cutoutPos);
        Shader.SetGlobalFloat("CutoutSize", 0.1f);
        Shader.SetGlobalFloat("FalloffSize", 0.05f);

        Vector3 offset = targetObject.position - transform.position;
        RaycastHit[] hitObjects = Physics.RaycastAll(transform.position, offset, offset.magnitude, wallMask);
    }
}

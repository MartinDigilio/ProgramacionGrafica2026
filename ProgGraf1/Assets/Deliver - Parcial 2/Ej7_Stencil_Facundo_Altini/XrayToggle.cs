using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class XrayToggle : MonoBehaviour
{
    public Material normalMaterial;
    public Material seeThoughMaterial;

    private Renderer rend;
    private bool isSeeThrough = false;

    void Start()
    {
        rend = GetComponent<Renderer>();
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.T))
        {
            isSeeThrough = !isSeeThrough;
            rend.material = isSeeThrough ? seeThoughMaterial : normalMaterial;
        }
    }
}

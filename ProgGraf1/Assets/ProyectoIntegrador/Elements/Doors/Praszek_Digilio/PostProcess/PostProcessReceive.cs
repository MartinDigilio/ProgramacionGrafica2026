using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PostProcessReceive : MonoBehaviour
{
    public Camera playerCam;
    private PortalEffect1 portalEffect;

    public Material greenPortal;
    public Material mirrorPortal;
    public Material orangePortal;

    private void Start()
    {
        portalEffect = playerCam.gameObject.GetComponent<PortalEffect1>();
    }

    public void TriggerGreenPortal()
    {
        if (portalEffect.material == null)
        {
            portalEffect.material = greenPortal;
        }
        else
        {
            portalEffect.material = null;
        }
    }

    public void TriggerMirrorPortal()
    {
        if (portalEffect.material == null)
        {
            portalEffect.material = mirrorPortal;
        }
        else
        {
            portalEffect.material = null;
        }
    }

    public void TriggerOrangePortal()
    {
        if (portalEffect.material == null)
        {
            portalEffect.material = orangePortal;
        }
        else
        {
            portalEffect.material = null;
        }
    }
}

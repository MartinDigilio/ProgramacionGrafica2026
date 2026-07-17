using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PostProcessTrigger : MonoBehaviour
{
    public bool isGreen;
    public bool isOrange;

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            if (isGreen)
            {
                other.gameObject.GetComponent<PostProcessReceive>().TriggerGreenPortal();
            }
            else if (isOrange)
            {
                other.gameObject.GetComponent<PostProcessReceive>().TriggerOrangePortal();
            }
            else
            {
                other.gameObject.GetComponent<PostProcessReceive>().TriggerMirrorPortal();
            }
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            if (isGreen)
            {
                other.gameObject.GetComponent<PostProcessReceive>().TriggerGreenPortal();
            }
            else if (isOrange)
            {
                other.gameObject.GetComponent<PostProcessReceive>().TriggerOrangePortal();
            }
            else
            {
                other.gameObject.GetComponent<PostProcessReceive>().TriggerMirrorPortal();
            }
        }
    }
}

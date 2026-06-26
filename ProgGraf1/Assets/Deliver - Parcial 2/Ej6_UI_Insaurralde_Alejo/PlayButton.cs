using UnityEngine;

public class PlayButton : MonoBehaviour
{
    public Material distortionMat;
    private float timer = 0f;
    private bool isDistorting = false;

    public void OnPlayClick() { isDistorting = true; }

    void Update()
    {
        if (isDistorting)
        {
            timer += Time.deltaTime * 2f; // Adjust speed here
            distortionMat.SetFloat("_DistortionTime", timer);
            if (timer > 2f) isDistorting = false; // Reset after it travels
        }
    }
}
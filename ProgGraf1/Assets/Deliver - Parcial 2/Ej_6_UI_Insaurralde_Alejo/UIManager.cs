using UnityEngine;

public class UIManager : MonoBehaviour
{
    [Header("Canvases")]
    public GameObject mainMenuCanvas;
    public GameObject loadingCanvas;

    void Start()
    {
        // Ensure starting state is correct
        mainMenuCanvas.SetActive(true);
        loadingCanvas.SetActive(false);
    }

    // Call this from the "PLAY" button
    public void ShowLoadingScreen()
    {
        mainMenuCanvas.SetActive(false);
        loadingCanvas.SetActive(true);
    }

    // Call this from the LoadingBar script when finished
    public void ShowMainMenu()
    {
        loadingCanvas.SetActive(false);
        mainMenuCanvas.SetActive(true);
    }
}
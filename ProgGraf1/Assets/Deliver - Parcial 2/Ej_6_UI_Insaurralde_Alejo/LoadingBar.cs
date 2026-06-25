using UnityEngine;
using UnityEngine.UI;

public class LoadingBar : MonoBehaviour
{
    [Header("Settings")]
    [Tooltip("How many seconds it takes to fill the bar")]
    public float fillDuration = 5.0f;
    public UIManager uiManager;

    private Image fillImage;
    private float timer = 0f;


    void Awake()
    {
        fillImage = GetComponent<Image>();
    }

    // This is called automatically by Unity whenever the GameObject becomes active
    void OnEnable()
    {
        timer = 0f;
        fillImage.fillAmount = 0f;
    }

    void Update()
    {
        if (timer < fillDuration)
        {
            timer += Time.deltaTime;
            fillImage.fillAmount = timer / fillDuration;
        }
        else
        {
            fillImage.fillAmount = 1f;
            uiManager.ShowMainMenu(); // Tells the manager to switch back
        }
    }
}
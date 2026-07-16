using UnityEngine;

public class Card3D : MonoBehaviour
{
    private HandManager3D handManager;
    private Vector3 targetLocalPosition;
    private Quaternion targetLocalRotation;
    private Vector3 targetScale;

    [Header("Movement Settings")]
    public float transitionSpeed = 10f;
    public Vector3 focusScale = new Vector3(1.5f, 1.5f, 1.5f);

    [Header("Card Dimensions (For Click Detection)")]
    public float cardWidth = 1.0f;
    public float cardHeight = 1.5f;

    private bool isCentered = false;
    private Vector3 originalScale;

    void Awake()
    {
        originalScale = transform.localScale;
        targetScale = originalScale;
    }

    void Update()
    {
        // Smoothly move, rotate, and scale relative to the parent (handArea)
        transform.localPosition = Vector3.Lerp(transform.localPosition, targetLocalPosition, Time.deltaTime * transitionSpeed);
        transform.localRotation = Quaternion.Slerp(transform.localRotation, targetLocalRotation, Time.deltaTime * transitionSpeed);
        transform.localScale = Vector3.Lerp(transform.localScale, targetScale, Time.deltaTime * transitionSpeed);
    }

    public void Setup(HandManager3D manager)
    {
        handManager = manager;
    }

    public void SetTarget(Vector3 localPosition, Quaternion localRotation, bool isCentering = false)
    {
        targetLocalPosition = localPosition;
        targetLocalRotation = localRotation;
        targetScale = isCentering ? Vector3.Scale(originalScale, focusScale) : originalScale;
        isCentered = isCentering;
    }

    public bool IsCentered() => isCentered;

    // Click checking still works flawlessly in world space
    public bool CheckClick(Ray ray)
    {
        Plane cardPlane = new Plane(transform.forward, transform.position);

        if (cardPlane.Raycast(ray, out float enterDistance))
        {
            Vector3 hitPoint = ray.GetPoint(enterDistance);
            Vector3 localHitPoint = transform.InverseTransformPoint(hitPoint);

            float halfWidth = (cardWidth * transform.localScale.x) / 2f;
            float halfHeight = (cardHeight * transform.localScale.y) / 2f;

            if (localHitPoint.x >= -halfWidth && localHitPoint.x <= halfWidth &&
                localHitPoint.y >= -halfHeight && localHitPoint.y <= halfHeight)
            {
                return true;
            }
        }
        return false;
    }
}
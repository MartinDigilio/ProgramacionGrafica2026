using UnityEngine;

public class CardRotator : MonoBehaviour
{
    [Header("Rotation Settings")]
    [SerializeField] private float rotationSpeed = 0.5f;
    [SerializeField] private float damping = 5f; // How smoothly it comes to a stop

    [Header("Tilt Limits (Optional)")]
    [SerializeField] private bool limitRotation = false;
    [SerializeField] private float minXAngle = -45f;
    [SerializeField] private float maxXAngle = 45f;
    [SerializeField] private float minYAngle = -45f;
    [SerializeField] private float maxYAngle = 45f;

    private Vector3 _targetRotation;
    private Vector3 _currentRotation;
    private Vector3 _mouseReference;
    private Vector3 _mouseOffset;
    private bool _isRotating;

    void Start()
    {
        // Store the starting rotation of the card
        _targetRotation = transform.eulerAngles;
        _currentRotation = _targetRotation;
    }

    void Update()
    {
        HandleInput();
        ApplyRotation();
    }

    private void HandleInput()
    {
        // When the player clicks/touches the screen
        if (Input.GetMouseButtonDown(0))
        {
            _isRotating = true;
            _mouseReference = Input.mousePosition;
        }

        // While holding down the click/touch
        if (Input.GetMouseButton(0) && _isRotating)
        {
            _mouseOffset = Input.mousePosition - _mouseReference;

            // Horizontal mouse movement rotates around Y axis
            // Vertical mouse movement rotates around X axis
            float rotationY = _mouseOffset.x * rotationSpeed;
            float rotationX = -_mouseOffset.y * rotationSpeed;

            _targetRotation.y += rotationY;
            _targetRotation.x += rotationX;

            // Apply clamps if limitRotation is checked
            if (limitRotation)
            {
                // Clamp X between min and max
                _targetRotation.x = Mathf.Clamp(NormalizeAngle(_targetRotation.x), minXAngle, maxXAngle);
                // Clamp Y between min and max
                _targetRotation.y = Mathf.Clamp(NormalizeAngle(_targetRotation.y), minYAngle, maxYAngle);
            }

            // Update reference for the next frame
            _mouseReference = Input.mousePosition;
        }

        // When releasing the click
        if (Input.GetMouseButtonUp(0))
        {
            _isRotating = false;
        }
    }

    private void ApplyRotation()
    {
        // Smoothly interpolate from current rotation to target rotation (Lerp/Damp effect)
        _currentRotation.x = Mathf.LerpAngle(_currentRotation.x, _targetRotation.x, Time.deltaTime * damping);
        _currentRotation.y = Mathf.LerpAngle(_currentRotation.y, _targetRotation.y, Time.deltaTime * damping);
        _currentRotation.z = Mathf.LerpAngle(_currentRotation.z, _targetRotation.z, Time.deltaTime * damping);

        transform.eulerAngles = _currentRotation;
    }

    // Helper method to keep angles within -180 to 180 range for clamping
    private float NormalizeAngle(float angle)
    {
        while (angle > 180f) angle -= 360f;
        while (angle < -180f) angle += 360f;
        return angle;
    }
}
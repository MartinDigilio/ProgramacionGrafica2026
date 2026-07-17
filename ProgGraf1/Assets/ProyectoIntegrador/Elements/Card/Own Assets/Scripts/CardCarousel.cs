using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class CardCarousel : MonoBehaviour
{
    [Header("Setup")]
    [Tooltip("Drag all your different card prefabs into this list.")]
    [SerializeField] private List<GameObject> cardPrefabs = new List<GameObject>();
    [SerializeField] private float radius = 5f;

    [Header("Movement")]
    [SerializeField] private float rotationSpeed = 5f;

    private int currentIndex = 0;
    private float targetYRotation = 0f;
    private bool isRotating = false;
    private int totalCards = 0;

    void Start()
    {
        SpawnUniqueCards();
    }

    void Update()
    {
        HandleInput();
    }

    /// <summary>
    /// Spawns each unique card prefab from the list exactly once in a circle.
    /// </summary>
    void SpawnUniqueCards()
    {
        // Safety check to make sure you actually assigned prefabs
        if (cardPrefabs == null || cardPrefabs.Count == 0)
        {
            Debug.LogError("Please assign card prefabs to the Card Prefabs list in the Inspector!", this);
            return;
        }

        // Total cards is now dynamically determined by how many prefabs you gave it
        totalCards = cardPrefabs.Count;

        // Clear existing children just in case of a reset
        foreach (Transform child in transform)
        {
            Destroy(child.gameObject);
        }

        for (int i = 0; i < totalCards; i++)
        {
            // Skip if a slot in the inspector list was left empty
            if (cardPrefabs[i] == null) continue;

            // Calculate the angle for this specific card slot (in radians)
            float angle = i * Mathf.PI * 2f / totalCards;

            // Calculate x and z positions based on the angle and radius
            float x = Mathf.Cos(angle) * radius;
            float z = Mathf.Sin(angle) * radius;

            Vector3 spawnPosition = transform.position + new Vector3(x, 0f, z);

            // Spawn the UNIQUE prefab at index 'i'
            GameObject newCard = Instantiate(cardPrefabs[i], spawnPosition, Quaternion.identity, transform);

            // Keeps the hierarchy tidy
            newCard.name = $"{cardPrefabs[i].name}_{i}";

            // Orient the card to face the center anchor
            newCard.transform.LookAt(transform.position);
            newCard.transform.Rotate(0, 180, 0); // Flip 180 if the card face is pointing backwards
        }
    }

    void HandleInput()
    {
        if (!isRotating && totalCards > 0)
        {
            if (Input.GetMouseButtonDown(0)) // LMB: Next Card
            {
                RotateToCard(1);
            }
            else if (Input.GetMouseButtonDown(1)) // RMB: Previous Card
            {
                RotateToCard(-1);
            }
        }
    }

    void RotateToCard(int direction)
    {
        currentIndex = (currentIndex + direction + totalCards) % totalCards;
        float angleStep = 360f / totalCards;
        targetYRotation += angleStep * direction;

        StartCoroutine(AnimateRotation());
    }

    IEnumerator AnimateRotation()
    {
        isRotating = true;

        Quaternion startRotation = transform.rotation;
        Quaternion targetRotation = Quaternion.Euler(0, targetYRotation, 0);
        float time = 0f;

        while (time < 1f)
        {
            time += Time.deltaTime * rotationSpeed;
            transform.rotation = Quaternion.Slerp(startRotation, targetRotation, time);
            yield return null;
        }

        transform.rotation = targetRotation;
        isRotating = false;
    }
}
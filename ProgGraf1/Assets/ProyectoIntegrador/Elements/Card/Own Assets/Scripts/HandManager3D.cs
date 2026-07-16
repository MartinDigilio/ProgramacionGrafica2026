using System.Collections.Generic;
using UnityEngine;

public class HandManager3D : MonoBehaviour
{
    [Header("Prefabs & Anchors")]
    public List<GameObject> cardPrefabs; // Array of different card prefabs to choose from
    public Transform handArea;
    public Transform centerPoint;

    [Header("Hand Layout Settings")]
    public float cardSpacing = 1.5f;
    public float fanArc = 5f;

    private List<Card3D> cardsInHand = new List<Card3D>();
    private Card3D centeredCard = null;
    private Camera mainCamera;

    void Start()
    {
        mainCamera = Camera.main;
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            DrawCard();
        }

        if (Input.GetMouseButtonDown(0))
        {
            HandleMouseClick();
        }
    }

    private void HandleMouseClick()
    {
        if (mainCamera == null) return;

        Ray ray = mainCamera.ScreenPointToRay(Input.mousePosition);
        Card3D clickedCard = null;

        for (int i = cardsInHand.Count - 1; i >= 0; i--)
        {
            if (cardsInHand[i].CheckClick(ray))
            {
                clickedCard = cardsInHand[i];
                break;
            }
        }

        if (clickedCard != null)
        {
            if (clickedCard.IsCentered())
            {
                ReturnCardToHand(clickedCard);
            }
            else
            {
                CenterCard(clickedCard);
            }
        }
    }

    public void DrawCard()
    {
        if (cardPrefabs == null || cardPrefabs.Count == 0 || handArea == null) return;

        // 1. Pick a random card prefab from your list
        int randomIndex = Random.Range(0, cardPrefabs.Count);
        GameObject chosenPrefab = cardPrefabs[randomIndex];

        // 2. Instantiate it directly as a child of the handArea
        GameObject newCardObj = Instantiate(chosenPrefab, handArea);
        Card3D newCard = newCardObj.GetComponent<Card3D>();

        if (newCard != null)
        {
            newCard.Setup(this);
            cardsInHand.Add(newCard);

            // Set its initial local position slightly below the hand so it glides up 
            newCard.transform.localPosition = new Vector3(0, -3f, 0);
            newCard.transform.localRotation = Quaternion.identity;

            UpdateCardPositions();
        }
    }

    public void UpdateCardPositions()
    {
        int activeHandCount = cardsInHand.Count;
        if (activeHandCount == 0) return;

        float totalWidth = (activeHandCount - 1) * cardSpacing;
        float startX = -totalWidth / 2f;

        for (int i = 0; i < cardsInHand.Count; i++)
        {
            if (cardsInHand[i] == centeredCard) continue;

            float xOffset = startX + (i * cardSpacing);

            // Set local position and rotation targets relative to the handArea
            Vector3 localOffset = new Vector3(xOffset, 0, -i * 0.05f);
            float zRotation = -((i - (activeHandCount - 1) / 2f) * fanArc);
            Quaternion targetRot = Quaternion.Euler(0, 0, zRotation);

            cardsInHand[i].SetTarget(localOffset, targetRot, false);

            // Keeps the newest or right-most cards rendered on top in the local hierarchy
            cardsInHand[i].transform.SetSiblingIndex(i);
        }
    }

    public void CenterCard(Card3D cardToCenter)
    {
        if (centeredCard != null && centeredCard != cardToCenter)
        {
            ReturnCardToHand(centeredCard);
        }

        centeredCard = cardToCenter;

        // Render the centered card on top of all other cards
        cardToCenter.transform.SetAsLastSibling();

        // Convert the centerPoint's world position/rotation to the handArea's local coordinates
        Vector3 worldTargetPos = centerPoint.position + (centerPoint.forward * -0.1f);
        Vector3 localCenterPos = handArea.InverseTransformPoint(worldTargetPos);
        Quaternion localCenterRot = Quaternion.Inverse(handArea.rotation) * centerPoint.rotation;

        cardToCenter.SetTarget(localCenterPos, localCenterRot, true);
    }

    public void ReturnCardToHand(Card3D card)
    {
        if (centeredCard == card)
        {
            centeredCard = null;
        }
        UpdateCardPositions();
    }
}
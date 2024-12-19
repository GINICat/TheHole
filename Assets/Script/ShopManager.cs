using UnityEngine;
using UnityEngine.UI;
using System.Collections.Generic;

public class ShopManager : MonoBehaviour
{
    [System.Serializable]
    public class BallInfo
    {
        public string name;
        public int price;
        public int scoreValue;
        public bool isUnlocked;
        public GameObject prefab;
    }

    public List<BallInfo> allBalls = new List<BallInfo>();
    public GameObject shopItemPrefab;
    public Transform shopItemsContainer;
    public Text currencyText;
    public GameObject shopPanel;

    private int currency;

    public void OpenShop()
    {
        shopPanel.SetActive(true);
        PopulateShop();
        UpdateCurrencyDisplay();
    }

    public void CloseShop()
    {
        shopPanel.SetActive(false);
    }

    void PopulateShop()
    {
        foreach (Transform child in shopItemsContainer)
        {
            Destroy(child.gameObject);
        }

        List<BallInfo> availableBalls = new List<BallInfo>(allBalls);
        int itemsToShow = Mathf.Min(3, availableBalls.Count);

        for (int i = 0; i < itemsToShow; i++)
        {
            int randomIndex = Random.Range(0, availableBalls.Count);
            BallInfo ball = availableBalls[randomIndex];
            availableBalls.RemoveAt(randomIndex);

            GameObject shopItem = Instantiate(shopItemPrefab, shopItemsContainer);
            SetupShopItem(shopItem, ball);
        }
    }

    void SetupShopItem(GameObject shopItem, BallInfo ball)
    {
        Text nameText = shopItem.transform.Find("NameText").GetComponent<Text>();
        Text priceText = shopItem.transform.Find("PriceText").GetComponent<Text>();
        Button buyButton = shopItem.transform.Find("BuyButton").GetComponent<Button>();

        nameText.text = ball.name;
        priceText.text = ball.isUnlocked ? "Unlocked" : $"Price: {ball.price}";

        buyButton.onClick.AddListener(() => BuyBall(ball));
        buyButton.interactable = !ball.isUnlocked && currency >= ball.price;
    }

    public void BuyBall(BallInfo ball)
    {
        if (currency >= ball.price && !ball.isUnlocked)
        {
            currency -= ball.price;
            ball.isUnlocked = true;
            UpdateCurrencyDisplay();
            FindObjectOfType<GameManager>().AddUnlockedBall(ball);
            PopulateShop();
        }
    }

    public void AddCurrency(int amount)
    {
        currency += amount;
        UpdateCurrencyDisplay();
    }

    void UpdateCurrencyDisplay()
    {
        currencyText.text = $"Currency: {currency}";
    }
}
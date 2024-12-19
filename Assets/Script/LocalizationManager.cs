// LocalizationManager.cs
using UnityEngine;
using System.Collections.Generic;

public class LocalizationManager : MonoBehaviour
{
    public static LocalizationManager Instance;

    private Dictionary<string, string> localizedTexts;

    void Awake()
    {
        if (Instance == null)
        {
            Instance = this;
            DontDestroyOnLoad(gameObject);
            LoadLocalizedText();
        }
        else
        {
            Destroy(gameObject);
        }
    }

    void LoadLocalizedText()
    {
        // 这里可以根据需要加载不同语言的文本
        localizedTexts = new Dictionary<string, string>
        {
            { "score", "Score" },
            { "currency", "Currency" },
            { "level", "Level" },
            { "welcome_to_store", "Welcome to the store!" },
            { "item_purchased", "Item purchased!" },
            { "not_enough_currency", "Not enough currency." }
        };
    }

    public string GetLocalizedText(string key)
    {
        if (localizedTexts.ContainsKey(key))
        {
            return localizedTexts[key];
        }
        return key;
    }
}

// ScoreManager.cs

using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;
using Hotel.Scripts;

public class CurrencyManager : Singleton<CurrencyManager>
{
    public Text currencyText;
    private int _currency = 0;

    public int Currency
    {
        get => _currency;
        set
        {
            ResourceManager.Instance.Money =  _currency = value;
            UpdateCurrencyText();
        }
    }

    [HideInInspector] public float currencyMagnification = 1f;

    void Start()
    {
        UpdateCurrencyText();
        UpdateCurrencyText();
        currencyText.gameObject.SetActive(true);
        AddEventListener(EventName.MoneyLevelUp, args => { currencyMagnification += 0.1f; });
    }

    public void AddScore(int points)
    {
        Currency += (int) (points * currencyMagnification);
        UpdateCurrencyText();
        PlayCurrencyAnimation();
        AudioManager.Instance.PlayScoreSound(); // 播放得分音效
    }

    public void UpdateCurrencyText()
    {
        currencyText.text = Currency.ToString();
    }

    void PlayCurrencyAnimation()
    {
        var animations = currencyText.GetComponents<DOTweenAnimation>();
        foreach (var anim in animations)
        {
            anim.DORestart();
        }
    }
}
// ScoreManager.cs
using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;

public class ScoreManager : Singleton<ScoreManager>
{
    public Text scoreText;
    public Text currencyText;
    public int score { get; private set; } = 0;
    public int currency { get; private set; } = 0;
    [HideInInspector] public float currencyMagnification = 1f;

    void Start()
    {
        UpdateScoreText();
        UpdateCurrencyText();
        currencyText.gameObject.SetActive(false);
        AddEventListener(EventName.LevelClear, args =>
        {
            currencyText.gameObject.SetActive(true);
        });
        AddEventListener(EventName.LevelUpComplete, args =>
        {
            currencyText.gameObject.SetActive(false);
        });
        AddEventListener(EventName.MoneyLevelUp, args =>
        {
            currencyMagnification += 0.1f;
        });
    }

    public void AddScore(int points)
    {
        score += points;
        UpdateScoreText();
        PlayScoreAnimation();
        AudioManager.Instance.PlayScoreSound(); // 播放得分音效
    }

    public void ConvertScoreToCurrency()
    {
        currency += (int)(score * currencyMagnification);
        score = 0;
        UpdateScoreText();
        UpdateCurrencyText();
        PlayCurrencyAnimation();
    }

    public void UpdateScoreText(float newScore = -1)
    {
        if (newScore >= 0)
        {
            scoreText.text = Mathf.RoundToInt(newScore).ToString();
        }
        else
        {
            scoreText.text = score.ToString();
        }
    }

    public void UpdateCurrencyText(float newCurrency = -1)
    {
        currencyText.text = "";
        if (newCurrency >= 0)
        {
            currencyText.text += Mathf.RoundToInt(newCurrency).ToString();
        }
        else
        {
            currencyText.text += currency.ToString();
        }
    }

    void PlayScoreAnimation()
    {
        var animations = scoreText.GetComponents<DOTweenAnimation>();
        foreach (var anim in animations)
        {
            anim.DORestart();
        }
    }

    void PlayCurrencyAnimation()
    {
        var animations = currencyText.GetComponents<DOTweenAnimation>();
        foreach (var anim in animations)
        {
            anim.DORestart();
        }
    }

    public int GetScore()
    {
        return score;
    }

    public void ResetScore()
    {
        score = 0;
        UpdateScoreText();
    }

    public int GetCurrency()
    {
        return currency;
    }

    public void ResetCurrency()
    {
        currency = 0;
        UpdateCurrencyText();
    }

    public void SpendCurrency(int amount)
    {
        if (currency >= amount)
        {
            currency -= amount;
            UpdateCurrencyText();
            PlayCurrencyAnimation();
        }
    }
}

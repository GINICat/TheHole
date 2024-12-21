// GameManager.cs
using UnityEngine;
using UnityEngine.UI;
using System.Collections.Generic;
using DG.Tweening; // 引入DOTween命名空间

public class GameManager : Singleton<GameManager>
{
    public Text timerText;
    public Text scoreText;
    public Text levelText;
    public GameObject gameOverPanel;

    private float roundTime = 30f;
    private float currentTime;
    private int currentLevel = 1;
    private int targetScore = 100;

    protected override void Awake()
    {
        base.Awake();
        UIManager.instance.Init();
    }

    void Start()
    {
        Time.timeScale = 1f;
        // DontDestroyOnLoad(transform.parent.gameObject);
        InitializeGame();
    }

    void Update()
    {
        
#if UNITY_EDITOR
        if (Input.GetKeyDown(KeyCode.G))
        {
            if (UIManager.instance.GetFirstUIWithType<GMPage>() != null)
            {
                UIManager.instance.DestroyAllUIWithType<GMPage>();
            }
            else
            {
                UIManager.instance.CreateUI<GMPage>();
            }
        }
#endif
    }

    void InitializeGame()
    {
        currentTime = roundTime;
        UpdateUI();
    }

    void UpdateUI()
    {
        scoreText.text = $"{CurrencyManager.instance.Currency}/{targetScore}";
        levelText.text = $"{currentLevel}";
    }

    public void OpenLevelUp()
    {
        UIManager.instance.CreateUI<LevelUpPage>();
    }
}
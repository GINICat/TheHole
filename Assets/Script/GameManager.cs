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

    private ShopManager shopManager;
    private List<ShopManager.BallInfo> unlockedBalls = new List<ShopManager.BallInfo>();

    protected override void Awake()
    {
        base.Awake();
        UIManager.instance.Init();
    }

    void Start()
    {
        Time.timeScale = 1f;
        // DontDestroyOnLoad(transform.parent.gameObject);
        shopManager = FindObjectOfType<ShopManager>();
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
        scoreText.text = $"{ScoreManager.instance.GetScore()}/{targetScore}";
        levelText.text = $"{currentLevel}";
    }

    void OpenShop()
    {
        shopManager.OpenShop();
    }

    int CalculateReward()
    {
        return ScoreManager.instance.GetScore() / 10;
    }

    public void AddUnlockedBall(ShopManager.BallInfo ball)
    {
        unlockedBalls.Add(ball);
    }

    public GameObject GetRandomUnlockedBall()
    {
        if (unlockedBalls.Count > 0)
        {
            int randomIndex = Random.Range(0, unlockedBalls.Count);
            return unlockedBalls[randomIndex].prefab;
        }
        return null;
    }

    public void StartNextRound()
    {
        shopManager.CloseShop();
        InitializeGame();
    }

    void PlayTimerTweenAnimation()
    {
        // 播放DOTween动画，例如缩放效果
        timerText.transform.DOKill(); // 停止任何现有的动画
        timerText.transform.DOScale(1.5f, 0.5f).SetLoops(2, LoopType.Yoyo);
    }
}

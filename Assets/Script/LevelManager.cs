// LevelManager.cs
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class LevelManager : Singleton<LevelManager>
{
    [HideInInspector] public float levelDuration = 30f;
    [HideInInspector] public int requiredScore = 100;
    public Text levelText;
    public Text timerText;
    public Text scoreTargetText;
    public GameObject gameOverPanel;
    private float levelTimer;
    private ScoreManager scoreManager;
    private bool isGameOver;

    void Start()
    {
        levelTimer = levelDuration;
        scoreManager = FindObjectOfType<ScoreManager>();
        UpdateLevelText();
        UpdateTimerText();
        gameOverPanel.SetActive(false);
        isGameOver = false;
    }

    void Update()
    {
        if (isGameOver) return;

        levelTimer -= Time.deltaTime;
        UpdateTimerText();
        UpdateScoreTargetText();

        if (levelTimer <= 0)
        {
            if (scoreManager.GetScore() >= requiredScore)
            {
                NextLevel();
            }
            else
            {
                GameOver();
            }
        }
    }

    void NextLevel()
    {
        // 将分数转换为货币
        scoreManager.ConvertScoreToCurrency();
        // 逻辑可以扩展，例如增加难度等
        levelTimer = levelDuration;
        requiredScore += 100; // 增加下一个关卡的要求分数
        UpdateLevelText();
        UpdateScoreTargetText();
        EventManager.SendNotification(EventName.LevelClear);
        UIManager.instance.CreateUI<LevelUpPage>();
    }

    void GameOver()
    {
        Time.timeScale = 0f;
        isGameOver = true;
        Debug.Log("Game Over");
        // 显示游戏结束面板
        gameOverPanel.SetActive(true);
        // 将分数转换为货币
        scoreManager.ConvertScoreToCurrency();
    }

    public void RestartGame()
    {
        SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
        // 重置所有分数和时间
        // scoreManager.ResetScore();
        // scoreManager.ResetCurrency();
        // levelTimer = levelDuration;
        // requiredScore = 100;
        // isGameOver = false;
        // UpdateLevelText();
        // UpdateTimerText();
        // gameOverPanel.SetActive(false);
    }

    public void AddTime(float value)
    {
        levelTimer += value;
    }

    void UpdateLevelText()
    {
        levelText.text = (requiredScore / 100).ToString();
    }

    void UpdateScoreTargetText()
    {
        scoreTargetText.text = requiredScore.ToString();
    }

    void UpdateTimerText()
    {
        int minutes = Mathf.FloorToInt(levelTimer / 60);
        int seconds = Mathf.FloorToInt(levelTimer % 60);
        timerText.text = string.Format("{0:00}:{1:00}", minutes, seconds);
    }
}

// BallSpawner.cs
using UnityEngine;

public class BallSpawner : Singleton<BallSpawner>
{
    public GameObject[] ballPrefabs; // 用于存放不同类型的球
    public float spawnInterval = 1.0f;
    [HideInInspector] public float globalBallSpawnScale = 1f;
    private float timer = 0f;
    private Camera mainCamera;
    [Header("闪光球")]
    public GameObject shiningBallPrefab;
    private float shiningBallProbability = 0f;
    private float highScoreBallProbability = 0f;

    void Start()
    {
        mainCamera = Camera.main;
        AddEventListener(EventName.BallScaleLevelUp, args =>
        {
            globalBallSpawnScale += 0.1f;
        });
        AddEventListener(EventName.ShiningBallLevelUp, args =>
        {
            shiningBallProbability += 5f;
        });
        AddEventListener(EventName.HighScoreBallLevelUp, args =>
        {
            highScoreBallProbability += 5f;
        });
    }

    void Update()
    {
        timer += Time.deltaTime;
        if (timer >= spawnInterval)
        {
            SpawnBall();
            timer = 0f;
        }
    }

    void SpawnBall()
    {
        Vector3 spawnPosition = GetRandomEdgePosition();
        float ballTypeRandomValue = Random.Range(0f, 100f);
        GameObject ball = null;
        if (ballTypeRandomValue < shiningBallProbability)
        {
            ball = Instantiate(shiningBallPrefab, spawnPosition, Quaternion.identity);
        }
        else
        {
            float highScoreRandomValue = Random.Range(0f, 100f);
            int randomIndex;
            if (highScoreRandomValue < highScoreBallProbability)
            {
                randomIndex = Random.Range(10, ballPrefabs.Length);
            }
            else
            {
                randomIndex = Random.Range(0, ballPrefabs.Length);
            }
            ball = Instantiate(ballPrefabs[randomIndex], spawnPosition, Quaternion.identity);
        }
        ball.transform.localScale *= globalBallSpawnScale;
        BallMovement ballMovement = ball.GetComponent<BallMovement>();
        if (ballMovement != null)
        {
            // 随机设置速度和方向
            ballMovement.speed = Random.Range(1.0f, 5.0f);
            ballMovement.initialDirection = new Vector3(Random.Range(-1.0f, 1.0f), 0, Random.Range(-1.0f, 1.0f));
        }
    }

    Vector3 GetRandomEdgePosition()
    {
        float x = 0f, y = 0f, z = 0f;
        int edge = Random.Range(0, 4);

        switch (edge)
        {
            case 0: // Top
                x = Random.Range(-mainCamera.aspect * mainCamera.orthographicSize, mainCamera.aspect * mainCamera.orthographicSize);
                y = mainCamera.orthographicSize;
                z = Random.Range(-mainCamera.aspect * mainCamera.orthographicSize, mainCamera.aspect * mainCamera.orthographicSize);
                break;
            case 1: // Bottom
                x = Random.Range(-mainCamera.aspect * mainCamera.orthographicSize, mainCamera.aspect * mainCamera.orthographicSize);
                y = -mainCamera.orthographicSize;
                z = Random.Range(-mainCamera.aspect * mainCamera.orthographicSize, mainCamera.aspect * mainCamera.orthographicSize);
                break;
            case 2: // Left
                x = -mainCamera.aspect * mainCamera.orthographicSize;
                y = Random.Range(-mainCamera.orthographicSize, mainCamera.orthographicSize);
                z = Random.Range(-mainCamera.aspect * mainCamera.orthographicSize, mainCamera.aspect * mainCamera.orthographicSize);
                break;
            case 3: // Right
                x = mainCamera.aspect * mainCamera.orthographicSize;
                y = Random.Range(-mainCamera.orthographicSize, mainCamera.orthographicSize);
                z = Random.Range(-mainCamera.aspect * mainCamera.orthographicSize, mainCamera.aspect * mainCamera.orthographicSize);
                break;
        }

        return new Vector3(x, y, z);
    }
}

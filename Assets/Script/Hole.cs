// Hole.cs

using KToolkit;
using UnityEngine;

public class Hole : Observer
{
    private ScoreManager scoreManager;

    void Start()
    {
        scoreManager = FindObjectOfType<ScoreManager>();
        AddEventListener(EventName.HoleScaleLevelUp, args =>
        {
            Vector3 newScale = transform.parent.localScale;
            newScale = new Vector3(newScale.x + 0.1f, newScale.y + 0.1f, newScale.z + 0.1f);
            transform.parent.localScale = newScale;
        });
    }

    void OnTriggerEnter(Collider other)
    {
        BallMovement ball = other.gameObject.GetComponent<BallMovement>();
        if (ball != null)
        {
            scoreManager.AddScore(ball.pointValue);
            // 脚本写死加两倍
            if (ball.CompareTag("ShiningBall"))
            {
                scoreManager.AddScore(ball.pointValue * 2);
            }
            ball.PlayHoleSound();
            Destroy(other.gameObject);
        }
    }
}

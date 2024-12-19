// BallMovement.cs
using UnityEngine;

public class BallMovement : MonoBehaviour
{
    public float speed = 2.0f; // 默认速度
    public Vector3 initialDirection = Vector3.forward; // 默认初始方向
    public int pointValue = 10; // 默认分值
    public float minHeight = -10f; // 球的最小高度，低于此高度时销毁
    public AudioClip dropSound; // 落地音效
    public AudioClip collisionSound; // 碰撞音效
    public AudioClip holeSound; // 进洞音效

    private Rigidbody rb;
    private AudioSource audioSource;

    void Start()
    {
        rb = GetComponent<Rigidbody>();
        audioSource = GetComponent<AudioSource>();

        // 初始化速度和方向
        Vector3 direction = initialDirection.normalized;
        rb.velocity = direction * speed;

        // 确保使用重力
        rb.useGravity = true;
    }

    void Update()
    {
        // 检查球的高度
        if (transform.position.y < minHeight)
        {
            PlaySound(dropSound);
            Destroy(gameObject);
        }
    }

    void OnCollisionEnter(Collision collision)
    {
        // 播放碰撞音效
        PlaySoundWithRandomPitch(collisionSound);
    }

    void PlaySound(AudioClip clip)
    {
        if (clip != null && audioSource != null)
        {
            audioSource.pitch = 1.0f; // 重置pitch
            audioSource.PlayOneShot(clip);
        }
    }

    void PlaySoundWithRandomPitch(AudioClip clip)
    {
        if (clip != null && audioSource != null)
        {
            audioSource.pitch = Random.Range(0.8f, 1.2f); // 随机pitch
            audioSource.PlayOneShot(clip);
        }
    }

    public void PlayHoleSound()
    {
        PlaySound(holeSound);
    }
}

// AudioManager.cs
using UnityEngine;
using System.Collections.Generic;

public class AudioManager : MonoBehaviour
{
    public static AudioManager Instance;

    public List<AudioClip> scoreSounds;
    private AudioSource audioSource;

    void Awake()
    {
        if (Instance == null)
        {
            Instance = this;
            DontDestroyOnLoad(gameObject);
            audioSource = GetComponent<AudioSource>();
        }
        else
        {
            Destroy(gameObject);
        }
    }

    public void PlayScoreSound()
    {
        if (scoreSounds.Count > 0)
        {
            int randomIndex = Random.Range(0, scoreSounds.Count);
            audioSource.PlayOneShot(scoreSounds[randomIndex]);
        }
    }
}

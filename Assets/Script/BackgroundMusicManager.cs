// BackgroundMusicManager.cs
using UnityEngine;
using System.Collections;

public class BackgroundMusicManager : MonoBehaviour
{
    public AudioClip[] musicTracks;
    private AudioSource audioSource;

    void Start()
    {
        audioSource = GetComponent<AudioSource>();
        if (audioSource == null)
        {
            audioSource = gameObject.AddComponent<AudioSource>();
        }
        StartCoroutine(PlayRandomMusic());
    }

    IEnumerator PlayRandomMusic()
    {
        while (true)
        {
            if (musicTracks.Length > 0)
            {
                int randomIndex = Random.Range(0, musicTracks.Length);
                audioSource.clip = musicTracks[randomIndex];
                audioSource.Play();
                yield return new WaitForSeconds(audioSource.clip.length);
            }
            else
            {
                yield return null;
            }
        }
    }
}
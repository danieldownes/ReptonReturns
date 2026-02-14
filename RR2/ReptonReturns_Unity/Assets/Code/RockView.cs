using UnityEngine;

public class RockView : MonoBehaviour
{
    [SerializeField] private Rock rock;
    [SerializeField] private Transform mesh;
    [SerializeField] private AudioClip falling;
    [SerializeField] private AudioClip crash;
    [SerializeField] private AudioSource audioSource;

    void Start()
    {
        rock.StoppedFalling += stoppedFalling;
        mesh.localRotation = Random.rotation;
    }

    private void stoppedFalling()
    {
        audioSource.PlayOneShot(crash);
    }
}

using UnityEngine;

public class Diamond : Piece
{
    [SerializeField] private AudioSource collectedSound;

    public override void Traverse()
    {
        collectedSound.Play();
        Destroy(this.gameObject, 0.5f);
    }
}
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bullets : MonoBehaviour
{
    public Transform playerTransform;

    public float speed;
    public float timeTillDeath;

    private Vector3 dir;
    void Awake()
    {
        playerTransform = GameObject.Find("Player").transform;
        dir = Vector3.Normalize(playerTransform.position - gameObject.transform.position);

        timeTillDeath = 50;
    }

    void Update()
    {
        transform.Translate(dir * Time.deltaTime * speed);
        timeTillDeath -= Time.deltaTime;
        if (timeTillDeath <= 0)
        {
            Destroy(this.gameObject);
        }
    }

    void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("TimeStop"))
        {
            speed = 0;
        }
    }

    void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("TimeStop"))
        {
            speed = 15;
        }
    }
}

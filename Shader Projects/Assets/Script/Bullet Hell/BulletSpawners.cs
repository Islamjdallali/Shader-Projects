using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BulletSpawners : MonoBehaviour
{


    public float timeToSpawn;
    public bool isTimeStopped;

    [SerializeField] private GameObject bullet;

    // Start is called before the first frame update
    void Start()
    {
        timeToSpawn = Random.Range(1,5);
    }

    // Update is called once per frame
    void Update()
    {
        if (!isTimeStopped)
            timeToSpawn -= Time.deltaTime;

        if (timeToSpawn <= 0)
        {
            Instantiate(bullet,gameObject.transform);
            timeToSpawn = Random.Range(1,5);
        }
    }

    void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("TimeStop"))
        {
            isTimeStopped = true;
        }
    }

    void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("TimeStop"))
        {
            isTimeStopped = false;
        }
    }
}

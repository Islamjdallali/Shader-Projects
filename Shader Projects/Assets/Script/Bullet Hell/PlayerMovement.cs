using System.IO;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMovement : MonoBehaviour
{

    private bool isTimeStopped;
    private float timestopSphereScale;

    [SerializeField] private Transform timestopSphere;
    [SerializeField] private float speed;
    [SerializeField] private InverseEffect inverseEffect;

    // Update is called once per frame
    void Update()
    {
        float zAxis = Input.GetAxis("Vertical");
        float xAxis = Input.GetAxis("Horizontal");

        if (Input.GetKeyDown(KeyCode.Space))
        {
            if (!isTimeStopped)
                isTimeStopped = true;
            else if (isTimeStopped)
                isTimeStopped = false;
        }

        if (isTimeStopped)
        {
            TimeStop();
        }
        else if (!isTimeStopped)
        {
            NormalTime();
        }

        transform.Translate(new Vector3(xAxis,0,zAxis) * Time.deltaTime * speed);
    }

    void TimeStop()
    {
        inverseEffect.InverseRadius += Time.deltaTime * 2;
        inverseEffect.WarpRadius += Time.deltaTime * 2;

        timestopSphereScale += Time.deltaTime * 200;

        if (timestopSphereScale >= 200)
        {
            timestopSphereScale = 200;
        }

        timestopSphere.localScale = new Vector3(timestopSphereScale,timestopSphereScale,timestopSphereScale);

        if (inverseEffect.InverseRadius >= 2)
        {
            inverseEffect.InverseRadius = 2;
        }
        if (inverseEffect.WarpRadius >= 1.2)
        {
            inverseEffect.WarpRadius = 2.2f;
        }
    }

    void NormalTime()
    {
        inverseEffect.InverseRadius -= Time.deltaTime * 2;
        inverseEffect.WarpRadius -= Time.deltaTime * 2;

        timestopSphereScale -= Time.deltaTime * 200;

        if (timestopSphereScale <= 1)
        {
            timestopSphereScale = 1;
        }

        timestopSphere.localScale = new Vector3(timestopSphereScale,timestopSphereScale,timestopSphereScale);

        if (inverseEffect.InverseRadius <= 0)
        {
            inverseEffect.InverseRadius = 0;
        }
        if (inverseEffect.WarpRadius <= -0.2f)
        {
            inverseEffect.WarpRadius = -0.2f;
        }
    }
}

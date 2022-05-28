using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ComputeTest : MonoBehaviour
{
    public struct Cube
    {
        public Vector3 pos;
        public Color col;
    }

    public ComputeShader computeShader;

    public RenderTexture renderTexture;

    public int repetitions;
    public List<GameObject> objects;

    public int x, y;

    public GameObject cube;

    private Cube[] data;

    private void Start()
    {
        data = new Cube[x * y];

        for (int i = 0; i < x; i++)
        {
            for (int j = 0; j < y; j++)
            {
                GameObject obj = Instantiate(cube);
                obj.transform.position = new Vector3(i, j, Random.Range(19.9f, 20.1f));
                obj.GetComponent<Renderer>().material.SetColor("_Color", Random.ColorHSV());
                objects.Add(obj);
                Cube cubedata = new Cube();
                cubedata.pos = obj.transform.position;
                cubedata.col = obj.GetComponent<Renderer>().material.color;
                data[i * y + j] = cubedata;
            }
        }
    }

    public void OnRandomizeGPU()
    {
        int colorSize = sizeof(float) * 4;
        int vector3Size = sizeof(float) * 3;
        int totalSize = colorSize + vector3Size;

        ComputeBuffer cubesBuffer = new ComputeBuffer(data.Length, totalSize);
        cubesBuffer.SetData(data);

        computeShader.SetBuffer(0, "cubes", cubesBuffer);
        computeShader.SetFloat("resolution", data.Length);
        computeShader.SetFloat("repetitions",repetitions);
        computeShader.Dispatch(0, data.Length / 10, 1, 1);

        cubesBuffer.GetData(data);

        for (int i = 0; i < objects.Count; i++)
        {
            GameObject obj = objects[i];
            Cube cube = data[i];
            obj.transform.position = cube.pos;
            obj.GetComponent<MeshRenderer>().material.SetColor("_Color",cube.col);
        } 

        cubesBuffer.Dispose();
    }

    public void OnRandomize()
    {
        for (int i = 0; i < repetitions; i++)
        {
            for (int c = 0; c < objects.Count; c++)
            {
                GameObject obj = objects[c];
                obj.transform.position = new Vector3(obj.transform.position.x, obj.transform.position.y, Random.Range(19.9f, 20.1f));
                obj.GetComponent<Renderer>().material.SetColor("_Color", Random.ColorHSV());
            }
        }
    }
}

// PaddleManager.cs
using UnityEngine;

public class PaddleManager : MonoBehaviour
{
    public GameObject[] paddlePrefabs; // 不同的Paddle预制件
    public Transform spawnPoint; // Paddle的生成位置
    private GameObject currentPaddle;

    void Start()
    {
        LoadRandomPaddle(); // 在游戏开始时加载随机的Paddle
    }

    public void LoadPaddle(int index)
    {
        if (currentPaddle != null)
        {
            Destroy(currentPaddle);
        }

        currentPaddle = Instantiate(paddlePrefabs[index], spawnPoint.position, spawnPoint.rotation);
        PaddleController paddleController = currentPaddle.GetComponent<PaddleController>();

        // 根据需要设置不同的控制方式
        switch (index)
        {
            case 0:
                paddleController.controlType = PaddleControlType.Default;
                break;
            case 1:
                paddleController.controlType = PaddleControlType.Paw;
                break;
            case 2:
                paddleController.controlType = PaddleControlType.Stick;
                break;
            case 3:
                paddleController.controlType = PaddleControlType.Magnet;
                break;
            case 4:
                paddleController.controlType = PaddleControlType.Hammer;
                break;
            // Add more cases as needed
        }
    }

    public void LoadRandomPaddle()
    {
        int randomIndex = Random.Range(0, paddlePrefabs.Length);
        LoadPaddle(randomIndex);
    }
}

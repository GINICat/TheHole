// PaddleController.cs
using UnityEngine;
using DG.Tweening;
using KToolkit; // 引入DOTween命名空间

[RequireComponent(typeof(Rigidbody))]
public class PaddleController : Observer
{
    private Camera mainCamera;
    private Rigidbody rb;
    private Animator animator;
    public float moveForce = 50f;
    public float maxSpeed = 10f;
    public float rotationSpeed = 100f;
    public float minHeight = 0.5f; // Paddle 的最小高度
    public float maxHeight = 1.5f; // Paddle 的最大高度
    public float stickDownForce = 200f; // Stick类型按下时的向下力
    public float magnetForce = 1000f; // Magnet的引力效果
    public float tweenDuration = 0.5f;
    public float tweenStrength = 0.2f;
    private Tweener currentTween;
    private bool enablePlayerInput = true;
    private GameObject grabbedBall = null;
    public Transform grabPoint; // 用于放置抓取球的空子对象
    public PaddleControlType controlType = PaddleControlType.Default; // 当前控制类型
    private bool isStickDown = false; // Stick是否向下
    private bool isMagnetActive = false; // Magnet是否激活

    void Start()
    {
        mainCamera = Camera.main;
        rb = GetComponent<Rigidbody>();
        animator = GetComponent<Animator>();

        // 锁定 X 和 Z 轴的旋转，解锁 Y 轴移动限制
        rb.constraints = RigidbodyConstraints.FreezeRotationX | RigidbodyConstraints.FreezeRotationZ;

        // 增加全局重力
        Physics.gravity = new Vector3(0, -20f, 0);

        AddEventListener(EventName.LevelClear, args => enablePlayerInput = false);
        AddEventListener(EventName.LevelUpComplete, args => enablePlayerInput = true);
    }

    void Update()
    {
        if (!enablePlayerInput) return;

        HandleMovement();

        // 检测鼠标点击以触发抓取动画或其他动作
        if (Input.GetMouseButtonDown(0))
        {
            switch (controlType)
            {
                case PaddleControlType.Default:
                case PaddleControlType.Paw:
                case PaddleControlType.Hammer:
                    animator.SetBool("Catch", true);
                    PlayPaddleTweenAnimation();
                    if (controlType == PaddleControlType.Hammer)
                    {
                        PlayHammerAnimation();
                    }
                    break;
                case PaddleControlType.Stick:
                    isStickDown = true; // 标记Stick向下
                    PlayPaddleTweenAnimation();
                    break;
                case PaddleControlType.Magnet:
                    isMagnetActive = true; // 激活Magnet
                    break;
            }
        }
        else if (Input.GetMouseButtonUp(0))
        {
            switch (controlType)
            {
                case PaddleControlType.Default:
                case PaddleControlType.Paw:
                case PaddleControlType.Hammer:
                    animator.SetBool("Catch", false);
                    ReleaseBall();
                    break;
                case PaddleControlType.Stick:
                    isStickDown = false; // 标记Stick不向下
                    rb.velocity = Vector3.zero; // 取消Stick的惯性
                    rb.angularVelocity = Vector3.zero; // 取消Stick的旋转惯性
                    break;
                case PaddleControlType.Magnet:
                    isMagnetActive = false; // 停止Magnet
                    break;
            }
        }

        if (controlType == PaddleControlType.Stick && Input.GetMouseButton(0))
        {
            // 检测左右旋转输入
            float rotationInput = Input.GetAxis("Mouse X");
            rb.MoveRotation(rb.rotation * Quaternion.Euler(Vector3.up * rotationInput * rotationSpeed * Time.deltaTime));
        }
    }

    void FixedUpdate()
    {
        if (isStickDown)
        {
            rb.AddForce(Vector3.down * stickDownForce * Time.fixedDeltaTime, ForceMode.Force); // 持续向下施加力
        }

        if (isMagnetActive)
        {
            ActivateMagnet(); // 持续吸引球
        }
    }

    void HandleMovement()
    {
        Ray ray = mainCamera.ScreenPointToRay(Input.mousePosition);
        Plane xzPlane = new Plane(Vector3.up, Vector3.up * minHeight); // 将平面设为 minHeight 高度
        if (xzPlane.Raycast(ray, out float distance))
        {
            Vector3 targetPosition = ray.GetPoint(distance);
            targetPosition.y = Mathf.Clamp(targetPosition.y, minHeight, maxHeight); // 限制 y 轴高度

            Vector3 direction = (targetPosition - transform.position).normalized;
            Vector3 desiredVelocity = direction * maxSpeed;
            Vector3 force = (desiredVelocity - rb.velocity) * moveForce;

            switch (controlType)
            {
                case PaddleControlType.Stick:
                case PaddleControlType.Default:
                case PaddleControlType.Paw:
                case PaddleControlType.Hammer:
                    rb.AddForce(new Vector3(force.x, 0, force.z));
                    break;
                case PaddleControlType.Magnet:
                    rb.AddForce(new Vector3(force.x, 0, force.z) * 0.5f); // Magnet 控制稍慢
                    break;
            }

            if (rb.velocity.magnitude > maxSpeed)
            {
                rb.velocity = rb.velocity.normalized * maxSpeed;
            }

            if (rb.velocity.magnitude > 0.1f)
            {
                Quaternion targetRotation = Quaternion.LookRotation(rb.velocity);
                rb.MoveRotation(Quaternion.RotateTowards(transform.rotation, targetRotation, rotationSpeed * Time.deltaTime));
            }

            // 限制 Paddle 的高度
            Vector3 clampedPosition = transform.position;
            clampedPosition.y = Mathf.Clamp(clampedPosition.y, minHeight, maxHeight);
            rb.position = clampedPosition;
        }
    }

    void PlayPaddleTweenAnimation()
    {
        // 如果有正在进行的动画，先停止它
        if (currentTween != null && currentTween.IsActive())
        {
            currentTween.Kill();
        }

        var animations = GetComponents<DOTweenAnimation>();
        foreach (var anim in animations)
        {
            anim.DORestart();
        }
    }

    void PlaySwingAnimation()
    {
        animator.SetTrigger("Swing"); // 触发挥杆动画
    }

    void ActivateMagnet()
    {
        // 启动磁力吸引
        Collider[] hitColliders = Physics.OverlapSphere(transform.position, 5.0f); // 假设磁力范围为5
        foreach (var hitCollider in hitColliders)
        {
            if (hitCollider.CompareTag("Ball"))
            {
                Rigidbody ballRb = hitCollider.GetComponent<Rigidbody>();
                if (ballRb != null)
                {
                    Vector3 direction = (transform.position - ballRb.transform.position).normalized;
                    ballRb.AddForce(direction * magnetForce * Time.fixedDeltaTime, ForceMode.Force); // 向Paddle施加吸引力
                }
            }
        }
    }

    void DeactivateMagnet()
    {
        // 停止磁力吸引逻辑
    }

    void PlayHammerAnimation()
    {
        animator.SetTrigger("Hammer"); // 触发Hammer动画
        ApplyHammerForce();
    }

    void ApplyHammerForce()
    {
        Collider[] hitColliders = Physics.OverlapSphere(transform.position, 5.0f); // 假设Hammer范围为5
        foreach (var hitCollider in hitColliders)
        {
            if (hitCollider.CompareTag("Ball"))
            {
                Rigidbody ballRb = hitCollider.GetComponent<Rigidbody>();
                if (ballRb != null)
                {
                    Vector3 direction = (hitCollider.transform.position - transform.position).normalized;
                    ballRb.AddForce(direction * 500f); // 向外施加推力
                }
            }
        }
    }

    void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Ball") && grabbedBall == null && (animator.GetBool("Catch") || controlType == PaddleControlType.Magnet))
        {
            GrabBall(other.gameObject);
        }
    }

    void GrabBall(GameObject ball)
    {
        grabbedBall = ball;
        Rigidbody ballRb = ball.GetComponent<Rigidbody>();
        ballRb.isKinematic = true; // 停止球的物理运动
        ball.transform.position = grabPoint.position; // 瞬移到抓取位置
        ball.transform.SetParent(grabPoint); // 将球作为子对象

        // 抓住球时减小惯性或重置速度
        rb.velocity = Vector3.zero;
        rb.angularVelocity = Vector3.zero;
    }

    void ReleaseBall()
    {
        if (grabbedBall != null)
        {
            Rigidbody ballRb = grabbedBall.GetComponent<Rigidbody>();
            ballRb.isKinematic = false; // 恢复球的物理运动
            grabbedBall.transform.SetParent(null); // 解除球的子对象关系
            grabbedBall = null;
        }
    }

    void OnDisable()
    {
        // 确保在对象禁用时停止所有DOTween动画
        if (currentTween != null && currentTween.IsActive())
        {
            currentTween.Kill();
        }
    }
}

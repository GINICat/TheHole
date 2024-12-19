using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Rendering.Universal;
using UnityEngine.Rendering;
using TMPro;
using System.Collections.Generic;

namespace NekoLegends
{
    public class GalaxyDemo : MonoBehaviour
    {

        [SerializeField] private List<GameObject> Models;
        [SerializeField] private MeshRenderer Sword;
        [SerializeField] private SkinnedMeshRenderer NekoCharacter;
        [SerializeField] private MeshRenderer GoldCoin;

        [SerializeField] private List<Material> MaterialsSword;
        [SerializeField] private List<Material> MaterialsNeko;
        [SerializeField] private List<Material> MaterialsCoin;

        [Space]
        [SerializeField] private Button ModelBtn;
        [SerializeField] private Button CameraBtn;
        [SerializeField] private Button GlobalVolumnBtn;
        [SerializeField] private Button LightsBtn;
        [SerializeField] private Button RotateBtn;
        [Space]
        [SerializeField] private Button NextBtn;
        [SerializeField] private Button LogoBtn;

        [Space]
        [SerializeField] private Transform MainCamTransform;
        [SerializeField] private Transform ZoomedCamTransform;
        [SerializeField] private Transform BGTransform;
        [SerializeField] public TextMeshProUGUI DescriptionText;

        [Space]
        [SerializeField] private Volume GlobalVolume;

        [SerializeField] private GameObject PointLight;
        [SerializeField] private GameObject DemoUI;


        private DepthOfField _depthOfField;

        private Camera _mainCamera;
        private bool isRotating, _isZoomedIn; 
        private int _currentModelIndex, _currentMaterialIndex;


        private const string _title = "Galaxy Shader Demo";

        #region Singleton
        public static GalaxyDemo Instance
        {
            get
            {
                if (_instance == null)
                    _instance = FindFirstObjectByType(typeof(GalaxyDemo)) as GalaxyDemo;

                return _instance;
            }
            set
            {
                _instance = value;
            }
        }
        private static GalaxyDemo _instance;
        #endregion

        #region Button listeners setup
        private void OnEnable()
        {
            ModelBtn.onClick.AddListener(ModelBtnClicked);
            CameraBtn.onClick.AddListener(CameraBtnClicked);
            GlobalVolumnBtn.onClick.AddListener(GlobalVolumnBtnClicked); 
            LightsBtn.onClick.AddListener(LightsBtnClicked);
            RotateBtn.onClick.AddListener(RotateBtnClicked);

            NextBtn.onClick.AddListener(NextBtnClicked);
            LogoBtn.onClick.AddListener(LogoBtnClicked);

        }

        private void OnDisable()
        {
            ModelBtn.onClick.RemoveListener(ModelBtnClicked);
            CameraBtn.onClick.RemoveListener(CameraBtnClicked);
            GlobalVolumnBtn.onClick.RemoveListener(GlobalVolumnBtnClicked);
            LightsBtn.onClick.RemoveListener(LightsBtnClicked);
            RotateBtn.onClick.RemoveListener(RotateBtnClicked);
            NextBtn.onClick.RemoveListener(NextBtnClicked);
            LogoBtn.onClick.RemoveListener(() => LoadWebsite("nekolegends.com"));
        }
        #endregion

        void Start()
        {
            Application.targetFrameRate = 144;
            _mainCamera = Camera.main;

            GlobalVolume.profile.TryGet<DepthOfField>(out _depthOfField);
            GlobalVolumnBtnClicked();//global volume off
            CameraBtnClicked();//start zoomed 
            DescriptionText.SetText(_title);
        }

        private void LogoBtnClicked()
        {
            DemoUI.SetActive(!DemoUI.activeSelf);
        }
        private void NextBtnClicked()
        {
            // Increment the current material index and wrap around if necessary
            _currentMaterialIndex = (_currentMaterialIndex + 1) % MaterialsSword.Count;

            // Assign the new materials to the MeshRenderers
            Sword.material = MaterialsSword[_currentMaterialIndex];
            NekoCharacter.material = MaterialsNeko[_currentMaterialIndex];
            GoldCoin.material = MaterialsCoin[_currentMaterialIndex];

            switch (_currentMaterialIndex)
            {
                case 0:
                    DescriptionText.SetText("Galaxy Effect");
                    break;
                case 1:
                    DescriptionText.SetText("Aurora Effect");
                    break;
                case 2:
                    DescriptionText.SetText("Icy Effect");
                    break;
                case 3:
                    DescriptionText.SetText("Flame Effect");
                    break;
                case 4:
                    DescriptionText.SetText("Lightning Effect");
                    break;

            }

        }




        private void GlobalVolumnBtnClicked()
        {
            GlobalVolume.enabled = !GlobalVolume.enabled;
        }

        private void RotateBtnClicked()
        {
            isRotating = !isRotating;
        }

        private void ModelBtnClicked()
        {
            Models[_currentModelIndex].SetActive(false);
            _currentModelIndex = (_currentModelIndex + 1) % Models.Count;
            Models[_currentModelIndex].SetActive(true);

            switch (_currentModelIndex)
            {
                case 0:
                    DescriptionText.SetText("Giant Sword");
                    break;
                case 1:
                    DescriptionText.SetText("Neko Cat");
                    break;
                case 2:
                    DescriptionText.SetText("Gold Coin");
                    break;

            }
        }

        private void CameraBtnClicked()
        {
            _isZoomedIn = !_isZoomedIn;
            ZoomCamera(_isZoomedIn);
        }

        private void LightsBtnClicked()
        {
            PointLight.SetActive(!PointLight.activeSelf);
        }

        private void ZoomCamera(bool isIn)
        {
            if (_isZoomedIn)
            {
                _mainCamera.transform.SetPositionAndRotation(ZoomedCamTransform.transform.position, ZoomedCamTransform.transform.rotation);
                SetDOF(0.35f, 13f);
                BGTransform.transform.localScale = new Vector3(2f, 2f);
            }
            else
            {
                _mainCamera.transform.SetPositionAndRotation(MainCamTransform.transform.position, MainCamTransform.transform.rotation);
                SetDOF(0.35f, 22f);
                BGTransform.transform.localScale = new Vector3(1f, 1f);
            }
        }
        

        private void SetDOF(float inValue, float inAperture)
        {
            _depthOfField.focusDistance.value = inValue;
            _depthOfField.aperture.value = inAperture;
        }

        public void SetDescriptionText(string inText)
        {

            DescriptionText.SetText(inText);
        }

        public void LoadWebsite(string url)
        {
            Application.OpenURL(url);
        }

        public void SetBackgroundActive(bool isOn)
        {
            BGTransform.gameObject.SetActive(isOn);
        }

     

        void Update()
        {
            if (isRotating)
            {
                float rotationSpeed = 50f;
                foreach (GameObject GO in Models)
                {
                    GO.transform.Rotate(Vector3.up, rotationSpeed * Time.deltaTime);
                }
            }
        }

    }
}

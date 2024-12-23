using Hotel.Scripts;
using UnityEngine;

namespace Hotel.ManagerDisplay
{
    public class ResourceManagerDisplay : MonoBehaviour
    {
        [SerializeField]
        public ResourceManager resourceManager;

        private void Awake()
        {
            resourceManager = ResourceManager.Instance;
        }
    }
}
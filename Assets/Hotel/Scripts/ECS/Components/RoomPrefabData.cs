using Unity.Entities;
using Unity.Entities.Serialization;

namespace Hotel.Scripts.ECS.Components
{
    public struct RoomPrefabData : IComponentData
    {
        public EntityPrefabReference Prefab;
    }
}
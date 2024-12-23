using Hotel.Scripts.Base.Room;
using Hotel.Scripts.ECS.Components;
using Unity.Entities;
using Unity.Entities.Serialization;
using Unity.Mathematics;
using UnityEngine;

namespace Hotel.Scripts.ECS.Authorings
{
    public class RoomPrefabAuthoring : MonoBehaviour
    {
        public GameObject prefab;
        
        private class RoomPrefabBaker : Baker<RoomPrefabAuthoring>
        {
            public override void Bake(RoomPrefabAuthoring authoring)
            {
                var entity = GetEntity(TransformUsageFlags.None);
                var prefab = new EntityPrefabReference(authoring.prefab);
                AddComponent(entity, new RoomPrefabData()
                {
                    Prefab = prefab
                });

                AddComponent(entity, new RoomCreateData() {Type = RoomType.Workshop});
            }
        }
    }
}
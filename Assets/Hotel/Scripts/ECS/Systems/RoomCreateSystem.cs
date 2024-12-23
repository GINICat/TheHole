using Hotel.Scripts.Base.Room;
using Hotel.Scripts.ECS.Components;
using Unity.Burst;
using Unity.Collections;
using Unity.Entities;
using Unity.Mathematics;
using Unity.Scenes;
using UnityEngine;

namespace Hotel.Scripts.ECS.Systems
{
    [BurstCompile]
    public partial struct RoomCreateSystem : ISystem
    {
        private Entity? _roomPrefab;

        public void OnCreate(ref SystemState state)
        {
        }

        [BurstCompile]
        public void OnUpdate(ref SystemState state)
        {
            var ecb = GetEntityCommandBuffer(ref state);
            if (!_roomPrefab.HasValue)
            {
                var query = SystemAPI.QueryBuilder()
                                     .WithAll<RoomPrefabData>()
                                     .WithNone<PrefabLoadResult>()
                                     .WithNone<RequestEntityPrefabLoaded>()
                                     .Build();
                if (query.TryGetSingletonEntity<RoomPrefabData>(out var prefabEntity))
                {
                    ecb.AddComponent(prefabEntity, new RequestEntityPrefabLoaded()
                    {
                        Prefab = state.EntityManager.GetComponentData<RoomPrefabData>(prefabEntity).Prefab
                    });
                }
                
                foreach (var (prefab, entity) in SystemAPI.Query<RefRO<PrefabLoadResult>>().WithEntityAccess())
                {
                    _roomPrefab = ecb.Instantiate(prefab.ValueRO.PrefabRoot);

                    // Remove both RequestEntityPrefabLoaded and PrefabLoadResult to prevent
                    // the prefab being loaded and instantiated multiple times, respectively
                    ecb.RemoveComponent<RoomPrefabData>(entity);
                    ecb.RemoveComponent<RequestEntityPrefabLoaded>(entity);
                    ecb.RemoveComponent<PrefabLoadResult>(entity);
                }
                return;
            }

            new CreateRoomJob()
            {
                ecb = ecb,
                roomPrefab = _roomPrefab.Value
            }.Run();
            // foreach (var data in SystemAPI.Query<RefRO<RoomCreateData>>())
            // {
            //     CreateRoom(ref state, data.ValueRO.Type);
            // }
        }

        private EntityCommandBuffer GetEntityCommandBuffer(ref SystemState state)
        {
            var ecbSingleton = SystemAPI.GetSingleton<BeginSimulationEntityCommandBufferSystem.Singleton>();
            var ecb = ecbSingleton.CreateCommandBuffer(state.WorldUnmanaged);
            return ecb;
        }

        private void CreateRoom(ref SystemState state, RoomType roomType)
        {
            var entity = state.EntityManager.Instantiate(_roomPrefab.Value);

            state.EntityManager.SetComponentData(entity, new RoomData()
            {
                Level = 1,
                Capacity = 3,
                Type = roomType,
            });
            state.EntityManager.SetComponentData(entity, new Unity.Transforms.LocalTransform()
            {
                Position = new float3(10, 10, 10),
                Scale = 1.0f,
                Rotation = quaternion.identity
            });

            state.EntityManager.SetName(entity, "aslkdjklj");
        }
    }

    [BurstCompile]
    public partial struct CreateRoomJob : IJobEntity
    {
        public EntityCommandBuffer ecb;
        public Entity roomPrefab;

        private void Execute(Entity e, ref RoomCreateData data)
        {
            ecb.RemoveComponent<RoomCreateData>(e);
            var entity = ecb.Instantiate(roomPrefab);

            ecb.AddComponent(entity, new RoomData()
            {
                Level = 1,
                Capacity = 3,
                Type = data.Type,
            });
            ecb.SetComponent(entity, new Unity.Transforms.LocalTransform()
            {
                Position = new float3(10, 10, 10),
                Scale = 1.0f,
                Rotation = quaternion.identity
            });

            ecb.SetName(entity, "aslkdjklj");
        }
    }
}
using Hotel.Scripts.Base.Room;
using Unity.Entities;

namespace Hotel.Scripts.ECS.Components
{
    public struct RoomCreateData : IComponentData
    {
        public RoomType Type;
    }
}
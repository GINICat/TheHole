using Hotel.Scripts.Base.Room;
using Unity.Entities;

namespace Hotel.Scripts.ECS.Components
{
    public struct RoomData : IComponentData
    {
        public int Level;
        public int Capacity;
        public RoomType Type;
    }
}
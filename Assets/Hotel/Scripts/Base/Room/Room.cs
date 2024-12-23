using System.Runtime.CompilerServices;

namespace Hotel.Scripts.Base.Room
{
    public enum RoomType : byte
    {
        Loft,
        Workshop,
    }

    public abstract class RoomBase
    {
        public abstract int Level { get; }
        public abstract int Capacity { get; }
        public abstract RoomType Type { get; }

        public abstract void LevelUp();
    }
}
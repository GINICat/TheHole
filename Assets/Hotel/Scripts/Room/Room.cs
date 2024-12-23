using Hotel.Scripts.Base.Room;

namespace Hotel.Scripts.Room
{
    public class Loft : RoomBase
    {
        public override int Level { get; }
        public override int Capacity => 3;
        public override RoomType Type => RoomType.Loft;

        public override void LevelUp()
        {
            throw new System.NotImplementedException();
        }
    }

    public class Workshop : RoomBase
    {
        public override int Level { get; }
        public override int Capacity => 3;
        public override RoomType Type => RoomType.Workshop;

        public override void LevelUp()
        {
            throw new System.NotImplementedException();
        }
    }
}
using System;
using System.Linq;
using Hotel.Scripts.Base;
using Hotel.Scripts.Base.Room;
using UnityEngine;

namespace Hotel.Scripts
{
    [Serializable]
    public class ResourceManager : Singleton<ResourceManager>
    {
        //人口
        public int Population
        {
            get { return _guestCount; }
        }

        //钱
        public int Money
        {
            get { return _money; }
            set { _money = value; }
        }

        //房间数量
        public int RoomCount => _roomCounts.Sum();

        [SerializeField] private int _guestCount;
        [SerializeField] private int _money;
        [SerializeField] private int[] _roomCounts = new int[Enum.GetNames(typeof(RoomType)).Length];

        public void AddRoomCount(RoomType roomType)
        {
            _roomCounts[(int) roomType]++;
        }
    }
}
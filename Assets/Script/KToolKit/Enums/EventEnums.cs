

public enum EventName
{
    LevelClear,         // 过关，暂无参数，用于显示金币数值，屏蔽玩家操作用
    LevelUpComplete,         // 升级完成，暂无参数，用于恢复玩家操作用
    
    HoleScaleLevelUp,         // 洞口大小升级通知，暂无参数，这里不知道事件接收的逻辑具体怎么弄，先放着
    BallScaleLevelUp,         // 球大小升级通知，暂无参数
    MoneyLevelUp,         // 金钱收益升级通知，暂无参数
    HighScoreBallLevelUp,         // 高分球升级通知，暂无参数
    ShiningBallLevelUp,         // 闪光球升级通知，暂无参数
}


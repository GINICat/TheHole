using System;
using System.Collections;
using System.Collections.Generic;
using KToolkit;
using UnityEngine;
using UnityEngine.UI;


public enum PerkType
{
    ExpandHole = 1,
    MagnifyBall = 2,
    MoneyIncrease = 3,
    HighScoreBall = 4,
    ShiningBall = 5,
}


public class PerkController : Observer
{
    private PerkType perkType;

    private void Start()
    {
        AddEventListener(EventName.LevelUpComplete, args =>
        {
            ProcessLevelUp();
        });
    }

    public void SetPerkType(PerkType value)
    {
        perkType = value;
        string perkTypeStr = ((int)value - 1).ToString();
        transform.Find("icon").GetComponent<Image>().sprite =
            Resources.Load<Sprite>("level_up_icon/Plus_" + perkTypeStr);
        if (perkType == PerkType.ExpandHole)
        {
            transform.Find("title").GetComponent<Text>().text = "洞口升级";
            transform.Find("desc").GetComponent<Text>().text = "洞口大小略微扩大";
        }
        if (perkType == PerkType.MagnifyBall)
        {
            transform.Find("title").GetComponent<Text>().text = "球体升级";
            transform.Find("desc").GetComponent<Text>().text = "球体大小略微扩大";
        }
        if (perkType == PerkType.MoneyIncrease)
        {
            transform.Find("title").GetComponent<Text>().text = "收益升级";
            transform.Find("desc").GetComponent<Text>().text = "金钱收益略微提升";
        }
        if (perkType == PerkType.HighScoreBall)
        {
            transform.Find("title").GetComponent<Text>().text = "高分球升级";
            transform.Find("desc").GetComponent<Text>().text = "略微提升出现高分球的几率";
        }
        if (perkType == PerkType.ShiningBall)
        {
            transform.Find("title").GetComponent<Text>().text = "闪光球升级";
            transform.Find("desc").GetComponent<Text>().text = "略微提升出现闪光球的几率";
        }
    }

    private void ProcessLevelUp()
    {
        if (perkType == PerkType.ExpandHole)
        {
            EventManager.SendNotification(EventName.HoleScaleLevelUp);
        }

        if (perkType == PerkType.MagnifyBall)
        {
            EventManager.SendNotification(EventName.BallScaleLevelUp);
        }

        if (perkType == PerkType.MoneyIncrease)
        {
            EventManager.SendNotification(EventName.MoneyLevelUp);
        }

        if (perkType == PerkType.HighScoreBall)
        {
            EventManager.SendNotification(EventName.HighScoreBallLevelUp);
        }

        if (perkType == PerkType.ShiningBall)
        {
            EventManager.SendNotification(EventName.ShiningBallLevelUp);
        }
    }
}

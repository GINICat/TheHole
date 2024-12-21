using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

[UI_Info("GM/gm_page", "GMPage")]
public class GMPage : UIBase
{
    Dictionary<string, UnityAction> allFuncs = new Dictionary<string, UnityAction>();
    
    public override void OnStart()
    {
        base.OnStart();
        InitAllFuncs();
        GenerateAllFuncs();
        transform.Find("quit").GetComponent<Button>().onClick.AddListener((() =>
        {
            UIManager.instance.DestroyUI(this);
        }));
    }
    
    void InitAllFuncs()
    {
        allFuncs.Add("加100分", () =>
        {
            CurrencyManager.instance.AddScore(100);
        });
        allFuncs.Add("测试升级-洞口", () =>
        {
            EventManager.SendNotification(EventName.HoleScaleLevelUp);
        });
        allFuncs.Add("测试升级-金钱", () =>
        {
            EventManager.SendNotification(EventName.MoneyLevelUp);
        });
        allFuncs.Add("测试升级-球体", () =>
        {
            EventManager.SendNotification(EventName.BallScaleLevelUp);
        });
        
        allFuncs.Add("测试升级-闪光球", () =>
        {
            EventManager.SendNotification(EventName.ShiningBallLevelUp);
        });
        allFuncs.Add("测试升级-高分球", () =>
        {
            EventManager.SendNotification(EventName.HighScoreBallLevelUp);
        });
    }

    void GenerateAllFuncs()
    {
        foreach (var item in allFuncs)
        {
            var button = (Resources.Load<GameObject>("UI_prefabs/GM/gm_button"));
            button = GameObject.Instantiate(button, transform.Find("Scroll View/Viewport/Content"));
            button.transform.Find("title").GetComponent<Text>().text = item.Key;
            button.GetComponent<Button>().onClick.AddListener(item.Value);
        }
    }
}
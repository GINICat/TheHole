using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


[UI_Info("level_up_page", "LevelUpPage")]
public class LevelUpPage : UIBase
{
    private Transform layoutRoot;
    public override void InitParams(params object[] args)
    {
        base.InitParams(args);
        Time.timeScale = 0f;
        layoutRoot = transform.Find("layout_root");
        List<int> perkTypeList = GenerateRandomSequence(1, 5);
        for (int i = 0; i < 3; ++i)
        {
            var perkCardCell = GameObject.Instantiate(Resources.Load<GameObject>("UI_prefabs/perk_card"), layoutRoot);
            perkCardCell.GetComponent<Button>().onClick.AddListener(ClickLevelUpPerk);
            perkCardCell.GetComponent<PerkController>().SetPerkType((PerkType)perkTypeList[i]);
        }
    }
    
    private List<int> GenerateRandomSequence(int minValue, int maxValue)
    {
        List<int> numbers = new List<int>();
        for (int i = minValue; i <= maxValue; i++)
        {
            numbers.Add(i);
        }
        System.Random rng = new System.Random();
        int n = numbers.Count;
        while (n > 1)
        {
            n--;
            int k = rng.Next(n + 1);
            int value = numbers[k];
            numbers[k] = numbers[n];
            numbers[n] = value;
        }
        return numbers;
    }

    public override void OnDestroy()
    {
        base.OnDestroy();
        Time.timeScale = 1f;
    }

    void ClickLevelUpPerk()
    {
        //todo 具体升级内容的逻辑
        EventManager.SendNotification(EventName.LevelUpComplete);
        DestroySelf();
    }
}

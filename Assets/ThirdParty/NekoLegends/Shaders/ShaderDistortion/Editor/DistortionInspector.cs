#if UNITY_EDITOR
using UnityEditor;
using UnityEngine;

namespace NekoLegends
{
    public class DistortionInspector : ShaderGUI
    {
        protected bool showNormalProperties, showLightingProperties;

        public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
        {
            ShowLogo();
            ShowMainSection(materialEditor, properties);
        }

        protected void ShowMainSection(MaterialEditor materialEditor, MaterialProperty[] properties)
        {
            MaterialProperty _DistortionMap = FindProperty("_DistortionMap", properties);
            MaterialProperty _Scale = FindProperty("_Scale", properties);
            MaterialProperty _Strength = FindProperty("_Strength", properties);
            MaterialProperty _Speed = FindProperty("_Speed", properties);
            MaterialProperty _Clarity = FindProperty("_Clarity", properties);

            materialEditor.ShaderProperty(_DistortionMap, _DistortionMap.displayName);
            materialEditor.ShaderProperty(_Scale, _Scale.displayName);
            materialEditor.ShaderProperty(_Strength, _Strength.displayName);
            materialEditor.ShaderProperty(_Speed, _Speed.displayName);
            materialEditor.ShaderProperty(_Clarity, _Clarity.displayName);
        }

        private void ShowLogo()
        {
            // Placeholder implementation for ShowLogo
            GUILayout.Label("Shader Logo", EditorStyles.boldLabel);
        }
    }
}
#endif

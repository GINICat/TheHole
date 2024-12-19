#if UNITY_EDITOR
using UnityEditor;
using UnityEngine;

namespace NekoLegends
{
    public class GalaxyShaderInspector : ShaderGUI
    {
        private bool showNormalsLayerProperties, showFirstLayerProperties, showSecondLayerProperties, showFlareLayerProperties;

        public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
        {
            ShowLogo();

            MaterialProperty mainTexture = FindProperty("MainTexture", properties);
            MaterialProperty edgeEmission = FindProperty("_Edge_Emission", properties);
            MaterialProperty metallic = FindProperty("Metallic", properties);
            MaterialProperty smoothness = FindProperty("Smoothness", properties);
            MaterialProperty color = FindProperty("_Color", properties);

            materialEditor.ShaderProperty(mainTexture, mainTexture.displayName);
            materialEditor.ShaderProperty(edgeEmission, edgeEmission.displayName);
            materialEditor.ShaderProperty(metallic, metallic.displayName);
            materialEditor.ShaderProperty(smoothness, smoothness.displayName);
            materialEditor.ShaderProperty(color, color.displayName);

            MaterialProperty firstLayerTexture = FindProperty("_FirstLayer", properties);
            MaterialProperty firstLayerMask = FindProperty("_FirstLayerMask", properties);
            MaterialProperty firstLayerSpeed = FindProperty("_FirstLayer_Speed", properties);
            MaterialProperty firstLayerStillOpacity = FindProperty("_FirstLayer_Still_Opacity", properties);
            MaterialProperty layersOpacity = FindProperty("_Layers_Opacity", properties);
            MaterialProperty tileX = FindProperty("_Tile_X", properties);
            MaterialProperty tileY = FindProperty("_Tile_Y", properties);

            MaterialProperty normalMap = FindProperty("NormalMap", properties);
            MaterialProperty normal_Strength = FindProperty("_Normal_Strength", properties);

            showNormalsLayerProperties = EditorPrefs.GetBool("GalaxyShaderInspector_ShowNormalsLayerProperties", false);
            showNormalsLayerProperties = EditorGUILayout.BeginFoldoutHeaderGroup(showNormalsLayerProperties, "Normals Layer");
            if (showNormalsLayerProperties)
            {
                materialEditor.ShaderProperty(normalMap, normalMap.displayName);
                materialEditor.ShaderProperty(normal_Strength, normal_Strength.displayName);
            }
            EditorGUILayout.EndFoldoutHeaderGroup();
            EditorPrefs.SetBool("GalaxyShaderInspector_ShowNormalsLayerProperties", showNormalsLayerProperties);

            showFirstLayerProperties = EditorPrefs.GetBool("GalaxyShaderInspector_ShowFirstLayerProperties", false);
            showFirstLayerProperties = EditorGUILayout.BeginFoldoutHeaderGroup(showFirstLayerProperties, "First Layer");
            if (showFirstLayerProperties)
            {
                materialEditor.ShaderProperty(firstLayerTexture, firstLayerTexture.displayName);
                materialEditor.ShaderProperty(firstLayerMask, firstLayerMask.displayName);
                materialEditor.ShaderProperty(firstLayerSpeed, firstLayerSpeed.displayName);
                materialEditor.ShaderProperty(firstLayerStillOpacity, firstLayerStillOpacity.displayName);
                materialEditor.ShaderProperty(layersOpacity, layersOpacity.displayName);
                materialEditor.ShaderProperty(tileX, tileX.displayName);
                materialEditor.ShaderProperty(tileY, tileY.displayName);
            }
            EditorGUILayout.EndFoldoutHeaderGroup();
            EditorPrefs.SetBool("GalaxyShaderInspector_ShowFirstLayerProperties", showFirstLayerProperties);

            MaterialProperty secondLayer = FindProperty("_SecondLayer", properties);
            MaterialProperty secondLayerMask = FindProperty("_SecondLayerMask", properties);
            MaterialProperty secondLayerSpeed = FindProperty("_SecondLayer_Speed", properties);
            MaterialProperty tileX2 = FindProperty("_Tile_X_2", properties);
            MaterialProperty tileY2 = FindProperty("_Tile_Y_2", properties);

            showSecondLayerProperties = EditorPrefs.GetBool("GalaxyShaderInspector_ShowSecondLayerProperties", false);
            showSecondLayerProperties = EditorGUILayout.BeginFoldoutHeaderGroup(showSecondLayerProperties, "Second Layer");
            if (showSecondLayerProperties)
            {
                materialEditor.ShaderProperty(secondLayer, secondLayer.displayName);
                materialEditor.ShaderProperty(secondLayerMask, secondLayerMask.displayName);
                materialEditor.ShaderProperty(secondLayerSpeed, secondLayerSpeed.displayName);
                materialEditor.ShaderProperty(tileX2, tileX2.displayName);
                materialEditor.ShaderProperty(tileY2, tileY2.displayName);
            }
            EditorGUILayout.EndFoldoutHeaderGroup();
            EditorPrefs.SetBool("GalaxyShaderInspector_ShowSecondLayerProperties", showSecondLayerProperties);

            MaterialProperty flareLayer = FindProperty("_FlareLayer", properties);
            MaterialProperty flareLayerMask = FindProperty("_FlareLayerMask", properties);
            MaterialProperty flareSpeed = FindProperty("_Flare_Speed", properties);
            MaterialProperty flareNoise = FindProperty("_Flare_Noise", properties);
            MaterialProperty tileXFlare = FindProperty("_Tile_X_Flare", properties);
            MaterialProperty tileYFlare = FindProperty("_Tile_Y_Flare", properties);

            showFlareLayerProperties = EditorPrefs.GetBool("GalaxyShaderInspector_ShowFlareLayerProperties", false);
            showFlareLayerProperties = EditorGUILayout.BeginFoldoutHeaderGroup(showFlareLayerProperties, "Flare Layer");
            if (showFlareLayerProperties)
            {
                materialEditor.ShaderProperty(flareLayer, flareLayer.displayName);
                materialEditor.ShaderProperty(flareLayerMask, flareLayerMask.displayName);
                materialEditor.ShaderProperty(flareSpeed, flareSpeed.displayName);
                materialEditor.ShaderProperty(flareNoise, flareNoise.displayName);
                materialEditor.ShaderProperty(tileXFlare, tileXFlare.displayName);
                materialEditor.ShaderProperty(tileYFlare, tileYFlare.displayName);
            }
            EditorGUILayout.EndFoldoutHeaderGroup();
            EditorPrefs.SetBool("GalaxyShaderInspector_ShowFlareLayerProperties", showFlareLayerProperties);
        }

        private void ShowLogo()
        {
            // Placeholder implementation for ShowLogo
            GUILayout.Label("Shader Logo", EditorStyles.boldLabel);
        }
    }
}
#endif

Analytic Soft Shadows
Created by Jolly Theory
Support Thread: https://forum.unity.com/threads/released-analytic-soft-shadows-for-unity.1067756/

-----
USAGE:

URP:
1) Import URP.unitypackage by double clicking it. File overrides are intended.
2) Add UASSRendererFeature to your URP Renderer (URP Renderer asset > Renderer Features > UASS Renderer Feature)
3) Add 'UASS' component to your camera. Add multiple for mulltiple soft-shadow-generating lights.
4) Use 'Lit + AnalyticShadows' shader instead of 'Lit' shader on objects that you want to receive analytic soft shadows. ('Universal Render Pipeline/Lit + AnalyticShadows') (It is a copy of Lit shader, without any extra parameters)
5) Add UASSSphere/Capsule/Box components to objects that should cast shadows, there can be multiple per object. You will have to approximate your shadow shapes from these three basic shapes. You can right-click on collider components to turn them into UASS counterparts.
6) Turn off MeshRenderer's 'Cast Shadows' for appropriate meshes, or set 'Shadow Type' to 'No Shadows' for your entire light. (In places where you don't want old shadowmaps shadows mixing with new analytic shadows)
7) Adjust the algorithm and light angle settings to fit your scene. Try increasing bias if you see any self-shadowing artifacts.
For custom shaders: Sample a global screen texture called "_UASSTexture" with screen UV in your shader, .rgb component will have the analytic soft shadows signal, use it in your shader (You can now multiply light color by it for example).

Built-in RP:
1) Set your camera to Deferred rendering path.
2) Add 'UASS' component to your camera. Add multiple for mulltiple soft-shadow-generating lights.
3) Add UASSSphere/Capsule/Box components to objects that should cast shadows, there can be multiple per object. You will have to approximate your shadow shapes from these three basic shapes. You can right-click on collider components to turn them into UASS counterparts.
4) Turn off MeshRenderer's 'Cast Shadows' for appropriate meshes, or set 'Shadow Type' to 'No Shadows' for your entire light. (In places where you don't want old shadowmaps shadows mixing with new analytic shadows)
5) Adjust the algorithm and light angle settings to fit your scene. Try increasing bias if you see any self-shadowing artifacts.
In built-in, all shaders that are opaque and render to the depth buffer can receive shadows, no custom shaders or materials required. Shaders that are not opaque and don't render to the depth buffer may need to be adjusted to receive shadows.
For custom shaders: Sample a global screen texture called "_UASSTexture" with screen UV in your shader, .rgb component will have the analytic soft shadows signal, use it in your shader (You can now multiply light color by it for example).

----
TIPS:

- Add more than one UASS component to your camera to have multiple lights casting shadows. It's recommended to not go higher than three UASS components for performance reasons.
- Rightclick on Collider components to turn them into UASS counterparts (Rightclick BoxCollider -> 'Turn into UASSBox').
- Tools/UASS/* menu has helpful functions that you can use for, for example, quickly converting all of a ragdoll's colliders to UASS shadowcasters.
- If you're having import issues try right clicking on 'UnityAnalyticSoftShadows' folder -> Reimport.
- Try closing and re-opening the Scene View window if you are having visual glitches inside of it.
- "Invalid pass index 1 in DrawMesh" error might appear when first enabling the asset, it can be safely ignored.

URP Shader Graph and Amplify Shader Editor examples:
-https://forum.unity.com/threads/released-screen-space-cavity-curvature-for-unity-inspired-by-blenders-cavity-effects.1261145/#post-8412501
-https://forum.unity.com/threads/released-screen-space-cavity-curvature-for-unity-inspired-by-blenders-cavity-effects.1261145/page-2#post-8974291
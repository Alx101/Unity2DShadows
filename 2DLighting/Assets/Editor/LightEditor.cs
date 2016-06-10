using UnityEngine;
using UnityEditor;
using UnityEditorInternal;
using System.Collections;
using System.Collections.Generic;

public class LightEditor : EditorWindow
{
	public static LightEditor editor;
	public ShadowController controller;
	public List<LightSettings2D> lightSettings;
	List<int> layers;
	Dictionary<int, bool> foldouts;
    Dictionary<int, int> layerCount;
    int scrollHeight;
    bool settingsEditor = true;
    bool value;

	Vector2 overallScroll;
	Vector2 scroll1;
	int operation;

	[MenuItem("Tools/Light editor")]
	static void ShowAndEnable()
	{
		editor = (LightEditor)EditorWindow.GetWindow(typeof(LightEditor));
	}

	public void OnEnable()
	{
		foldouts = new Dictionary<int, bool>();
        layerCount = new Dictionary<int, int>();
		layers = new List<int>();
        lightSettings = new List<LightSettings2D>();
	}

	public void OnGUI()
	{
        layers.Clear();
		lightSettings.Clear();
        layerCount.Clear();
		lightSettings.AddRange(((LightSettings2D[])GameObject.FindObjectsOfType<LightSettings2D>()));
		foreach (LightSettings2D ob in lightSettings)
		{
            if (!layers.Contains(ob.gameObject.layer))
            {
                layerCount[ob.gameObject.layer] = 1;
                layers.Add(ob.gameObject.layer);
                if(!foldouts.ContainsKey(ob.gameObject.layer))
                    foldouts[ob.gameObject.layer] = true;
            }
            else
                layerCount[ob.gameObject.layer]++;
		}

		controller = (ShadowController)GameObject.FindObjectOfType<ShadowController>();

		if (!controller.lightMesh)
		{
			GameObject o = GameObject.CreatePrimitive(PrimitiveType.Quad);
			controller.lightMesh = o.GetComponent<MeshFilter>().sharedMesh;
			GameObject.DestroyImmediate(o);
		}

		GUIStyle largeBoldLabel = new GUIStyle(EditorStyles.boldLabel);
		largeBoldLabel.fontSize = 14;
		largeBoldLabel.clipping = UnityEngine.TextClipping.Overflow;

		GUIStyle mediumBoldLabel = new GUIStyle(largeBoldLabel);
		mediumBoldLabel.fontSize = 12;

        GUIStyle foldoutMediumBold = new GUIStyle(EditorStyles.foldout);
        foldoutMediumBold.fontSize = 12;
        foldoutMediumBold.fontStyle = FontStyle.Bold;

        GUIStyle layerFoldout = new GUIStyle(foldoutMediumBold);
        layerFoldout.fontSize = 10;
        layerFoldout.fontStyle = FontStyle.BoldAndItalic;

		GUIStyle smallBoldLabel = new GUIStyle(mediumBoldLabel);
		smallBoldLabel.fontSize = 10;

		overallScroll = EditorGUILayout.BeginScrollView(overallScroll);

		EditorGUILayout.LabelField("Shadow controller options", largeBoldLabel);
		controller.shadowColor = EditorGUILayout.ColorField("Shadow color", controller.shadowColor);
		controller.MapResolution = (ShadowController.ShadowmapResolution)EditorGUILayout.EnumPopup("Shadowmap resolution", controller.MapResolution);
		controller.blendMode = (ShadowController.ShadowBlendMode)EditorGUILayout.EnumPopup("Blending mode", controller.blendMode);
		controller.alphaThreshold = EditorGUILayout.Slider("Alpha cutoff threshold", controller.alphaThreshold, 0, 1);
		//controller.movingShadowcasters = EditorGUILayout.Toggle(controller.movingShadowcasters, )
		EditorGUILayout.Space();

        scrollHeight = 0;
        foreach (KeyValuePair<int, bool> fold in foldouts)
        {
            if (fold.Value)
            {
                int temp = layerCount[fold.Key] * 100;
                if (temp > scrollHeight)
                    scrollHeight = temp;
                if (scrollHeight > 300)
                    scrollHeight = 300;
                break;
            }
            else
                scrollHeight = 50;
        }
        if (!settingsEditor)
            scrollHeight = 0;

		EditorGUILayout.LabelField("Mass light setting editor", largeBoldLabel);
        EditorGUILayout.Space();
        settingsEditor = EditorGUILayout.Foldout(settingsEditor, "LightSettings2D", foldoutMediumBold);
        if (settingsEditor)
        {
            scroll1 = EditorGUILayout.BeginScrollView(scroll1, GUILayout.Height(scrollHeight));
            foreach (int layer in layers)
            {
                //EditorGUILayout.LabelField(LayerMask.LayerToName(layer), smallBoldLabel);
                foldouts[layer] = EditorGUILayout.Foldout(foldouts[layer], LayerMask.LayerToName(layer), layerFoldout);
                if (!foldouts[layer])
                    continue;
                foreach (LightSettings2D sett in lightSettings)
                {
                    if (sett.gameObject.layer == layer)
                    {
                        EditorGUILayout.SelectableLabel(sett.name, EditorStyles.boldLabel, GUILayout.Height(20));
                        sett.CastShadows = EditorGUILayout.Toggle("Cast shadows", sett.CastShadows);
                        sett.RecieveShadows = EditorGUILayout.Toggle("Recieve shadows", sett.RecieveShadows);
                    }
                }
            }
            EditorGUILayout.EndScrollView();
            EditorGUILayout.Space();
        }

		EditorGUILayout.LabelField("Mass operations", mediumBoldLabel);
		operation = EditorGUILayout.LayerField(operation);
        value = EditorGUILayout.Toggle("Value", value);
        if (GUILayout.Button("Add LightSettings2D script"))
		{
			SpriteRenderer[] objects = FindObjectsOfType<SpriteRenderer>();
			foreach (SpriteRenderer obj in objects)
			{
				if (!(obj.GetComponent<LightSettings2D>() ?? null) && obj.gameObject.layer == operation)
					obj.gameObject.AddComponent<LightSettings2D>();
			}
		}
        if (GUILayout.Button("Toggle ShadowCaster"))
        {
            foreach (LightSettings2D obj in lightSettings)
            {
                if (obj.gameObject.layer == operation)
                    obj.CastShadows = !obj.CastShadows;
            }
        }
        if (GUILayout.Button("Toggle Lit"))
        {
            foreach (LightSettings2D obj in lightSettings)
            {
                if (obj.gameObject.layer == operation)
                    obj.RecieveShadows = !obj.RecieveShadows;
            }
        }
        if (GUILayout.Button("Set ShadowCaster"))
        {
            foreach (LightSettings2D obj in lightSettings)
            {
                if (obj.gameObject.layer == operation)
                    obj.CastShadows = value;
            }
        }
        if (GUILayout.Button("Set Lit"))
        {
            foreach (LightSettings2D obj in lightSettings)
            {
                if (obj.gameObject.layer == operation)
                    obj.RecieveShadows = value;
            }
        }


        EditorGUILayout.EndScrollView();

	}

	private bool IsInLayerMask(GameObject obj, LayerMask layerMask)
	{
		// Convert the object's layer to a bitfield for comparison
		int objLayerMask = (1 << obj.layer);
		if ((layerMask.value & objLayerMask) > 0)  // Extra round brackets required!
			return true;
		else
			return false;
	}
}

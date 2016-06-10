using UnityEngine;
using UnityEditor;
using System.Collections;

[CustomEditor(typeof(LightSource))]
public class LightSourceEditor : Editor
{
	void OnSceneGUI()
	{
		LightSource source = (LightSource)target;

		Handles.color = Color.white;
		Handles.DrawWireArc(source.transform.position, Vector3.back, Vector3.up, 360, (source.size / 2));
		Vector3 pa = source.DirFromAngle(source.angle / 2, false) * (source.size / 2);
		Vector3 pb = source.DirFromAngle(source.angle / -2, false) * (source.size / 2);
		pa.z = source.transform.position.z;
		pb.z = source.transform.position.z;
		Handles.color = new Color(0.5f, 0.5f, 0.5f, 0.2f);
		Handles.DrawSolidArc(source.transform.position, Vector3.back, pa, source.angle, (source.size / 2));
		Handles.color = Color.white;
		Handles.DrawLine(source.transform.position, source.transform.position + pa);
		Handles.DrawLine(source.transform.position, source.transform.position + pb);
	}
}

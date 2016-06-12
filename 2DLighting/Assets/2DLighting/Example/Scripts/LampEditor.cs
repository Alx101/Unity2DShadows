using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class LampEditor : MonoBehaviour
{
	public LightSource selected
	{
		get
		{
			return sel;
		}
		set
		{
			sel = value;
			selectLabel.text = value.gameObject.name;
			onoff.isOn = value.on;
			cone.value = value.angle;
			rotation.value = value.transform.rotation.eulerAngles.z;
		}
	}
	LightSource sel;
	public Toggle onoff;
	public Slider cone;
	public Slider rotation;
	public Text selectLabel;

	// Use this for initialization
	void Start ()
	{
	}

	public void OnOff(bool val)
	{
		if(sel)
			sel.on = val;
	}

	public void SetRot(float val)
	{
		if(sel)
			sel.transform.eulerAngles = new Vector3(sel.transform.eulerAngles.x, sel.transform.eulerAngles.y, val);
	}

	public void SetCone(float val)
	{
		if(sel)
			sel.angle = val;
	}

	// Update is called once per frame
	void Update ()
	{
	
	}
}

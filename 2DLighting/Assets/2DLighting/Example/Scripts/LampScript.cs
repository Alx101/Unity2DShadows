using UnityEngine;
using System.Collections;

[RequireComponent(typeof(SpriteRenderer), typeof(LightSource), typeof(Draggable))]
public class LampScript : MonoBehaviour
{
	public Sprite onSprite;
	public Sprite offSprite;
	public LampEditor lampEditor;

	SpriteRenderer rend;
	LightSource light;
	Draggable drag;

	// Use this for initialization
	void Start ()
	{
		rend = GetComponent<SpriteRenderer>();
		light = GetComponent<LightSource>();
		drag = GetComponent<Draggable>();
		drag.OnClicked += Drag_OnClicked;
	}

	private void Drag_OnClicked(object sender, System.EventArgs e)
	{
		lampEditor.selected = light;
	}

	// Update is called once per frame
	void Update ()
	{
		rend.sprite = (light.on) ? onSprite : offSprite;
	}
}

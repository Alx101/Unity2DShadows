using UnityEngine;
using System;
using System.Collections;

public class Draggable : MonoBehaviour
{
	public float dragRadius = 1.0f;

	public event EventHandler OnClicked;

	Vector3 deltaPos;
	bool dragging = false;

	// Use this for initialization
	void Start ()
	{
	
	}

	public void invokeClicked()
	{
		if (OnClicked != null)
			OnClicked.Invoke(this, null);
	}

	// Update is called once per frame
	void LateUpdate()
	{
		if (dragging)
		{
			deltaPos = Camera.main.ScreenToWorldPoint(new Vector3(Input.mousePosition.x, Input.mousePosition.y, -1)) - transform.position;
			deltaPos.z = 0;
			transform.Translate(deltaPos);
		}

	}

	public void isDragged(bool val)
	{
		dragging = val;
	}
}

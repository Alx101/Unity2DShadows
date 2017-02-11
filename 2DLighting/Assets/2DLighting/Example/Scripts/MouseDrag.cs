using UnityEngine;
using System.Collections;

public class MouseDrag : MonoBehaviour
{

	Collider2D target;
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update ()
	{
		if (Input.GetMouseButtonDown(0))
		{
			Vector3 pos = Camera.main.ScreenToWorldPoint(new Vector3(Input.mousePosition.x, Input.mousePosition.y));
			Vector2 point = new Vector2(pos.x, pos.y);
			Collider2D hit = Physics2D.OverlapCircle(point, 1f);
			if (hit != null)
			{
				Draggable drag = hit.GetComponent<Draggable>();
				drag.invokeClicked();
				drag.isDragged(true);
				target = hit;
			}
		}
		if (Input.GetMouseButtonUp(0) && target)
		{
			target.GetComponent<Draggable>().isDragged(false);
		}
	}
}

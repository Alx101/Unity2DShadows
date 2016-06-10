using UnityEngine;
using System.Collections;
  
[RequireComponent(typeof(SpriteRenderer))]
public class LightSettings2D : MonoBehaviour
{
	//Wether or not this object will cast shadows
	public bool CastShadows = true;
	
	//Wether or not this object will be affected by shadows (activating this and the above might cause artifacts)
	public bool RecieveShadows = true;
	
	//Reference to the sprite renderer
	SpriteRenderer rend;

	//Material reference for the shaded version
	Material lit;
	//Material reference for the standard sprite material
	Material standard;

	void Start()
	{
		rend = GetComponent<SpriteRenderer>(); //Get sprite renderer
		standard = rend.material; //Fill standard material reference
		lit = new Material(Shader.Find("Hidden/2DLighting/Blend")); //Create lit material 
	}

	void Update()
	{
		rend.material = (RecieveShadows) ? lit : standard; //Update material state
	}
}

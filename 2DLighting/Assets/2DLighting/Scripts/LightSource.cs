using UnityEngine;
using System.Collections;

public class LightSource : MonoBehaviour
{
	//Angle of the cone of light
	[Range(0, 360)]
	public float angle = 360f;
	//Intensity (hardness) of the light
	[Range(0, 5)]
	public float intensity = 1;
	
	//Diameter of the light in unity units (the bigger the light, the higher imprecision)
	public int size = 2;
	//Color of the light
	public Color lightColor;
	//How blurry the light is (values > 2 might cause artifacts)
    public float blurAmount = 1;
	
	//Internal update flag
	[HideInInspector]
	public bool needsUpdate = true;
	//Wether or not the light emits any light (it's on or not)
	public bool on = true;
	
	//Reference matrices for shadow calculation
	[HideInInspector]
	public Matrix4x4 mvp;
	[HideInInspector]
	public Matrix4x4 lightMvp;
	[HideInInspector]
	public Matrix4x4 orthoProj;

	//Update flag variables
	float lastInt;
	Vector3 lastPos;
	Vector3 lastRot;
	int lastSize;
	Color lastCol;
	Vector3 initScale;
    float lastBlur;

	//GameObject lightQuad; <-- old code, unsure if this changed anything
	
	//Used for updating the matrices used in shadow mapping
    public void RecalculateMatrices()
    {
        mvp = Matrix4x4.TRS(transform.position, transform.rotation, Vector3.one).inverse; //Get local inverse MVP matrix
        mvp.m23 = -10; //Make sure it's far away from the z-plane
        
		//Calculate the light MVP
		lightMvp = Matrix4x4.identity;
        lightMvp = Matrix4x4.TRS(transform.position, transform.rotation, new Vector3(size, size, 1.0f));
        
		//Create local orthographic projection matrix for this light
		orthoProj = Matrix4x4.Ortho(-(float)size / 2, (float)size / 2, -(float)size / 2, (float)size / 2, .3f, 1000f);
    }

	void Update()
	{
		//Check if update is needed, and if so update all values that need updating
		if (lastBlur != blurAmount || lastPos != transform.position || lastRot != transform.rotation.eulerAngles || lastSize != size || lastCol != lightColor || lastInt != intensity)
		{
			needsUpdate = true;
			lastSize = size;
			lastInt = intensity;
			lastCol = lightColor;
			lastPos = transform.position;
			lastRot = transform.rotation.eulerAngles;
            lastBlur = blurAmount;

			RecalculateMatrices();
		}
	}

	//Helper function
	public Vector3 DirFromAngle(float angleInDegrees, bool globalAngle)
	{
		if (!globalAngle)
			angleInDegrees += transform.eulerAngles.z;
		return new Vector3(Mathf.Cos(angleInDegrees * Mathf.Deg2Rad), Mathf.Sin(angleInDegrees * Mathf.Deg2Rad), transform.position.z);
	}
}

#version 330

uniform mat4 P;
uniform mat4 C;
uniform mat4 mT;
uniform mat4 mR;
uniform mat4 L;
uniform vec4 lightPos;
uniform vec4 camPos;
uniform int shadingMode;

smooth in vec4 smoothColor;
in vec4 rotatedLight;
smooth in vec4 currentPos;
smooth in vec4 norm;

out vec4 fragColor;

void main()
{
	if(shadingMode == 0 || shadingMode == 1)
	{
		fragColor = smoothColor;
	}
	else
	{
		vec4 path = rotatedLight - currentPos;
		float diffuse = dot(norm, path) * inversesqrt(dot(path,path));
		path = normalize(path);
		if(diffuse < 0)
			diffuse = 0;
		vec4 toCamera = normalize(camPos-currentPos);
		vec4 rvec = normalize(2.0 * dot(path, norm) * norm - path);
		float spec = dot(rvec,toCamera);
		if(spec < 0)
			spec = 0;
		spec = pow(spec, 10.0f);
		fragColor = (diffuse + 0.1 + spec) * smoothColor;
		//fragColor = vec4(dot(toCamera,norm));
		//fragColor = rvec;
	}

    //TODO add gouraud and phong shading support
}

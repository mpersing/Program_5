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

float getDiffuse(vec4 n, vec4 l)
{
	return clamp(dot(n, l), 0, 1);
}

float getSpecular(vec4 n, vec4 l, vec4 c, float alpha)
{
	vec4 r = reflect(-l, n);
	float temp = clamp(dot(r,c), 0, 1);
	return pow(temp, alpha);
}

void main()
{
	if(shadingMode == 0 || shadingMode == 1)
	{
		fragColor = smoothColor;
	}
	else
	{
		vec4 toLight = normalize(rotatedLight-currentPos);
		vec4 toCamera = normalize(camPos-currentPos);
		vec4 normalizedNorm = normalize(norm);

		float diffuse = getDiffuse(normalizedNorm, toLight);

		float spec = getSpecular(normalizedNorm, toLight, toCamera, 10.0f);

		fragColor = vec4(0.1 + spec) + (diffuse) * smoothColor;
	}
}

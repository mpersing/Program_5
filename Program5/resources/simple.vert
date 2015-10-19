#version 330

uniform mat4 P;
uniform mat4 C;
uniform mat4 mT;
uniform mat4 mR;
uniform mat4 M;
uniform mat4 N;
uniform mat4 L;
uniform vec4 lightPos;
uniform vec4 camPos;
uniform int shadingMode;

in vec3 pos;
in vec3 colorIn;

smooth out vec4 smoothColor;
out vec4 rotatedLight;
smooth out vec4 currentPos;
smooth out vec4 norm;

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

vec4 justColor()
{
    return vec4(colorIn, 1);
}

vec4 gouraud()
{
	vec4 toLight = normalize(rotatedLight-currentPos);
	vec4 toCamera = normalize(camPos-currentPos);

	float diffuse = getDiffuse(norm, toLight);

	float spec = getSpecular(norm, toLight, toCamera, 10.0f);

    return vec4(spec + 0.1) + diffuse * vec4(colorIn,1);
}

vec4 phong()
{
    return justColor();
}

void main()
{

	rotatedLight = L*lightPos;
	currentPos = mR*mT*vec4(pos,1);
	norm = normalize(mR*vec4(colorIn * 2 - 1,0));
    
	gl_Position = P*C*currentPos;
    
    if(shadingMode == 0)
        smoothColor = justColor();
    else if (shadingMode == 1)
        smoothColor = gouraud();
    else
        smoothColor = phong();
}

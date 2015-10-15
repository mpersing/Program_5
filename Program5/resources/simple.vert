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

vec4 justColor()
{
    return vec4(colorIn, 1);
}

vec4 gouraud()
{
	norm = N*vec4(colorIn * 2 - 1,1);
	vec4 path = rotatedLight - currentPos;
	float diffuse = dot(norm, rotatedLight-currentPos) * inversesqrt(dot(path,path));
	if(diffuse < 0)
		diffuse = 0;
	vec4 rvec = 2.0f * dot(camPos, norm) * norm - camPos;
	float spec = pow(dot(rvec, camPos), 10.0f);
	if(spec < 0)
		spec = 0;
    return spec * vec4(colorIn,1);
}

vec4 phong()
{
    return justColor();
}

void main()
{
    //TODO add gouraud and phong shading support
	rotatedLight = L*lightPos;
	currentPos = mR*mT*vec4(pos,1);
	norm = normalize(mR*vec4(colorIn * 2 - 1,1));
    
	vec4 pos = vec4(pos, 1);
	gl_Position = P*M*pos;
    
    if(shadingMode == 0)
        smoothColor = justColor();
    else if (shadingMode == 1)
        smoothColor = gouraud();
    else
        smoothColor = phong();
}

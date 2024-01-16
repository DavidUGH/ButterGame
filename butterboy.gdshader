shader_type canvas_item;

uniform bool flash;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	
	if (flash)
	{
		COLOR = vec4(1, 1, 1, color.a);
	}
	else
	{
		COLOR = color;
	}
}

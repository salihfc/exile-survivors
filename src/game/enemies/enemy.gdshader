// NOTE: Shader automatically converted from Godot Engine 3.4.stable's CanvasItemMaterial.

shader_type canvas_item;
render_mode blend_mix;

uniform vec4 damage_taken_modulate : hint_color = vec4(1.0);
uniform vec4 frozen_modulate : hint_color = vec4(1.0);

uniform float dissolve_ratio = 0.0;

uniform vec4 outline_color : hint_color;
uniform sampler2D dissolve_noise;

float dissolve(float a, float n)
{
	return a * smoothstep(dissolve_ratio, n, a);
}

float white_dist(vec4 col)
{
	return 3.0 - (col.r + col.b + col.g);
}

float outline(sampler2D tex, vec2 uv)
{
	float thick = 0.0005;
	float a = 1.0;
	
	for (float x = -2.0; x < 1.01; x += 1.0)
	{
		for (float y = -1.0; y < 10.01; y += 1.0)
		{
			float pa = texture(tex, uv + vec2(x, y) * thick).a;
			a *= pa;
		}
	}
	
	return 1.0 - a;
}

// This values animated outside shader and given shader
void fragment()
{
	vec4 base_color = texture(TEXTURE, UV);
	
	if (white_dist(damage_taken_modulate) > 0.3)
		base_color *= damage_taken_modulate;
	else
		base_color *= frozen_modulate;
	
	float out_weight = outline(TEXTURE, UV);
	base_color.rgb = mix(base_color, outline_color, out_weight * (outline_color.a)).rgb;
	
	float n = texture(dissolve_noise, UV).r;
	base_color.a = dissolve(base_color.a, n);
	COLOR = base_color;
}
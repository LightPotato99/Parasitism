shader_type canvas_item;

uniform float whiteness : hint_range(0,1) = 0;

vec3 interpolate_vec3(vec3 start, vec3 end, float delta){
	return start + (end - start) * delta;
}

void fragment(){
	vec4 origin = texture(TEXTURE, UV);
	COLOR.rgb = interpolate_vec3(origin.rgb, vec3(1,1,1), whiteness);
	COLOR.a = origin.a;
}
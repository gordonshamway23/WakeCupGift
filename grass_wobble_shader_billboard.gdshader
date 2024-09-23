// NOTE: Shader automatically converted from Godot Engine 3.5.3.stable's SpatialMaterial.

// This shader could theoretically also work on a mesh instance, but I think a 3d sprite is enough for grass.

shader_type spatial;
// skip_vertex_transform is important, so one can change vertex transformation
render_mode skip_vertex_transform,async_visible,blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx;
uniform vec4 albedo : hint_color;
uniform sampler2D texture_albedo : hint_albedo;
uniform float specular;
uniform float metallic;
uniform float roughness : hint_range(0,1);

// shear wobble animation strength
uniform float shear_wobble_strength = 0.5;

// shear wobble animation speed
uniform float shear_wobble_speed = 1.0;

//how many variations of grass tufts are in the texture
uniform int count_variants = 1;

void vertex() {
	//position of the node origin in world space
	vec4 obj_pos_world = WORLD_MATRIX * vec4(0.0,0.0,0.0,1.0);
	
	//a number that varies by world position of the node
	float variation = (obj_pos_world.x + obj_pos_world.y + obj_pos_world.z) * 10.0;
	
	//let vertex wobble by shearing it
	//sin phase derived from node world position, so that not all grass tufts wobble the same :)
	float shear_wobble_phase = variation; 
	float shear_wobble = sin(TIME*shear_wobble_speed + shear_wobble_phase) * shear_wobble_strength;
	mat4 shear_wobble_mat = mat4(vec4(1,0,0,0), vec4(shear_wobble,1,0,0), vec4(0,0,1,0), vec4(0,0,0,1));
	VERTEX = (INV_CAMERA_MATRIX *  WORLD_MATRIX * vec4(0.0,0.0,0.0,1.0)).xyz + (shear_wobble_mat * vec4(VERTEX.x,VERTEX.y+0.5,VERTEX.z,1.0)).xyz;
	
	// select a grass tuft variant depending on world pos
	int variant_index = int(variation) % count_variants;
	UV.x = (float(variant_index)+UV.x)/float(count_variants);
}




void fragment() {
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	ALBEDO = albedo.rgb * albedo_tex.rgb;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	SPECULAR = specular;
	ALPHA = albedo.a * albedo_tex.a;
}

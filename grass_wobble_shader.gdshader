// NOTE: Shader automatically converted from Godot Engine 3.5.3.stable's SpatialMaterial.

shader_type spatial;
render_mode skip_vertex_transform,async_visible,blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx;
uniform vec4 albedo : hint_color;
uniform sampler2D texture_albedo : hint_albedo;
uniform float specular;
uniform float metallic;
uniform float roughness : hint_range(0,1);
uniform float point_size : hint_range(0,128);
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;

uniform float shear_wobble_strength = 0.5;
uniform float shear_wobble_speed = 1.0;

void vertex() {
	vec4 vert_pos_world = WORLD_MATRIX * vec4(VERTEX, 1.0);
	float shear_wobble_phase = vert_pos_world.x + vert_pos_world.y + vert_pos_world.z;
	float shear_wobble = sin(TIME*shear_wobble_speed + shear_wobble_phase) * shear_wobble_strength;
	mat4 shear_wobble_mat = mat4(vec4(1,0,0,0), vec4(shear_wobble,1,0,0), vec4(0,0,1,0), vec4(0,0,0,1));
	VERTEX = (INV_CAMERA_MATRIX * shear_wobble_mat * vert_pos_world).xyz;
	
	UV=UV*uv1_scale.xy+uv1_offset.xy;
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

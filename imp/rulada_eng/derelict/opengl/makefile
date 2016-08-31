CP=cp
#DIR=c:\dm\imp\rulada
DMDDIR=c:\dm
CFLAGS=-mn -6 -r
#CFLAGS=-g -mn -6 -r

DFLAGS=-O -release  -nofloat -w -Ddhtml


CC=dmc

DMD=dmd

DOC=.\html


.c.obj:
	$(CC) -c $(CFLAGS) $*

.cpp.obj:
	$(CC) -c $(CFLAGS) $*

.d.obj:
	$(DMD) -c $(DFLAGS) $*

.asm.obj:
	$(CC) -c $*

targets : DerelictGL.lib

MAKEFILES= makefile

SRC= cgl.d gl.d gl12.d gl13.d gl14.d gl15.d gl20.d gl21.d glext.d \
	glfuncs.d gltypes.d glx.d wgl.d	\
	extension\loader.d \
	extension\arb\color_buffer_float.d extension\arb\depth_texture.d \
	extension\arb\draw_buffers.d \
	extension\arb\fragment_program.d extension\arb\fragment_program_shadow.d \
	extension\arb\fragment_shader.d \
	extension\arb\half_float_pixel.d extension\arb\matrix_palette.d \
	extension\arb\multisample.d extension\arb\multitexture.d \
	extension\arb\occlusion_query.d extension\arb\pixel_buffer_object.d \
	extension\arb\point_parameters.d extension\arb\point_sprite.d \
	extension\arb\shader_objects.d extension\arb\shading_language_100.d \
	extension\arb\shadow.d \
	extension\arb\shadow_ambient.d extension\arb\texture_border_clamp.d \
	extension\arb\texture_compression.d extension\arb\texture_cube_map.d \
	extension\arb\texture_env_add.d extension\arb\texture_env_combine.d \
	extension\arb\texture_env_crossbar.d extension\arb\texture_env_dot3.d \
	extension\arb\texture_float.d extension\arb\texture_mirrored_repeat.d \
	extension\arb\texture_non_power_of_two.d extension\arb\texture_rectangle.d \
	extension\arb\transpose_matrix.d extension\arb\vertex_blend.d \
	extension\arb\vertex_buffer_object.d extension\arb\vertex_program.d \
	extension\arb\vertex_shader.d \
	extension\arb\window_pos.d \
	extension\ati\draw_buffers.d extension\ati\element_array.d extension\ati\envmap_bumpmap.d extension\ati\fragment_shader.d \
	extension\ati\map_object_buffer.d extension\ati\pn_triangles.d extension\ati\separate_stencil.d extension\ati\shader_texture_lod.d \
	extension\ati\text_fragment_shader.d extension\ati\texture_compression_3dc.d extension\ati\texture_env_combine3.d extension\ati\texture_float.d \
	extension\ati\texture_mirror_once.d extension\ati\vertex_array_object.d extension\ati\vertex_attrib_array_object.d \
	extension\ati\vertex_streams.d \
	extension\ext\abgr.d extension\ext\bgra.d extension\ext\bindable_uniform.d \
	extension\ext\blend_color.d extension\ext\blend_equation_separate.d \
	extension\ext\blend_func_separate.d extension\ext\blend_minmax.d extension\ext\blend_subtract.d \
	extension\ext\Cg_shader.d extension\ext\clip_volume_hint.d extension\ext\cmyka.d \
	extension\ext\color_subtable.d extension\ext\compiled_vertex_array.d extension\ext\convolution.d \
	extension\ext\coordinate_frame.d extension\ext\cull_vertex.d extension\ext\depth_bounds_test.d \
	extension\ext\draw_buffers2.d extension\ext\draw_instanced.d extension\ext\draw_range_elements.d \
	extension\ext\fog_coord.d extension\ext\four22_pixels.d extension\ext\fragment_lighting.d \
	extension\ext\framebuffer_blit.d extension\ext\framebuffer_multisample.d extension\ext\framebuffer_object.d \
	extension\ext\framebuffer_sRGB.d extension\ext\geometry_shader4.d extension\ext\histogram.d \
	extension\ext\light_texture.d extension\ext\misc_attribute.d extension\ext\multi_draw_arrays.d \
	extension\ext\multisample.d extension\ext\packed_depth_stencil.d extension\ext\packed_float.d \
	extension\ext\packed_pixels.d extension\ext\paletted_texture.d extension\ext\pixel_buffer_object.d \
	extension\ext\pixel_transform.d extension\ext\pixel_transform_color_table.d \
	extension\ext\point_parameters.d extension\ext\rescale_normal.d extension\ext\scene_marker.d \
	extension\ext\secondary_color.d extension\ext\separate_specular_color.d extension\ext\shadow_funcs.d \
	extension\ext\shared_texture_palette.d extension\ext\stencil_clear_tag.d extension\ext\stencil_two_side.d \
	extension\ext\stencil_wrap.d extension\ext\texture3D.d extension\ext\texture_array.d \
	extension\ext\texture_buffer_object.d extension\ext\texture_compression_dxt1.d \
	extension\ext\texture_compression_latc.d extension\ext\texture_compression_rgtc.d extension\ext\texture_compression_s3tc.d \
	extension\ext\texture_cube_map.d extension\ext\texture_edge_clamp.d extension\ext\texture_env_add.d \
	extension\ext\texture_env_combine.d extension\ext\texture_env_dot3.d extension\ext\texture_filter_anisotropic.d \
	extension\ext\texture_integer.d extension\ext\texture_lod_bias.d extension\ext\texture_mirror_clamp.d \
	extension\ext\texture_perturb_normal.d extension\ext\texture_rectangle.d extension\ext\texture_sRGB.d extension\ext\timer_query.d \
	extension\ext\vertex_shader.d extension\ext\vertex_weighting.d \
	extension\hp\convolution_border_modes.d extension\hp\occlusion_test.d \
	extension\nv\blend_square.d extension\nv\copy_depth_to_color.d extension\nv\depth_buffer_float.d \
	extension\nv\depth_clamp.d extension\nv\evaluators.d extension\nv\fence.d extension\nv\float_buffer.d \
	extension\nv\fog_distance.d extension\nv\fragment_program.d extension\nv\fragment_program2.d extension\nv\fragment_program4.d \
	extension\nv\fragment_program_option.d extension\nv\framebuffer_multisample_coverage.d \
	extension\nv\geometry_program4.d extension\nv\geometry_shader4.d extension\nv\gpu_program4.d \
	extension\nv\half_float.d extension\nv\light_max_exponent.d extension\nv\multisample_filter_hint.d \
	extension\nv\occlusion_query.d extension\nv\packed_depth_stencil.d extension\nv\parameter_buffer_object.d \
	extension\nv\pixel_data_range.d extension\nv\point_sprite.d extension\nv\primitive_restart.d \
	extension\nv\register_combiners.d extension\nv\register_combiners2.d extension\nv\texgen_emboss.d \
	extension\nv\texgen_reflection.d extension\nv\texture_compression_vtc.d extension\nv\texture_env_combine4.d \
	extension\nv\texture_expand_normal.d extension\nv\texture_rectangle.d extension\nv\texture_shader.d \
	extension\nv\texture_shader2.d extension\nv\texture_shader3.d extension\nv\transform_feedback.d \
	extension\nv\vertex_array_range.d extension\nv\vertex_array_range2.d extension\nv\vertex_program.d \
	extension\nv\vertex_program1_1.d extension\nv\vertex_program2.d extension\nv\vertex_program2_option.d \
	extension\nv\vertex_program3.d extension\nv\vertex_program4.d \
	extension\sgi\color_matrix.d \
	extension\sgis\generate_mipmap.d
	
	
DerelictGL.lib : $(SRC)
	$(DMD) -lib -ofDerelictGL.lib  $(SRC) $(DFLAGS)


module rae.gl.GLExtensions;

//debug(logging) 
import tango.util.log.Trace;//Thread safe console output.

import stringz = tango.stdc.stringz;

import tango.sys.SharedLib;//The new way of loading stuff from libs.

public import rae.gl.gl;
public import rae.gl.glu;
public import rae.gl.glext;

version(gtk)
{
//import gtkglc.gl;
//import gtkglc.glu;
import gtkD.glgdk.GLQuery;//For checking opengl extensions.
}

version(glfw)
{
	import glfw.glfw;
}

void loadSym(T)(inout T t, SharedLib lib, char[] name)
{
	debug(OpenGLLoader) Trace.formatln("Trying to load a symbol: {}", name );
	
	try
	{
		t = cast(T)lib.getSymbol(name.ptr);
	}
	catch(Exception e)
	{
		
	}
	//t = cast(T)lib.getSymbolNoThrow(name.ptr);
	if( t !is null )
	{
		//debug(GLExtensions) 
		debug(OpenGLLoader) Trace.formatln("Symbol {} found. Address = 0x{:x}", name, cast(void*)t);
	}
	else
	{
		//debug(GLExtensions) 
		debug(OpenGLLoader) Trace.formatln("Symbol {} not found", name);
	}

}



//These should be defined in gtkglc.glext; or some
//other glext.d.

//GL_ARB_vertex_program
const GL_COLOR_SUM_ARB                  = 0x8458;
const GL_VERTEX_PROGRAM_ARB             = 0x8620;
const GL_VERTEX_ATTRIB_ARRAY_ENABLED_ARB = 0x8622;
const GL_VERTEX_ATTRIB_ARRAY_SIZE_ARB   = 0x8623;
const GL_VERTEX_ATTRIB_ARRAY_STRIDE_ARB = 0x8624;
const GL_VERTEX_ATTRIB_ARRAY_TYPE_ARB   = 0x8625;
const GL_CURRENT_VERTEX_ATTRIB_ARB      = 0x8626;
const GL_PROGRAM_LENGTH_ARB             = 0x8627;
const GL_PROGRAM_STRING_ARB             = 0x8628;
const GL_MAX_PROGRAM_MATRIX_STACK_DEPTH_ARB = 0x862E;
const GL_MAX_PROGRAM_MATRICES_ARB       = 0x862F;
const GL_CURRENT_MATRIX_STACK_DEPTH_ARB = 0x8640;
const GL_CURRENT_MATRIX_ARB             = 0x8641;
const GL_VERTEX_PROGRAM_POINT_SIZE_ARB  = 0x8642;
const GL_VERTEX_PROGRAM_TWO_SIDE_ARB    = 0x8643;
const GL_VERTEX_ATTRIB_ARRAY_POINTER_ARB = 0x8645;
const GL_PROGRAM_ERROR_POSITION_ARB     = 0x864B;
const GL_PROGRAM_BINDING_ARB            = 0x8677;
const GL_MAX_VERTEX_ATTRIBS_ARB         = 0x8869;
const GL_VERTEX_ATTRIB_ARRAY_NORMALIZED_ARB = 0x886A;
const GL_PROGRAM_ERROR_STRING_ARB       = 0x8874;
const GL_PROGRAM_FORMAT_ASCII_ARB       = 0x8875;
const GL_PROGRAM_FORMAT_ARB             = 0x8876;
const GL_PROGRAM_INSTRUCTIONS_ARB       = 0x88A0;
const GL_MAX_PROGRAM_INSTRUCTIONS_ARB   = 0x88A1;
const GL_PROGRAM_NATIVE_INSTRUCTIONS_ARB = 0x88A2;
const GL_MAX_PROGRAM_NATIVE_INSTRUCTIONS_ARB = 0x88A3;
const GL_PROGRAM_TEMPORARIES_ARB        = 0x88A4;
const GL_MAX_PROGRAM_TEMPORARIES_ARB    = 0x88A5;
const GL_PROGRAM_NATIVE_TEMPORARIES_ARB = 0x88A6;
const GL_MAX_PROGRAM_NATIVE_TEMPORARIES_ARB = 0x88A7;
const GL_PROGRAM_PARAMETERS_ARB         = 0x88A8;
const GL_MAX_PROGRAM_PARAMETERS_ARB     = 0x88A9;
const GL_PROGRAM_NATIVE_PARAMETERS_ARB  = 0x88AA;
const GL_MAX_PROGRAM_NATIVE_PARAMETERS_ARB = 0x88AB;
const GL_PROGRAM_ATTRIBS_ARB            = 0x88AC;
const GL_MAX_PROGRAM_ATTRIBS_ARB        = 0x88AD;
const GL_PROGRAM_NATIVE_ATTRIBS_ARB     = 0x88AE;
const GL_MAX_PROGRAM_NATIVE_ATTRIBS_ARB = 0x88AF;
const GL_PROGRAM_ADDRESS_REGISTERS_ARB  = 0x88B0;
const GL_MAX_PROGRAM_ADDRESS_REGISTERS_ARB = 0x88B1;
const GL_PROGRAM_NATIVE_ADDRESS_REGISTERS_ARB = 0x88B2;
const GL_MAX_PROGRAM_NATIVE_ADDRESS_REGISTERS_ARB = 0x88B3;
const GL_MAX_PROGRAM_LOCAL_PARAMETERS_ARB = 0x88B4;
const GL_MAX_PROGRAM_ENV_PARAMETERS_ARB = 0x88B5;
const GL_PROGRAM_UNDER_NATIVE_LIMITS_ARB = 0x88B6;
const GL_TRANSPOSE_CURRENT_MATRIX_ARB   = 0x88B7;
const GL_MATRIX0_ARB                    = 0x88C0;
const GL_MATRIX1_ARB                    = 0x88C1;
const GL_MATRIX2_ARB                    = 0x88C2;
const GL_MATRIX3_ARB                    = 0x88C3;
const GL_MATRIX4_ARB                    = 0x88C4;
const GL_MATRIX5_ARB                    = 0x88C5;
const GL_MATRIX6_ARB                    = 0x88C6;
const GL_MATRIX7_ARB                    = 0x88C7;
const GL_MATRIX8_ARB                    = 0x88C8;
const GL_MATRIX9_ARB                    = 0x88C9;
const GL_MATRIX10_ARB                   = 0x88CA;
const GL_MATRIX11_ARB                   = 0x88CB;
const GL_MATRIX12_ARB                   = 0x88CC;
const GL_MATRIX13_ARB                   = 0x88CD;
const GL_MATRIX14_ARB                   = 0x88CE;
const GL_MATRIX15_ARB                   = 0x88CF;
const GL_MATRIX16_ARB                   = 0x88D0;
const GL_MATRIX17_ARB                   = 0x88D1;
const GL_MATRIX18_ARB                   = 0x88D2;
const GL_MATRIX19_ARB                   = 0x88D3;
const GL_MATRIX20_ARB                   = 0x88D4;
const GL_MATRIX21_ARB                   = 0x88D5;
const GL_MATRIX22_ARB                   = 0x88D6;
const GL_MATRIX23_ARB                   = 0x88D7;
const GL_MATRIX24_ARB                   = 0x88D8;
const GL_MATRIX25_ARB                   = 0x88D9;
const GL_MATRIX26_ARB                   = 0x88DA;
const GL_MATRIX27_ARB                   = 0x88DB;
const GL_MATRIX28_ARB                   = 0x88DC;
const GL_MATRIX29_ARB                   = 0x88DD;
const GL_MATRIX30_ARB                   = 0x88DE;
const GL_MATRIX31_ARB                   = 0x88DF;

//GL_ARB_fragment_program
const GL_FRAGMENT_PROGRAM_ARB           = 0x8804;
const GL_PROGRAM_ALU_INSTRUCTIONS_ARB   = 0x8805;
const GL_PROGRAM_TEX_INSTRUCTIONS_ARB   = 0x8806;
const GL_PROGRAM_TEX_INDIRECTIONS_ARB   = 0x8807;
const GL_PROGRAM_NATIVE_ALU_INSTRUCTIONS_ARB = 0x8808;
const GL_PROGRAM_NATIVE_TEX_INSTRUCTIONS_ARB = 0x8809;
const GL_PROGRAM_NATIVE_TEX_INDIRECTIONS_ARB = 0x880A;
const GL_MAX_PROGRAM_ALU_INSTRUCTIONS_ARB = 0x880B;
const GL_MAX_PROGRAM_TEX_INSTRUCTIONS_ARB = 0x880C;
const GL_MAX_PROGRAM_TEX_INDIRECTIONS_ARB = 0x880D;
const GL_MAX_PROGRAM_NATIVE_ALU_INSTRUCTIONS_ARB = 0x880E;
const GL_MAX_PROGRAM_NATIVE_TEX_INSTRUCTIONS_ARB = 0x880F;
const GL_MAX_PROGRAM_NATIVE_TEX_INDIRECTIONS_ARB = 0x8810;
const GL_MAX_TEXTURE_COORDS_ARB         = 0x8871;
const GL_MAX_TEXTURE_IMAGE_UNITS_ARB    = 0x8872;


//GL_ARB_texture_rectangle
const GL_TEXTURE_RECTANGLE_ARB =        0x84F5;
const GL_TEXTURE_BINDING_RECTANGLE_ARB= 0x84F6;
const GL_PROXY_TEXTURE_RECTANGLE_ARB =  0x84F7;
const GL_MAX_RECTANGLE_TEXTURE_SIZE_ARB=0x84F8;


//GL_EXT_framebuffer_object
const GL_INVALID_FRAMEBUFFER_OPERATION_EXT = 0x0506;
const GL_MAX_RENDERBUFFER_SIZE_EXT =      0x84E8;
const GL_FRAMEBUFFER_BINDING_EXT =        0x8CA6;
const GL_RENDERBUFFER_BINDING_EXT =       0x8CA7;
const GL_FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE_EXT = 0x8CD0;
const GL_FRAMEBUFFER_ATTACHMENT_OBJECT_NAME_EXT = 0x8CD1;
const GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL_EXT = 0x8CD2;
const GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE_EXT = 0x8CD3;
const GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_3D_ZOFFSET_EXT = 0x8CD4;
const GL_FRAMEBUFFER_COMPLETE_EXT =       0x8CD5;
const GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT_EXT = 0x8CD6;
const GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT_EXT = 0x8CD7;
const GL_FRAMEBUFFER_INCOMPLETE_DUPLICATE_ATTACHMENT_EXT = 0x8CD8;
const GL_FRAMEBUFFER_INCOMPLETE_DIMENSIONS_EXT = 0x8CD9;
const GL_FRAMEBUFFER_INCOMPLETE_FORMATS_EXT = 0x8CDA;
const GL_FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER_EXT = 0x8CDB;
const GL_FRAMEBUFFER_INCOMPLETE_READ_BUFFER_EXT = 0x8CDC;
const GL_FRAMEBUFFER_UNSUPPORTED_EXT =    0x8CDD;
const GL_MAX_COLOR_ATTACHMENTS_EXT =      0x8CDF;
const GL_COLOR_ATTACHMENT0_EXT =          0x8CE0;
const GL_COLOR_ATTACHMENT1_EXT =          0x8CE1;
const GL_COLOR_ATTACHMENT2_EXT =          0x8CE2;
const GL_COLOR_ATTACHMENT3_EXT =          0x8CE3;
const GL_COLOR_ATTACHMENT4_EXT =          0x8CE4;
const GL_COLOR_ATTACHMENT5_EXT =          0x8CE5;
const GL_COLOR_ATTACHMENT6_EXT =          0x8CE6;
const GL_COLOR_ATTACHMENT7_EXT =          0x8CE7;
const GL_COLOR_ATTACHMENT8_EXT =          0x8CE8;
const GL_COLOR_ATTACHMENT9_EXT =          0x8CE9;
const GL_COLOR_ATTACHMENT10_EXT =         0x8CEA;
const GL_COLOR_ATTACHMENT11_EXT =         0x8CEB;
const GL_COLOR_ATTACHMENT12_EXT =         0x8CEC;
const GL_COLOR_ATTACHMENT13_EXT =         0x8CED;
const GL_COLOR_ATTACHMENT14_EXT =         0x8CEE;
const GL_COLOR_ATTACHMENT15_EXT =         0x8CEF;
const GL_DEPTH_ATTACHMENT_EXT =           0x8D00;
const GL_STENCIL_ATTACHMENT_EXT =         0x8D20;
const GL_FRAMEBUFFER_EXT =                0x8D40;
const GL_RENDERBUFFER_EXT =               0x8D41;
const GL_RENDERBUFFER_WIDTH_EXT =         0x8D42;
const GL_RENDERBUFFER_HEIGHT_EXT =        0x8D43;
const GL_RENDERBUFFER_INTERNAL_FORMAT_EXT = 0x8D44;
const GL_STENCIL_INDEX1_EXT =             0x8D46;
const GL_STENCIL_INDEX4_EXT =             0x8D47;
const GL_STENCIL_INDEX8_EXT =             0x8D48;
const GL_STENCIL_INDEX16_EXT =            0x8D49;
const GL_RENDERBUFFER_RED_SIZE_EXT =      0x8D50;
const GL_RENDERBUFFER_GREEN_SIZE_EXT =    0x8D51;
const GL_RENDERBUFFER_BLUE_SIZE_EXT =     0x8D52;
const GL_RENDERBUFFER_ALPHA_SIZE_EXT =    0x8D53;
const GL_RENDERBUFFER_DEPTH_SIZE_EXT =    0x8D54;
const GL_RENDERBUFFER_STENCIL_SIZE_EXT =  0x8D55;


//GL_EXT_texture_filter_anisotropic
const GL_TEXTURE_MAX_ANISOTROPY_EXT =     0x84FE;
const GL_MAX_TEXTURE_MAX_ANISOTROPY_EXT = 0x84FF;

//


//GL_VERSION_2_0

//C     #define GL_BLEND_EQUATION_RGB             GL_BLEND_EQUATION
//C     #define GL_VERTEX_ATTRIB_ARRAY_ENABLED    0x8622
alias GL_BLEND_EQUATION GL_BLEND_EQUATION_RGB;
//C     #define GL_VERTEX_ATTRIB_ARRAY_SIZE       0x8623
const GL_VERTEX_ATTRIB_ARRAY_ENABLED = 0x8622;
//C     #define GL_VERTEX_ATTRIB_ARRAY_STRIDE     0x8624
const GL_VERTEX_ATTRIB_ARRAY_SIZE = 0x8623;
//C     #define GL_VERTEX_ATTRIB_ARRAY_TYPE       0x8625
const GL_VERTEX_ATTRIB_ARRAY_STRIDE = 0x8624;
//C     #define GL_CURRENT_VERTEX_ATTRIB          0x8626
const GL_VERTEX_ATTRIB_ARRAY_TYPE = 0x8625;
//C     #define GL_VERTEX_PROGRAM_POINT_SIZE      0x8642
const GL_CURRENT_VERTEX_ATTRIB = 0x8626;
//C     #define GL_VERTEX_PROGRAM_TWO_SIDE        0x8643
const GL_VERTEX_PROGRAM_POINT_SIZE = 0x8642;
//C     #define GL_VERTEX_ATTRIB_ARRAY_POINTER    0x8645
const GL_VERTEX_PROGRAM_TWO_SIDE = 0x8643;
//C     #define GL_STENCIL_BACK_FUNC              0x8800
const GL_VERTEX_ATTRIB_ARRAY_POINTER = 0x8645;
//C     #define GL_STENCIL_BACK_FAIL              0x8801
const GL_STENCIL_BACK_FUNC = 0x8800;
//C     #define GL_STENCIL_BACK_PASS_DEPTH_FAIL   0x8802
const GL_STENCIL_BACK_FAIL = 0x8801;
//C     #define GL_STENCIL_BACK_PASS_DEPTH_PASS   0x8803
const GL_STENCIL_BACK_PASS_DEPTH_FAIL = 0x8802;
//C     #define GL_MAX_DRAW_BUFFERS               0x8824
const GL_STENCIL_BACK_PASS_DEPTH_PASS = 0x8803;
//C     #define GL_DRAW_BUFFER0                   0x8825
const GL_MAX_DRAW_BUFFERS = 0x8824;
//C     #define GL_DRAW_BUFFER1                   0x8826
const GL_DRAW_BUFFER0 = 0x8825;
//C     #define GL_DRAW_BUFFER2                   0x8827
const GL_DRAW_BUFFER1 = 0x8826;
//C     #define GL_DRAW_BUFFER3                   0x8828
const GL_DRAW_BUFFER2 = 0x8827;
//C     #define GL_DRAW_BUFFER4                   0x8829
const GL_DRAW_BUFFER3 = 0x8828;
//C     #define GL_DRAW_BUFFER5                   0x882A
const GL_DRAW_BUFFER4 = 0x8829;
//C     #define GL_DRAW_BUFFER6                   0x882B
const GL_DRAW_BUFFER5 = 0x882A;
//C     #define GL_DRAW_BUFFER7                   0x882C
const GL_DRAW_BUFFER6 = 0x882B;
//C     #define GL_DRAW_BUFFER8                   0x882D
const GL_DRAW_BUFFER7 = 0x882C;
//C     #define GL_DRAW_BUFFER9                   0x882E
const GL_DRAW_BUFFER8 = 0x882D;
//C     #define GL_DRAW_BUFFER10                  0x882F
const GL_DRAW_BUFFER9 = 0x882E;
//C     #define GL_DRAW_BUFFER11                  0x8830
const GL_DRAW_BUFFER10 = 0x882F;
//C     #define GL_DRAW_BUFFER12                  0x8831
const GL_DRAW_BUFFER11 = 0x8830;
//C     #define GL_DRAW_BUFFER13                  0x8832
const GL_DRAW_BUFFER12 = 0x8831;
//C     #define GL_DRAW_BUFFER14                  0x8833
const GL_DRAW_BUFFER13 = 0x8832;
//C     #define GL_DRAW_BUFFER15                  0x8834
const GL_DRAW_BUFFER14 = 0x8833;
//C     #define GL_BLEND_EQUATION_ALPHA           0x883D
const GL_DRAW_BUFFER15 = 0x8834;
//C     #define GL_POINT_SPRITE                   0x8861
const GL_BLEND_EQUATION_ALPHA = 0x883D;
//C     #define GL_COORD_REPLACE                  0x8862
const GL_POINT_SPRITE = 0x8861;
//C     #define GL_MAX_VERTEX_ATTRIBS             0x8869
const GL_COORD_REPLACE = 0x8862;
//C     #define GL_VERTEX_ATTRIB_ARRAY_NORMALIZED 0x886A
const GL_MAX_VERTEX_ATTRIBS = 0x8869;
//C     #define GL_MAX_TEXTURE_COORDS             0x8871
const GL_VERTEX_ATTRIB_ARRAY_NORMALIZED = 0x886A;
//C     #define GL_MAX_TEXTURE_IMAGE_UNITS        0x8872
const GL_MAX_TEXTURE_COORDS = 0x8871;
//C     #define GL_FRAGMENT_SHADER                0x8B30
const GL_MAX_TEXTURE_IMAGE_UNITS = 0x8872;
//C     #define GL_VERTEX_SHADER                  0x8B31
const GL_FRAGMENT_SHADER = 0x8B30;
//C     #define GL_MAX_FRAGMENT_UNIFORM_COMPONENTS 0x8B49
const GL_VERTEX_SHADER = 0x8B31;
//C     #define GL_MAX_VERTEX_UNIFORM_COMPONENTS  0x8B4A
const GL_MAX_FRAGMENT_UNIFORM_COMPONENTS = 0x8B49;
//C     #define GL_MAX_VARYING_FLOATS             0x8B4B
const GL_MAX_VERTEX_UNIFORM_COMPONENTS = 0x8B4A;
//C     #define GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS 0x8B4C
const GL_MAX_VARYING_FLOATS = 0x8B4B;
//C     #define GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS 0x8B4D
const GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS = 0x8B4C;
//C     #define GL_SHADER_TYPE                    0x8B4F
const GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS = 0x8B4D;
//C     #define GL_FLOAT_VEC2                     0x8B50
const GL_SHADER_TYPE = 0x8B4F;
//C     #define GL_FLOAT_VEC3                     0x8B51
const GL_FLOAT_VEC2 = 0x8B50;
//C     #define GL_FLOAT_VEC4                     0x8B52
const GL_FLOAT_VEC3 = 0x8B51;
//C     #define GL_INT_VEC2                       0x8B53
const GL_FLOAT_VEC4 = 0x8B52;
//C     #define GL_INT_VEC3                       0x8B54
const GL_INT_VEC2 = 0x8B53;
//C     #define GL_INT_VEC4                       0x8B55
const GL_INT_VEC3 = 0x8B54;
//C     #define GL_BOOL                           0x8B56
const GL_INT_VEC4 = 0x8B55;
//C     #define GL_BOOL_VEC2                      0x8B57
const GL_BOOL = 0x8B56;
//C     #define GL_BOOL_VEC3                      0x8B58
const GL_BOOL_VEC2 = 0x8B57;
//C     #define GL_BOOL_VEC4                      0x8B59
const GL_BOOL_VEC3 = 0x8B58;
//C     #define GL_FLOAT_MAT2                     0x8B5A
const GL_BOOL_VEC4 = 0x8B59;
//C     #define GL_FLOAT_MAT3                     0x8B5B
const GL_FLOAT_MAT2 = 0x8B5A;
//C     #define GL_FLOAT_MAT4                     0x8B5C
const GL_FLOAT_MAT3 = 0x8B5B;
//C     #define GL_SAMPLER_1D                     0x8B5D
const GL_FLOAT_MAT4 = 0x8B5C;
//C     #define GL_SAMPLER_2D                     0x8B5E
const GL_SAMPLER_1D = 0x8B5D;
//C     #define GL_SAMPLER_3D                     0x8B5F
const GL_SAMPLER_2D = 0x8B5E;
//C     #define GL_SAMPLER_CUBE                   0x8B60
const GL_SAMPLER_3D = 0x8B5F;
//C     #define GL_SAMPLER_1D_SHADOW              0x8B61
const GL_SAMPLER_CUBE = 0x8B60;
//C     #define GL_SAMPLER_2D_SHADOW              0x8B62
const GL_SAMPLER_1D_SHADOW = 0x8B61;
//C     #define GL_DELETE_STATUS                  0x8B80
const GL_SAMPLER_2D_SHADOW = 0x8B62;
//C     #define GL_COMPILE_STATUS                 0x8B81
const GL_DELETE_STATUS = 0x8B80;
//C     #define GL_LINK_STATUS                    0x8B82
const GL_COMPILE_STATUS = 0x8B81;
//C     #define GL_VALIDATE_STATUS                0x8B83
const GL_LINK_STATUS = 0x8B82;
//C     #define GL_INFO_LOG_LENGTH                0x8B84
const GL_VALIDATE_STATUS = 0x8B83;
//C     #define GL_ATTACHED_SHADERS               0x8B85
const GL_INFO_LOG_LENGTH = 0x8B84;
//C     #define GL_ACTIVE_UNIFORMS                0x8B86
const GL_ATTACHED_SHADERS = 0x8B85;
//C     #define GL_ACTIVE_UNIFORM_MAX_LENGTH      0x8B87
const GL_ACTIVE_UNIFORMS = 0x8B86;
//C     #define GL_SHADER_SOURCE_LENGTH           0x8B88
const GL_ACTIVE_UNIFORM_MAX_LENGTH = 0x8B87;
//C     #define GL_ACTIVE_ATTRIBUTES              0x8B89
const GL_SHADER_SOURCE_LENGTH = 0x8B88;
//C     #define GL_ACTIVE_ATTRIBUTE_MAX_LENGTH    0x8B8A
const GL_ACTIVE_ATTRIBUTES = 0x8B89;
//C     #define GL_FRAGMENT_SHADER_DERIVATIVE_HINT 0x8B8B
const GL_ACTIVE_ATTRIBUTE_MAX_LENGTH = 0x8B8A;
//C     #define GL_SHADING_LANGUAGE_VERSION       0x8B8C
const GL_FRAGMENT_SHADER_DERIVATIVE_HINT = 0x8B8B;
//C     #define GL_CURRENT_PROGRAM                0x8B8D
const GL_SHADING_LANGUAGE_VERSION = 0x8B8C;
//C     #define GL_POINT_SPRITE_COORD_ORIGIN      0x8CA0
const GL_CURRENT_PROGRAM = 0x8B8D;
//C     #define GL_LOWER_LEFT                     0x8CA1
const GL_POINT_SPRITE_COORD_ORIGIN = 0x8CA0;
//C     #define GL_UPPER_LEFT                     0x8CA2
const GL_LOWER_LEFT = 0x8CA1;
//C     #define GL_STENCIL_BACK_REF               0x8CA3
const GL_UPPER_LEFT = 0x8CA2;
//C     #define GL_STENCIL_BACK_VALUE_MASK        0x8CA4
const GL_STENCIL_BACK_REF = 0x8CA3;
//C     #define GL_STENCIL_BACK_WRITEMASK         0x8CA5
const GL_STENCIL_BACK_VALUE_MASK = 0x8CA4;

const GL_STENCIL_BACK_WRITEMASK = 0x8CA5;


// GL_VERSION_2_1

//C     #define GL_CURRENT_RASTER_SECONDARY_COLOR 0x845F
//C     #define GL_PIXEL_PACK_BUFFER              0x88EB
const GL_CURRENT_RASTER_SECONDARY_COLOR = 0x845F;
//C     #define GL_PIXEL_UNPACK_BUFFER            0x88EC
const GL_PIXEL_PACK_BUFFER = 0x88EB;
//C     #define GL_PIXEL_PACK_BUFFER_BINDING      0x88ED
const GL_PIXEL_UNPACK_BUFFER = 0x88EC;
//C     #define GL_PIXEL_UNPACK_BUFFER_BINDING    0x88EF
const GL_PIXEL_PACK_BUFFER_BINDING = 0x88ED;
//C     #define GL_FLOAT_MAT2x3                   0x8B65
const GL_PIXEL_UNPACK_BUFFER_BINDING = 0x88EF;
//C     #define GL_FLOAT_MAT2x4                   0x8B66
const GL_FLOAT_MAT2x3 = 0x8B65;
//C     #define GL_FLOAT_MAT3x2                   0x8B67
const GL_FLOAT_MAT2x4 = 0x8B66;
//C     #define GL_FLOAT_MAT3x4                   0x8B68
const GL_FLOAT_MAT3x2 = 0x8B67;
//C     #define GL_FLOAT_MAT4x2                   0x8B69
const GL_FLOAT_MAT3x4 = 0x8B68;
//C     #define GL_FLOAT_MAT4x3                   0x8B6A
const GL_FLOAT_MAT4x2 = 0x8B69;
//C     #define GL_SRGB                           0x8C40
const GL_FLOAT_MAT4x3 = 0x8B6A;
//C     #define GL_SRGB8                          0x8C41
const GL_SRGB = 0x8C40;
//C     #define GL_SRGB_ALPHA                     0x8C42
const GL_SRGB8 = 0x8C41;
//C     #define GL_SRGB8_ALPHA8                   0x8C43
const GL_SRGB_ALPHA = 0x8C42;
//C     #define GL_SLUMINANCE_ALPHA               0x8C44
const GL_SRGB8_ALPHA8 = 0x8C43;
//C     #define GL_SLUMINANCE8_ALPHA8             0x8C45
const GL_SLUMINANCE_ALPHA = 0x8C44;
//C     #define GL_SLUMINANCE                     0x8C46
const GL_SLUMINANCE8_ALPHA8 = 0x8C45;
//C     #define GL_SLUMINANCE8                    0x8C47
const GL_SLUMINANCE = 0x8C46;
//C     #define GL_COMPRESSED_SRGB                0x8C48
const GL_SLUMINANCE8 = 0x8C47;
//C     #define GL_COMPRESSED_SRGB_ALPHA          0x8C49
const GL_COMPRESSED_SRGB = 0x8C48;
//C     #define GL_COMPRESSED_SLUMINANCE          0x8C4A
const GL_COMPRESSED_SRGB_ALPHA = 0x8C49;
//C     #define GL_COMPRESSED_SLUMINANCE_ALPHA    0x8C4B
const GL_COMPRESSED_SLUMINANCE = 0x8C4A;

const GL_COMPRESSED_SLUMINANCE_ALPHA = 0x8C4B;


// 23 - GL_EXT_packed_pixels
const GLuint GL_UNSIGNED_BYTE_3_3_2_EXT			= 0x8032;
const GLuint GL_UNSIGNED_SHORT_4_4_4_4_EXT		= 0x8033;
const GLuint GL_UNSIGNED_SHORT_5_5_5_1_EXT		= 0x8034;
const GLuint GL_UNSIGNED_INT_8_8_8_8_EXT		= 0x8035;
const GLuint GL_UNSIGNED_INT_10_10_10_2_EXT		= 0x8036;

// 4 - GL_EXT_texture
const GLuint GL_ALPHA4_EXT				= 0x803B;
const GLuint GL_ALPHA8_EXT				= 0x803C;
const GLuint GL_ALPHA12_EXT				= 0x803D;
const GLuint GL_ALPHA16_EXT				= 0x803E;
const GLuint GL_LUMINANCE4_EXT				= 0x803F;
const GLuint GL_LUMINANCE8_EXT				= 0x8040;
const GLuint GL_LUMINANCE12_EXT				= 0x8041;
const GLuint GL_LUMINANCE16_EXT				= 0x8042;
const GLuint GL_LUMINANCE4_ALPHA4_EXT			= 0x8043;
const GLuint GL_LUMINANCE6_ALPHA2_EXT			= 0x8044;
const GLuint GL_LUMINANCE8_ALPHA8_EXT			= 0x8045;
const GLuint GL_LUMINANCE12_ALPHA4_EXT			= 0x8046;
const GLuint GL_LUMINANCE12_ALPHA12_EXT			= 0x8047;
const GLuint GL_LUMINANCE16_ALPHA16_EXT			= 0x8048;
const GLuint GL_INTENSITY_EXT				= 0x8049;
const GLuint GL_INTENSITY4_EXT				= 0x804A;
const GLuint GL_INTENSITY8_EXT				= 0x804B;
const GLuint GL_INTENSITY12_EXT				= 0x804C;
const GLuint GL_INTENSITY16_EXT				= 0x804D;
const GLuint GL_RGB2_EXT				= 0x804E;
const GLuint GL_RGB4_EXT				= 0x804F;
const GLuint GL_RGB5_EXT				= 0x8050;
const GLuint GL_RGB8_EXT				= 0x8051;
const GLuint GL_RGB10_EXT				= 0x8052;
const GLuint GL_RGB12_EXT				= 0x8053;
const GLuint GL_RGB16_EXT				= 0x8054;
const GLuint GL_RGBA2_EXT				= 0x8055;
const GLuint GL_RGBA4_EXT				= 0x8056;
const GLuint GL_RGB5_A1_EXT				= 0x8057;
const GLuint GL_RGBA8_EXT				= 0x8058;
const GLuint GL_RGB10_A2_EXT				= 0x8059;
const GLuint GL_RGBA12_EXT				= 0x805A;
const GLuint GL_RGBA16_EXT				= 0x805B;
const GLuint GL_TEXTURE_RED_SIZE_EXT			= 0x805C;
const GLuint GL_TEXTURE_GREEN_SIZE_EXT			= 0x805D;
const GLuint GL_TEXTURE_BLUE_SIZE_EXT			= 0x805E;
const GLuint GL_TEXTURE_ALPHA_SIZE_EXT			= 0x805F;
const GLuint GL_TEXTURE_LUMINANCE_SIZE_EXT		= 0x8060;
const GLuint GL_TEXTURE_INTENSITY_SIZE_EXT		= 0x8061;
const GLuint GL_REPLACE_EXT				= 0x8062;
const GLuint GL_PROXY_TEXTURE_1D_EXT			= 0x8063;
const GLuint GL_PROXY_TEXTURE_2D_EXT			= 0x8064;
const GLuint GL_TEXTURE_TOO_LARGE_EXT			= 0x8065;

/*
 * Non-ARB Extensions
 */
// 1 - GL_EXT_abgr
const GLuint GL_ABGR_EXT				= 0x8000;

// 129 - GL_EXT_bgra
const GLuint GL_BGR_EXT					= 0x80E0;
const GLuint GL_BGRA_EXT				= 0x80E1;

//


public
{

//Function prototypes from GL_ARB_vertex_program and GL_ARB_fragment_program:
typedef extern(C) void function (GLuint, GLdouble) glVertexAttrib1dARBFunc;
glVertexAttrib1dARBFunc glVertexAttrib1dARB;
typedef extern(C) void function (GLuint, GLdouble *) glVertexAttrib1dvARBFunc;
glVertexAttrib1dvARBFunc glVertexAttrib1dvARB;
typedef extern(C) void function (GLuint, GLfloat) glVertexAttrib1fARBFunc;
glVertexAttrib1fARBFunc glVertexAttrib1fARB;
typedef extern(C) void function (GLuint, GLfloat *) glVertexAttrib1fvARBFunc;
glVertexAttrib1fvARBFunc glVertexAttrib1fvARB;
typedef extern(C) void function (GLuint, GLshort) glVertexAttrib1sARBFunc;
glVertexAttrib1sARBFunc glVertexAttrib1sARB;
typedef extern(C) void function (GLuint, GLshort *) glVertexAttrib1svARBFunc;
glVertexAttrib1svARBFunc glVertexAttrib1svARB;
typedef extern(C) void function (GLuint, GLdouble, GLdouble) glVertexAttrib2dARBFunc;
glVertexAttrib2dARBFunc glVertexAttrib2dARB;
typedef extern(C) void function (GLuint, GLdouble *) glVertexAttrib2dvARBFunc;
glVertexAttrib2dvARBFunc glVertexAttrib2dvARB;
typedef extern(C) void function (GLuint, GLfloat, GLfloat) glVertexAttrib2fARBFunc;
glVertexAttrib2fARBFunc glVertexAttrib2fARB;
typedef extern(C) void function (GLuint, GLfloat *) glVertexAttrib2fvARBFunc;
glVertexAttrib2fvARBFunc glVertexAttrib2fvARB;
typedef extern(C) void function (GLuint, GLshort, GLshort) glVertexAttrib2sARBFunc;
glVertexAttrib2sARBFunc glVertexAttrib2sARB;
typedef extern(C) void function (GLuint, GLshort *) glVertexAttrib2svARBFunc;
glVertexAttrib2svARBFunc glVertexAttrib2svARB;
typedef extern(C) void function (GLuint, GLdouble, GLdouble, GLdouble) glVertexAttrib3dARBFunc;
glVertexAttrib3dARBFunc glVertexAttrib3dARB;
typedef extern(C) void function (GLuint, GLdouble *) glVertexAttrib3dvARBFunc;
glVertexAttrib3dvARBFunc glVertexAttrib3dvARB;
typedef extern(C) void function (GLuint, GLfloat, GLfloat, GLfloat) glVertexAttrib3fARBFunc;
glVertexAttrib3fARBFunc glVertexAttrib3fARB;
typedef extern(C) void function (GLuint, GLfloat *) glVertexAttrib3fvARBFunc;
glVertexAttrib3fvARBFunc glVertexAttrib3fvARB;
typedef extern(C) void function (GLuint, GLshort, GLshort, GLshort) glVertexAttrib3sARBFunc;
glVertexAttrib3sARBFunc glVertexAttrib3sARB;
typedef extern(C) void function (GLuint, GLshort *) glVertexAttrib3svARBFunc;
glVertexAttrib3svARBFunc glVertexAttrib3svARB;
typedef extern(C) void function (GLuint, GLbyte *) glVertexAttrib4NbvARBFunc;
glVertexAttrib4NbvARBFunc glVertexAttrib4NbvARB;
typedef extern(C) void function (GLuint, GLint *) glVertexAttrib4NivARBFunc;
glVertexAttrib4NivARBFunc glVertexAttrib4NivARB;
typedef extern(C) void function (GLuint, GLshort *) glVertexAttrib4NsvARBFunc;
glVertexAttrib4NsvARBFunc glVertexAttrib4NsvARB;
typedef extern(C) void function (GLuint, GLubyte, GLubyte, GLubyte, GLubyte) glVertexAttrib4NubARBFunc;
glVertexAttrib4NubARBFunc glVertexAttrib4NubARB;
typedef extern(C) void function (GLuint, GLubyte *) glVertexAttrib4NubvARBFunc;
glVertexAttrib4NubvARBFunc glVertexAttrib4NubvARB;
typedef extern(C) void function (GLuint, GLuint *) glVertexAttrib4NuivARBFunc;
glVertexAttrib4NuivARBFunc glVertexAttrib4NuivARB;
typedef extern(C) void function (GLuint, GLushort *) glVertexAttrib4NusvARBFunc;
glVertexAttrib4NusvARBFunc glVertexAttrib4NusvARB;
typedef extern(C) void function (GLuint, GLbyte *) glVertexAttrib4bvARBFunc;
glVertexAttrib4bvARBFunc glVertexAttrib4bvARB;
typedef extern(C) void function (GLuint, GLdouble, GLdouble, GLdouble, GLdouble) glVertexAttrib4dARBFunc;
glVertexAttrib4dARBFunc glVertexAttrib4dARB;
typedef extern(C) void function (GLuint, GLdouble *) glVertexAttrib4dvARBFunc;
glVertexAttrib4dvARBFunc glVertexAttrib4dvARB;
typedef extern(C) void function (GLuint, GLfloat, GLfloat, GLfloat, GLfloat) glVertexAttrib4fARBFunc;
glVertexAttrib4fARBFunc glVertexAttrib4fARB;
typedef extern(C) void function (GLuint, GLfloat *) glVertexAttrib4fvARBFunc;
glVertexAttrib4fvARBFunc glVertexAttrib4fvARB;
typedef extern(C) void function (GLuint, GLint *) glVertexAttrib4ivARBFunc;
glVertexAttrib4ivARBFunc glVertexAttrib4ivARB;
typedef extern(C) void function (GLuint, GLshort, GLshort, GLshort, GLshort) glVertexAttrib4sARBFunc;
glVertexAttrib4sARBFunc glVertexAttrib4sARB;
typedef extern(C) void function (GLuint, GLshort *) glVertexAttrib4svARBFunc;
glVertexAttrib4svARBFunc glVertexAttrib4svARB;
typedef extern(C) void function (GLuint, GLubyte *) glVertexAttrib4ubvARBFunc;
glVertexAttrib4ubvARBFunc glVertexAttrib4ubvARB;
typedef extern(C) void function (GLuint, GLuint *) glVertexAttrib4uivARBFunc;
glVertexAttrib4uivARBFunc glVertexAttrib4uivARB;
typedef extern(C) void function (GLuint, GLushort *) glVertexAttrib4usvARBFunc;
glVertexAttrib4usvARBFunc glVertexAttrib4usvARB;
typedef extern(C) void function (GLuint, GLint, GLenum, GLboolean, GLsizei, GLvoid *) glVertexAttribPointerARBFunc;
glVertexAttribPointerARBFunc glVertexAttribPointerARB;
typedef extern(C) void function (GLuint) glEnableVertexAttribArrayARBFunc;
glEnableVertexAttribArrayARBFunc glEnableVertexAttribArrayARB;
typedef extern(C) void function (GLuint) glDisableVertexAttribArrayARBFunc;
glDisableVertexAttribArrayARBFunc glDisableVertexAttribArrayARB;
typedef extern(C) void function (GLenum, GLenum, GLsizei, GLvoid *) glProgramStringARBFunc;
glProgramStringARBFunc glProgramStringARB;
typedef extern(C) void function (GLenum, GLuint) glBindProgramARBFunc;
glBindProgramARBFunc glBindProgramARB;
typedef extern(C) void function (GLsizei, GLuint *) glDeleteProgramsARBFunc;
glDeleteProgramsARBFunc glDeleteProgramsARB;
typedef extern(C) void function (GLsizei, GLuint *) glGenProgramsARBFunc;
glGenProgramsARBFunc glGenProgramsARB;
typedef extern(C) void function (GLenum, GLuint, GLdouble, GLdouble, GLdouble, GLdouble) glProgramEnvParameter4dARBFunc;
glProgramEnvParameter4dARBFunc glProgramEnvParameter4dARB;
typedef extern(C) void function (GLenum, GLuint, GLdouble *) glProgramEnvParameter4dvARBFunc;
glProgramEnvParameter4dvARBFunc glProgramEnvParameter4dvARB;
typedef extern(C) void function (GLenum, GLuint, GLfloat, GLfloat, GLfloat, GLfloat) glProgramEnvParameter4fARBFunc;
glProgramEnvParameter4fARBFunc glProgramEnvParameter4fARB;
typedef extern(C) void function (GLenum, GLuint, GLfloat *) glProgramEnvParameter4fvARBFunc;
glProgramEnvParameter4fvARBFunc glProgramEnvParameter4fvARB;
typedef extern(C) void function (GLenum, GLuint, GLdouble, GLdouble, GLdouble, GLdouble) glProgramLocalParameter4dARBFunc;
glProgramLocalParameter4dARBFunc glProgramLocalParameter4dARB;
typedef extern(C) void function (GLenum, GLuint, GLdouble *) glProgramLocalParameter4dvARBFunc;
glProgramLocalParameter4dvARBFunc glProgramLocalParameter4dvARB;
typedef extern(C) void function (GLenum, GLuint, GLfloat, GLfloat, GLfloat, GLfloat) glProgramLocalParameter4fARBFunc;
glProgramLocalParameter4fARBFunc glProgramLocalParameter4fARB;
typedef extern(C) void function (GLenum, GLuint, GLfloat *) glProgramLocalParameter4fvARBFunc;
glProgramLocalParameter4fvARBFunc glProgramLocalParameter4fvARB;
typedef extern(C) void function (GLenum, GLuint, GLdouble *) glGetProgramEnvParameterdvARBFunc;
glGetProgramEnvParameterdvARBFunc glGetProgramEnvParameterdvARB;
typedef extern(C) void function (GLenum, GLuint, GLfloat *) glGetProgramEnvParameterfvARBFunc;
glGetProgramEnvParameterfvARBFunc glGetProgramEnvParameterfvARB;
typedef extern(C) void function (GLenum, GLuint, GLdouble *) glGetProgramLocalParameterdvARBFunc;
glGetProgramLocalParameterdvARBFunc glGetProgramLocalParameterdvARB;
typedef extern(C) void function (GLenum, GLuint, GLfloat *) glGetProgramLocalParameterfvARBFunc;
glGetProgramLocalParameterfvARBFunc glGetProgramLocalParameterfvARB;
typedef extern(C) void function (GLenum, GLenum, GLint *) glGetProgramivARBFunc;
glGetProgramivARBFunc glGetProgramivARB;
typedef extern(C) void function (GLenum, GLenum, GLvoid *) glGetProgramStringARBFunc;
glGetProgramStringARBFunc glGetProgramStringARB;
typedef extern(C) void function (GLuint, GLenum, GLdouble *) glGetVertexAttribdvARBFunc;
glGetVertexAttribdvARBFunc glGetVertexAttribdvARB;
typedef extern(C) void function (GLuint, GLenum, GLfloat *) glGetVertexAttribfvARBFunc;
glGetVertexAttribfvARBFunc glGetVertexAttribfvARB;
typedef extern(C) void function (GLuint, GLenum, GLint *) glGetVertexAttribivARBFunc;
glGetVertexAttribivARBFunc glGetVertexAttribivARB;
typedef extern(C) void function (GLuint, GLenum, GLvoid* *) glGetVertexAttribPointervARBFunc;
glGetVertexAttribPointervARBFunc glGetVertexAttribPointervARB;
typedef extern(C) GLboolean function (GLuint) glIsProgramARBFunc;
glIsProgramARBFunc glIsProgramARB;


//Function prototypes from GL_EXT_framebuffer_object:

//GLboolean glIsRenderbufferEXT(GLuint renderbuffer);
typedef extern(C) GLboolean function (GLuint) glIsRenderbufferEXTFunc;
glIsRenderbufferEXTFunc glIsRenderbufferEXT;

//void glBindRenderbufferEXT(GLenum target, GLuint renderbuffer);
typedef extern(C) void function (GLenum, GLuint) glBindRenderbufferEXTFunc;
glBindRenderbufferEXTFunc glBindRenderbufferEXT;

//void glDeleteRenderbuffersEXT(GLsizei n, const GLuint *renderbuffers);
typedef extern(C) void function (GLsizei, GLuint*) glDeleteRenderbuffersEXTFunc;
glDeleteRenderbuffersEXTFunc glDeleteRenderbuffersEXT;

//void glGenRenderbuffersEXT(sizei n, uint *framebuffers);
typedef extern(C) void function (GLsizei, GLuint*) glGenRenderbuffersEXTFunc;
glGenRenderbuffersEXTFunc glGenRenderbuffersEXT;

//void glRenderbufferStorageEXT(GLenum target, GLenum internalformat,
//																GLsizei width, GLsizei height);
typedef extern(C) void function (GLenum, GLenum, GLsizei, GLsizei) glRenderbufferStorageEXTFunc;
glRenderbufferStorageEXTFunc glRenderbufferStorageEXT;

//void glGetRenderbufferParameterivEXT(GLenum target, GLenum pname, GLint *params);
//TODO

//GLboolean glIsFramebufferEXT(GLuint framebuffer);
typedef extern(C) GLboolean function (GLuint) glIsFramebufferEXTFunc;
glIsFramebufferEXTFunc glIsFramebufferEXT;

//void glBindFramebufferEXT(GLenum target, GLuint framebuffer);
typedef extern(C) void function (GLenum, GLuint) glBindFramebufferEXTFunc;
glBindFramebufferEXTFunc glBindFramebufferEXT;
	
//void glDeleteFramebuffersEXT(GLsizei n, const GLuint *framebuffers);
typedef extern(C) void function (GLsizei, GLuint*) glDeleteFramebuffersEXTFunc;
glDeleteFramebuffersEXTFunc glDeleteFramebuffersEXT;

//void glGenFramebuffersEXT(GLsizei n, GLuint *framebuffers);
typedef extern(C) void function (GLsizei, GLuint*) glGenFramebuffersEXTFunc;
glGenFramebuffersEXTFunc glGenFramebuffersEXT;

//GLenum glCheckFramebufferStatusEXT(GLenum target);
typedef extern(C) GLenum function (GLenum) glCheckFramebufferStatusEXTFunc;
glCheckFramebufferStatusEXTFunc glCheckFramebufferStatusEXT;

/*
void glFramebufferTexture1DEXT(GLenum target, GLenum attachment,
																GLenum textarget, GLuint texture,
																GLint level);
//TODO
void glFramebufferTexture2DEXT(GLenum target, GLenum attachment,
																GLenum textarget, GLuint texture,
																GLint level);
//TODO
void glFramebufferTexture3DEXT(GLenum target, GLenum attachment,
																GLenum textarget, GLuint texture,
																GLint level, GLint zoffset);
//TODO
*/

//void glFramebufferRenderbufferEXT(GLenum target, GLenum attachment,
//																		GLenum renderbuffertarget, GLuint renderbuffer);
typedef extern(C) void function (GLenum, GLenum, GLenum, GLuint) glFramebufferRenderbufferEXTFunc;
glFramebufferRenderbufferEXTFunc glFramebufferRenderbufferEXT;

//void glGetFramebufferAttachmentParameterivEXT(GLenum target, GLenum attachment,
//																								GLenum pname, GLint *params);
//TODO
//void glGenerateMipmapEXT(GLenum target);
//TODO




//void glFramebufferTexture2DEXT (GLenum target, GLenum attachment,
//																GLenum textarget, GLuint texture,
//																GLint level);
typedef extern(C) void function (GLenum, GLenum, GLenum, GLuint, GLint) glFramebufferTexture2DEXTFunc;
glFramebufferTexture2DEXTFunc glFramebufferTexture2DEXT;


//
alias char GLchar;

//GL_VERSION_2_0

extern(C) void function (GLenum, GLenum) glBlendEquationSeparate;
extern(C) void function (GLsizei, GLenum *) glDrawBuffers;
extern(C) void function (GLenum, GLenum, GLenum, GLenum) glStencilOpSeparate;
extern(C) void function (GLenum, GLenum, GLint, GLuint) glStencilFuncSeparate;
extern(C) void function (GLenum, GLuint) glStencilMaskSeparate;
extern(C) void function (GLuint, GLuint) glAttachShader;
extern(C) void function (GLuint, GLuint, GLchar *) glBindAttribLocation;
extern(C) void function (GLuint) glCompileShader;
extern(C) GLuint function () glCreateProgram;
extern(C) GLuint function (GLenum) glCreateShader;
extern(C) void function (GLuint) glDeleteProgram;
extern(C) void function (GLuint) glDeleteShader;
extern(C) void function (GLuint, GLuint) glDetachShader;
extern(C) void function (GLuint) glDisableVertexAttribArray;
extern(C) void function (GLuint) glEnableVertexAttribArray;
extern(C) void function (GLuint, GLuint, GLsizei, GLsizei *, GLint *, GLenum *, GLchar *) glGetActiveAttrib;
extern(C) void function (GLuint, GLuint, GLsizei, GLsizei *, GLint *, GLenum *, GLchar *) glGetActiveUniform;
extern(C) void function (GLuint, GLsizei, GLsizei *, GLuint *) glGetAttachedShaders;
extern(C) GLint function (GLuint, GLchar *) glGetAttribLocation;
extern(C) void function (GLuint, GLenum, GLint *) glGetProgramiv;
extern(C) void function (GLuint, GLsizei, GLsizei *, GLchar *) glGetProgramInfoLog;
extern(C) void function (GLuint, GLenum, GLint *) glGetShaderiv;
extern(C) void function (GLuint, GLsizei, GLsizei *, GLchar *) glGetShaderInfoLog;
extern(C) void function (GLuint, GLsizei, GLsizei *, GLchar *) glGetShaderSource;
extern(C) GLint function (GLuint, GLchar *) glGetUniformLocation;
extern(C) void function (GLuint, GLint, GLfloat *) glGetUniformfv;
extern(C) void function (GLuint, GLint, GLint *) glGetUniformiv;
extern(C) void function (GLuint, GLenum, GLdouble *) glGetVertexAttribdv;
extern(C) void function (GLuint, GLenum, GLfloat *) glGetVertexAttribfv;
extern(C) void function (GLuint, GLenum, GLint *) glGetVertexAttribiv;
extern(C) void function (GLuint, GLenum, GLvoid* *) glGetVertexAttribPointerv;
extern(C) GLboolean function (GLuint) glIsProgram;
extern(C) GLboolean function (GLuint) glIsShader;
extern(C) void function (GLuint) glLinkProgram;
extern(C) void function (GLuint, GLsizei, GLchar* *, GLint *) glShaderSource;
extern(C) void function (GLuint) glUseProgram;
extern(C) void function (GLint, GLfloat) glUniform1f;
extern(C) void function (GLint, GLfloat, GLfloat) glUniform2f;
extern(C) void function (GLint, GLfloat, GLfloat, GLfloat) glUniform3f;
extern(C) void function (GLint, GLfloat, GLfloat, GLfloat, GLfloat) glUniform4f;
extern(C) void function (GLint, GLint) glUniform1i;
extern(C) void function (GLint, GLint, GLint) glUniform2i;
extern(C) void function (GLint, GLint, GLint, GLint) glUniform3i;
extern(C) void function (GLint, GLint, GLint, GLint, GLint) glUniform4i;
extern(C) void function (GLint, GLsizei, GLfloat *) glUniform1fv;
extern(C) void function (GLint, GLsizei, GLfloat *) glUniform2fv;
extern(C) void function (GLint, GLsizei, GLfloat *) glUniform3fv;
extern(C) void function (GLint, GLsizei, GLfloat *) glUniform4fv;
extern(C) void function (GLint, GLsizei, GLint *) glUniform1iv;
extern(C) void function (GLint, GLsizei, GLint *) glUniform2iv;
extern(C) void function (GLint, GLsizei, GLint *) glUniform3iv;
extern(C) void function (GLint, GLsizei, GLint *) glUniform4iv;
extern(C) void function (GLint, GLsizei, GLboolean, GLfloat *) glUniformMatrix2fv;
extern(C) void function (GLint, GLsizei, GLboolean, GLfloat *) glUniformMatrix3fv;
extern(C) void function (GLint, GLsizei, GLboolean, GLfloat *) glUniformMatrix4fv;
extern(C) void function (GLuint) glValidateProgram;
extern(C) void function (GLuint, GLdouble) glVertexAttrib1d;
extern(C) void function (GLuint, GLdouble *) glVertexAttrib1dv;
extern(C) void function (GLuint, GLfloat) glVertexAttrib1f;
extern(C) void function (GLuint, GLfloat *) glVertexAttrib1fv;
extern(C) void function (GLuint, GLshort) glVertexAttrib1s;
extern(C) void function (GLuint, GLshort *) glVertexAttrib1sv;
extern(C) void function (GLuint, GLdouble, GLdouble) glVertexAttrib2d;
extern(C) void function (GLuint, GLdouble *) glVertexAttrib2dv;
extern(C) void function (GLuint, GLfloat, GLfloat) glVertexAttrib2f;
extern(C) void function (GLuint, GLfloat *) glVertexAttrib2fv;
extern(C) void function (GLuint, GLshort, GLshort) glVertexAttrib2s;
extern(C) void function (GLuint, GLshort *) glVertexAttrib2sv;
extern(C) void function (GLuint, GLdouble, GLdouble, GLdouble) glVertexAttrib3d;
extern(C) void function (GLuint, GLdouble *) glVertexAttrib3dv;
extern(C) void function (GLuint, GLfloat, GLfloat, GLfloat) glVertexAttrib3f;
extern(C) void function (GLuint, GLfloat *) glVertexAttrib3fv;
extern(C) void function (GLuint, GLshort, GLshort, GLshort) glVertexAttrib3s;
extern(C) void function (GLuint, GLshort *) glVertexAttrib3sv;
extern(C) void function (GLuint, GLbyte *) glVertexAttrib4Nbv;
extern(C) void function (GLuint, GLint *) glVertexAttrib4Niv;
extern(C) void function (GLuint, GLshort *) glVertexAttrib4Nsv;
extern(C) void function (GLuint, GLubyte, GLubyte, GLubyte, GLubyte) glVertexAttrib4Nub;
extern(C) void function (GLuint, GLubyte *) glVertexAttrib4Nubv;
extern(C) void function (GLuint, GLuint *) glVertexAttrib4Nuiv;
extern(C) void function (GLuint, GLushort *) glVertexAttrib4Nusv;
extern(C) void function (GLuint, GLbyte *) glVertexAttrib4bv;
extern(C) void function (GLuint, GLdouble, GLdouble, GLdouble, GLdouble) glVertexAttrib4d;
extern(C) void function (GLuint, GLdouble *) glVertexAttrib4dv;
extern(C) void function (GLuint, GLfloat, GLfloat, GLfloat, GLfloat) glVertexAttrib4f;
extern(C) void function (GLuint, GLfloat *) glVertexAttrib4fv;
extern(C) void function (GLuint, GLint *) glVertexAttrib4iv;
extern(C) void function (GLuint, GLshort, GLshort, GLshort, GLshort) glVertexAttrib4s;
extern(C) void function (GLuint, GLshort *) glVertexAttrib4sv;
extern(C) void function (GLuint, GLubyte *) glVertexAttrib4ubv;
extern(C) void function (GLuint, GLuint *) glVertexAttrib4uiv;
extern(C) void function (GLuint, GLushort *) glVertexAttrib4usv;
extern(C) void function (GLuint, GLint, GLenum, GLboolean, GLsizei, GLvoid *) glVertexAttribPointer;

//GLX_SGI_swap_control
extern(C) GLint function (GLint) glXSwapIntervalSGI;
//GLX_MESA_swap_control
extern(C) GLint function (GLint) glXSwapIntervalMESA;

}


class GLExtensions
{
public:
	/*
	static bool checkExtension(string extens)
	{
		if( GLQuery.glExtension(extens) )
			return true;
		//else
			return false;
	}*/
	
	static bool checkExtension(char[] extens, bool enable_output = false )
		{
			version(gtk)
			{
				if( GLQuery.glExtension(extens) )
				{
					if(enable_output == true) Trace.formatln( extens ~ " found." );
					return true;
				}
			}
			version(glfw)
			{
				if( glfwExtensionSupported( stringz.toStringz(extens) ) )
				{
					if(enable_output == true) Trace.formatln( extens ~ " found." );
					return true;
				}
			}
			
			//else
				if(enable_output == true) Trace.formatln("OpenGL extension " ~ extens ~ " was NOT found."
				" Either your graphics hardware or the drivers don't support the extension."
				" You'll need it for this program to function properly.");
				return false;
		}
	
	static int checkMaxTextureSize()
	{
		GLint texSize; glGetIntegerv(GL_MAX_TEXTURE_SIZE, &texSize);
		return texSize;
	}
	
	static void checkGLExtensions()
	{
		Trace.formatln("Checking OpenGL extensions: ");
		
		if( !checkExtension( "GL_ARB_fragment_program", true ) )
			{}//assert(0);
		if( !checkExtension( "GL_ARB_vertex_program", true ) )
			{}//assert(0);
		if( !checkExtension( "GL_EXT_framebuffer_object", true ) )
			{}//assert(0);
		if( !checkExtension( "GL_ARB_texture_rectangle", true ) )
			{}//assert(0);
		if( !checkExtension( "GL_EXT_texture_filter_anisotropic", true ) )
			{}//assert(0);
		if( !checkExtension( "GL_EXT_packed_pixels", true ) )
			{}//assert(0);
			
		Trace.formatln("Maximum texture size: {}", checkMaxTextureSize() );
		
		/*
		//Connect GL_ARB_vertex_program and GL_ARB_fragment_program functions:
		glVertexAttrib1dARB = cast(glVertexAttrib1dARBFunc)GLQuery.getProcAddress("glVertexAttrib1dARB");
		glVertexAttrib1dvARB = cast(glVertexAttrib1dvARBFunc)GLQuery.getProcAddress("glVertexAttrib1dvARB");
		glVertexAttrib1fARB = cast(glVertexAttrib1fARBFunc)GLQuery.getProcAddress("glVertexAttrib1fARB");
		glVertexAttrib1fvARB = cast(glVertexAttrib1fvARBFunc)GLQuery.getProcAddress("glVertexAttrib1fvARB");
		glVertexAttrib1sARB = cast(glVertexAttrib1sARBFunc)GLQuery.getProcAddress("glVertexAttrib1sARB");
		glVertexAttrib1svARB = cast(glVertexAttrib1svARBFunc)GLQuery.getProcAddress("glVertexAttrib1svARB");
		glVertexAttrib2dARB = cast(glVertexAttrib2dARBFunc)GLQuery.getProcAddress("glVertexAttrib2dARB");
		glVertexAttrib2dvARB = cast(glVertexAttrib2dvARBFunc)GLQuery.getProcAddress("glVertexAttrib2dvARB");
		glVertexAttrib2fARB = cast(glVertexAttrib2fARBFunc)GLQuery.getProcAddress("glVertexAttrib2fARB");
		glVertexAttrib2fvARB = cast(glVertexAttrib2fvARBFunc)GLQuery.getProcAddress("glVertexAttrib2fvARB");
		glVertexAttrib2sARB = cast(glVertexAttrib2sARBFunc)GLQuery.getProcAddress("glVertexAttrib2sARB");
		glVertexAttrib2svARB = cast(glVertexAttrib2svARBFunc)GLQuery.getProcAddress("glVertexAttrib2svARB");
		glVertexAttrib3dARB = cast(glVertexAttrib3dARBFunc)GLQuery.getProcAddress("glVertexAttrib3dARB");
		glVertexAttrib3dvARB = cast(glVertexAttrib3dvARBFunc)GLQuery.getProcAddress("glVertexAttrib3dvARB");
		glVertexAttrib3fARB = cast(glVertexAttrib3fARBFunc)GLQuery.getProcAddress("glVertexAttrib3fARB");
		glVertexAttrib3fvARB = cast(glVertexAttrib3fvARBFunc)GLQuery.getProcAddress("glVertexAttrib3fvARB");
		glVertexAttrib3sARB = cast(glVertexAttrib3sARBFunc)GLQuery.getProcAddress("glVertexAttrib3sARB");
		glVertexAttrib3svARB = cast(glVertexAttrib3svARBFunc)GLQuery.getProcAddress("glVertexAttrib3svARB");
		glVertexAttrib4NbvARB = cast(glVertexAttrib4NbvARBFunc)GLQuery.getProcAddress("glVertexAttrib4NbvARB");
		glVertexAttrib4NivARB = cast(glVertexAttrib4NivARBFunc)GLQuery.getProcAddress("glVertexAttrib4NivARB");
		glVertexAttrib4NsvARB = cast(glVertexAttrib4NsvARBFunc)GLQuery.getProcAddress("glVertexAttrib4NsvARB");
		glVertexAttrib4NubARB = cast(glVertexAttrib4NubARBFunc)GLQuery.getProcAddress("glVertexAttrib4NubARB");
		glVertexAttrib4NubvARB = cast(glVertexAttrib4NubvARBFunc)GLQuery.getProcAddress("glVertexAttrib4NubvARB");
		glVertexAttrib4NuivARB = cast(glVertexAttrib4NuivARBFunc)GLQuery.getProcAddress("glVertexAttrib4NuivARB");
		glVertexAttrib4NusvARB = cast(glVertexAttrib4NusvARBFunc)GLQuery.getProcAddress("glVertexAttrib4NusvARB");
		glVertexAttrib4bvARB = cast(glVertexAttrib4bvARBFunc)GLQuery.getProcAddress("glVertexAttrib4bvARB");
		glVertexAttrib4dARB = cast(glVertexAttrib4dARBFunc)GLQuery.getProcAddress("glVertexAttrib4dARB");
		glVertexAttrib4dvARB = cast(glVertexAttrib4dvARBFunc)GLQuery.getProcAddress("glVertexAttrib4dvARB");
		glVertexAttrib4fARB = cast(glVertexAttrib4fARBFunc)GLQuery.getProcAddress("glVertexAttrib4fARB");
		glVertexAttrib4fvARB = cast(glVertexAttrib4fvARBFunc)GLQuery.getProcAddress("glVertexAttrib4fvARB");
		glVertexAttrib4ivARB = cast(glVertexAttrib4ivARBFunc)GLQuery.getProcAddress("glVertexAttrib4ivARB");
		glVertexAttrib4sARB = cast(glVertexAttrib4sARBFunc)GLQuery.getProcAddress("glVertexAttrib4sARB");
		glVertexAttrib4svARB = cast(glVertexAttrib4svARBFunc)GLQuery.getProcAddress("glVertexAttrib4svARB");
		glVertexAttrib4ubvARB = cast(glVertexAttrib4ubvARBFunc)GLQuery.getProcAddress("glVertexAttrib4ubvARB");
		glVertexAttrib4uivARB = cast(glVertexAttrib4uivARBFunc)GLQuery.getProcAddress("glVertexAttrib4uivARB");
		glVertexAttrib4usvARB = cast(glVertexAttrib4usvARBFunc)GLQuery.getProcAddress("glVertexAttrib4usvARB");
		glVertexAttribPointerARB = cast(glVertexAttribPointerARBFunc)GLQuery.getProcAddress("glVertexAttribPointerARB");
		glEnableVertexAttribArrayARB = cast(glEnableVertexAttribArrayARBFunc)GLQuery.getProcAddress("glEnableVertexAttribArrayARB");
		glDisableVertexAttribArrayARB = cast(glDisableVertexAttribArrayARBFunc)GLQuery.getProcAddress("glDisableVertexAttribArrayARB");
		glProgramStringARB = cast(glProgramStringARBFunc)GLQuery.getProcAddress("glProgramStringARB");
		glBindProgramARB = cast(glBindProgramARBFunc)GLQuery.getProcAddress("glBindProgramARB");
		glDeleteProgramsARB = cast(glDeleteProgramsARBFunc)GLQuery.getProcAddress("glDeleteProgramsARB");
		glGenProgramsARB = cast(glGenProgramsARBFunc)GLQuery.getProcAddress("glGenProgramsARB");
		glProgramEnvParameter4dARB = cast(glProgramEnvParameter4dARBFunc)GLQuery.getProcAddress("glProgramEnvParameter4dARB");
		glProgramEnvParameter4dvARB = cast(glProgramEnvParameter4dvARBFunc)GLQuery.getProcAddress("glProgramEnvParameter4dvARB");
		glProgramEnvParameter4fARB = cast(glProgramEnvParameter4fARBFunc)GLQuery.getProcAddress("glProgramEnvParameter4fARB");
		glProgramEnvParameter4fvARB = cast(glProgramEnvParameter4fvARBFunc)GLQuery.getProcAddress("glProgramEnvParameter4fvARB");
		glProgramLocalParameter4dARB = cast(glProgramLocalParameter4dARBFunc)GLQuery.getProcAddress("glProgramLocalParameter4dARB");
		glProgramLocalParameter4dvARB = cast(glProgramLocalParameter4dvARBFunc)GLQuery.getProcAddress("glProgramLocalParameter4dvARB");
		glProgramLocalParameter4fARB = cast(glProgramLocalParameter4fARBFunc)GLQuery.getProcAddress("glProgramLocalParameter4fARB");
		glProgramLocalParameter4fvARB = cast(glProgramLocalParameter4fvARBFunc)GLQuery.getProcAddress("glProgramLocalParameter4fvARB");
		glGetProgramEnvParameterdvARB = cast(glGetProgramEnvParameterdvARBFunc)GLQuery.getProcAddress("glGetProgramEnvParameterdvARB");
		glGetProgramEnvParameterfvARB = cast(glGetProgramEnvParameterfvARBFunc)GLQuery.getProcAddress("glGetProgramEnvParameterfvARB");
		glGetProgramLocalParameterdvARB = cast(glGetProgramLocalParameterdvARBFunc)GLQuery.getProcAddress("glGetProgramLocalParameterdvARB");
		glGetProgramLocalParameterfvARB = cast(glGetProgramLocalParameterfvARBFunc)GLQuery.getProcAddress("glGetProgramLocalParameterfvARB");
		glGetProgramivARB = cast(glGetProgramivARBFunc)GLQuery.getProcAddress("glGetProgramivARB");
		glGetProgramStringARB = cast(glGetProgramStringARBFunc)GLQuery.getProcAddress("glGetProgramStringARB");
		glGetVertexAttribdvARB = cast(glGetVertexAttribdvARBFunc)GLQuery.getProcAddress("glGetVertexAttribdvARB");
		glGetVertexAttribfvARB = cast(glGetVertexAttribfvARBFunc)GLQuery.getProcAddress("glGetVertexAttribfvARB");
		glGetVertexAttribivARB = cast(glGetVertexAttribivARBFunc)GLQuery.getProcAddress("glGetVertexAttribivARB");
		glGetVertexAttribPointervARB = cast(glGetVertexAttribPointervARBFunc)GLQuery.getProcAddress("glGetVertexAttribPointervARB");
		glIsProgramARB = cast(glIsProgramARBFunc)GLQuery.getProcAddress("glIsProgramARB");
		
		
		//Connect GL_EXT_framebuffer_object functions:
		glIsRenderbufferEXT = cast(glIsRenderbufferEXTFunc)GLQuery.getProcAddress("glIsRenderbufferEXT");
		glBindRenderbufferEXT = cast(glBindRenderbufferEXTFunc)GLQuery.getProcAddress("glBindRenderbufferEXT");
		glDeleteRenderbuffersEXT = cast(glDeleteRenderbuffersEXTFunc)GLQuery.getProcAddress("glDeleteRenderbuffersEXT");
		glGenRenderbuffersEXT = cast(glGenRenderbuffersEXTFunc)GLQuery.getProcAddress("glGenRenderbuffersEXT");
		glRenderbufferStorageEXT = cast(glRenderbufferStorageEXTFunc)GLQuery.getProcAddress("glRenderbufferStorageEXT");
		glIsFramebufferEXT = cast(glIsFramebufferEXTFunc)GLQuery.getProcAddress("glIsFramebufferEXT");
		glBindFramebufferEXT = cast(glBindFramebufferEXTFunc)GLQuery.getProcAddress("glBindFramebufferEXT");
		glDeleteFramebuffersEXT = cast(glDeleteFramebuffersEXTFunc)GLQuery.getProcAddress("glDeleteFramebuffersEXT");
		glGenFramebuffersEXT = cast(glGenFramebuffersEXTFunc)GLQuery.getProcAddress("glGenFramebuffersEXT");		
		glCheckFramebufferStatusEXT = cast(glCheckFramebufferStatusEXTFunc)GLQuery.getProcAddress("glCheckFramebufferStatusEXT");
		glFramebufferRenderbufferEXT = cast(glFramebufferRenderbufferEXTFunc)GLQuery.getProcAddress("glFramebufferRenderbufferEXT");
		glFramebufferTexture2DEXT = cast(glFramebufferTexture2DEXTFunc)GLQuery.getProcAddress("glFramebufferTexture2DEXT");
		*/
		
		debug(OpenGLLoader) Trace.formatln("Trying to load OpenGL library.");
	
		SharedLib lib;
	
	version (Windows)
	{
		try
		{
			lib = SharedLib.load("OpenGL32.dll");
		}
		catch(SharedLibException)
		{
			Trace.formatln("Library load failed: OpenGL32.dll");
			throw new Exception("Library load failed: OpenGL32.dll");
		}
	}
	else version (linux)
	{
		try
		{
			lib = SharedLib.load("libGL.so");
		}
		catch(SharedLibException)
		{
			Trace.formatln("Library load failed: libGL.so");
			throw new Exception("Library load failed: libGL.so");
		}
	}
	else version (darwin)
	{
		try
		{
			lib = SharedLib.load("/System/Library/Frameworks/OpenGL.framework/Libraries/libGL.dylib");
		}
		catch(SharedLibException)
		{
			Trace.formatln("Library load failed: /System/Library/Frameworks/OpenGL.framework/Libraries/libGL.dylib");
			throw new Exception("Library load failed: /System/Library/Frameworks/OpenGL.framework/Libraries/libGL.dylib");
		}
	}
		
		debug(OpenGLLoader) Trace.formatln("OpenGL library loaded succesfully.");
		
		debug(OpenGLLoader) Trace.formatln("Trying to load symbols.");
		
		loadSym( glBlendEquationSeparate, lib, `glBlendEquationSeparate` );
		
		debug(OpenGLLoader) Trace.formatln("First one was OK.");
		
		loadSym( glDrawBuffers, lib, `glDrawBuffers` );
		loadSym( glStencilOpSeparate, lib, `glStencilOpSeparate` );
		loadSym( glStencilFuncSeparate, lib, `glStencilFuncSeparate` );
		loadSym( glStencilMaskSeparate, lib, `glStencilMaskSeparate` );
		loadSym( glAttachShader, lib, `glAttachShader` );
		loadSym( glBindAttribLocation, lib, `glBindAttribLocation` );
		loadSym( glCompileShader, lib, `glCompileShader` );
		loadSym( glCreateProgram, lib, `glCreateProgram` );
		loadSym( glCreateShader, lib, `glCreateShader` );
		loadSym( glDeleteProgram, lib, `glDeleteProgram` );
		loadSym( glDeleteShader, lib, `glDeleteShader` );
		loadSym( glDetachShader, lib, `glDetachShader` );
		loadSym( glDisableVertexAttribArray, lib, `glDisableVertexAttribArray` );
		loadSym( glEnableVertexAttribArray, lib, `glEnableVertexAttribArray` );
		loadSym( glGetActiveAttrib, lib, `glGetActiveAttrib` );
		loadSym( glGetActiveUniform, lib, `glGetActiveUniform` );
		loadSym( glGetAttachedShaders, lib, `glGetAttachedShaders` );
		loadSym( glGetAttribLocation, lib, `glGetAttribLocation` );
		loadSym( glGetProgramiv, lib, `glGetProgramiv` );
		loadSym( glGetProgramInfoLog, lib, `glGetProgramInfoLog` );
		loadSym( glGetShaderiv, lib, `glGetShaderiv` );
		loadSym( glGetShaderInfoLog, lib, `glGetShaderInfoLog` );
		loadSym( glGetShaderSource, lib, `glGetShaderSource` );
		loadSym( glGetUniformLocation, lib, `glGetUniformLocation` );
		loadSym( glGetUniformfv, lib, `glGetUniformfv` );
		loadSym( glGetUniformiv, lib, `glGetUniformiv` );// (GLuint, GLint, GLint *);
		loadSym( glGetVertexAttribdv, lib, `glGetVertexAttribdv` );// (GLuint, GLenum, GLdouble *);
		loadSym( glGetVertexAttribfv, lib, `glGetVertexAttribfv` );// (GLuint, GLenum, GLfloat *);
		loadSym( glGetVertexAttribiv, lib, `glGetVertexAttribiv` );// (GLuint, GLenum, GLint *);
		loadSym( glGetVertexAttribPointerv, lib, `glGetVertexAttribPointerv` );// (GLuint, GLenum, GLvoid* *);
		loadSym( glIsProgram, lib, `glIsProgram` );// (GLuint);
		loadSym( glIsShader, lib, `glIsShader` );// (GLuint);
		loadSym( glLinkProgram, lib, `glLinkProgram` );// (GLuint);
		loadSym( glShaderSource, lib, `glShaderSource` );// (GLuint, GLsizei, const GLchar* *, const GLint *);
		loadSym( glUseProgram, lib, `glUseProgram` );// (GLuint);
		loadSym( glUniform1f, lib, `glUniform1f` );// (GLint, GLfloat);
		loadSym( glUniform2f, lib, `glUniform2f` );// (GLint, GLfloat, GLfloat);
		loadSym( glUniform3f, lib, `glUniform3f` );// (GLint, GLfloat, GLfloat, GLfloat);
		loadSym( glUniform4f, lib, `glUniform4f` );// (GLint, GLfloat, GLfloat, GLfloat, GLfloat);
		loadSym( glUniform1i, lib, `glUniform1i` );// (GLint, GLint);
		loadSym( glUniform2i, lib, `glUniform2i` );// (GLint, GLint, GLint);
		loadSym( glUniform3i, lib, `glUniform3i` );// (GLint, GLint, GLint, GLint);
		loadSym( glUniform4i, lib, `glUniform4i` );// (GLint, GLint, GLint, GLint, GLint);
		loadSym( glUniform1fv, lib, `glUniform1fv` );// (GLint, GLsizei, const GLfloat *);
		loadSym( glUniform2fv, lib, `glUniform2fv` );// (GLint, GLsizei, const GLfloat *);
		loadSym( glUniform3fv, lib, `glUniform3fv` );// (GLint, GLsizei, const GLfloat *);
		loadSym( glUniform4fv, lib, `glUniform4fv` );// (GLint, GLsizei, const GLfloat *);
		loadSym( glUniform1iv, lib, `glUniform1iv` );// (GLint, GLsizei, const GLint *);
		loadSym( glUniform2iv, lib, `glUniform2iv` );// (GLint, GLsizei, const GLint *);
		loadSym( glUniform3iv, lib, `glUniform3iv` );// (GLint, GLsizei, const GLint *);
		loadSym( glUniform4iv, lib, `glUniform4iv` );// (GLint, GLsizei, const GLint *);
		loadSym( glUniformMatrix2fv, lib, `glUniformMatrix2fv` );// (GLint, GLsizei, GLboolean, const GLfloat *);
		loadSym( glUniformMatrix3fv, lib, `glUniformMatrix3fv` );// (GLint, GLsizei, GLboolean, const GLfloat *);
		loadSym( glUniformMatrix4fv, lib, `glUniformMatrix4fv` );// (GLint, GLsizei, GLboolean, const GLfloat *);
		loadSym( glValidateProgram, lib, `glValidateProgram` );// (GLuint);
		loadSym( glVertexAttrib1d, lib, `glVertexAttrib1d` );// (GLuint, GLdouble);
		loadSym( glVertexAttrib1dv, lib, `glVertexAttrib1dv` );// (GLuint, const GLdouble *);
		loadSym( glVertexAttrib1f, lib, `glVertexAttrib1f` );// (GLuint, GLfloat);
		loadSym( glVertexAttrib1fv, lib, `glVertexAttrib1fv` );// (GLuint, const GLfloat *);
		loadSym( glVertexAttrib1s, lib, `glVertexAttrib1s` );// (GLuint, GLshort);
		loadSym( glVertexAttrib1sv, lib, `glVertexAttrib1sv` );// (GLuint, const GLshort *);
		loadSym( glVertexAttrib2d, lib, `glVertexAttrib2d` );// (GLuint, GLdouble, GLdouble);
		loadSym( glVertexAttrib2dv, lib, `glVertexAttrib2dv` );// (GLuint, const GLdouble *);
		loadSym( glVertexAttrib2f, lib, `glVertexAttrib2f` );// (GLuint, GLfloat, GLfloat);
		loadSym( glVertexAttrib2fv, lib, `glVertexAttrib2fv` );// (GLuint, const GLfloat *);
		loadSym( glVertexAttrib2s, lib, `glVertexAttrib2s` );// (GLuint, GLshort, GLshort);
		loadSym( glVertexAttrib2sv, lib, `glVertexAttrib2sv` );// (GLuint, const GLshort *);
		loadSym( glVertexAttrib3d, lib, `glVertexAttrib3d` );// (GLuint, GLdouble, GLdouble, GLdouble);
		loadSym( glVertexAttrib3dv, lib, `glVertexAttrib3dv` );// (GLuint, const GLdouble *);
		loadSym( glVertexAttrib3f, lib, `glVertexAttrib3f` );// (GLuint, GLfloat, GLfloat, GLfloat);
		loadSym( glVertexAttrib3fv, lib, `glVertexAttrib3fv` );// (GLuint, const GLfloat *);
		loadSym( glVertexAttrib3s, lib, `glVertexAttrib3s` );// (GLuint, GLshort, GLshort, GLshort);
		loadSym( glVertexAttrib3sv, lib, `glVertexAttrib3sv` );// (GLuint, const GLshort *);
		loadSym( glVertexAttrib4Nbv, lib, `glVertexAttrib4Nbv` );// (GLuint, const GLbyte *);
		loadSym( glVertexAttrib4Niv, lib, `glVertexAttrib4Niv` );// (GLuint, const GLint *);
		loadSym( glVertexAttrib4Nsv, lib, `glVertexAttrib4Nsv` );// (GLuint, const GLshort *);
		loadSym( glVertexAttrib4Nub, lib, `glVertexAttrib4Nub` );// (GLuint, GLubyte, GLubyte, GLubyte, GLubyte);
		loadSym( glVertexAttrib4Nubv, lib, `glVertexAttrib4Nubv` );// (GLuint, const GLubyte *);
		loadSym( glVertexAttrib4Nuiv, lib, `glVertexAttrib4Nuiv` );// (GLuint, const GLuint *);
		loadSym( glVertexAttrib4Nusv, lib, `glVertexAttrib4Nusv` );// (GLuint, const GLushort *);
		loadSym( glVertexAttrib4bv, lib, `glVertexAttrib4bv` );// (GLuint, const GLbyte *);
		loadSym( glVertexAttrib4d, lib, `glVertexAttrib4d` );// (GLuint, GLdouble, GLdouble, GLdouble, GLdouble);
		loadSym( glVertexAttrib4dv, lib, `glVertexAttrib4dv` );// (GLuint, const GLdouble *);
		loadSym( glVertexAttrib4f, lib, `glVertexAttrib4f` );// (GLuint, GLfloat, GLfloat, GLfloat, GLfloat);
		loadSym( glVertexAttrib4fv, lib, `glVertexAttrib4fv` );// (GLuint, const GLfloat *);
		loadSym( glVertexAttrib4iv, lib, `glVertexAttrib4iv` );// (GLuint, const GLint *);
		loadSym( glVertexAttrib4s, lib, `glVertexAttrib4s` );// (GLuint, GLshort, GLshort, GLshort, GLshort);
		loadSym( glVertexAttrib4sv, lib, `glVertexAttrib4sv` );// (GLuint, const GLshort *);
		loadSym( glVertexAttrib4ubv, lib, `glVertexAttrib4ubv` );//
		loadSym( glVertexAttrib4uiv, lib, `glVertexAttrib4uiv` );
		loadSym( glVertexAttrib4usv, lib, `glVertexAttrib4usv` );
		loadSym( glVertexAttribPointer, lib, `glVertexAttribPointer` );
		
		/*if( checkExtension( "GLX_SGI_swap_control" ) == true )
		{
			loadSym( glXSwapIntervalSGI, lib, `glXSwapIntervalSGI`);
		}
		
		if( checkExtension( "GLX_MESA_swap_control" ) == true )
		{
			loadSym( glXSwapIntervalMESA, lib, `glXSwapIntervalMESA`);
		}*/
		
	}
	
	
}	
	


version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-rae");
        } else version (DigitalMars) {
            pragma(link, "DD-rae");
        } else {
            pragma(link, "DO-rae");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-rae");
        } else version (DigitalMars) {
            pragma(link, "DD-rae");
        } else {
            pragma(link, "DO-rae");
        }
    }
}

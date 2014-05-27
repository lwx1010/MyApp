--- 
-- 所有着色器代码
-- @module utils.Shaders
-- 

local moduleName = "utils.Shaders"
module(moduleName)

---
-- 公共的vs
-- @field [parent=#utils.Shaders] #string common_vs
-- 
common_vs =
[[						
attribute vec4 a_position;							
attribute vec2 a_texCoord;							
attribute vec4 a_color;								
													
#ifdef GL_ES										
varying lowp vec4 v_fragmentColor;					
varying mediump vec2 v_texCoord;					
#else												
varying vec4 v_fragmentColor;						
varying vec2 v_texCoord;							
#endif												
													
void main()											
{													
    gl_Position = CC_MVPMatrix * a_position;		
	v_fragmentColor = a_color;						
	v_texCoord = a_texCoord;						
}																					
]]

---
-- 颜色变换矩阵vs
-- @field [parent=#utils.Shaders] #string colorMatrix_vs
-- 
colorMatrix_vs = common_vs

---
-- 颜色变换矩阵fs
-- @field [parent=#utils.Shaders] #string colorMatrix_fs
-- 
colorMatrix_fs =
[[						
#ifdef GL_ES								
precision lowp float;						
#endif										
											
varying vec4 v_fragmentColor;				
varying vec2 v_texCoord;					
uniform sampler2D CC_Texture0;			
	
uniform mat4 u_colorMatrix;				
uniform vec4 u_offset;				
											
void main()									
{							
	vec4 outputColor = texture2D(CC_Texture0, v_texCoord) * u_colorMatrix;
	outputColor = outputColor + u_offset;
	outputColor.a = v_fragmentColor.a * outputColor.a;
	outputColor.rgb = outputColor.rgb * outputColor.a;	// src_blend 是one，所以要预乘alpha
	gl_FragColor = outputColor;
}											
]]

---
-- 变灰vs
-- @field [parent=#utils.Shaders] #string gray_vs
-- 
gray_vs = common_vs

---
-- 变灰fs
-- @field [parent=#utils.Shaders] #string gray_fs
-- 
gray_fs =
[[						
#ifdef GL_ES								
precision lowp float;						
#endif										
											
varying vec4 v_fragmentColor;				
varying vec2 v_texCoord;					
uniform sampler2D CC_Texture0;					
											
void main()									
{		
	vec4 outputColor = v_fragmentColor * texture2D(CC_Texture0, v_texCoord);
	float gray = dot(outputColor.rgb, vec3(0.3086, 0.6094, 0.0820));
	gl_FragColor = vec4(gray, gray, gray, outputColor.a);
}											
]]
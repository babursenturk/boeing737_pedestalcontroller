#------------------------------------------------------------------------------
# LOCAL.MK - Allows you to customize the build/Make process for a particular 
#   PSoC Designer project.  The information you enter in this file is governed 
#   by MAKE.  It is recommended that you read about MAKE in the 
#   PSoC Designer/Documentation/Supporting Documents/Make.PDF.  It is also
#   strongly recommended that you set the Options >> Builder >> Enable verbose
#   build messages, so that you can view the impact of the changes caused
#   by actions in this file.
#
#   There are no dependencies in the primary Make process (e.g. ...\tools\Makefile)
#   associated with this file.  Therefore, if you build the project, after saving 
#   changed information in this file, you may not get the changes you expected.
#   You can "touch" a file before you build to allow changes in this file to 
#   take effect.
#
#   To see what variable names are used by the different tools, see the global
#   makefile, ...\tools\Makefile.
#
#   To see what variable names are already set to non-empty values, see the 
#   local makefile, project.mk. To append to such a variable, use the form used
#   for CODECOMPRESSOR in the example below. 
#
#   Example use:
#
# To Enable the 24MHZ alignment option in ImageCraft
#CODECOMPRESSOR:=$(CODECOMPRESSOR) -z 
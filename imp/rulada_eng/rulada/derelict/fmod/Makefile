include ../inc/win32_inc.mak
include ../inc/compiler_inc.mak

AL_SRC= \
   fmodex.d \
    fmodexfuncs.d \
   fmodextypes.d   
    
PACKAGE_PATH=derelict/fmod

all : DerelictFMODEX

$(LIB_PRE)DerelictFMODEX.$(LIB_EXT) :
	$(DC) $(DFLAGS) $(DFLAGS_REQ) $(AL_SRC) $(HD)/$(PACKAGE_PATH) $(OF)$@
	$(CP) $@ $(LIB_DEST)
	$(RM) $@

DerelictFMODEX : $(LIB_PRE)DerelictFMODEX.$(LIB_EXT)

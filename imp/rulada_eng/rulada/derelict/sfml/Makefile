PLATFORM=win32
include ../inc/$(PLATFORM)_inc.mak
include ../inc/compiler_inc.mak

PACKAGE_PATH=.

all : DerelictSFMLWindow DerelictSFMLSystem DerelictSFMLGraphics DerelictSFMLAudio DerelictSFMLNetwork

SYS_SRC= \
	config.d \
	stypes.d \
	sfuncs.d \
	system.d

WIN_SRC= \
	wtypes.d \
	wfuncs.d \
	window.d
	
GFX_SRC= \
	gtypes.d \
	gfuncs.d \
	graphics.d
	
AUDIO_SRC= \
	atypes.d \
	afuncs.d \
	audio.d
	
NET_SRC= \
	ntypes.d \
	nfuncs.d \
	network.d

$(LIB_TARGET) :
	$(DC) $(DFLAGS) $(DFLAGS_REQ) $(ALL_SRC) $(HD)/$(PACKAGE_PATH) $(OF)$@
	$(CP) $@ $(LIB_DEST)
	$(RM) $@
	
$(LIB_PRE)DerelictSFMLWindow.$(LIB_EXT) :
	$(DC) $(DFLAGS) $(DFLAGS_REQ) $(WIN_SRC) $(HD)/$(PACKAGE_PATH) $(OF)$@
	$(CP) $@ $(LIB_DEST)
	$(RM) $@
	
$(LIB_PRE)DerelictSFMLSystem.$(LIB_EXT) :
	$(DC) $(DFLAGS) $(DFLAGS_REQ) $(SYS_SRC) $(HD)/$(PACKAGE_PATH) $(OF)$@
	$(CP) $@ $(LIB_DEST)
	$(RM) $@
	
$(LIB_PRE)DerelictSFMLGraphics.$(LIB_EXT) :
	$(DC) $(DFLAGS) $(DFLAGS_REQ) $(GFX_SRC) $(HD)/$(PACKAGE_PATH) $(OF)$@
	$(CP) $@ $(LIB_DEST)
	$(RM) $@
	
$(LIB_PRE)DerelictSFMLAudio.$(LIB_EXT) :
	$(DC) $(DFLAGS) $(DFLAGS_REQ) $(AUDIO_SRC) $(HD)/$(PACKAGE_PATH) $(OF)$@
	$(CP) $@ $(LIB_DEST)
	$(RM) $@
	
$(LIB_PRE)DerelictSFMLNetwork.$(LIB_EXT) :
	$(DC) $(DFLAGS) $(DFLAGS_REQ) $(NET_SRC) $(HD)/$(PACKAGE_PATH) $(OF)$@
	$(CP) $@ $(LIB_DEST)
	$(RM) $@
	
DerelictSFMLWindow : $(LIB_PRE)DerelictSFMLWindow.$(LIB_EXT)
DerelictSFMLSystem : $(LIB_PRE)DerelictSFMLSystem.$(LIB_EXT)
DerelictSFMLGraphics : $(LIB_PRE)DerelictSFMLGraphics.$(LIB_EXT)
DerelictSFMLAudio : $(LIB_PRE)DerelictSFMLAudio.$(LIB_EXT)
DerelictSFMLNetwork : $(LIB_PRE)DerelictSFMLNetwork.$(LIB_EXT)

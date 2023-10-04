.PHONY: build release post touch sprites shadows stitched mono force copy copyall clean cleanframes cleanshadows cleansheets cleanstitched cleanmono optim

# dirOutput			= /Volumes/RAM/_Output
dirOutput			= _Output
dirFrames			= _Frames
dirShadows			= _Shadows
dirTempFrames		= _TempFrames
dirTempShadows		= _TempShadows
dirSheetsFrames		= _SheetsFrames
dirSheetsShadows	= _SheetsShadows
dirMono				= _Mono

build: sprites shadows stitched mono copy

release: sprites shadows stitched mono optim copy

post: stitched mono copy

touch:
	@./touch_all.sh

sprites:
	@-mkdir -p $(dirOutput)/$(dirFrames)
	@./render_all.sh 0

shadows:
	@-mkdir -p $(dirOutput)/$(dirShadows)
	@./render_all.sh 1

stitched:
	@-mkdir -p $(dirOutput)/$(dirTempFrames)
	@-mkdir -p $(dirOutput)/$(dirTempShadows)
	@-mkdir -p $(dirOutput)/$(dirSheetsFrames)
	@-mkdir -p $(dirOutput)/$(dirSheetsShadows)
	@./stitch_all.sh

mono:
	@-mkdir -p $(dirOutput)/$(dirMono)
	@./mono_all.sh 0

force:
	@-mkdir -p $(dirOutput)/$(dirMono)
	@./mono_all.sh 1

copy: mono
# 	@echo "COPY: copying CHANGED to SOURCE folder"
# 	@rsync --verbose --update $(dirOutput)/$(dirMono)/*.png ~/Projects/Playdate/dailydriver/Source/Vehicles/ | grep ".png"

copyall: mono
# 	@echo "COPY: copying ALL to SOURCE folder, forcefully"
# 	@cp -a $(dirOutput)/$(dirMono)/*.png ~/Projects/Playdate/dailydriver/Source/Vehicles/

optim:
	@echo "OPTIM: crushing ALL"
	@/Applications/ImageOptim.app/Contents/MacOS/ImageOptim $(dirOutput)/$(dirMono)/*.png > /dev/null 2>&1

clean:
	@rm -rf $(dirOutput)

cleanrenders: cleanframes cleanshadows

cleanframes:
	@rm -rf $(dirOutput)/$(dirFrames)

cleanshadows:
	@rm -rf $(dirOutput)/$(dirShadows)

cleansheets: cleanstitched cleanmono

cleanstitched:
	@rm -rf $(dirOutput)/$(dirTempFrames)
	@rm -rf $(dirOutput)/$(dirTempShadows)
	@rm -rf $(dirOutput)/$(dirSheetsFrames)
	@rm -rf $(dirOutput)/$(dirSheetsShadows)

cleanmono:
	@rm -rf $(dirOutput)/$(dirMono)

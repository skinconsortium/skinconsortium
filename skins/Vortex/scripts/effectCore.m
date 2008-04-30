					/*
+=============================================+
|EffectCore.m - Effect script for Vortex      |
+---------------------------------------------+
|Made by : Rohan Prabhu(a.k.a: rohan2kool)    |
|For : Vortex                                 |
|Controls : Basic effects like hoverButtons   |
|Inspirations : None                          |
|Copyrights : �Rohan Prabhu                   |
+---------------------------------------------+
|Feel free to use this code or parts of this  |
|code for your skins. Enjoy.                  |
+---------------------------------------------+
|mail : rohan2kool@gmail.com                  |
|website : http://www.geocities.com/tritium_sk|
|inz                                          |
+=============================================+
					*/

#include "../../../lib/std.mi"
#include "../../../lib/config.mi"

#define GET_HOVER_MODE stringToInteger(ca_gbmode.getData())
#define PERCENTAGE_XFADE (xSlider.getPosition()*100)/20

Function causeGlow(int obj, int mode, boolean reverse);
Function playPause(boolean revp);
Function Int getTreble();
Function Int getBass();

Global button stop, play, next, prev, eject, pause, sTog;
Global layer stopH, playH, nextH, prevH, ejectH;
Global int x=1, ssx=0, aC, sC, sH;
Global animatedLayer leftSub, leftBass, leftTreble, rightSub, rightBass, rightTreble;
Global Timer sonicEffectRefresh, xfShow;
Global toggleButton xfLayer;
Global Group xfGrp;

Global Slider xSlider;
Global animatedLayer xAnim; 
Global ConfigAttribute ca_gbmode;
Global layout main;
Global Timer tmr;

Global Slider Seek;
Global text Songticker;

Global ConfigAttribute ca_videofix;
Global string vidfix;
Global group butg;

System.onScriptLoaded() {
	main=getContainer("main").getLayout("normal");
	butg=main.getObject("player.main.cms");

	seek = main.findObject("seekghost");
	songticker = main.findObject("songticker");

	ca_gbmode = Config.getItemByGuid("{E9C2D926-53CA-400f-9A4D-85E31755A4CF}").getAttribute("Vortex_Glowmode");
	ca_videofix = Config.getItem("SkinTweaks").getAttribute("Prevent video playback Stop on video window Close");

	vidfix = ca_videofix.getData();
	ca_videofix.setData("1");
//	messagebox(ca_videofix.getData(),"",1,"");

	xfGrp=main.getObject("xfade.slider");
	xSlider=xfGrp.getObject("xfade.control");
	xAnim=xfGrp.getObject("slider.layer");

	xSlider.onPostedPosition(NULL);

	leftSub=butg.getObject("anim.sub.left");
	rightSub=butg.getObject("anim.sub.right");
	leftBass=butg.getObject("anim.bass.left");
	leftTreble=butg.getObject("anim.treble.left");
	rightBass=butg.getObject("anim.bass.right");
	rightTreble=butg.getObject("anim.treble.right");
	sTog=butg.getObject("speaker.toggle");

	sonicEffectRefresh=new Timer;
	sonicEffectRefresh.setDelay(0.1);

	xfLayer=butg.getObject("crossfade");

	leftSub.stop();
	rightSub.stop();
	
	stop=butg.getObject("stop");
	stopH=butg.getObject("stop.hover");

	play=butg.getObject("play");

	pause=butg.getObject("pause");
	playH=butg.getObject("pp.hover");

	next=butg.getObject("next");
	nextH=butg.getObject("next.hover");

	prev=butg.getObject("rev");
	prevH=butg.getObject("prev.hover");

	eject=butg.getObject("eject");
	ejectH=butg.getObject("eject.hover");

	play.hide();
	pause.hide();
	
	if(System.getStatus()==1) {
		playPause(1);
	} else if(System.getStatus()==0) {
		playPause(0);
	} else if(System.getStatus()==(-1)) {
		playPause(0);
	}

	System.setPrivateInt("vortex", "hoverEffect", 2);

	xfShow = New Timer;
	xfShow.setDelay(4000);

	xfGrp.hide();

	if(System.getPrivateInt("vortex", "btDrawer", 0)==1) {		
		ssx=1;
		leftSub.setStartFrame(0);
		leftSub.setEndFrame(9);
		rightSub.setStartFrame(0);
		rightSub.setEndFrame(9);
		leftSub.play();
		rightSub.play();
		sonicEffectRefresh.start();
	} else if(System.getPrivateInt("vortex", "btDrawer", 0)==0) {
		ssx=0;
		sonicEffectRefresh.stop();
		leftBass.gotoFrame(0);
		leftTreble.gotoFrame(0);
		leftSub.gotoFrame(0);
		rightSub.gotoFrame(0);
	}

/*	  tmr = new Timer;
	  tmr.setDelay(1000);*/
}

System.onScriptUnloading() {
/*	if (tmr) {
		tmr.stop();
		delete tmr;
	}*/
	ca_videofix.setData(vidfix);
}
/*
main.onsetVisible(int v) {
	if (v) tmr.start();
	else tmr.stop();
}

tmr.onTimer() {
	layout l = main;
	int x = l.getGuiX();
	int y = l.getGuiY();
	int h = l.getGuiH();
	int w = l.getGuiW();

	if (x+w < 0 || y+h < 0 || x > getViewPortWidth() || y > getViewPortHeight()) {
		l.center();
	}
	
}*/

stopH.onEnterArea()  {causeGlow(1,GET_HOVER_MODE,0);} //;
stopH.onLeaveArea()  {causeGlow(1,GET_HOVER_MODE,1);} //;
stop.onEnterArea()   {causeGlow(1,GET_HOVER_MODE,0);} //;
stop.onLeaveArea()   {causeGlow(1,GET_HOVER_MODE,1);} //;

playH.onEnterArea()  {causeGlow(2,GET_HOVER_MODE,0);} //;
playH.onLeaveArea()  {causeGlow(2,GET_HOVER_MODE,1);} //;
play.onEnterArea()   {causeGlow(2,GET_HOVER_MODE,0);} //;
play.onLeaveArea()   {causeGlow(2,GET_HOVER_MODE,1);} //;

pause.onEnterArea()  {causeGlow(2,GET_HOVER_MODE,0);} //;
pause.onLeaveArea()  {causeGlow(2,GET_HOVER_MODE,1);} //;

nextH.onEnterArea()  {causeGlow(3,GET_HOVER_MODE,0);} //;
nextH.onLeaveArea()  {causeGlow(3,GET_HOVER_MODE,1);} //;
next.onEnterArea()   {causeGlow(3,GET_HOVER_MODE,0);} //;
next.onLeaveArea()   {causeGlow(3,GET_HOVER_MODE,1);} //;

prevH.onEnterArea()  {causeGlow(4,GET_HOVER_MODE,0);} //;
prevH.onLeaveArea()  {causeGlow(4,GET_HOVER_MODE,1);} //;
prev.onEnterArea()   {causeGlow(4,GET_HOVER_MODE,0);} //;
prev.onLeaveArea()   {causeGlow(4,GET_HOVER_MODE,1);} //;

ejectH.onEnterArea() {causeGlow(5,GET_HOVER_MODE,0);} //;
ejectH.onLeaveArea() {causeGlow(5,GET_HOVER_MODE,1);} //;
eject.onEnterArea()  {causeGlow(5,GET_HOVER_MODE,0);} //;
eject.onLeaveArea()  {causeGlow(5,GET_HOVER_MODE,1);} //;

System.onPlay() {playPause(1);}

/*play.onRightClick() {	
	complete;
	Popupmenu hoverMode;
	hovermode = new Popupmenu;
	hovermode.addCommand("Select Hover Mode", 0, 0, 1);
	hovermode.addSeparator();
	hovermode.addCommand("Blink Fade", 1, 0, 0);
	hovermode.addCommand("Fade in/out", 2, 0, 0);
	hovermode.addCommand("Fade Blink", 3, 0, 0);
	System.setPrivateInt("vortex", "hovereffect", hovermode.popAtMouse());	
	delete hovermode;
}*/

System.onPause() {playPause(0);} //;
System.onStop() {playPause(0);} //;
System.onResume() {playPause(1);} //;

sTog.onLeftButtonUp(int x, int y) {
	if(ssx==0) {
		leftSub.setStartFrame(0);
		leftSub.setEndFrame(9);
		rightSub.setStartFrame(0);
		rightSub.setEndFrame(9);
		leftSub.play();
		rightSub.play();
		ssx=1;
		System.setPrivateInt("vortex", "btDrawer", 1);
		sonicEffectRefresh.start();
	} else if(ssx==1) {
		sonicEffectRefresh.stop();
		leftBass.gotoFrame(0);
		leftTreble.gotoFrame(0);
		rightBass.gotoFrame(0);
		rightTreble.gotoFrame(0);		
		leftSub.setStartFrame(9);
		leftSub.setEndFrame(18);
		rightSub.setStartFrame(9);
		rightSub.setEndFrame(18);
		leftSub.play();
		rightSub.play();
		ssx=0;
		System.setPrivateInt("vortex", "btDrawer", 0);
	}
}

sonicEffectRefresh.onTimer() {
	leftBass.gotoFrame(getBass()/255*leftBass.getLength());
	leftTreble.gotoFrame(getTreble()/255*leftTreble.getLength());

	rightBass.gotoFrame(getBass()/255*leftBass.getLength());
	rightTreble.gotoFrame(getTreble()/255*leftTreble.getLength());
}

									/*
+===========================================+  +======================================+
|General Information for causeGlow()        |  |Mode value table for causeGlow()      |
+-------------------------------------------+  +--------------------------------------+
|obj(integer) : The integer value for the   |  |Value  | Mode                         |
|               object.                     |  |-------+------------------------------+
+-------------------------------------------+  |1      | Blink fade(A fade style in   |
|mode(integer) : The integer value of the   |  |       | which the layer blinks first |
|                hover Effect mode          |  |       | and then fades out)          |   
+-------------------------------------------+  +-------+------------------------------+
|reverse(boolean) : Whether to reverse the  |  |2      | Fade in/out(Fades on mouse   |
|                   the hover effect        |  |       | in and fades out on mouse out|
+-------------------------------------------+  +-------+------------------------------+
|Integer object table                       |  |3      | Fade Blink(Fades first and   |
+-------------------------------------------+  |       | blinks on mouse out)         |
|Value |             Object                 |  +-------+------------------------------+
+------+------------------------------------+  |4      | animatH(Playes an            |
|1     | Stop                               |  |       | animatedLayer on Top of the  |
|2     | Play                               |  |       | button on mouse in and hides |
|3     | Next                               |  |       | ot on mouseOut)              |
|4     | Previous                           |  +-------+------------------------------+
|5     | Open(Eject) Button                 |  |5      | Not implemented yet          |
+===========================================+  +======================================+
									*/

causeGlow(int obj, int mode, boolean reverse) {
	if(mode==0) return;
	if(mode==1) {
		if(obj==1) {
			if(reverse) {
				stopH.cancelTarget();
				stopH.setTargetA(0);
				stopH.setTargetSpeed(1);
				stopH.gotoTarget();
			} else if(!reverse) {
				stopH.setAlpha(255);
			}
		} else if(obj==2) {
			if(reverse) {
				playH.cancelTarget();
				playH.setTargetA(0);
				playH.setTargetSpeed(1);
				playH.gotoTarget();
			} else if(!reverse) {
				playH.setAlpha(255);
			}
		} else if(obj==3) {
			if(reverse) {
				nextH.cancelTarget();
				nextH.setTargetA(0);
				nextH.setTargetSpeed(1);
				nextH.gotoTarget();
			} else if(!reverse) {
				nextH.setAlpha(255);
			}
		} else if(obj==4) {
			if(reverse) {
				prevH.cancelTarget();
				prevH.setTargetA(0);
				prevH.setTargetSpeed(1);
				prevH.gotoTarget();
			} else if(!reverse) {
				prevH.setAlpha(255);
			}
		} else if(obj==5) {
			if(reverse) {
				ejectH.cancelTarget();
				ejectH.setTargetA(0);
				ejectH.setTargetSpeed(1);
				ejectH.gotoTarget();
			} else if(!reverse) {
				ejectH.setAlpha(255);
			}
		}
	} else if(mode==2) {
		if(obj==1) {
			if(reverse) {
				stopH.cancelTarget();
				stopH.setTargetA(0);
				stopH.setTargetSpeed(0.5);
				stopH.gotoTarget();
			} else if(!reverse) {
				stopH.cancelTarget();
				stopH.setTargetA(255);
				stopH.setTargetSpeed(0.5);
				stopH.gotoTarget();
			}
		} else if(obj==2) {
			if(reverse) {
				playH.cancelTarget();
				playH.setTargetA(0);
				playH.setTargetSpeed(0.5);
				playH.gotoTarget();
			} else if(!reverse) {
				playH.cancelTarget();
				playH.setTargetA(255);
				playH.setTargetSpeed(0.5);
				playH.gotoTarget();
			}
		} else if(obj==3) {
			if(reverse) {
				nextH.cancelTarget();
				nextH.setTargetA(0);
				nextH.setTargetSpeed(0.5);
				nextH.gotoTarget();
			} else if(!reverse) {
				nextH.cancelTarget();
				nextH.setTargetA(255);
				nextH.setTargetSpeed(0.5);
				nextH.gotoTarget();
			}
		} else if(obj==4) {
			if(reverse) {
				prevH.cancelTarget();
				prevH.setTargetA(0);
				prevH.setTargetSpeed(0.5);
				prevH.gotoTarget();
			} else if(!reverse) {
				prevH.cancelTarget();
				prevH.setTargetA(255);
				prevH.setTargetSpeed(0.5);
				prevH.gotoTarget();
			}
		} else if(obj==5) {
			if(reverse) {
				ejectH.cancelTarget();
				ejectH.setTargetA(0);
				ejectH.setTargetSpeed(0.5);
				ejectH.gotoTarget();
			} else if(!reverse) {
				ejectH.cancelTarget();
				ejectH.setTargetA(255);
				ejectH.setTargetSpeed(0.5);
				ejectH.gotoTarget();
			}
		}		
	} else if(mode==3) {
		if(obj==1) {
			if(reverse) {
				stopH.setAlpha(0);
			} else if(!reverse) {
				stopH.cancelTarget();
				stopH.setTargetA(255);
				stopH.setTargetSpeed(0.5);
				stopH.gotoTarget();
			}
		} else if(obj==2) {
			if(reverse) {
				playH.setAlpha(0);
			} else if(!reverse) {
				playH.cancelTarget();
				playH.setTargetA(255);
				playH.setTargetSpeed(0.5);
				playH.gotoTarget();
			}
		} else if(obj==3) {
			if(reverse) {
				nextH.setAlpha(0);
			} else if(!reverse) {
				nextH.cancelTarget();
				nextH.setTargetA(255);
				nextH.setTargetSpeed(0.5);
				nextH.gotoTarget();
			}
		} else if(obj==4) {
			if(reverse) {
				prevH.setAlpha(0);
			} else if(!reverse) {
				prevH.cancelTarget();
				prevH.setTargetA(255);
				prevH.setTargetSpeed(0.5);
				prevH.gotoTarget();
			}
		} else if(obj==5) {
			if(reverse) {
				ejectH.setAlpha(0);
			} else if(!reverse) {
				ejectH.cancelTarget();
				ejectH.setTargetA(255);
				ejectH.setTargetSpeed(0.5);
				ejectH.gotoTarget();
			}
		}
	}
}

stopH.onTargetReached() { 
	if(sH==1) {
		stopH.setTargetA(0);
		stopH.setTargetSpeed(0.5);
		stopH.gotoTarget();
	}
}

playPause(boolean revp) {
	if(revp) {
		playH.setXMLParam("image", "player.main.playHp");
		pause.hide();
		play.hide();
		play.hide();
		pause.show();
	} else if(!revp) {
		playH.setXMLParam("image", "player.main.playH");
		pause.hide();
		play.hide();
		pause.hide();
		play.show();
	}
}

Int getBass() {
	int bass;
	for (int i = 0; i < 5; i++) {
		bass += System.getVisBand(0, i);
	}
	bass=bass/5;
	return bass;
}

Int getTreble() {
	int treble;
	for (int i = 0; i < 6; i++) {
		treble += System.getVisBand(0, 75 - i * 2);
	}
	treble /= 5;
	return treble;
}

xfLayer.onRightButtonUp(int x, int y) {
	xfGrp.show();
	complete;
	xfShow.start();
}

xfShow.onTimer() {
	xfGrp.hide();
}

xSlider.onPostedPosition(int newpos) {
	xAnim.gotoFrame((PERCENTAGE_XFADE/100)*xAnim.getEndFrame());
}

xSlider.onSetFinalPosition(int newpos) {
	xSlider.onPostedPosition(newpos);
}

xSlider.onSetPosition(int newpos) {
	xSlider.onPostedPosition(newpos);
}

seek.onsetPosition(int newpos) {
	Songticker.sendAction("setText", "Seek to: " + System.integerToTime(newpos/255*getPlayitemLength()) + "/" + integerToTime(getPlayitemLength()), 0, 0, 0, 0);
}
package meta.substates;

import openfl.Lib;
import game.Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.FlxSubState;
import game.Conductor;

class MusicBeatSubstate extends FlxSubState
{
	public static var instance:MusicBeatSubstate;
	public static var subInstance:MusicBeatSubstate; //idk

	#if mobile
	public var mobileManager:MobileControlManager;
	public inline function mobileButtonJustPressed(buttons:Dynamic):Bool {
		#if MOBILE_CONTROLS_ALLOWED
		return mobileManager.mobilePad.justPressed(buttons);
		#else
		return false;
		#end
	}
	public inline function mobileButtonPressed(buttons:Dynamic):Bool {
		#if MOBILE_CONTROLS_ALLOWED
		return mobileManager.mobilePad.pressed(buttons);
		#else
		return false;
		#end
	}
	public inline function mobileButtonReleased(buttons:Dynamic):Bool {
		#if MOBILE_CONTROLS_ALLOWED
		return mobileManager.mobilePad.justReleased(buttons);
		#else
		return false;
		#end
	}
	#end
	public function new()
	{
		#if MOBILE_CONTROLS_ALLOWED
		if (controls.isInSubSubstate)
			subInstance = this;
		else
		#end
			instance = this;

		#if mobile
		#if MOBILE_CONTROLS_ALLOWED
		controls.isInSubstate = true;
		#end
		mobileManager = new MobileControlManager(this);
		#end
		super();
	}
	override function destroy() {
		#if mobile
		if (mobileManager != null) mobileManager.destroy();
		#end
		#if MOBILE_CONTROLS_ALLOWED
		controls.isInSubstate = false;
		#end
		instance = null;
		super.destroy();
	}

	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var controls(get, never):game.Controls;

	inline function get_controls():game.Controls
		return game.cdev.engineutils.PlayerSettings.player1.controls;

	override function update(elapsed:Float)
	{
		// everyStep();
		var oldStep:Int = curStep;

		updateCurStep();
		curBeat = Math.floor(curStep / 4);

		if (oldStep != curStep && curStep > 0)
			stepHit();

		if (FlxG.keys.justPressed.F11)
			FlxG.fullscreen = !FlxG.fullscreen;

		super.update(elapsed);
	}

	override function onFocus()
	{
		super.onFocus();
		CDevConfig.setFPS(CDevConfig.saveData.fpscap);
	}

	private function updateCurStep():Void
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (Conductor.songPosition + CDevConfig.saveData.offset >= Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition + CDevConfig.saveData.offset - lastChange.songTime) / Conductor.stepCrochet);
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		// do literally nothing dumbass
	}
}

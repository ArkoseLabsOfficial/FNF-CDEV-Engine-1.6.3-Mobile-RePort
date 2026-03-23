package game;

#if android
import flixel.input.android.FlxAndroidKey;
#end
import flixel.FlxG;
import flixel.input.FlxInput;
import flixel.input.actions.FlxAction;
import flixel.input.actions.FlxActionInput;
import flixel.input.actions.FlxActionInputDigital;
import flixel.input.actions.FlxActionManager;
import flixel.input.actions.FlxActionSet;
import flixel.input.gamepad.FlxGamepadButton;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.keyboard.FlxKey;
import meta.substates.MusicBeatSubstate;
import meta.states.MusicBeatState;

#if (haxe >= "4.1.0")
enum abstract Action(String) to String from String
{
	// GAMEPLAY //
	var UP = "up";
	var LEFT = "left";
	var RIGHT = "right";
	var DOWN = "down";
	var UP_P = "up-press";
	var LEFT_P = "left-press";
	var RIGHT_P = "right-press";
	var DOWN_P = "down-press";
	var UP_R = "up-release";
	var LEFT_R = "left-release";
	var RIGHT_R = "right-release";
	var DOWN_R = "down-release";

	// UI //
	var UI_UP = "up";
	var UI_LEFT = "left";
	var UI_RIGHT = "right";
	var UI_DOWN = "down";
	var UI_UP_P = "up-press";
	var UI_LEFT_P = "left-press";
	var UI_RIGHT_P = "right-press";
	var UI_DOWN_P = "down-press";
	var UI_UP_R = "up-release";
	var UI_LEFT_R = "left-release";
	var UI_RIGHT_R = "right-release";
	var UI_DOWN_R = "down-release";

	// MAIN //
	var ACCEPT = "accept";
	var BACK = "back";
	var PAUSE = "pause";
	var RESET = "reset";
	var CHEAT = "cheat";
}
#else
@:enum
abstract Action(String) to String from String
{
	// GAMEPLAY //
	var UP = "up";
	var LEFT = "left";
	var RIGHT = "right";
	var DOWN = "down";
	var UP_P = "up-press";
	var LEFT_P = "left-press";
	var RIGHT_P = "right-press";
	var DOWN_P = "down-press";
	var UP_R = "up-release";
	var LEFT_R = "left-release";
	var RIGHT_R = "right-release";
	var DOWN_R = "down-release";

	// UI //
	var UI_UP = "up";
	var UI_LEFT = "left";
	var UI_RIGHT = "right";
	var UI_DOWN = "down";
	var UI_UP_P = "up-press";
	var UI_LEFT_P = "left-press";
	var UI_RIGHT_P = "right-press";
	var UI_DOWN_P = "down-press";
	var UI_UP_R = "up-release";
	var UI_LEFT_R = "left-release";
	var UI_RIGHT_R = "right-release";
	var UI_DOWN_R = "down-release";

	// MAIN //
	var ACCEPT = "accept";
	var BACK = "back";
	var PAUSE = "pause";
	var RESET = "reset";
	var CHEAT = "cheat";
}
#end

enum Device
{
	Keys;
	Gamepad(id:Int);
}

/**
 * Since, in many cases multiple actions should use similar keys, we don't want the
 * rebinding UI to list every action. ActionBinders are what the user percieves as
 * an input so, for instance, they can't set jump-press and jump-release to different keys.
 */
enum Control
{
	UP;
	LEFT;
	RIGHT;
	DOWN;

	// new
	UI_UP;
	UI_LEFT;
	UI_RIGHT;
	UI_DOWN;

	RESET;
	ACCEPT;
	BACK;
	PAUSE;
	CHEAT;
}

enum KeyboardScheme
{
	Solo;
	Duo(first:Bool);
	None;
	Custom;
}

/**
 * A list of actions that a player would invoke via some input device.
 * Uses FlxActions to funnel various inputs to a single action.
 */
class Controls extends FlxActionSet
{
	// GAMEPLAY //
	// HOLD
	var _up = new FlxActionDigital(Action.UP);
	var _left = new FlxActionDigital(Action.LEFT);
	var _right = new FlxActionDigital(Action.RIGHT);
	var _down = new FlxActionDigital(Action.DOWN);
	// PRESS
	var _upP = new FlxActionDigital(Action.UP_P);
	var _leftP = new FlxActionDigital(Action.LEFT_P);
	var _rightP = new FlxActionDigital(Action.RIGHT_P);
	var _downP = new FlxActionDigital(Action.DOWN_P);
	// RELEASE
	var _upR = new FlxActionDigital(Action.UP_R);
	var _leftR = new FlxActionDigital(Action.LEFT_R);
	var _rightR = new FlxActionDigital(Action.RIGHT_R);
	var _downR = new FlxActionDigital(Action.DOWN_R);

	// UI //
	// HOLD
	var _ui_up = new FlxActionDigital(Action.UP);
	var _ui_left = new FlxActionDigital(Action.LEFT);
	var _ui_right = new FlxActionDigital(Action.RIGHT);
	var _ui_down = new FlxActionDigital(Action.DOWN);
	// PRESS
	var _ui_upP = new FlxActionDigital(Action.UP_P);
	var _ui_leftP = new FlxActionDigital(Action.LEFT_P);
	var _ui_rightP = new FlxActionDigital(Action.RIGHT_P);
	var _ui_downP = new FlxActionDigital(Action.DOWN_P);
	// RELEASE
	var _ui_upR = new FlxActionDigital(Action.UP_R);
	var _ui_leftR = new FlxActionDigital(Action.LEFT_R);
	var _ui_rightR = new FlxActionDigital(Action.RIGHT_R);
	var _ui_downR = new FlxActionDigital(Action.DOWN_R);

	// MAIN //
	var _accept = new FlxActionDigital(Action.ACCEPT);
	var _back = new FlxActionDigital(Action.BACK);
	var _pause = new FlxActionDigital(Action.PAUSE);
	var _reset = new FlxActionDigital(Action.RESET);
	var _cheat = new FlxActionDigital(Action.CHEAT);

	#if (haxe >= "4.0.0")
	var byName:Map<String, FlxActionDigital> = [];
	#else
	var byName:Map<String, FlxActionDigital> = new Map<String, FlxActionDigital>();
	#end

	public var gamepadsAdded:Array<Int> = [];
	public var keyboardScheme = KeyboardScheme.None;

	public var UP(get, never):Bool;

	inline function get_UP()
		return _up.check() #if MOBILE_CONTROLS_ALLOWED || hitboxPressed(['NOTE_UP']) #end;

	public var LEFT(get, never):Bool;

	inline function get_LEFT()
		return _left.check() #if MOBILE_CONTROLS_ALLOWED || hitboxPressed(['NOTE_LEFT']) #end;

	public var RIGHT(get, never):Bool;

	inline function get_RIGHT()
		return _right.check() #if MOBILE_CONTROLS_ALLOWED || hitboxPressed(['NOTE_RIGHT']) #end;

	public var DOWN(get, never):Bool;

	inline function get_DOWN()
		return _down.check() #if MOBILE_CONTROLS_ALLOWED || hitboxPressed(['NOTE_DOWN']) #end;

	public var UP_P(get, never):Bool;

	inline function get_UP_P()
		return _upP.check() #if MOBILE_CONTROLS_ALLOWED || hitboxJustPressed(['NOTE_UP']) #end;

	public var LEFT_P(get, never):Bool;

	inline function get_LEFT_P()
		return _leftP.check() #if MOBILE_CONTROLS_ALLOWED || hitboxJustPressed(['NOTE_LEFT']) #end;

	public var RIGHT_P(get, never):Bool;

	inline function get_RIGHT_P()
		return _rightP.check() #if MOBILE_CONTROLS_ALLOWED || hitboxJustPressed(['NOTE_RIGHT']) #end;

	public var DOWN_P(get, never):Bool;

	inline function get_DOWN_P()
		return _downP.check() #if MOBILE_CONTROLS_ALLOWED || hitboxJustPressed(['NOTE_DOWN']) #end;

	public var UP_R(get, never):Bool;

	inline function get_UP_R()
		return _upR.check() #if MOBILE_CONTROLS_ALLOWED || hitboxJustReleased(['NOTE_UP']) #end;

	public var LEFT_R(get, never):Bool;

	inline function get_LEFT_R()
		return _leftR.check() #if MOBILE_CONTROLS_ALLOWED || hitboxJustReleased(['NOTE_LEFT']) #end;

	public var RIGHT_R(get, never):Bool;

	inline function get_RIGHT_R()
		return _rightR.check() #if MOBILE_CONTROLS_ALLOWED || hitboxJustReleased(['NOTE_RIGHT']) #end;

	public var DOWN_R(get, never):Bool;

	inline function get_DOWN_R()
		return _downR.check() #if MOBILE_CONTROLS_ALLOWED || hitboxJustReleased(['NOTE_DOWN']) #end;

	// UI CONTROLS DANG IT //
	public var UI_UP(get, never):Bool;

	inline function get_UI_UP()
		return _ui_up.check() #if MOBILE_CONTROLS_ALLOWED || mobilePadPressed(['UP']) #end;

	public var UI_LEFT(get, never):Bool;

	inline function get_UI_LEFT()
		return _ui_left.check() #if MOBILE_CONTROLS_ALLOWED || mobilePadPressed(['LEFT']) #end;

	public var UI_RIGHT(get, never):Bool;

	inline function get_UI_RIGHT()
		return _ui_right.check() #if MOBILE_CONTROLS_ALLOWED || mobilePadPressed(['RIGHT']) #end;

	public var UI_DOWN(get, never):Bool;

	inline function get_UI_DOWN()
		return _ui_down.check() #if MOBILE_CONTROLS_ALLOWED || mobilePadPressed(['DOWN']) #end;

	public var UI_UP_P(get, never):Bool;

	inline function get_UI_UP_P()
		return _ui_upP.check() #if MOBILE_CONTROLS_ALLOWED || mobilePadJustPressed(['UP']) #end;

	public var UI_LEFT_P(get, never):Bool;

	inline function get_UI_LEFT_P()
		return _ui_leftP.check() #if MOBILE_CONTROLS_ALLOWED || mobilePadJustPressed(['LEFT']) #end;

	public var UI_RIGHT_P(get, never):Bool;

	inline function get_UI_RIGHT_P()
		return _ui_rightP.check() #if MOBILE_CONTROLS_ALLOWED || mobilePadJustPressed(['RIGHT']) #end;

	public var UI_DOWN_P(get, never):Bool;

	inline function get_UI_DOWN_P()
		return _ui_downP.check() #if MOBILE_CONTROLS_ALLOWED || mobilePadJustPressed(['DOWN']) #end;

	public var UI_UP_R(get, never):Bool;

	inline function get_UI_UP_R()
		return _ui_upR.check() #if MOBILE_CONTROLS_ALLOWED || mobilePadJustReleased(['UP']) #end;

	public var UI_LEFT_R(get, never):Bool;

	inline function get_UI_LEFT_R()
		return _ui_leftR.check() #if MOBILE_CONTROLS_ALLOWED || mobilePadJustReleased(['LEFT']) #end;

	public var UI_RIGHT_R(get, never):Bool;

	inline function get_UI_RIGHT_R()
		return _ui_rightR.check() #if MOBILE_CONTROLS_ALLOWED || mobilePadJustReleased(['RIGHT']) #end;

	public var UI_DOWN_R(get, never):Bool;

	inline function get_UI_DOWN_R()
		return _ui_downR.check() #if MOBILE_CONTROLS_ALLOWED || mobilePadJustReleased(['DOWN']) #end;

	/////////////////////////////////////
	public var ACCEPT(get, never):Bool;

	inline function get_ACCEPT()
		return _accept.check() #if MOBILE_CONTROLS_ALLOWED || mobilePadJustPressed(['A']) #end;

	public var BACK(get, never):Bool;

	inline function get_BACK()
		return _back.check() #if mobile || checkBackButton() #end #if MOBILE_CONTROLS_ALLOWED || mobilePadJustPressed(['B']) #end;

	public var PAUSE(get, never):Bool;

	inline function get_PAUSE()
		return _pause.check() #if MOBILE_CONTROLS_ALLOWED || mobilePadJustPressed(['P']) #end;

	public var RESET(get, never):Bool;

	inline function get_RESET()
		return _reset.check();

	public var CHEAT(get, never):Bool;

	inline function get_CHEAT()
		return _cheat.check();

	#if (haxe >= "4.0.0")
	public function new(name, scheme = None)
	{
		super(name);

		add(_up);
		add(_left);
		add(_right);
		add(_down);
		add(_upP);
		add(_leftP);
		add(_rightP);
		add(_downP);
		add(_upR);
		add(_leftR);
		add(_rightR);

		add(_ui_up);
		add(_ui_left);
		add(_ui_right);
		add(_ui_down);
		add(_ui_upP);
		add(_ui_leftP);
		add(_ui_rightP);
		add(_ui_downP);
		add(_ui_upR);
		add(_ui_leftR);
		add(_ui_rightR);

		add(_downR);
		add(_accept);
		add(_back);
		add(_pause);
		add(_reset);
		add(_cheat);

		for (action in digitalActions)
			byName[action.name] = action;

		setKeyboardScheme(scheme, false);
	}
	#else
	public function new(name, scheme:KeyboardScheme = null)
	{
		super(name);

		add(_up);
		add(_left);
		add(_right);
		add(_down);
		add(_upP);
		add(_leftP);
		add(_rightP);
		add(_downP);
		add(_upR);
		add(_leftR);
		add(_rightR);

		add(_ui_up);
		add(_ui_left);
		add(_ui_right);
		add(_ui_down);
		add(_ui_upP);
		add(_ui_leftP);
		add(_ui_rightP);
		add(_ui_downP);
		add(_ui_upR);
		add(_ui_leftR);
		add(_ui_rightR);

		add(_downR);
		add(_accept);
		add(_back);
		add(_pause);
		add(_reset);
		add(_cheat);

		for (action in digitalActions)
			byName[action.name] = action;

		if (scheme == null)
			scheme = None;
		setKeyboardScheme(scheme, false);
	}
	#end

	override function update()
	{
		super.update();
	}

	// inline
	public function checkByName(name:Action):Bool
	{
		#if debug
		if (!byName.exists(name))
			throw 'Invalid name: $name';
		#end
		return byName[name].check();
	}

	public function getDialogueName(action:FlxActionDigital):String
	{
		var input = action.inputs[0];
		return switch input.device
		{
			case KEYBOARD: return '[${(input.inputID : FlxKey)}]';
			case GAMEPAD: return '(${(input.inputID : FlxGamepadInputID)})';
			case device: throw 'unhandled device: $device';
		}
	}

	public function getDialogueNameFromToken(token:String):String
	{
		return getDialogueName(getActionFromControl(Control.createByName(token.toUpperCase())));
	}

	function getActionFromControl(control:Control):FlxActionDigital
	{
		return switch (control)
		{
			case UP: _up;
			case DOWN: _down;
			case LEFT: _left;
			case RIGHT: _right;

			case UI_UP: _ui_up;
			case UI_DOWN: _ui_down;
			case UI_LEFT: _ui_left;
			case UI_RIGHT: _ui_right;

			case ACCEPT: _accept;
			case BACK: _back;
			case PAUSE: _pause;
			case RESET: _reset;
			case CHEAT: _cheat;
		}
	}

	static function init():Void
	{
		var actions = new FlxActionManager();
		FlxG.inputs.add(actions);
	}

	/**
	 * Calls a function passing each action bound by the specified control
	 * @param control
	 * @param func
	 * @return ->Void)
	 */
	function forEachBound(control:Control, func:FlxActionDigital->FlxInputState->Void)
	{
		switch (control)
		{
			case UP:
				func(_up, PRESSED);
				func(_upP, JUST_PRESSED);
				func(_upR, JUST_RELEASED);
			case LEFT:
				func(_left, PRESSED);
				func(_leftP, JUST_PRESSED);
				func(_leftR, JUST_RELEASED);
			case RIGHT:
				func(_right, PRESSED);
				func(_rightP, JUST_PRESSED);
				func(_rightR, JUST_RELEASED);
			case DOWN:
				func(_down, PRESSED);
				func(_downP, JUST_PRESSED);
				func(_downR, JUST_RELEASED);

			case UI_UP:
				func(_ui_up, PRESSED);
				func(_ui_upP, JUST_PRESSED);
				func(_ui_upR, JUST_RELEASED);
			case UI_LEFT:
				func(_ui_left, PRESSED);
				func(_ui_leftP, JUST_PRESSED);
				func(_ui_leftR, JUST_RELEASED);
			case UI_RIGHT:
				func(_ui_right, PRESSED);
				func(_ui_rightP, JUST_PRESSED);
				func(_ui_rightR, JUST_RELEASED);
			case UI_DOWN:
				func(_ui_down, PRESSED);
				func(_ui_downP, JUST_PRESSED);
				func(_ui_downR, JUST_RELEASED);

			case ACCEPT:
				func(_accept, JUST_PRESSED);
			case BACK:
				func(_back, JUST_PRESSED);
			case PAUSE:
				func(_pause, JUST_PRESSED);
			case RESET:
				func(_reset, JUST_PRESSED);
			case CHEAT:
				func(_cheat, JUST_PRESSED);
		}
	}

	public function replaceBinding(control:Control, device:Device, ?toAdd:Int, ?toRemove:Int)
	{
		if (toAdd == toRemove)
			return;

		switch (device)
		{
			case Keys:
				if (toRemove != null)
					unbindKeys(control, [toRemove]);
				if (toAdd != null)
					bindKeys(control, [toAdd]);

			case Gamepad(id):
				if (toRemove != null)
					unbindButtons(control, id, [toRemove]);
				if (toAdd != null)
					bindButtons(control, id, [toAdd]);
		}
	}

	public function copyFrom(controls:Controls, ?device:Device)
	{
		#if (haxe >= "4.0.0")
		for (name => action in controls.byName)
		{
			for (input in action.inputs)
			{
				if (device == null || isDevice(input, device))
					byName[name].add(cast input);
			}
		}
		#else
		for (name in controls.byName.keys())
		{
			var action = controls.byName[name];
			for (input in action.inputs)
			{
				if (device == null || isDevice(input, device))
					byName[name].add(cast input);
			}
		}
		#end

		switch (device)
		{
			case null:
				// add all
				#if (haxe >= "4.0.0")
				for (gamepad in controls.gamepadsAdded)
					if (!gamepadsAdded.contains(gamepad))
						gamepadsAdded.push(gamepad);
				#else
				for (gamepad in controls.gamepadsAdded)
					if (gamepadsAdded.indexOf(gamepad) == -1)
						gamepadsAdded.push(gamepad);
				#end

				mergeKeyboardScheme(controls.keyboardScheme);

			case Gamepad(id):
				gamepadsAdded.push(id);
			case Keys:
				mergeKeyboardScheme(controls.keyboardScheme);
		}
	}

	inline public function copyTo(controls:Controls, ?device:Device)
	{
		controls.copyFrom(this, device);
	}

	function mergeKeyboardScheme(scheme:KeyboardScheme):Void
	{
		if (scheme != None)
		{
			switch (keyboardScheme)
			{
				case None:
					keyboardScheme = scheme;
				default:
					keyboardScheme = Custom;
			}
		}
	}

	/**
	 * Sets all actions that pertain to the binder to trigger when the supplied keys are used.
	 * If binder is a literal you can inline this
	 */
	public function bindKeys(control:Control, keys:Array<FlxKey>)
	{
		#if (haxe >= "4.0.0")
		inline forEachBound(control, (action, state) -> addKeys(action, keys, state));
		#else
		forEachBound(control, function(action, state) addKeys(action, keys, state));
		#end
	}

	#if android
	public function bindAndroidKey(control:Control, keys:Array<FlxAndroidKey>)
	{
		#if (haxe >= "4.0.0")
		inline forEachBound(control, (action, state) -> addAndroidKeys(action, keys, state));
		#else
		forEachBound(control, function(action, state) addAndroidKeys(action, keys, state));
		#end
	}
	#end

	/**
	 * Sets all actions that pertain to the binder to trigger when the supplied keys are used.
	 * If binder is a literal you can inline this
	 */
	public function unbindKeys(control:Control, keys:Array<FlxKey>)
	{
		#if (haxe >= "4.0.0")
		inline forEachBound(control, (action, _) -> removeKeys(action, keys));
		#else
		forEachBound(control, function(action, _) removeKeys(action, keys));
		#end
	}

	inline static function addKeys(action:FlxActionDigital, keys:Array<FlxKey>, state:FlxInputState)
	{
		for (key in keys)
			action.addKey(key, state);
	}
	#if android
	inline static function addAndroidKeys(action:FlxActionDigital, keys:Array<FlxAndroidKey>, state:FlxInputState)
	{
		for (key in keys)
			action.addAndroidKey(key, state);
	}
	#end

	static function removeKeys(action:FlxActionDigital, keys:Array<FlxKey>)
	{
		var i = action.inputs.length;
		while (i-- > 0)
		{
			var input = action.inputs[i];
			if (input.device == KEYBOARD && keys.indexOf(cast input.inputID) != -1)
				action.remove(input);
		}
	}

	public function setKeyboardScheme(scheme:KeyboardScheme, reset = true)
	{
		loadKeyBinds();
	}

	public function loadKeyBinds()
	{
		// trace(FlxKey.fromString(CDevConfig.saveData.upBind));

		removeKeyboard();

		var save:Dynamic = game.cdev.CDevConfig.saveData;

		inline bindKeys(Control.UP, [FlxKey.fromString(save.upBind), FlxKey.UP]);
		inline bindKeys(Control.DOWN, [FlxKey.fromString(save.downBind), FlxKey.DOWN]);
		inline bindKeys(Control.LEFT, [FlxKey.fromString(save.leftBind), FlxKey.LEFT]);
		inline bindKeys(Control.RIGHT, [FlxKey.fromString(save.rightBind), FlxKey.RIGHT]);

		inline bindKeys(Control.UI_UP, [FlxKey.fromString(save.ui_upBind[0]), FlxKey.UP]);
		inline bindKeys(Control.UI_DOWN, [FlxKey.fromString(save.ui_downBind[0]), FlxKey.DOWN]);
		inline bindKeys(Control.UI_LEFT, [FlxKey.fromString(save.ui_leftBind[0]), FlxKey.LEFT]);
		inline bindKeys(Control.UI_RIGHT, [FlxKey.fromString(save.ui_rightBind[0]), FlxKey.RIGHT]);

		inline bindKeys(Control.ACCEPT, [FlxKey.fromString(save.acceptBind[0]), FlxKey.fromString(save.acceptBind[1])]);
		inline bindKeys(Control.BACK, [FlxKey.fromString(save.backBind[0]), FlxKey.fromString(save.backBind[1])]);
		inline bindKeys(Control.PAUSE, [FlxKey.fromString(save.pauseBind[0]), FlxKey.fromString(save.pauseBind[1])]);
		inline bindKeys(Control.RESET, [FlxKey.fromString(save.resetBind[0])]);

		#if android
		inline bindAndroidKey(Control.BACK, [FlxAndroidKey.BACK]);
		#end
	}

	function removeKeyboard()
	{
		for (action in this.digitalActions)
		{
			var i = action.inputs.length;
			while (i-- > 0)
			{
				var input = action.inputs[i];
				if (input.device == KEYBOARD)
					action.remove(input);
			}
		}
	}

	public function addGamepad(id:Int, ?buttonMap:Map<Control, Array<FlxGamepadInputID>>):Void
	{
		gamepadsAdded.push(id);

		#if (haxe >= "4.0.0")
		for (control => buttons in buttonMap)
			inline bindButtons(control, id, buttons);
		#else
		for (control in buttonMap.keys())
			bindButtons(control, id, buttonMap[control]);
		#end
	}

	inline function addGamepadLiteral(id:Int, ?buttonMap:Map<Control, Array<FlxGamepadInputID>>):Void
	{
		gamepadsAdded.push(id);

		#if (haxe >= "4.0.0")
		for (control => buttons in buttonMap)
			inline bindButtons(control, id, buttons);
		#else
		for (control in buttonMap.keys())
			bindButtons(control, id, buttonMap[control]);
		#end
	}

	public function removeGamepad(deviceID:Int = FlxInputDeviceID.ALL):Void
	{
		for (action in this.digitalActions)
		{
			var i = action.inputs.length;
			while (i-- > 0)
			{
				var input = action.inputs[i];
				if (input.device == GAMEPAD && (deviceID == FlxInputDeviceID.ALL || input.deviceID == deviceID))
					action.remove(input);
			}
		}

		gamepadsAdded.remove(deviceID);
	}

	public function addDefaultGamepad(id):Void
	{
		#if !switch
		addGamepadLiteral(id, [
			Control.ACCEPT => [A],
			Control.BACK => [B],
			Control.UP => [DPAD_UP, LEFT_STICK_DIGITAL_UP],
			Control.DOWN => [DPAD_DOWN, LEFT_STICK_DIGITAL_DOWN],
			Control.LEFT => [DPAD_LEFT, LEFT_STICK_DIGITAL_LEFT],
			Control.RIGHT => [DPAD_RIGHT, LEFT_STICK_DIGITAL_RIGHT],
			Control.PAUSE => [START],
			Control.RESET => [Y]
		]);
		#else
		addGamepadLiteral(id, [
			// Swap A and B for switch
			Control.ACCEPT => [B],
			Control.BACK => [A],
			Control.UP => [DPAD_UP, LEFT_STICK_DIGITAL_UP, RIGHT_STICK_DIGITAL_UP],
			Control.DOWN => [DPAD_DOWN, LEFT_STICK_DIGITAL_DOWN, RIGHT_STICK_DIGITAL_DOWN],
			Control.LEFT => [DPAD_LEFT, LEFT_STICK_DIGITAL_LEFT, RIGHT_STICK_DIGITAL_LEFT],
			Control.RIGHT => [DPAD_RIGHT, LEFT_STICK_DIGITAL_RIGHT, RIGHT_STICK_DIGITAL_RIGHT],
			Control.PAUSE => [START],
			// Swap Y and X for switch
			Control.RESET => [Y],
			Control.CHEAT => [X]
		]);
		#end
	}

	/**
	 * Sets all actions that pertain to the binder to trigger when the supplied keys are used.
	 * If binder is a literal you can inline this
	 */
	public function bindButtons(control:Control, id, buttons)
	{
		#if (haxe >= "4.0.0")
		inline forEachBound(control, (action, state) -> addButtons(action, buttons, state, id));
		#else
		forEachBound(control, function(action, state) addButtons(action, buttons, state, id));
		#end
	}

	/**
	 * Sets all actions that pertain to the binder to trigger when the supplied keys are used.
	 * If binder is a literal you can inline this
	 */
	public function unbindButtons(control:Control, gamepadID:Int, buttons)
	{
		#if (haxe >= "4.0.0")
		inline forEachBound(control, (action, _) -> removeButtons(action, gamepadID, buttons));
		#else
		forEachBound(control, function(action, _) removeButtons(action, gamepadID, buttons));
		#end
	}

	inline static function addButtons(action:FlxActionDigital, buttons:Array<FlxGamepadInputID>, state, id)
	{
		for (button in buttons)
			action.addGamepad(button, state, id);
	}

	static function removeButtons(action:FlxActionDigital, gamepadID:Int, buttons:Array<FlxGamepadInputID>)
	{
		var i = action.inputs.length;
		while (i-- > 0)
		{
			var input = action.inputs[i];
			if (isGamepad(input, gamepadID) && buttons.indexOf(cast input.inputID) != -1)
				action.remove(input);
		}
	}

	public function getInputsFor(control:Control, device:Device, ?list:Array<Int>):Array<Int>
	{
		if (list == null)
			list = [];

		switch (device)
		{
			case Keys:
				for (input in getActionFromControl(control).inputs)
				{
					if (input.device == KEYBOARD)
						list.push(input.inputID);
				}
			case Gamepad(id):
				for (input in getActionFromControl(control).inputs)
				{
					if (input.deviceID == id)
						list.push(input.inputID);
				}
		}
		return list;
	}

	public function removeDevice(device:Device)
	{
		switch (device)
		{
			case Keys:
				setKeyboardScheme(None);
			case Gamepad(id):
				removeGamepad(id);
		}
	}

	static function isDevice(input:FlxActionInput, device:Device)
	{
		return switch device
		{
			case Keys: input.device == KEYBOARD;
			case Gamepad(id): isGamepad(input, id);
		}
	}

	inline static function isGamepad(input:FlxActionInput, deviceID:Int)
	{
		return input.device == GAMEPAD && (deviceID == FlxInputDeviceID.ALL || input.deviceID == deviceID);
	}

	#if MOBILE_CONTROLS_ALLOWED
	public var isInSubstate:Bool = false; // don't worry about this it becomes true and false on it's own in MusicBeatSubstate
	public var isInSubSubstate:Bool = false; // don't worry about this thing is not important
	public var requestedInstance(get, default):Dynamic; // is set to MusicBeatState or MusicBeatSubstate when the constructor is called
	public var requestedHitbox(get, default):FunkinHitbox; // for PlayState and EditorPlayState
	public var requestedMobilePad(get, default):FunkinMobilePad; //for everything ig
	public var mobileControls(get, never):Bool; // this is useless for now
	public var backButtonClicked:Bool = false;
	//global back button function
	private function checkBackButton() {
		if (backButtonClicked) {
			backButtonClicked = false;
			return true;
		} else {
			return false;
		}
	}

	private function mobilePadPressed(keys:Array<String>):Bool
	{
		if (keys != null && requestedMobilePad != null)
			if (requestedMobilePad.pressed(keys) == true)
				return true;

		return false;
	}

	private function mobilePadJustPressed(keys:Array<String>):Bool
	{
		if (keys != null && requestedMobilePad != null)
			if (requestedMobilePad.justPressed(keys) == true)
				return true;

		return false;
	}

	private function mobilePadJustReleased(keys:Array<String>):Bool
	{
		if (keys != null && requestedMobilePad != null)
			if (requestedMobilePad.justReleased(keys) == true)
				return true;

		return false;
	}

	private function hitboxPressed(keys:Array<String>):Bool
	{
		if (keys != null && requestedHitbox != null)
			if (requestedHitbox.pressed(keys) == true)
				return true;

		return false;
	}

	private function hitboxJustPressed(keys:Array<String>):Bool
	{
		if (keys != null && requestedHitbox != null)
			if (requestedHitbox.justPressed(keys) == true)
				return true;

		return false;
	}

	private function hitboxJustReleased(keys:Array<String>):Bool
	{
		if (keys != null && requestedHitbox != null)
			if (requestedHitbox.justReleased(keys) == true)
				return true;

		return false;
	}

	@:noCompletion
	private function get_requestedInstance():Dynamic
	{
		/* if (isInSubSubstate)
			return MusicBeatSubstate.subInstance;
		else */ if (isInSubstate)
			return MusicBeatSubstate.instance;
		else
			return MusicBeatState.getState();
	}

	@:noCompletion
	private function get_requestedHitbox():FunkinHitbox
	{
		return requestedInstance.mobileManager.hitbox;
	}

	@:noCompletion
	private function get_requestedMobilePad():FunkinMobilePad
	{
		return requestedInstance.mobileManager.mobilePad;
	}

	@:noCompletion
	private function get_mobileControls():Bool
	{
		if (game.cdev.CDevConfig.saveData.mobilePadAlpha >= 0.1)
			return true;
		else
			return false;
	}
	#end
}

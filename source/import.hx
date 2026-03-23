import game.Paths;
import game.cdev.CDevConfig;

#if MOBILE_CONTROLS_ALLOWED
import mobile.*;
import mobile.objects.*;
import mobile.MobileConfig.ButtonModes;
#end

#if mobile
import mobile.MobileControlManager;
import mobile.CopyState;
import mobile.StorageUtil;
import mobile.ScreenUtil;
#end

#if android
import android.callback.CallBack as AndroidCallBack;
import android.content.Context as AndroidContext;
import android.widget.Toast as AndroidToast;
import android.os.Environment as AndroidEnvironment;
import android.Permissions as AndroidPermissions;
import android.Settings as AndroidSettings;
import android.Tools as AndroidTools;
import android.os.Build.VERSION as AndroidVersion;
import android.os.Build.VERSION_CODES as AndroidVersionCode;
#end

//uhhh, how does import.hx works?
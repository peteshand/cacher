package cacher.openfl;

import openfl.Lib;
import openfl.display.Stage;
import openfl.filesystem.File;

/**
 * ...
 * @author P.J.Shand
 */
class LocalFileCheckUtil {
	public static var REMOVE_DOMAIN:Bool = true;
	@:isVar static var appStorageDir(get, null):File;

	static public function localURL(url:String):String {
		if (url == null)
			return null;
		var _localPath:String = localPath(url);
		if (_localPath == null) {
			return null;
		}

		var localFile:File = new File(_localPath);

		if (localFile.exists) {
			return localFile.url;
		} else {
			return null;
		}
	}

	static public function localPath(url:String) {
		if (url == null)
			return null;

		url = removeQueryStr(url);

		var cacheDir:File = new File(appStorageDir.nativePath + File.separator + "cache" + File.separator);
		if (!cacheDir.exists)
			cacheDir.createDirectory();

		if (url.indexOf("://") == -1) {
			try {
				if (new File(url).exists) {
					// is system path
					return url;
				} else {
					// is realitive path
				}
			} catch (e:Dynamic) {}
		}

		var split:Array<String> = url.split("://");
		if (split[0] == "file") {
			return url; // already local
		}

		var url2:String = "";
		var v = split[0];
		if (split.length > 1)
			v = split[1];
		var dirs:Array<String> = v.split("/");
		var startIndex:Int = 0;
		if (REMOVE_DOMAIN)
			startIndex = 1;
		for (i in startIndex...dirs.length - 1) {
			url2 += dirs[i] + File.separator;
			var localDir:File = new File(cacheDir.nativePath + url2);
			if (!localDir.exists)
				localDir.createDirectory();
		}

		var path:String = cacheDir.nativePath + url2;
		return path + File.separator + dirs[dirs.length - 1];
	}

	static function removeQueryStr(value:String):String {
		if (value.indexOf("?") == -1)
			return value;
		var split:Array<String> = value.split("?");
		return split[0];
	}

	static function get_appStorageDir():File {
		if (appStorageDir == null){

			var stage:Stage = Lib.current.stage;
			if (stage == null || stage.window == null)
				return null;
			var appId = stage.window.application.meta.get("packageName");
			var storageRootDir = File.documentsDirectory.resolvePath(".appStorage");
			if (!storageRootDir.exists)
				storageRootDir.createDirectory();

			appStorageDir = storageRootDir.resolvePath(appId);
		}
		
		return appStorageDir;
	}
}

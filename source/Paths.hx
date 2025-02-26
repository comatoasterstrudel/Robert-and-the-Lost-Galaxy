package;

import flixel.graphics.frames.FlxAtlasFrames;

/**
 * A class that lets you get paths to files
 * easier.
 */
class Paths
{	
	inline static function getPartialPath(type:String):String
	{
		var returnThis:String = '';

		switch(type){
			case 'image' | 'xml':
				returnThis = 'images/';
			case 'sound':
				returnThis = 'sounds/';
			case 'music':
				returnThis = 'music/';
			case 'txt' | 'hscript' | 'json':
				returnThis = 'data/'; 
			case 'font':
				returnThis = 'fonts/';
			case 'video':
				returnThis = 'videos/';
		}

		return returnThis;
	}

	inline static function getFileExtension(type:String):String
	{
		var returnThis:String = '';

		switch(type){
			case 'image':
				returnThis = '.png';
			case 'sound' | 'music':
				returnThis = '.ogg';
			case 'txt':
				returnThis = '.txt'; 
			case 'xml':
				returnThis = '.xml';
			case 'font':
				returnThis = '.ttf';
			case 'hscript':
				returnThis = '.hx';
			case 'json':
				returnThis = '.json';
			case 'video':
				returnThis = '.mp4';
		}

		return returnThis;
	}

	inline public static function getFile(type:String, key:String, library:String)
	{
		return 'assets/' + library + '/' + getPartialPath(type) + key + getFileExtension(type);
	}

	inline static public function getSparrowAtlas(key:String, library:String)
	{
		return FlxAtlasFrames.fromSparrow(getFile('image', key, library), getFile('xml', key, library));
	}

	inline static public function txt(key:String, library:String)
	{
		return getFile('txt', key, library);
	}

	inline static public function json(key:String, library:String)
	{
		return getFile('json', key, library);
	}

	inline static public function script(key:String, library:String)
	{
		return getFile('hscript', key, library);
	}

	inline static public function xml(key:String, library:String)
	{
		return getFile('xml', key, library);
	}

	static public function sound(key:String, library:String)
	{
		return getFile('sound', key, library);
	}

	inline static public function music(key:String, library:String)
	{
		return getFile('music', key, library);
	}

	inline static public function image(key:String, library:String)
	{
		return getFile('image', key, library);
	}

	inline static public function font(key:String, library:String)
	{
		return getFile('font', key, library);
	}

	inline static public function video(key:String, library:String)
	{
		return getFile('video', key, library);
	}
}
// For https://community.bistudio.com/wiki/Spearhead_1944_Credits

private _cfg = getArray (configFile >> "SPE_Credits" >> "info");
private _images = flatten (getArray (configFile >> "SPE_Credits" >> "images")) select {_x isEqualType ""} apply {toLower _x };

_images = _images apply
{
	private _path = _x splitString "\";
	reverse _path;
	_path select 0
};

private _return = [
	'{| style="width: 100%;"',
	'| colspan="2" style="text-align: center; padding: 10em;" | [[File: spe_credits_picture.png|700px]]',
	'|-'
];

forceUnicode 0;

_return pushBack format ['| colspan="2" style="text-align: center; padding-bottom: 10em;" | <span style="font-size: larger; padding-bottom: 2.5em">%1</span>',localize "STR_SPE_CREDITS_THANKS_01" + "<br/>" + localize "STR_SPE_CREDITS_THANKS_02" + "<br/>" + localize "STR_SPE_CREDITS_THANKS_03" + "<br/>" + localize "STR_SPE_CREDITS_THANKS_04" + "<br/>" + localize "STR_SPE_CREDITS_THANKS_05" + "<br/><br/>" + localize "STR_SPE_CREDITS_THANKS_06" + "<br/>" + localize "STR_SPE_CREDITS_THANKS_07"];
_return pushBack "|-";


{
	if (count _x != 0) then {
		private _title = _x#0;
		private _ary = _x#1;
		_return pushBack format ['! colspan="2" | <span style="font-size: large; padding-bottom: 2.5em">%1</span>',toUpperANSI _title];
		_return pushBack "|-";

		private _padding = ["1.2em","3em"] select (count (_cfg#(_forEachIndex+1)) == 0);

		if (_ary#0 isEqualType []) then {
			private _ary1 = [];
			private _ary2 = [];

			{
				_ary1 pushBack (_x#0);
				_ary2 pushBack ((_x#1) regexReplace ["<.*?>", ""]);
			} forEach _ary;

			_return pushBack format ['| style="width: 50%2; text-align: right; padding-bottom: 1.2em; padding-left: 1.2em " | <span style="font-size: smaller;">%1</span>',_ary1 joinString "<br/>","%"];
			_return pushBack format ['| style="width: 50%2; text-align: left; padding-bottom: 1.2em; padding-right: 1.2em " | %1',_ary2 joinString "<br/>","%"];
		} else {
			_return pushBack format ['| colspan="2" style="text-align: center; padding-bottom: %2" | %1',_ary joinString "<br/>",_padding];
		};
		_return pushBack "|-";
	};
} forEach _cfg;

_return pushBack "|}";

_return = _return joinString endl;

_return = _return + endl + endl  + '<gallery mode="slideshow" showthumbnails>' + endl;

{
	_return = _return + _x + endl;
} forEach _images;

_return = _return + "</gallery>" + endl + endl + "[[Category: Spearhead 1944]]";

copyToClipboard _return;
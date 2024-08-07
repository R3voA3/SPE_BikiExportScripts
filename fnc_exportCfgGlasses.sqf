// For https://community.bistudio.com/wiki/Spearhead_1944_CfgGlasses

private _text = "{{Feature|important|The content of this page was generated by script. Manual edits might get lost.}}" + endl;
_text = _text + "{| class=""wikitable sortable"" border=""1"" style=""border-collapse:collapse; font-size:80%;"" cellpadding=""3px""" + endl;

_text = _text + format ["! %1 !! %2 !! %3 !! %4", "Preview", "Class Name", "Display Name", "Used by"] +  endl + "|-" + endl;

private _classes = "(configSourceMod _x == ""SPE"")" configClasses (configfile >> "CfgGlasses");

{
	if ((getNumber (_x >> "scope") < 2)) then {continue};

	private _picture = getText (_x >> "picture");
	private _class = configName _x;
	private _displayName = getText (_x >> "displayName");

	_picture = _picture splitString "\";
	reverse _picture;
	_picture = _picture param [0, ""];
	_picture = _picture splitString ".";
	_picture = _picture param [0, ""];

	if (_picture != "") then
	{
		_picture = _picture + ".png";
	};

	_text = _text + "| " + (if (_picture != "") then {format ["[[File:%1|150px]]", _picture]} else {""}) + endl;
	_text = _text + "| " + (if (_class != "") then {_class} else {""}) + endl;
	_text = _text + "| " + (if (_displayName != "") then {format ["''%1''", _displayName]} else {""}) + endl;

	private _usedBy = [];
	{
		private _weapons = getArray (_x >> "weapons");
		private _items = getArray (_x >> "items");
		private _linkedItems = getArray (_x >> "linkedItems");
		private _magazines = getArray (_x >> "magazines");
		private _headgearList = getArray (_x >> "headgearList");
		private _identityTypes = getArray (_x >> "identityTypes");

		private _toSearch = _weapons + _items + _linkedItems + _magazines + _headgearList + _identityTypes;

		if (_class in _toSearch) then
		{
			_usedBy pushBack configName _x;
		};
	} forEach ("(configSourceMod _x == ""SPE"")" configClasses (configfile >> "CfgVehicles"));

	_text = _text + "|" + endl;

	if (_usedBy isNotEqualTo []) then
	{
		private _collapse = count _usedBy > 10;
		if (_collapse) then
		{
			_text = _text + "{| class=""wikitable mw-collapsible mw-collapsed""" + endl;
			_text = _text + "! Objects" + endl;
			_text = _text + "|-" + endl;
			_text = _text + "|" + endl;
		};
		{
			_text = _text + "* " + _x + endl;
		} forEach _usedBy;

		if (_collapse) then
		{
			_text = _text + "|}" + endl;
		};
	};

	_text = _text + "|-" + endl;

} forEach _classes;

_text = _text + "|}" + endl + endl + "[[Category: Spearhead 1944]]";

copyToClipboard _text;
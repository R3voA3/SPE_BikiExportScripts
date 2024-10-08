// private _toExport = "equipment"; // For https://community.bistudio.com/wiki/Spearhead_1944_CfgWeapons_Equipment
// private _toExport = "weapon"; // For https://community.bistudio.com/wiki/Spearhead_1944_CfgWeapons_Weapons
// private _toExport = "item"; // For https://community.bistudio.com/wiki/Spearhead_1944_CfgWeapons_Items

private _text = "{{Feature|important|The content of this page was generated by script. Manual edits might get lost.}}" + endl;
_text = _text + "{| class=""wikitable sortable"" border=""1"" style=""border-collapse:collapse; font-size:80%;"" cellpadding=""3px""" + endl;

if (_toExport == "equipment" || _toExport == "item") then
{
	_text = _text + format ["! %1 !! %2 !! %3 !! %4 !! %5", "Preview", "Class", "Name", "Inventory description", "Used by"] +  endl + "|-" + endl;
}
else
{
	_text = _text + format ["! %1 !! %2 !! %3 !! %4 !! %5 !! %6 !! %7", "Preview", "Class", "Name", "Inventory description", "Magazines", "Accessories", "Used by"] +  endl + "|-" + endl;
};

private _classes = "(configSourceMod _x == ""SPE"")" configClasses (configfile >> "cfgweapons");

{
	if ((getNumber (_x >> "scope") < 2) || (((configName _x) call BIS_fnc_itemType select 0) != _toExport)) then {continue};

	private _picture = getText (_x >> "picture");
	private _class = configName _x;
	private _displayName = getText (_x >> "displayName");
	private _descriptionShort = getText (_x >> "descriptionShort");
	private _libraryText = getText (_x >> "Library" >> "libTextDesc");

	private _magazines = compatibleMagazines _class;
	private _accessories = compatibleItems _class;

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

	if (_libraryText != "") then
	{
		_descriptionShort = _descriptionShort + endl + endl + _libraryText;
	};

	_text = _text + "| " + (if (_descriptionShort != "") then {format ["''%1''", _descriptionShort]} else {""}) + endl;

	if (_toExport == "weapons") then
	{
		_text = _text + "|" + endl;

		if (_magazines isNotEqualTo []) then
		{
			{
				_text = _text + "* " + _x + endl;
			} forEach _magazines;
		};

		_text = _text + "|" + endl;

		if (_accessories isNotEqualTo []) then
		{
			{
				_text = _text + "* " + _x + endl;
			} forEach _accessories;
		};
	};

	private _usedBy = [];
	{
		private _weapons = getArray (_x >> "weapons");
		private _items = getArray (_x >> "items");
		private _linkedItems = getArray (_x >> "linkedItems");
		private _magazines = getArray (_x >> "magazines");
		private _headgearList = getArray (_x >> "headgearList");

		private _toSearch = _weapons + _items + _linkedItems + _magazines + _headgearList;

		if (_class in _toSearch) then
		{
			_usedBy pushBack configName _x;
		};
	} forEach ("(configSourceMod _x == ""SPE"")" configClasses (configfile >> "CfgVehicles"));

	_text = _text + "|" + endl;

	if (_usedBy isNotEqualTo []) then
	{
		private _collapse = count _usedBy > (count _magazines max 10);
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
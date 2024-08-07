// For https://community.bistudio.com/wiki/Spearhead_1944_CfgMarkers

private _condition = "(configSourceMod _x == ""SPE"") && getNumber (_x >> ""scope"") > 0";
private _markers = _condition configClasses (configFile >> "CfgMarkers");

private _uniqueClasses = [];
private _markerData = [];
private _export = "{{Feature|important|The content of this page was generated by script. Manual edits might get lost.}}" + endl;

{
	private _name = getText (_x >> "name");
	private _classname = configName _x;
	private _markerClass = getText (_x >> "markerClass");
	private _icon = getText (_x >> "icon");

	_uniqueClasses pushBackUnique _markerClass;
	_markerData append [[_name, _classname, _markerClass, _icon]];
} forEach _markers;

{
	private _markerClass = _x;
	private _category = getText (configFile >> "CfgMarkerClasses" >> _x >> "displayName");

	if (_category == "") then {continue};

	// Headline
	_export = _export + format ["= %1 =", _category] + endl;

	_export = _export + "{| class=""wikitable sortable""" + endl + "|-" + endl;
	_export = _export + "! style= ""width:150px"" | Preview !! style= ""width:350px"" | Class Name !! style= ""width:150px;"" | Display Name" + endl + "|-" + endl;

	{
		_x params ["_name", "_classname", "_markerClassMarker", "_icon"];

		if (_markerClass != _markerClassMarker) then {continue};

		_icon = _icon splitString "\";
		reverse _icon;
		_icon = _icon param [0, ""];
		_icon = _icon splitString "." param [0, ""];

		if (_icon != "") then
		{
			_icon = format ["[[File:%1.png|150px|center]]", toLower _icon];
		};

		_export = _export + format ["| style=""background-color: #4c4c4c;"" | %1 || %2 || ''%3''", _icon, _classname, _name] + endl + "|-" + endl;
	} forEach _markerData;

	_export = _export + "|}" + endl + endl;
} forEach _uniqueClasses;

// Category
_export = _export + "[[Category: Spearhead 1944]]";

copyToClipboard _export;
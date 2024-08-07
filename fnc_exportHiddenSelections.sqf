// For https://community.bistudio.com/wiki/Spearhead_1944_Retexturing#Hidden_Selections_List

private _cfgVehicles = "getText (_x >> 'author') == 'Heavy Ordnance Works' && getNumber (_x >> 'scope') == 2" configClasses (configfile >> "CfgVehicles");

private _data = createHashMap;

{
	private _className = configName _x;
	private _displayName = getText (_x >> "displayName");

	if (_displayName == "") then {continue};

	private _hiddenSelections = getArray (_x >> "hiddenSelections");

	if (_hiddenSelections isEqualTo []) then {continue};

	if !(_hiddenSelections in _data) then
	{
		_data set [_hiddenSelections, [[_className, _displayName]]];
	}
	else
	{
		private _value = _data get _hiddenSelections;
		_value pushBack [_className, _displayName];
		_data set [_hiddenSelections, _value];
	};
} forEach _cfgVehicles;

private _text = "{{Feature|important|The following table was generated by script. Manual edits might get lost.}}" + endl;

_text = _text + "{| class=""wikitable sortable""" + endl;
_text = _text + "! Class Names" + endl;
_text = _text + "! Display Names" + endl;
_text = _text + "! Hidden Selections" + endl + "|-" + endl;

{
	private _classes = endl;
	private _displayNames = endl;

	{
		_x params ["_className", "_displayName"];
		_classes = _classes + format ["* %1%2", _className, endl];
		_displayNames = _displayNames + format ["* ''%1''%2", _displayName, endl];
	} forEach _y;

	private _selections = endl;

	{
		_selections = _selections + format ["* %1%2", _x, endl];
	} forEach _x;

	_text = _text + "|" + _classes + " || " + _displayNames + " || " + _selections + endl + "|-" + endl;
} forEach _data;

_text = _text + "|}";

copyToClipboard _text;
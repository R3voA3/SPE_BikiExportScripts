// For https://community.bistudio.com/wiki/Spearhead_1944_CfgGroups

_addon = "SPE";

private _text = "{{Feature|important|The content of this page was generated by script. Manual edits might get lost.}}" + endl;

{
	_text = _text + format ["= %1 =", getText (configFile >> "CfgGroups" >> _x >> "name")] + endl;
	{
		if (configSourceMod _x != _addon) then {continue};
		private _nameFaction = getText (_x >> "name");
		_text = _text + format ["== %1 ==", _nameFaction] + endl;
		{
			if (configSourceMod _x != _addon) then {continue};
			private _nameType = getText (_x >> "name");
			_text = _text + format ["=== %1 ===", _nameType] + endl;

			_text = _text + "{| class=""wikitable sortable"" width=100% border=""1"" style=""border-collapse:collapse;""" + endl;
			_text = _text + format ["! %1 !! %2 !! %3 !! %4", "Class Name", "Display Name", "Units", "Previews"] +  endl + "|-" + endl;

			{
				if (configSourceMod _x != _addon) then {continue};
				private _nameGroup = getText (_x >> "name");

				private _textUnits = endl;
				private _textPictures = endl;
				{
					if (configSourceMod _x != _addon) then {continue};
					private _vehicleClass = getText (_x >> "vehicle");
					private _displayName = getText (configFile >> "CfgVehicles" >> _vehicleClass >> "displayName");
					private _picture = getText (configFile >> "CfgVehicles" >> _vehicleClass >> "editorPreview");
					_picture = _picture splitString "\";
					reverse _picture;
					_picture = _picture param [0, ""];
					_textUnits = _textUnits + format ["* %1 ({{hl|%2}})", _displayName, _vehicleClass] + endl;
					_textPictures = _textPictures + format ["[[File:%1|150px|&nbsp;]]", _picture] + endl;
				} forEach ("true" configClasses _x);

				_textUnits trim [endl, 2];
				_textPictures trim [endl, 2];
				_text = _text + "| " + format ["{{hl|%1}}", configName _x] + endl + "| " + _nameGroup + endl + "| " + _textUnits + "| " + _textPictures;
				_text = _text + "|-" + endl;
			} forEach ("true" configClasses _x);
			_text = _text + "|}" + endl + endl;
		} forEach ("true" configClasses _x);

	} forEach ("true" configClasses (configFile >> "CfgGroups" >> _x));
} forEach ["West", "Indep"];

_text = _text + endl + endl + "[[Category: Spearhead 1944]]";

copyToClipboard _text;
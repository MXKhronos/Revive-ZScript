local ZScript = {};

function ZScript.Load(zScr, zEnv)
	zEnv.Enum = Enum;

	zEnv.math = math;
	zEnv.table = table;
	zEnv.string = string;
	zEnv.pcall = pcall;
	zEnv.task = {
		wait = task.wait;
		defer = task.defer;
		spawn = task.spawn;
		delay = task.delay;
	};

	zEnv.pairs = pairs;
	zEnv.ipairs = ipairs;
	zEnv.next = next;
	zEnv.select = select;
	zEnv.tonumber = tonumber;
	zEnv.tostring = tostring;
	zEnv.unpack = unpack;
	zEnv.typeof = typeof;
	
	zEnv.tick = tick;

	zScr.regDataType("Vector2", Vector2);
	zScr.regDataType("Vector3", Vector3);
	zScr.regDataType("CFrame", CFrame);
	
end

return ZScript;
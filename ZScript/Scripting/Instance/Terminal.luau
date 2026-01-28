local classPackage = {
	UserId = 0;
};

return {
    Class = classPackage;

	Constructor = function(zScr, public, private, instance)
		local staticUserdata = zScr.Instance:MatchList(function(userdata)
			local match = userdata.ClassName == private.ClassName and userdata.UserId == instance.UserId;
			local breakSearch = true;
			return match, breakSearch;
		end)[1];
		if staticUserdata then return staticUserdata end;

		public.UserId = instance.UserId;

		return;
	end;
};
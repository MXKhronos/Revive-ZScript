local RunService = game:GetService("RunService");
--==

local classPackage = {
	Name = "";
	UserId = 0;
};

function classPackage.__tostring(private, public)
	return `{public.Name}:{public.UserId}`;
end

function classPackage.GetCFrame(private, public)
	local playerClass = shared.modPlayers.get(private.__instance);
	return playerClass:GetCFrame();
end

function classPackage.SetCFrame(private, public, cframe: CFrame, ...)
	if RunService:IsClient() then
		warn("Can not set CFrame of Player from client.");
		return;
	end
	local playerClass = shared.modPlayers.get(private.__instance);
	playerClass:SetCFrame(cframe);
end

return {
    Class = classPackage;
	CanDestroy = false;
    Constructor = function(zScr, public, private, instance)
		public.UserId = instance.UserId;
		public.Name = instance.Name;
    end;
};
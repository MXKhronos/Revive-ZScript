local classPackage = {};

function classPackage.Connect(private, public, func)
    private.__instance:Connect(func);
end

function classPackage.Fire(private, public, ...)
    private.__instance:Fire(...);
end

return {
	Class = classPackage;
	Constructor = function(zScr, public, private, ...)
        if private.__instance == nil then
            private.__instance = shared.EventSignal.new(...);
        end
    end;
}

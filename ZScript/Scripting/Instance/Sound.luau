local classPackage = {
    SoundId = "";
    Volume = 0.5;
    PlaybackSpeed = 1;
};

function classPackage.Play(private, public)
    private.__instance:Play();
end

function classPackage.Stop(private, public)
    private.__instance:Stop();
end

return {
    Class = classPackage;
    Constructor = function(zScr, public, private, instance)
        if private.__instance == nil then
            private.__instance = Instance.new("Sound");
        end
    end;
};
-- CHANGE THIS VALUE TO CHANGE THE CAP
-- The cap is set to 295 to represent 32 traits with the 2 archetypes subtracted
local MaxTraitPoints = 295

RegisterHook("/Script/Engine.PlayerController:ClientRestart", function(self, NewPawn)
    ExecuteInGameThread(function()
        local PlayerController = self:get()

        if not PlayerController:IsValid() or not PlayerController.Player:IsValid() or not PlayerController.Character:IsValid() or PlayerController:HasAnyInternalFlags(EInternalObjectFlags.PendingKill) then
            print("[TraitCap] PlayerController not found, could not change traits cap\n")
            return
        end

        local CharacterFullName = PlayerController.Character:GetFullName()
        local CharacterStringTable = {}

        for i in CharacterFullName:gmatch("%S+") do
            table.insert(CharacterStringTable, i)
        end

        local HostTraitsComponent = StaticFindObject(string.format("%s.Traits", CharacterStringTable[#CharacterStringTable]))
        if not HostTraitsComponent:IsValid() then print("[TraitCap] HostTraitsComponent not found, could not change host traits cap\n") return end

        HostTraitsComponent.MaxTraitPoints = MaxTraitPoints
        print("[TraitCap] Max trait points adjusted for self\n")
    end)
end)

NotifyOnNewObject("/Script/Remnant.RemnantTraitsComponent", function(CreatedObject)
    ExecuteInGameThread(function()
        local OnlineSession = FindFirstOf("GunfireOnlineSessionManager")

        if OnlineSession and OnlineSession:IsValid() and OnlineSession.SessionType == 1 then
            if not CreatedObject:IsValid() then print("[TraitCap] CreatedObject not found, could not change host traits cap\n") return end

            CreatedObject:SetPropertyValue("MaxTraitPoints", MaxTraitPoints)
            print("[TraitCap] Max trait points adjusted for lobby member\n")
        end
    end)
end)
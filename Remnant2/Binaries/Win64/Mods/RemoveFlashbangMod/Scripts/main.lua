local preId, postId
RegisterHook("/Script/Engine.PlayerController:ClientRestart", function(PlayerSelf)
    local PlayerController = PlayerSelf:get()

    if not PlayerController:IsValid() or not PlayerController.Player:IsValid() or not PlayerController.Character:IsValid() or PlayerController:HasAnyInternalFlags(EInternalObjectFlags.PendingKill) then
        print("[RemoveFlashbangMod] PlayerController not found, could not disable flashbang\n")
        return
    end

    local WorldReset = PlayerController.WorldReset

    pcall(function()
        UnregisterHook("/Game/World_Base/Interactives/Interactive_Checkpoint/Interactive_Checkpoint.Interactive_Checkpoint_C:OnBeginActivation", preId, postId)  
    end)
    preId, postId = RegisterHook("/Game/World_Base/Interactives/Interactive_Checkpoint/Interactive_Checkpoint.Interactive_Checkpoint_C:OnBeginActivation", function(CheckpointSelf)
        ExecuteInGameThread(function()
            if WorldReset:IsValid() then
                WorldReset.TheTimeline.Length = 0
                print("[RemoveFlashbangMod] Flashbang removed\n")
            end
        end)
    end)  
end)  

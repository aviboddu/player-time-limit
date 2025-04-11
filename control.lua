script.on_init(function()
    if game.is_multiplayer() then
        storage['when-to-unban'] = {}
        storage['player-tick-when-reset'] = {}
        storage['tick-when-reset'] = 0
        script.on_nth_tick(60, function()
            local server_days = math.ceil((game.ticks_played - storage['tick-when-reset']) / (60 * 86400.0))
            for player in game.connected_players do
                local player_tick_when_reset = storage['player-tick-when-reset'][player.index] or 0
                local player_days = (player.online_time - player_tick_when_reset) /
                    (60 * settings.startup["time-limit-in-seconds"].value)
                if player_days > server_days then
                    game:ban_player(player, "time-limit-exceeded")
                    storage['when-to-unban'][player.index] = game.ticks_played +
                        settings.startup["time-to-ban-in-seconds"].value * 60
                end
            end
            for idx, ticks in pairs(storage['when-to-unban']) do
                if ticks < game.ticks_played then
                    game:unban_player(idx)
                    storage['when-to-unban'][idx] = nil
                end
            end
        end)
        script.on_event(defines.events.on_player_unbanned, function(event)
            storage['when-to-unban'][event.player_index] = nil
        end)
        commands.add_command("reset_time_limit", "Reset the time limit for all players and unban them", function()
            storage['tick-when-reset'] = game.ticks_played
            for player in game.players do
                storage['player-tick-when-reset'][player.index] = player.online_time
            end
            for idx, _ in pairs(storage['when-to-unban']) do
                game:unban_player(idx)
                storage['when-to-unban'][idx] = nil
            end
        end)
        commands.add_command("debug_time_limit", "Debug the time limit for all players", function()
            script.print("time-limit-settings:")
            script.print("time-limit-in-seconds: " .. settings.startup["time-limit-in-seconds"].value)
            script.print("time-to-ban-in-seconds: " .. settings.startup["time-to-ban-in-seconds"].value)
            script.print("storage:")
            script.print("tick-when-reset: " .. storage['tick-when-reset'])
            script.print("player-tick-when-reset:")
            script.print(serpent.block(storage['player-tick-when-reset']))
            script.print("when-to-unban:")
            script.print(serpent.block(storage['when-to-unban']))
        end)
    end
end)

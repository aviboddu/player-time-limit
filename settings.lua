data:extend({
    {
        type = "int-setting",
        name = "time_limit_in_seconds",
        setting_type = "startup",
        default_value = 3600,
        minimum_value = 0,
        maximum_value = 86400
    },
    {
        type = "int-setting",
        name = "time_to_ban_in_seconds",
        setting_type = "startup",
        default_value = 3600,
        minimum_value = 0,
    }
})

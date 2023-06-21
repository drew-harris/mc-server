package net.drewh.drewsplugin;

import org.bukkit.plugin.java.JavaPlugin;

public final class DrewsPlugin extends JavaPlugin {
    @Override
    public void onEnable() {
        // Plugin startup logic
        getServer().getPluginManager().registerEvents(new PlayerListener(), this);
        System.out.println("Hello, world!");
    }
}

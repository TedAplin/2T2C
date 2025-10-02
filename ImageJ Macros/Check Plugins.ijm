// **INFO** //
// Version: 09/2025
// Not well tested, should alert if any dependent plugins are absent
// Author: AI mostly, quickly whipped together + some work from Ted Aplin

// List of important plugin filenames to check
plugins = newArray(
    "bio-formats.jar",      // Bio-Formats plugin
    "SplitChannels.class",  // Split Channels plugin (typical plugin class)
    "ZProjector.class",     // Z Project plugin
    "Bin.class",            // Bin plugin (example filename, adjust as needed)
    "Correct3dDrift.class"  // Correct 3d Drift plugin
);

// Get ImageJ plugins directory
pluginsDir = getDirectory("plugins");

missingPlugins = newArray();

// Check each plugin and collect missing ones
for (i=0; i<plugins.length; i++) {
    pluginPath = pluginsDir + plugins[i];
    if (!File.exists(pluginPath)) {
        Array.concat(missingPlugins, plugins[i]);
    }
}

// Notify user about missing plugins
if (missingPlugins.length > 0) {
    msg = "The following plugins are missing:\n";
    for (i=0; i<missingPlugins.length; i++) {
        msg += missingPlugins[i] + "\n";
    }
    msg += "\nPlease install them using ImageJ Updater (Help > Update) or manually add them to the plugins folder and restart ImageJ.";
    showMessage("Plugin Check", msg);
} else {
    showMessage("Plugin Check", "All specified plugins are installed.");
}

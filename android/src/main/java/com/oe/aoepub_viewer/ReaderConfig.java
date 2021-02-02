package com.oe.aoepub_viewer;

import android.content.Context;
import android.graphics.Color;

import com.oe.aoepub_viewer.folioreader.Config;

public class ReaderConfig {
    private String identifier;
    private String themeColor;
    private String scrollDirection;
    private boolean allowSharing;
    private boolean showTts;
    private int nightMode;

    public Config config;

    public ReaderConfig(Context context, String identifier, String themeColor,
                        String scrollDirection, boolean allowSharing, boolean showTts, int nightMode) {

//        config = AppUtil.getSavedConfig(context);
//        if (config == null)
        config = new Config();
        if (scrollDirection.equals("vertical")) {
            config.setAllowedDirection(Config.AllowedDirection.ONLY_VERTICAL);
        } else if (scrollDirection.equals("horizontal")) {
            config.setAllowedDirection(Config.AllowedDirection.ONLY_HORIZONTAL);
        } else {
            config.setAllowedDirection(Config.AllowedDirection.VERTICAL_AND_HORIZONTAL);
        }
        config.setThemeColorInt(Color.parseColor(themeColor));
        config.setNightThemeColorInt(Color.parseColor(themeColor));
        config.setShowRemainingIndicator(true);
        config.setShowTts(showTts);
        //config.setColorMode(nightMode);
    }
}

package com.oe.aoepub_viewer.folioreader.ui.base;

import android.content.Context;

import com.oe.aoepub_viewer.folioreader.util.FontFinder;
import com.oe.aoepub_viewer.R;
import com.oe.aoepub_viewer.folioreader.Config;

import java.io.File;

/**
 * @author gautam chibde on 14/6/17.
 */

public final class HtmlUtil {

    /**
     * Function modifies input html string by adding extra css,js and font information.
     *
     * @param context     Activity Context
     * @param htmlContent input html raw data
     * @return modified raw html string
     */
    public static String getHtmlContent(Context context, String htmlContent, Config config) {

        String cssPath =
                String.format(context.getString(R.string.css_tag), "file:///android_asset/css/Style.css");

        String jsPath = String.format(context.getString(R.string.script_tag),
                "file:///android_asset/js/jsface.min.js") + "\n";

        jsPath = jsPath + String.format(context.getString(R.string.script_tag),
                "file:///android_asset/js/jquery-3.4.1.min.js") + "\n";

        jsPath = jsPath + String.format(context.getString(R.string.script_tag),
                "file:///android_asset/js/rangy-core.js") + "\n";

        jsPath = jsPath + String.format(context.getString(R.string.script_tag),
                "file:///android_asset/js/rangy-highlighter.js") + "\n";

        jsPath = jsPath + String.format(context.getString(R.string.script_tag),
                "file:///android_asset/js/rangy-classapplier.js") + "\n";

        jsPath = jsPath + String.format(context.getString(R.string.script_tag),
                "file:///android_asset/js/rangy-serializer.js") + "\n";

        jsPath = jsPath + String.format(context.getString(R.string.script_tag),
                "file:///android_asset/js/Bridge.js") + "\n";

        jsPath = jsPath + String.format(context.getString(R.string.script_tag),
                "file:///android_asset/js/rangefix.js") + "\n";

        jsPath = jsPath + String.format(context.getString(R.string.script_tag),
                "file:///android_asset/js/readium-cfi.umd.js") + "\n";

        jsPath = jsPath + String.format(context.getString(R.string.script_tag_method_call),
                "setMediaOverlayStyleColors('#C0ED72','#C0ED72')") + "\n";

        jsPath = jsPath
                + "<meta name=\"viewport\" content=\"height=device-height, user-scalable=no\" />";

        String fontName = config.getFont();

        System.out.println("Font family: " + fontName);

        // Inject CSS & user font style
        String toInject = "\n" + cssPath + "\n" + jsPath + "\n";

        String userFontFile = FontFinder.getFontAssetsDir(fontName); //FontFinder.getFontFile(fontName);
        if (userFontFile != null) {
            System.out.println("Injected user font into CSS");
            System.out.println("  - path: " + userFontFile);
            System.out.println("  - family: '" + fontName + "'");
            toInject += "<style>\n";
            toInject += "@font-face {\n";
            toInject += "  font-family: '" + fontName + "';\n";
            toInject += "  src: url('file://" + userFontFile + "');\n";
            toInject += "}\n";
            toInject += ".custom-font {\n";
            toInject += "  font-family: '" + fontName + "', sans-serif;\n";
            toInject += "}\n";
            toInject += "\n</style>";
        }

        toInject += "</head>";

        htmlContent = htmlContent.replace("</head>", toInject);

        String classes = "custom-font";

        if (config.getColorMode() == 4) {
            classes += " nightMode";
        } else if (config.getColorMode() == 3) {
            classes += " pinkMode";
        } else if (config.getColorMode() == 2) {
            classes += " grayMode";
        } else if (config.getColorMode() == 1) {
            classes += " purpleMode";
        }

        switch (config.getFontSize()) {
            case 0:
                classes += " textSizeOne";
                break;
            case 1:
                classes += " textSizeTwo";
                break;
            case 2:
                classes += " textSizeThree";
                break;
            case 3:
                classes += " textSizeFour";
                break;
            case 4:
                classes += " textSizeFive";
                break;
            default:
                break;
        }

        String styles = "font-family: '" + fontName + "';";

        htmlContent = htmlContent.replace("<html",
                "<html class=\"" + classes + "\"" +
                        " style=\"" + styles + "\"" +
                        " onclick=\"onClickHtml()\"");
        return htmlContent;
    }
}

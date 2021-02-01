package com.oe.aoepub_viewer;

import android.app.Activity;
import android.content.Context;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class AoepubViewerPlugin implements MethodChannel.MethodCallHandler {

    private Reader reader;
    private ReaderConfig config;

    static private Activity activity;
    static private Context context;
    static BinaryMessenger messenger;

    /**
     * Plugin registration.
     */
    public static void registerWith(PluginRegistry.Registrar registrar) {

        context = registrar.context();
        activity = registrar.activity();
        messenger = registrar.messenger();

        final MethodChannel channel = new MethodChannel(registrar.messenger(), "aoepub_viewer");
        channel.setMethodCallHandler(new AoepubViewerPlugin());
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {

        if (call.method.equals("setConfig")) {
            Map<String, Object> arguments = (Map<String, Object>) call.arguments;
            String identifier = arguments.get("identifier").toString();
            String themeColor = arguments.get("themeColor").toString();
            String scrollDirection = arguments.get("scrollDirection").toString();
            int nightMode = Integer.parseInt(arguments.get("nightMode").toString());
            boolean allowSharing = Boolean.parseBoolean(arguments.get("allowSharing").toString());
            boolean enableTts = Boolean.parseBoolean(arguments.get("enableTts").toString());
            config = new ReaderConfig(context, identifier, themeColor,
                    scrollDirection, allowSharing, enableTts, nightMode);

        } else if (call.method.equals("open")) {

            Map<String, Object> arguments = (Map<String, Object>) call.arguments;
            String bookPath = arguments.get("bookPath").toString();
            String lastLocation = arguments.get("lastLocation").toString();

            reader = new Reader(context, messenger, config);
            reader.open(bookPath, lastLocation);

        } else if (call.method.equals("close")) {
            reader.close();
        } else {
            result.notImplemented();
        }
    }
}

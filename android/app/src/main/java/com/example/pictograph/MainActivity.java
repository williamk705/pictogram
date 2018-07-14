package com.example.pictograph;

import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.app.WallpaperManager;
import android.graphics.Bitmap;

import java.io.IOException;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;

public class MainActivity extends FlutterActivity {

    Bitmap bitmap;
    private static final String WALLPAPER_CHANNEL = "samples.flutter.io/wallpaper";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        new MethodChannel(getFlutterView(), WALLPAPER_CHANNEL).setMethodCallHandler(new MethodCallHandler() {
                @Override
                public void onMethodCall(MethodCall call, Result result) {
                    if (call.method.equals("setAndroidWallpaper")) {
                        byte[] pictureData = call.argument("data");

                        if (pictureData.length > 0) {
                            //make the byte list of pictures the wallpaper
                            setAndroidWallpaper(pictureData);
                            result.success("success");
                        } else {
                            result.error("UNAVAILABLE", "Wallpaper not available.", null);
                        }
                    } else {
                        result.notImplemented();
                    }
                }
            }
        );
    }

    private String setAndroidWallpaper(byte[] picture) {
        Bitmap bmp = BitmapFactory.decodeByteArray(picture, 0, picture.length);
        WallpaperManager newWallpaper = WallpaperManager.getInstance(getApplicationContext());
        try {
            newWallpaper.setBitmap(bmp);
        }catch (IOException e) {
            e.printStackTrace();
        }
        return "";
    }
}

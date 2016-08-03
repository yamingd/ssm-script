package com._company_._project_;

/**
 * Created by yamingd.
 */
public final class Devices {

    public static final int iPhone = 1;

    public static final int iPad = 2;

    public static final int PCWeb = 3;

    public static final int AndroidApp = 4;

    public static final int WeixinApp = 5;

    public static int get(String userAgent){

        if (userAgent.contains("Android")){
            return AndroidApp;
        }else if (userAgent.contains("iPhone")){
            return iPhone;
        }else if (userAgent.contains("MicroMessenger")){
            return WeixinApp;
        }else if (userAgent.contains("iPad")){
            return iPad;
        }else{
            return PCWeb;
        }

    }
}

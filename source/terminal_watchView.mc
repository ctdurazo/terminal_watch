import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Math;
import Toybox.ActivityMonitor;
import Toybox.Activity;
import Toybox.Weather;


class terminal_watchView extends WatchUi.WatchFace {
    
    var weather_conditions;

    function initialize() {
        weather_conditions = {
            Weather.CONDITION_CLEAR=> "Clear", 
            Weather.CONDITION_PARTLY_CLOUDY=> "Partly cloudy", 
            Weather.CONDITION_MOSTLY_CLOUDY=> "Mostly cloudy",
            Weather.CONDITION_RAIN=> "Rain", 
            Weather.CONDITION_SNOW=> "Snow", 
            Weather.CONDITION_WINDY=> "Windy",
            Weather.CONDITION_THUNDERSTORMS=> "Thunderstorms",
            Weather.CONDITION_WINTRY_MIX=> "Wintry mix",
            Weather.CONDITION_FOG=> "Fog",
            Weather.CONDITION_HAZY=> "Hazy",
            Weather.CONDITION_HAIL=> "Hail",
            Weather.CONDITION_SCATTERED_SHOWERS=> "Scattered showers",
            Weather.CONDITION_SCATTERED_THUNDERSTORMS=> "Scattered thunderstorms",
            Weather.CONDITION_UNKNOWN_PRECIPITATION=> "Unknown precipitation",
            Weather.CONDITION_LIGHT_RAIN=> "Light rain",
            Weather.CONDITION_HEAVY_RAIN=> "Heavy rain",
            Weather.CONDITION_LIGHT_SNOW=> "Light snow",
            Weather.CONDITION_HEAVY_SNOW=> "Heavy snow",
            Weather.CONDITION_LIGHT_RAIN_SNOW=> "Light rain snow",
            Weather.CONDITION_HEAVY_RAIN_SNOW=> "Heavy rain snow",
            Weather.CONDITION_CLOUDY=> "Cloudy",
            Weather.CONDITION_RAIN_SNOW=> "Rain snow",
            Weather.CONDITION_PARTLY_CLEAR=> "Partly clear",
            Weather.CONDITION_MOSTLY_CLEAR=> "Mostly clear",
            Weather.CONDITION_LIGHT_SHOWERS=> "Light showers",
            Weather.CONDITION_SHOWERS=> "Showers",
            Weather.CONDITION_HEAVY_SHOWERS=> "Heavy showers",
            Weather.CONDITION_CHANCE_OF_SHOWERS=> "Chance of showers",
            Weather.CONDITION_CHANCE_OF_THUNDERSTORMS=> "Chance of thunderstorms",
            Weather.CONDITION_MIST=> "Mist",
            Weather.CONDITION_DUST=> "Dust",
            Weather.CONDITION_DRIZZLE=> "Drizzle",
            Weather.CONDITION_TORNADO=> "Tornado",
            Weather.CONDITION_SMOKE=> "Smoke",
            Weather.CONDITION_ICE=> "Ice",
            Weather.CONDITION_SAND=> "Sand",
            Weather.CONDITION_SQUALL=> "Squall",
            Weather.CONDITION_SANDSTORM=> "Sandstorm",
            Weather.CONDITION_VOLCANIC_ASH=> "Volcanic ash",
            Weather.CONDITION_HAZE=> "Haze",
            Weather.CONDITION_FAIR=> "Fair",
            Weather.CONDITION_HURRICANE=> "Hurricane",
            Weather.CONDITION_TROPICAL_STORM=> "Tropical storm",
            Weather.CONDITION_CHANCE_OF_SNOW=> "Chance of snow",
            Weather.CONDITION_CHANCE_OF_RAIN_SNOW=> "Chance of rain snow",
            Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN=> "Cloudy chance of rain",
            Weather.CONDITION_CLOUDY_CHANCE_OF_SNOW=> "Cloudy chance of snow",
            Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN_SNOW=> "Cloudy chance of rain snow",
            Weather.CONDITION_FLURRIES=> "Flurries",
            Weather.CONDITION_FREEZING_RAIN=> "Freezing rain",
            Weather.CONDITION_SLEET=> "Sleet",
            Weather.CONDITION_ICE_SNOW=> "Ice snow",
            Weather.CONDITION_THIN_CLOUDS=> "Thin clouds",
            Weather.CONDITION_UNKNOWN=> "Unknown"
        };
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {}

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Update the view
        var timeValue = View.findDrawableById("TimeValue") as Text;
        timeValue.setText(getTime());

        var dateValue = View.findDrawableById("DateValue") as Text;
        dateValue.setText(getDate());

        var batteryValue = View.findDrawableById("BattValue") as Text;
        batteryValue.setText(getBattery());

        var stepValue = View.findDrawableById("StepValue") as Text;
        stepValue.setText(getSteps());

        var heartRateValue = View.findDrawableById("HRValue") as Text;
        heartRateValue.setText(getHeartRate());

        var temperatureValue = View.findDrawableById("TemperatureValue") as Text;
        temperatureValue.setText(getTemperature());
        
        var weatherValue = View.findDrawableById("WeatherValue") as Text;
        weatherValue.setText(getWeather());
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {}

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {}

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {}

    // Get the current time and format it correctly
    private function getTime() {
        var timeFormat = "$1$:$2$:$3$";
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {
            if (getApp().getProperty("UseMilitaryFormat")) {
                timeFormat = "$1$$2$$3$";
                hours = hours.format("%02d");
            }
        }        
        var minutes = clockTime.min.format("%02d"); // 2-digit minutes
        var seconds = clockTime.sec.format("%02d"); // 2-digit seconds
        return Lang.format(timeFormat, [hours, minutes, seconds]);
    }

    private function getDate() {
        // Get the current time
        var now = Time.now();
        // Extract the date info, the strings will be localized
        var date = Gregorian.info(now, Time.FORMAT_MEDIUM); // Extract the date info
        // Format the date into "ddd, MMM, D", for instance: "Thu, Jan 6"
        var dateString = Lang.format("$1$, $2$ $3$, $4$", [date.day_of_week, date.month, date.day, date.year]);
        return dateString;
    }

    private function getBattery() {
        var battery = System.getSystemStats().battery;
        return Lang.format("$1$%", [battery.format("%d")]);
    }

    private function getSteps() {
        var steps = ActivityMonitor.getInfo().steps;
        return Lang.format("$1$", [steps.format("%d")]);
    }

    private function getHeartRate() {
        // initialize it to --
        var heartRate = "--";

        // Get the activity info if possible
        var info = Activity.getActivityInfo();
        if (info != null) {
            if (info.currentHeartRate != null) {
                heartRate = Lang.format("$1$", [info.currentHeartRate.format("%d")]);
            }
        }
        // if (heartRate == null) {
        //     // Fallback to `getHeartRateHistory`
        //     var latestHeartRateSample = ActivityMonitor.getHeartRateHistory(1, true).next();
        //     if (latestHeartRateSample != null) {
        //         heartRate = Lang.format("$1$", [latestHeartRateSample.heartRate.format("%d")]);
        //     }
        // }

        return heartRate + " bpm";
    }

    private function getTemperature() {
        var info = Weather.getCurrentConditions();
        var temperature = (info.temperature * 1.8) + 32;

        return Lang.format("$1$ F", [temperature.format("%d")]);
    }

    private function getWeather() {
        var info = Weather.getCurrentConditions();
        var condition = info.condition;
        return Lang.format("$1$", [weather_conditions[condition]]);
    }
}
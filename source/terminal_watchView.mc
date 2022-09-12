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


class terminal_watchView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Get the current time and format it correctly
        var timeFormat = "$1$:$2$";
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {
            if (getApp().getProperty("UseMilitaryFormat")) {
                timeFormat = "$1$$2$";
                hours = hours.format("%02d");
            }
        }
        var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);
        var stats = System.getSystemStats(); 
        var pwr = stats.battery; 
        var batStr = Lang.format( "$1$%", [ pwr.format( "%2d" ) ] ); 
        var date = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var steps = ActivityMonitor.getInfo().steps;
        var stepStr = Lang.format( "$1$", [ steps.format( "%5d" ) ] );
        var hr = Activity.Info.currentHeartRate;
        var hrStr = Lang.format( "$1$", [ hr.format( "%3d" ) ] );

        // Update the view
        var timeLabel = View.findDrawableById("TimeLabel") as Text;
        timeLabel.setText("[Time]");

        var timeValue = View.findDrawableById("TimeValue") as Text;
        timeValue.setText(timeString);

        var dateLabel = View.findDrawableById("DateLabel") as Text;
        dateLabel.setText("[DATE]");

        var dateValue = View.findDrawableById("DateValue") as Text;
        dateValue.setText(date.month + " " + date.day + ", " + date.year);

        var battLabel = View.findDrawableById("BattLabel") as Text;
        battLabel.setText("[Batt]");

        var battValue = View.findDrawableById("BattValue") as Text;
        battValue.setText(batStr);

        var stepLabel = View.findDrawableById("StepLabel") as Text;
        stepLabel.setText("[STEP]");

        var stepValue = View.findDrawableById("StepValue") as Text;
        stepValue.setText(stepStr);

        var hrLabel = View.findDrawableById("HRLabel") as Text;
        hrLabel.setText("[L_HR]");

        var hrValue = View.findDrawableById("HRValue") as Text;
        hrValue.setText(hrStr + " bpm");

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}

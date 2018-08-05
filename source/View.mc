using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;
using Toybox.Time;
using Toybox.Time.Gregorian;

class Box {
    var x, y, w, h;

    function initialize(x, y, w, h) {
        self.x = x;
        self.y = y;
        self.w = w;
        self.h = h;
    }

    function setPos(x, y) {
        self.x = x;
        self.y = y;
    }

    function setSize(w, h) {
        self.w = w;
        self.h = h;
    }
}

class IsPhoneConnected {
    static function isTrue() {
        return Sys.getDeviceSettings().phoneConnected;
    }
}

class View extends Ui.WatchFace {
    var squareFont = null;
    var boxTime = null;
    var boxSeconds = null;
    var boxDate = null;

    var lblSeconds = null;
    var lblDate = null;
    var iconBattery = null;
    var iconConnection = null;

    var iconManager = null;

    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));

        var font = null;
        var label = null;
        var dim = null;
        var icon = null;

        font = Ui.loadResource(Rez.Fonts.square_BIG);
        label = View.findDrawableById("TimeLabel");
        dim = dc.getTextDimensions("00:00", font);
        boxTime = new Box(label.locX, label.locY, dim[1], dim[1]);

        font = Ui.loadResource(Rez.Fonts.square_MEDIUM);
        dim = dc.getTextDimensions("00", font);
        boxSeconds = new Box(boxTime.x, boxTime.y + boxTime.h - 10,
                dim[0], dim[1]);
        label = new Ui.Text({
            :text => "",
            :color => App.getApp().getProperty("ForegroundColor"),
            :font => font,
            :locX => boxSeconds.x,
            :locY => boxSeconds.y,
            :justification => Gfx.TEXT_JUSTIFY_CENTER
        });
        lblSeconds = label;

        font = Ui.loadResource(Rez.Fonts.square_SMALL);
        dim = dc.getTextDimensions("00-00-0000", font);
        boxDate = new Box(boxTime.x, boxTime.y - dim[1] - 5, dim[0], dim[1]);
        label = new Ui.Text({
            :text => "",
            :color => App.getApp().getProperty("ForegroundColor"),
            :font => font,
            :locX => boxDate.x,
            :locY => boxDate.y,
            :justification => Gfx.TEXT_JUSTIFY_CENTER
        });
        lblDate = label;

        icon = new BatteryIcon({
            :locX => boxSeconds.x - 12,
            :locY => dc.getHeight() - 25,
            :width => 25,
            :height => 10
        });
        iconBattery = icon;

        icon = new ConnectionIcon({
            :locX => boxSeconds.x + 22,
            :locY => dc.getHeight() - 32,
            :width => 10,
            :height => 20
        });
        iconConnection = icon;

        iconManager = new IconManager(120, 10);
        iconManager.addIcon(iconConnection, IsPhoneConnected);
    }

    function onShow() {
    }

    function onUpdate(dc) {
        var timeDelimiter = ":";
        if (App.getApp().getProperty("TimeDelimiter") == 1) {
            timeDelimiter = " ";
        } else if (App.getApp().getProperty("TimeDelimiter") == 2) {
            timeDelimiter = "";
        }

        var dateDelimiter = ".";
        if (App.getApp().getProperty("DateDelimiter") == 1) {
            dateDelimiter = "-";
        } else if (App.getApp().getProperty("DateDelimiter") == 2) {
            dateDelimiter= "/";
        }

        var timeFormat = "$1$" + timeDelimiter + "$2$";
        var clockTime = Sys.getClockTime();
        var hours = clockTime.hour;
        if (!Sys.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        }
        var timeString = Lang.format(timeFormat,
                [hours, clockTime.min.format("%02d")]);

        var view = View.findDrawableById("TimeLabel");
        view.setColor(App.getApp().getProperty("ForegroundColor"));
        view.setText(timeString);

        lblSeconds.setColor(App.getApp().getProperty("SecondsColor"));
        lblSeconds.setText(clockTime.sec.format("%02d"));

        var date = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var dateString = Lang.format(
            "$1$" + dateDelimiter + "$2$" + dateDelimiter + "$3$",
            [
                date.day.format("%02d"),
                date.month.format("%02d"),
                date.year.format("%04d")
            ]
        );
        lblDate.setColor(App.getApp().getProperty("DateColor"));
        lblDate.setText(dateString);

        dc.clearClip();
        View.onUpdate(dc);
        if (App.getApp().getProperty("ShowSeconds")) {
            lblSeconds.draw(dc);
        }
        if (App.getApp().getProperty("ShowDate")) {
            lblDate.draw(dc);
        }
        iconBattery.draw(dc);

        iconManager.draw(dc);

        // Sys.println("alarms: " + Sys.getDeviceSettings().alarmCount);
        // Sys.println("dnd: " + Sys.getDeviceSettings().doNotDisturb);
        // Sys.println("notif: " + Sys.getDeviceSettings().notificationCount);
        // Sys.println("phone: " + Sys.getDeviceSettings().phoneConnected);
    }

    function onPartialUpdate(dc) {
        if (!App.getApp().getProperty("ShowSeconds")) {
            return;
        }

        var sec = Sys.getClockTime().sec;
        var label = lblSeconds;
        label.setText(sec.format("%02d"));
        label.setColor(App.getApp().getProperty("SecondsColor"));
        dc.setColor(App.getApp().getProperty("SecondsColor"),
                App.getApp().getProperty("BackgroundColor"));
        dc.setClip(boxSeconds.x - boxSeconds.w / 2, boxSeconds.y, boxSeconds.w,
                boxSeconds.h);
        dc.clear();
        label.draw(dc);
    }

    function onPowerBudgetExceeded(powerInfo) {
        App.getApp().setProperty("ShowSeconds", false);
    }

    function onHide() {
    }

    function onExitSleep() {
    }

    function onEnterSleep() {
    }

    // FIXME: remove before shipping
    function printDim(x, y, w, h) {
        System.println("x: " + x + ", y: " + y + ", w: " + w + ", h: " + h);
    }
}

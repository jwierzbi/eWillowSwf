using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class BatteryIcon extends Ui.Drawable {
    var color = null;
    var threshold = 25.0;

    function initialize(options) {
        var settings = {
            :identifier => "BatteryIcon",
            :locX => options[:locX],
            :locY => options[:locY],
            :width => options[:width],
            :height => options[:height]
        };

        color = options has :color ? options["color"] :
                App.getApp().getProperty("ForegroundColor");

        Drawable.initialize(settings);
    }

    function draw(dc) {
        dc.setColor(color, Gfx.COLOR_TRANSPARENT);
        // draw outer outline
        dc.drawRectangle(locX, locY, width - 2, height);
        // draw inner outline
        dc.drawRectangle(locX + 1, locY + 1, width - 4, height - 2);
        // draw right connector
        dc.drawRectangle(locX + width - 2, locY + 2, 2, height - 4);

        var battery = Sys.getSystemStats().battery;
        var fill = (width - 4) * battery / 100;

        if (battery <= threshold) {
            dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        }
        dc.fillRectangle(locX + 2, locY + 2, fill, height - 4);
    }

    // FIXME: remove before shipping
    function printDim(x, y, w, h) {
        System.println("x: " + x + ", y: " + y + ", w: " + w + ", h: " + h);
    }
}
using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class ConnectionIcon extends Ui.Drawable {
    var color = null;
    var threshold = 25.0;

    function initialize(options) {
        var settings = {
            :identifier => "ConnectionIcon",
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
        // draw phones body
        dc.drawRectangle(locX, locY + 2, width, height - 2);
        // draw aerial
        dc.drawLine(locX, locY, locX + 4, locY);
        // draw screen
        dc.drawRectangle(locX + 2, locY + 4, width - 4, height - 12);
        // draw keyboard
        dc.drawPoint(locX + 3, locY + height - 7);
        dc.drawPoint(locX + 3, locY + height - 5);
        dc.drawPoint(locX + 3, locY + height - 3);
        dc.drawPoint(locX + width - 4, locY + height - 7);
        dc.drawPoint(locX + width - 4, locY + height - 5);
        dc.drawPoint(locX + width - 4, locY + height - 3);
    }

    // FIXME: remove before shipping
    function printDim(x, y, w, h) {
        System.println("x: " + x + ", y: " + y + ", w: " + w + ", h: " + h);
    }
}
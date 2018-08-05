using Toybox.Application as Application;
using Toybox.WatchUi as Ui;
using Toybox.System;

class App extends Application.AppBase {
    function initialize() {
        AppBase.initialize();
    }

    function onStart(state) {
    }

    function onStop(state) {
    }

    function getInitialView() {
        return [ new View() ];
    }

    function onSettingsChanged() {
        Ui.requestUpdate();
    }
}

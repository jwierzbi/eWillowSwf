
class _IconWrapper {
    var icon = null;
    var cond = null;

    function initialize(icon, cond) {
        self.icon = icon;
        self.cond = cond;
    }

    function isVisible() {
        return cond.isTrue();
    }

    function draw(dc) {
        icon.draw(dc);
    }
}

class IconManager {
    var x;
    var y;

    // for now only one icon
    var icon = null;

    function initialize(x, y) {
        self.x = x;
        self.y = y;
    }

    function addIcon(icon, cond) {
        self.icon = new _IconWrapper(icon, cond);
        icon.setLocation(x - icon.width, y);
    }

    function draw(dc) {
        if (icon.isVisible()) {
            icon.draw(dc);
        }
    }
}

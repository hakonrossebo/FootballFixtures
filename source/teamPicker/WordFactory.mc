using Toybox.Graphics as Gfx;
using Toybox.WatchUi as Ui;

class WordFactory extends Ui.PickerFactory {
    var mWords;
    var mWordsValues;
    var mFont;

    function initialize(words, values, options) {
        mWords = words;
        mWordsValues = values;

        if(options != null) {
            mFont = options.get(:font);
        }

        if(mFont == null) {
            mFont = Gfx.FONT_LARGE;
        }
    }

    function getIndex(value) {
		return mWordsValues[value];
    }

    function getSize() {
        return mWords.size();
    }

    function getValue(index) {
        return mWordsValues[index];
    }

    function getDrawable(index, selected) {
        return new Ui.Text({:text=>mWords[index], :color=>Gfx.COLOR_WHITE, :font=>mFont, :locX=>Ui.LAYOUT_HALIGN_CENTER, :locY=>Ui.LAYOUT_VALIGN_CENTER});
    }
}

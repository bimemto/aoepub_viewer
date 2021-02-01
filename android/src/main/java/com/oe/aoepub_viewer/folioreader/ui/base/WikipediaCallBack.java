package com.oe.aoepub_viewer.folioreader.ui.base;


import com.oe.aoepub_viewer.folioreader.model.dictionary.Wikipedia;

/**
 * @author gautam chibde on 4/7/17.
 */

public interface WikipediaCallBack extends BaseMvpView {

    void onWikipediaDataReceived(Wikipedia wikipedia);

    //TODO
    void playMedia(String url);
}

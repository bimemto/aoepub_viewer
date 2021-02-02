package com.oe.aoepub_viewer.folioreader.ui.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.oe.aoepub_viewer.R;
import com.oe.aoepub_viewer.folioreader.util.StyleableTextView;
import com.oe.aoepub_viewer.folioreader.util.UiUtil;
import com.skydoves.powermenu.MenuBaseAdapter;

public class FontMenuAdapter extends MenuBaseAdapter<FontMenuItem> {

    @Override
    public View getView(int index, View view, ViewGroup viewGroup) {
        final Context context = viewGroup.getContext();

        if (view == null) {
            LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            view = inflater.inflate(R.layout.font_menu_item, viewGroup, false);
        }

        FontMenuItem item = (FontMenuItem) getItem(index);
        final StyleableTextView title = view.findViewById(R.id.txtFontName);
        title.setText(item.title);
        UiUtil.setCustomFont(title, context, item.font);
        return super.getView(index, view, viewGroup);
    }
}

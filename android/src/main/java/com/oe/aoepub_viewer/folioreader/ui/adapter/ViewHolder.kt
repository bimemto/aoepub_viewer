package com.oe.aoepub_viewer.folioreader.ui.adapter

import android.view.View
import androidx.recyclerview.widget.RecyclerView
import com.oe.aoepub_viewer.folioreader.ui.adapter.ListViewType

open class ViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
    var listViewType: ListViewType = ListViewType.UNKNOWN_VIEW
    var itemPosition: Int = -1

    open fun onBind(position: Int) {}
}
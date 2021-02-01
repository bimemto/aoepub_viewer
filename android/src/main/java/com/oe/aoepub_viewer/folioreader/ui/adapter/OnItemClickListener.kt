package com.oe.aoepub_viewer.folioreader.ui.adapter

import androidx.recyclerview.widget.RecyclerView

interface OnItemClickListener {
    fun onItemClick(
        adapter: RecyclerView.Adapter<RecyclerView.ViewHolder>,
        viewHolder: RecyclerView.ViewHolder, position: Int, id: Long
    )
}
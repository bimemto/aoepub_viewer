package com.oe.aoepub_viewer.folioreader.ui.view

import android.animation.Animator
import android.animation.ArgbEvaluator
import android.animation.ValueAnimator
import android.os.Build
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.*
import androidx.core.content.ContextCompat
import androidx.fragment.app.Fragment
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.google.android.material.bottomsheet.BottomSheetDialogFragment
import com.oe.aoepub_viewer.R
import com.oe.aoepub_viewer.folioreader.Config
import com.oe.aoepub_viewer.folioreader.model.event.ReloadDataEvent
import com.oe.aoepub_viewer.folioreader.ui.activity.FolioActivity
import com.oe.aoepub_viewer.folioreader.ui.activity.FolioActivityCallback
import com.oe.aoepub_viewer.folioreader.ui.adapter.FontMenuAdapter
import com.oe.aoepub_viewer.folioreader.ui.adapter.FontMenuItem
import com.oe.aoepub_viewer.folioreader.ui.fragment.MediaControllerFragment
import com.oe.aoepub_viewer.folioreader.util.AppUtil
import com.oe.aoepub_viewer.folioreader.util.UiUtil
import com.skydoves.powermenu.CustomPowerMenu
import com.skydoves.powermenu.MenuAnimation
import com.skydoves.powermenu.MenuBaseAdapter
import com.skydoves.powermenu.OnMenuItemClickListener
import kotlinx.android.synthetic.main.view_config.*
import org.greenrobot.eventbus.EventBus


/**
 * Created by mobisys2 on 11/16/2016.
 */
class ConfigBottomSheetDialogFragment : BottomSheetDialogFragment(), CompoundButton.OnCheckedChangeListener {

    companion object {
        const val FADE_DAY_NIGHT_MODE = 500

        @JvmField
        val LOG_TAG: String = ConfigBottomSheetDialogFragment::class.java.simpleName
    }

    private lateinit var config: Config
    private var colorMode = 0
    private lateinit var activityCallback: FolioActivityCallback
    private lateinit var customPowerMenu: CustomPowerMenu<*, *>

    override fun onCreateView(
            inflater: LayoutInflater,
            container: ViewGroup?,
            savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.view_config, container)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        if (activity is FolioActivity)
            activityCallback = activity as FolioActivity

        view.viewTreeObserver.addOnGlobalLayoutListener {
            val dialog = dialog as BottomSheetDialog
            val bottomSheet =
                    dialog.findViewById<View>(com.google.android.material.R.id.design_bottom_sheet) as FrameLayout?
            val behavior = BottomSheetBehavior.from(bottomSheet!!)
            behavior.state = BottomSheetBehavior.STATE_EXPANDED
            behavior.peekHeight = 0
        }

        config = AppUtil.getSavedConfig(activity)!!
        initViews()
    }

    override fun onDestroy() {
        super.onDestroy()
        view?.viewTreeObserver?.addOnGlobalLayoutListener(null)
    }

    private fun initViews() {
        inflateView()
        configFonts()
        view_config_font_size_seek_bar.progress = config.fontSize
        configSeekBar()
        selectFont(config.font, false)
        colorMode = config.colorMode
        when (colorMode) {
            4 -> {
                container.setBackgroundColor(ContextCompat.getColor(context!!, R.color.night))
            }
//            3 -> {
//                container.setBackgroundColor(ContextCompat.getColor(context!!, R.color.pink))
//            }
//            2 -> {
//                container.setBackgroundColor(ContextCompat.getColor(context!!, R.color.gray))
//            }
//            1 -> {
//                container.setBackgroundColor(ContextCompat.getColor(context!!, R.color.purple))
//            }
            else -> {
                container.setBackgroundColor(ContextCompat.getColor(context!!, R.color.white))
            }
        }

        when (colorMode) {
            4 -> {
                btnBlack.isChecked = true
            }
            3 -> {
                btnPink.isChecked = true
            }
            2 -> {
                btnGray.isChecked = true
            }
            1 -> {
                btnPurple.isChecked = true
            }
            else -> {
                btnWhite.isChecked = true
            }
        }
        UiUtil.setColorIntToDrawable(
                config.currentThemeColor,
                btnFont.drawable
        )
    }

    private fun inflateView() {

        if (config.allowedDirection != Config.AllowedDirection.VERTICAL_AND_HORIZONTAL) {
            //view5.visibility = View.GONE
            buttonVertical.visibility = View.GONE
            buttonHorizontal.visibility = View.GONE
        }
        btnWhite.setOnCheckedChangeListener(this@ConfigBottomSheetDialogFragment)
        btnPurple.setOnCheckedChangeListener(this@ConfigBottomSheetDialogFragment)
        btnGray.setOnCheckedChangeListener(this@ConfigBottomSheetDialogFragment)
        btnPink.setOnCheckedChangeListener(this@ConfigBottomSheetDialogFragment)
        btnBlack.setOnCheckedChangeListener(this@ConfigBottomSheetDialogFragment)

        if (activityCallback.direction == Config.Direction.HORIZONTAL) {
            buttonHorizontal.isSelected = true
            UiUtil.setColorIntToDrawable(
                    config.currentThemeColor,
                    iv_horizontal.drawable
            )
            UiUtil.setColorResToDrawable(R.color.app_gray, iv_vertical.drawable)
        } else if (activityCallback.direction == Config.Direction.VERTICAL) {
            buttonVertical.isSelected = true
            UiUtil.setColorIntToDrawable(
                    config.currentThemeColor,
                    iv_vertical.drawable
            )
            UiUtil.setColorResToDrawable(R.color.app_gray, iv_horizontal.drawable)
        }

        buttonVertical.setOnClickListener {
            config = AppUtil.getSavedConfig(context)!!
            config.direction = Config.Direction.VERTICAL
            AppUtil.saveConfig(context, config)
            activityCallback.onDirectionChange(Config.Direction.VERTICAL)
            buttonHorizontal.isSelected = false
            buttonVertical.isSelected = true
            UiUtil.setColorIntToDrawable(
                    config.currentThemeColor,
                    iv_vertical.drawable
            )
            UiUtil.setColorResToDrawable(R.color.app_gray, iv_horizontal.drawable)
        }

        buttonHorizontal.setOnClickListener {
            config = AppUtil.getSavedConfig(context)!!
            config.direction = Config.Direction.HORIZONTAL
            AppUtil.saveConfig(context, config)
            activityCallback.onDirectionChange(Config.Direction.HORIZONTAL)
            buttonHorizontal.isSelected = true
            buttonVertical.isSelected = false
            UiUtil.setColorIntToDrawable(
                    config.currentThemeColor,
                    iv_horizontal.drawable
            )
            UiUtil.setColorResToDrawable(R.color.app_gray, iv_vertical.drawable)
        }

        btnFont.setOnClickListener {
            customPowerMenu.showAsAnchorCenter(btnFont)
//            val location = IntArray(2)
//            btnFont.getLocationOnScreen(location)
//            val x = location[0]
//            val y = location[1]
//            customPowerMenu.showAtLocation(btnFont, x - 50, y + 150)
        }
    }

    private val onIconMenuItemClickListener: OnMenuItemClickListener<FontMenuItem> = OnMenuItemClickListener<FontMenuItem> { position, item ->
        selectFont(item!!.font, true)
        customPowerMenu.dismiss()
    }

    private fun configFonts() {

        val colorStateList = UiUtil.getColorList(
                config.currentThemeColor,
                ContextCompat.getColor(context!!, R.color.grey_color)
        )

        txtVertical.setTextColor(colorStateList)
        txtHorizontal.setTextColor(colorStateList)
        //val adapter = FontAdapter(config, context!!)
        customPowerMenu = CustomPowerMenu.Builder<FontMenuItem, MenuBaseAdapter<FontMenuItem>>(context!!, FontMenuAdapter())
                .addItem(FontMenuItem("Bookerly", "fonts/andada/Andada-Regular.otf"))
                .addItem(FontMenuItem("Georgia", "fonts/lato/Lato-Regular.ttf"))
                .addItem(FontMenuItem("Baskerville", "fonts/lora/Lora-Regular.ttf"))
                .addItem(FontMenuItem("Raleway", "fonts/raleway/Raleway-Regular.ttf"))
                .setOnMenuItemClickListener(onIconMenuItemClickListener)
                .setAnimation(MenuAnimation.SHOWUP_BOTTOM_RIGHT)
                .setMenuRadius(10f)
                .setMenuShadow(10f)
                .build()
//        view_config_font_spinner.adapter = adapter
//
//        view_config_font_spinner.background.setColorFilter(
//                if (config.isNightMode) {
//                    R.color.night_default_font_color
//                } else {
//                    R.color.day_default_font_color
//                },
//                PorterDuff.Mode.SRC_ATOP
//        )
//
//        val fontIndex = adapter.fontKeyList.indexOf(config.font)
//        view_config_font_spinner.setSelection(if (fontIndex < 0) 0 else fontIndex)
//
//        view_config_font_spinner.onItemSelectedListener =
//                object : AdapterView.OnItemSelectedListener {
//                    override fun onItemSelected(
//                            parent: AdapterView<*>?,
//                            view: View?,
//                            position: Int,
//                            id: Long
//                    ) {
//                        selectFont(adapter.fontKeyList[position], true)
//                    }
//
//                    override fun onNothingSelected(parent: AdapterView<*>?) {
//                    }
//                }
    }

    private fun selectFont(selectedFont: String, isReloadNeeded: Boolean) {
        // parse font from name
        config.font = selectedFont

        if (isAdded && isReloadNeeded) {
            AppUtil.saveConfig(activity, config)
            EventBus.getDefault().post(ReloadDataEvent())
        }
    }

    private fun changeTheme(toThemeColor: Int) {

        val day = ContextCompat.getColor(context!!, R.color.white)
        val night = ContextCompat.getColor(context!!, R.color.night)

        val colorMode: Int
        colorMode = when (toThemeColor) {
            4 -> {
                night
            }
            else -> {
                day
            }
        }
        val fromThemeColor: Int
        fromThemeColor = when (this.colorMode) {
            4 -> {
                night
            }
            else -> {
                day
            }
        }
        val colorAnimation = ValueAnimator.ofObject(
                ArgbEvaluator(),
                fromThemeColor, colorMode
        )
//        val colorAnimation = ValueAnimator.ofObject(
//                ArgbEvaluator(),
//                if (isNightMode == 4) night else colorMode, if (isNightMode == 4) colorMode else night
//        )
        colorAnimation.duration = FADE_DAY_NIGHT_MODE.toLong()

        colorAnimation.addUpdateListener { animator ->
            val value = animator.animatedValue as Int
            container.setBackgroundColor(value)
        }

        colorAnimation.addListener(object : Animator.AnimatorListener {
            override fun onAnimationStart(animator: Animator) {}

            override fun onAnimationEnd(animator: Animator) {
                this@ConfigBottomSheetDialogFragment.colorMode = toThemeColor //!isNightMode
                config.colorMode = this@ConfigBottomSheetDialogFragment.colorMode
                AppUtil.saveConfig(activity, config)
                EventBus.getDefault().post(ReloadDataEvent())
            }

            override fun onAnimationCancel(animator: Animator) {}

            override fun onAnimationRepeat(animator: Animator) {}
        })

        colorAnimation.duration = FADE_DAY_NIGHT_MODE.toLong()

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {

            val attrs = intArrayOf(android.R.attr.navigationBarColor)
            val typedArray = activity?.theme?.obtainStyledAttributes(attrs)
            val defaultNavigationBarColor = typedArray?.getColor(
                    0,
                    ContextCompat.getColor(context!!, R.color.white)
            )
            val black = ContextCompat.getColor(context!!, R.color.black)

            val navigationColorAnim = ValueAnimator.ofObject(
                    ArgbEvaluator(),
                    if (this.colorMode == 4) black else defaultNavigationBarColor,
                    if (this.colorMode == 4) defaultNavigationBarColor else black
            )

            navigationColorAnim.addUpdateListener { valueAnimator ->
                val value = valueAnimator.animatedValue as Int
                activity?.window?.navigationBarColor = value
            }

            navigationColorAnim.duration = FADE_DAY_NIGHT_MODE.toLong()
            navigationColorAnim.start()
        }

        colorAnimation.start()
    }

    private fun configSeekBar() {
        val thumbDrawable = ContextCompat.getDrawable(activity!!, R.drawable.seekbar_thumb)
        UiUtil.setColorIntToDrawable(config.currentThemeColor, thumbDrawable)
        UiUtil.setColorResToDrawable(
                R.color.grey_color,
                view_config_font_size_seek_bar.progressDrawable
        )
        view_config_font_size_seek_bar.thumb = thumbDrawable

        view_config_font_size_seek_bar.setOnSeekBarChangeListener(object :
                SeekBar.OnSeekBarChangeListener {
            override fun onProgressChanged(seekBar: SeekBar, progress: Int, fromUser: Boolean) {
                config.fontSize = progress
                AppUtil.saveConfig(activity, config)
                EventBus.getDefault().post(ReloadDataEvent())
            }

            override fun onStartTrackingTouch(seekBar: SeekBar) {}

            override fun onStopTrackingTouch(seekBar: SeekBar) {}
        })
    }

    private fun setToolBarColor() {
        if (colorMode != 4) {
            activityCallback.setDayMode()
        } else {
            activityCallback.setNightMode()
        }
    }

    private fun setAudioPlayerBackground() {

        var mediaControllerFragment: Fragment? =
                fragmentManager?.findFragmentByTag(MediaControllerFragment.LOG_TAG)
                        ?: return
        mediaControllerFragment = mediaControllerFragment as MediaControllerFragment
        if (colorMode == 4) {
            mediaControllerFragment.setDayMode()
        } else {
            mediaControllerFragment.setNightMode()
        }
    }

    override fun onCheckedChanged(radio: CompoundButton?, value: Boolean) {
        if (value) {
            when (radio?.id) {
                R.id.btnWhite -> {
                    if (colorMode == 0) {
                        return
                    }
                    colorMode = 0
                    changeTheme(0)
                    btnPurple.isChecked = false
                    btnGray.isChecked = false
                    btnPink.isChecked = false
                    btnBlack.isChecked = false
                }
                R.id.btnPurple -> {
                    if (colorMode == 1) {
                        return
                    }
                    colorMode = 1
                    changeTheme(1)
                    btnWhite.isChecked = false
                    btnGray.isChecked = false
                    btnPink.isChecked = false
                    btnBlack.isChecked = false
                }
                R.id.btnGray -> {
                    if (colorMode == 2) {
                        return
                    }
                    colorMode = 2
                    changeTheme(2)
                    btnPurple.isChecked = false
                    btnWhite.isChecked = false
                    btnPink.isChecked = false
                    btnBlack.isChecked = false
                }
                R.id.btnPink -> {
                    if (colorMode == 3) {
                        return
                    }
                    colorMode = 3
                    changeTheme(3)
                    btnPurple.isChecked = false
                    btnGray.isChecked = false
                    btnWhite.isChecked = false
                    btnBlack.isChecked = false
                }
                R.id.btnBlack -> {
                    if (colorMode == 4) {
                        return
                    }
                    colorMode = 4
                    changeTheme(4)
                    btnPurple.isChecked = false
                    btnGray.isChecked = false
                    btnPink.isChecked = false
                    btnWhite.isChecked = false
                }
            }
            setToolBarColor()
            setAudioPlayerBackground()
            //UiUtil.setColorResToDrawable(R.color.app_gray, view_config_ib_night_mode.drawable)
            UiUtil.setColorIntToDrawable(config.currentThemeColor, btnFont.drawable)
            //dialog?.hide()
        }

    }
}

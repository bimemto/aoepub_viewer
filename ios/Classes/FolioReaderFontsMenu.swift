//
//  FolioReaderFontsMenu.swift
//  aoepub_viewer
//
//  Created by Salem Duy on 27/01/2021.
//

import UIKit
import Popover

public enum FolioReaderFont: Int {
    case andada = 0
    case lato
    case lora
    case raleway

    public static func folioReaderFont(fontName: String) -> FolioReaderFont? {
        var font: FolioReaderFont?
        switch fontName {
        case "andada": font = .andada
        case "lato": font = .lato
        case "lora": font = .lora
        case "raleway": font = .raleway
        default: break
        }
        return font
    }

    public var cssIdentifier: String {
        switch self {
        case .andada: return "andada"
        case .lato: return "lato"
        case .lora: return "lora"
        case .raleway: return "raleway"
        }
    }
}

public enum FolioReaderFontSize: Int {
    case xs = 0
    case s
    case m
    case l
    case xl

    public static func folioReaderFontSize(fontSizeStringRepresentation: String) -> FolioReaderFontSize? {
        var fontSize: FolioReaderFontSize?
        switch fontSizeStringRepresentation {
        case "textSizeOne": fontSize = .xs
        case "textSizeTwo": fontSize = .s
        case "textSizeThree": fontSize = .m
        case "textSizeFour": fontSize = .l
        case "textSizeFive": fontSize = .xl
        default: break
        }
        return fontSize
    }

    public var cssIdentifier: String {
        switch self {
        case .xs: return "textSizeOne"
        case .s: return "textSizeTwo"
        case .m: return "textSizeThree"
        case .l: return "textSizeFour"
        case .xl: return "textSizeFive"
        }
    }
}

class FolioReaderFontsMenu: UIViewController, SMSegmentViewDelegate, UIGestureRecognizerDelegate {
    var menuView: UIView!
    var btnChangeFont: UIButton!
    fileprivate var readerConfig: FolioReaderConfig
    fileprivate var folioReader: FolioReader
    var statusBarStyle: UIStatusBarStyle = .default
    
    fileprivate var texts = ["Bookerly", "Georgia", "Baskerville", "Raleway"]

      fileprivate var popover: Popover!
      fileprivate var popoverOptions: [PopoverOption] = [
        .type(.up),
        .cornerRadius(10),
        .blackOverlayColor(UIColor(white: 0.0, alpha: 0.6))
      ]

    init(folioReader: FolioReader, readerConfig: FolioReaderConfig) {
        self.readerConfig = readerConfig
        self.folioReader = folioReader

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.clear

        // Tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(FolioReaderFontsMenu.tapGesture))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        let menuHeightFull: CGFloat = hasTopNotch ? 266 : 232
        let menuHeightLack: CGFloat = hasTopNotch ? 214 : 180
        // Menu view
        var visibleHeight: CGFloat = self.readerConfig.canChangeScrollDirection ? menuHeightFull : menuHeightLack
        visibleHeight = self.readerConfig.canChangeFontStyle ? visibleHeight : visibleHeight - 55
        menuView = UIView(frame: CGRect(x: 0, y: view.frame.height-visibleHeight, width: view.frame.width, height: view.frame.height))
        let colorMode = self.folioReader.isNight()
        switch colorMode {
        case 0:
            menuView.backgroundColor = self.readerConfig.daysModeNavBackground
            break
        case 1:
            menuView.backgroundColor = self.readerConfig.daysModeNavBackground
            break
        case 2:
            menuView.backgroundColor = self.readerConfig.daysModeNavBackground
            break
        case 3:
            menuView.backgroundColor = self.readerConfig.daysModeNavBackground
            break
        case 4:
            menuView.backgroundColor = self.readerConfig.nightModeBackground
            break
        default:
            menuView.backgroundColor = self.readerConfig.daysModeNavBackground
            break
        }
        
        menuView.autoresizingMask = .flexibleWidth
        menuView.layer.shadowColor = UIColor.black.cgColor
        menuView.layer.shadowOffset = CGSize(width: 0, height: 0)
        menuView.layer.shadowOpacity = 0.3
        menuView.layer.shadowRadius = 6
        menuView.layer.shadowPath = UIBezierPath(rect: menuView.bounds).cgPath
        menuView.layer.rasterizationScale = UIScreen.main.scale
        menuView.layer.shouldRasterize = true
        view.addSubview(menuView)

        let normalColor = UIColor(rgba: "#BDBDBD") //UIColor(white: 0.5, alpha: 0.7)
        let selectedColor = self.readerConfig.tintColor
        let sun = UIImage(readerImageNamed: "ic_sun")
        let moon = UIImage(readerImageNamed: "ic_moon")
        let fontSmall = UIImage(readerImageNamed: "icon-font-small")
        let fontBig = UIImage(readerImageNamed: "icon-font-big")

        let sunNormal = sun?.imageTintColor(normalColor)?.withRenderingMode(.alwaysOriginal)
        let moonNormal = moon?.imageTintColor(normalColor)?.withRenderingMode(.alwaysOriginal)
        let fontSmallNormal = fontSmall?.imageTintColor(normalColor)?.withRenderingMode(.alwaysOriginal)
        let fontBigNormal = fontBig?.imageTintColor(normalColor)?.withRenderingMode(.alwaysOriginal)

        let sunSelected = sun?.imageTintColor(selectedColor)?.withRenderingMode(.alwaysOriginal)
        let moonSelected = moon?.imageTintColor(selectedColor)?.withRenderingMode(.alwaysOriginal)
        
        //paper color changer
        let whiteNormal = UIImage(readerImageNamed: "ic_paper_white")
        let whiteSelected = UIImage(readerImageNamed: "ic_paper_white_selected")
        let purpleNormal = UIImage(readerImageNamed: "ic_paper_purple")
        let purpleSelected = UIImage(readerImageNamed: "ic_paper_purple_selected")
        let grayNormal = UIImage(readerImageNamed: "ic_paper_gray")
        let graySelected = UIImage(readerImageNamed: "ic_paper_gray_selected")
        let pinkNormal = UIImage(readerImageNamed: "ic_paper_pink")
        let pinkSelected = UIImage(readerImageNamed: "ic_paper_pink_selected")
        let blackNormal = UIImage(readerImageNamed: "ic_paper_black")
        let blackSelected = UIImage(readerImageNamed: "ic_paper_black_selected")
        
        // Day night mode
        let dayNight = SMSegmentView(frame: CGRect(x: 0, y: 0, width: view.frame.width - 60, height: 55),
                                     separatorColour: self.readerConfig.nightModeSeparatorColor,
                                     separatorWidth: 0,
                                     segmentProperties:  [
                                        keySegmentTitleFont: UIFont(name: "Avenir-Light", size: 17)!,
                                        keySegmentOnSelectionColour: UIColor.clear,
                                        keySegmentOffSelectionColour: UIColor.clear,
                                        keySegmentOnSelectionTextColour: selectedColor,
                                        keySegmentOffSelectionTextColour: normalColor,
                                        keyContentVerticalMargin: 17 as AnyObject
            ])
        dayNight.delegate = self
        dayNight.tag = 1
        dayNight.addSegmentWithTitle("", onSelectionImage: whiteSelected, offSelectionImage: whiteNormal)
        dayNight.addSegmentWithTitle("", onSelectionImage: purpleSelected, offSelectionImage: purpleNormal)
        dayNight.addSegmentWithTitle("", onSelectionImage: graySelected, offSelectionImage: grayNormal)
        dayNight.addSegmentWithTitle("", onSelectionImage: pinkSelected, offSelectionImage: pinkNormal)
        dayNight.addSegmentWithTitle("", onSelectionImage: blackSelected, offSelectionImage: blackNormal)
        dayNight.selectSegmentAtIndex(self.folioReader.nightMode)
        //dayNight.translatesAutoresizingMaskIntoConstraints = false
        
        // Separator
        let vertialSeparator = UIView(frame: CGRect(x: dayNight.frame.width + dayNight.frame.origin.x, y: 11, width: 2, height: 33))
        vertialSeparator.backgroundColor = UIColor(rgba: "#C4C4C4")
        // font button
        let iconFontLight = UIImage(readerImageNamed: "ic_change_font")
        let iconFontDark = iconFontLight?.imageTintColor(UIColor.white)?.withRenderingMode(.alwaysOriginal)
        btnChangeFont = UIButton(frame: CGRect(x: vertialSeparator.frame.width + vertialSeparator.frame.origin.x, y: 2.5, width: 50, height: 50))
        if(self.folioReader.isNight() == 4) {
            btnChangeFont.setImage(iconFontDark, for: .normal)
        } else {
            btnChangeFont.setImage(iconFontLight, for: .normal)
        }
        btnChangeFont.addTarget(self, action: #selector(didBtnChangeFontClick), for: .touchUpInside)

        
        //color & font container
        let container: UIStackView = UIStackView(frame: CGRect(x: 0, y: 10, width: view.frame.width, height: 55))
        container.axis = .horizontal
        container.alignment = .fill
        container.distribution = .fill
        container.addSubview(dayNight)
        container.addSubview(vertialSeparator)
        container.addSubview(btnChangeFont)
        menuView.addSubview(container)

        // Separator
        let line = UIView(frame: CGRect(x: 0, y: dayNight.frame.height+dayNight.frame.origin.y, width: view.frame.width, height: 1))
        line.backgroundColor = UIColor(rgba: "#00000000")
        menuView.addSubview(line)

        // Fonts adjust
        let fontNameHeight: CGFloat = self.readerConfig.canChangeFontStyle ? 55: 0
        let fontName = SMSegmentView(frame: CGRect(x: 15, y: line.frame.height+line.frame.origin.y, width: view.frame.width-30, height: fontNameHeight),
                                     separatorColour: UIColor.clear,
                                     separatorWidth: 0,
                                     segmentProperties:  [
                                        keySegmentOnSelectionColour: UIColor.clear,
                                        keySegmentOffSelectionColour: UIColor.clear,
                                        keySegmentOnSelectionTextColour: selectedColor,
                                        keySegmentOffSelectionTextColour: normalColor,
                                        keyContentVerticalMargin: 17 as AnyObject
            ])
        fontName.delegate = self
        fontName.tag = 2

        fontName.addSegmentWithTitle("Andada", onSelectionImage: nil, offSelectionImage: nil)
        fontName.addSegmentWithTitle("Lato", onSelectionImage: nil, offSelectionImage: nil)
        fontName.addSegmentWithTitle("Lora", onSelectionImage: nil, offSelectionImage: nil)
        fontName.addSegmentWithTitle("Raleway", onSelectionImage: nil, offSelectionImage: nil)

//        fontName.segments[0].titleFont = UIFont(name: "Andada-Regular", size: 18)!
//        fontName.segments[1].titleFont = UIFont(name: "Lato-Regular", size: 18)!
//        fontName.segments[2].titleFont = UIFont(name: "Lora-Regular", size: 18)!
//        fontName.segments[3].titleFont = UIFont(name: "Raleway-Regular", size: 18)!
        fontName.selectSegmentAtIndex(self.folioReader.currentFont.rawValue)
        menuView.addSubview(fontName)

        // Separator 2
        let line2 = UIView(frame: CGRect(x: 0, y: fontName.frame.height+fontName.frame.origin.y, width: view.frame.width, height: 1))
        line2.backgroundColor = UIColor(rgba: "#00000000")
        menuView.addSubview(line2)

        // Font slider size
        let slider = HADiscreteSlider(frame: CGRect(x: 60, y: line2.frame.origin.y+2, width: view.frame.width-120, height: 55))
        slider.tickStyle = ComponentStyle.rounded
        slider.tickCount = 5
        slider.tickSize = CGSize(width: 8, height: 8)

        slider.thumbStyle = ComponentStyle.rounded
        slider.thumbSize = CGSize(width: 28, height: 28)
        slider.thumbShadowOffset = CGSize(width: 0, height: 2)
        slider.thumbShadowRadius = 3
        slider.thumbColor = selectedColor

        slider.backgroundColor = UIColor.clear
        slider.tintColor = normalColor//self.readerConfig.nightModeSeparatorColor
        slider.minimumValue = 0
        slider.value = CGFloat(self.folioReader.currentFontSize.rawValue)
        slider.addTarget(self, action: #selector(FolioReaderFontsMenu.sliderValueChanged(_:)), for: UIControl.Event.valueChanged)

        // Force remove fill color
        slider.layer.sublayers?.forEach({ layer in
            layer.backgroundColor = UIColor.clear.cgColor
        })

        menuView.addSubview(slider)

        // Font icons
        let fontSmallView = UIImageView(frame: CGRect(x: 20, y: line2.frame.origin.y+14, width: 30, height: 30))
        fontSmallView.image = fontSmallNormal
        fontSmallView.contentMode = UIView.ContentMode.center
        menuView.addSubview(fontSmallView)

        let fontBigView = UIImageView(frame: CGRect(x: view.frame.width-50, y: line2.frame.origin.y+14, width: 30, height: 30))
        fontBigView.image = fontBigNormal
        fontBigView.contentMode = UIView.ContentMode.center
        menuView.addSubview(fontBigView)

        // Only continues if user can change scroll direction
        guard (self.readerConfig.canChangeScrollDirection == true) else {
            return
        }

        // Separator 3
        let line3 = UIView(frame: CGRect(x: 0, y: line2.frame.origin.y+56, width: view.frame.width, height: 1))
        line3.backgroundColor = UIColor(rgba: "#00000000")
        menuView.addSubview(line3)

//        let vertical = UIImage(readerImageNamed: "icon-menu-vertical")
//        let horizontal = UIImage(readerImageNamed: "icon-menu-horizontal")
//        let verticalNormal = vertical?.imageTintColor(normalColor)?.withRenderingMode(.alwaysOriginal)
//        let horizontalNormal = horizontal?.imageTintColor(normalColor)?.withRenderingMode(.alwaysOriginal)
//        let verticalSelected = vertical?.imageTintColor(selectedColor)?.withRenderingMode(.alwaysOriginal)
//        let horizontalSelected = horizontal?.imageTintColor(selectedColor)?.withRenderingMode(.alwaysOriginal)
        let verticalNormal = UIImage(readerImageNamed: "ic_vertical_scroll")
        let verticalSelected = UIImage(readerImageNamed: "ic_vertical_scroll_active")
        let horizontalNormal = UIImage(readerImageNamed: "ic_horizontal_scroll")
        let horizontalSelected = UIImage(readerImageNamed: "ic_horizontal_scroll_active")

        // Layout direction
        let layoutDirection = SMSegmentView(frame: CGRect(x: 0, y: line3.frame.origin.y, width: view.frame.width, height: 55),
                                            separatorColour: self.readerConfig.nightModeSeparatorColor,
                                            separatorWidth: 0,
                                            segmentProperties:  [
                                                keySegmentTitleFont: UIFont(name: "Avenir-Light", size: 17)!,
                                                keySegmentOnSelectionColour: UIColor.clear,
                                                keySegmentOffSelectionColour: UIColor.clear,
                                                keySegmentOnSelectionTextColour: selectedColor,
                                                keySegmentOffSelectionTextColour: normalColor,
                                                keyContentVerticalMargin: 17 as AnyObject
            ])
        layoutDirection.delegate = self
        layoutDirection.tag = 3
        layoutDirection.addSegmentWithTitle(self.readerConfig.localizedLayoutVertical, onSelectionImage: verticalSelected, offSelectionImage: verticalNormal)
        layoutDirection.addSegmentWithTitle(self.readerConfig.localizedLayoutHorizontal, onSelectionImage: horizontalSelected, offSelectionImage: horizontalNormal)

        var scrollDirection = FolioReaderScrollDirection(rawValue: self.folioReader.currentScrollDirection)

        if scrollDirection == .defaultVertical && self.readerConfig.scrollDirection != .defaultVertical {
            scrollDirection = self.readerConfig.scrollDirection
        }

        switch scrollDirection ?? .vertical {
        case .vertical, .defaultVertical:
            layoutDirection.selectSegmentAtIndex(FolioReaderScrollDirection.vertical.rawValue)
        case .horizontal, .horizontalWithVerticalContent:
            layoutDirection.selectSegmentAtIndex(FolioReaderScrollDirection.horizontal.rawValue)
        }
        menuView.addSubview(layoutDirection)
    }

    // MARK: - SMSegmentView delegate
    func segmentView(_ segmentView: SMSegmentView, didSelectSegmentAtIndex index: Int) {
        guard (self.folioReader.readerCenter?.currentPage) != nil else { return }

        if segmentView.tag == 1 {
            self.folioReader.nightMode = index
            let fontIconLight = UIImage(readerImageNamed: "ic_change_font")
            let fontIconDark = fontIconLight?.imageTintColor(UIColor.white)?.withRenderingMode(.alwaysOriginal)
            switch index {
            case 0:
                UIView.animate(withDuration: 0.6, animations: {
                    self.menuView.backgroundColor = self.readerConfig.daysModeNavBackground
                    self.btnChangeFont?.setImage(fontIconLight, for: .normal)
                    self.statusBarStyle = UIStatusBarStyle.default
                    self.setNeedsStatusBarAppearanceUpdate()
                })
                break;
            case 1:
                UIView.animate(withDuration: 0.6, animations: {
                    self.menuView.backgroundColor = self.readerConfig.daysModeNavBackground
                    self.btnChangeFont?.setImage(fontIconLight, for: .normal)
                    self.statusBarStyle = UIStatusBarStyle.default
                    self.setNeedsStatusBarAppearanceUpdate()
                })
                break;
            case 2:
                UIView.animate(withDuration: 0.6, animations: {
                    self.menuView.backgroundColor = self.readerConfig.daysModeNavBackground
                    self.btnChangeFont?.setImage(fontIconLight, for: .normal)
                    self.statusBarStyle = UIStatusBarStyle.default
                    self.setNeedsStatusBarAppearanceUpdate()
                })
                break;
            case 3:
                UIView.animate(withDuration: 0.6, animations: {
                    self.menuView.backgroundColor = self.readerConfig.daysModeNavBackground
                    self.btnChangeFont?.setImage(fontIconLight, for: .normal)
                    self.statusBarStyle = UIStatusBarStyle.default
                    self.setNeedsStatusBarAppearanceUpdate()
                })
                break;
            case 4:
                UIView.animate(withDuration: 0.6, animations: {
                    self.menuView.backgroundColor = self.readerConfig.nightModeBackground
                    self.btnChangeFont?.setImage(fontIconDark, for: .normal)
                    self.statusBarStyle = UIStatusBarStyle.lightContent
                    self.setNeedsStatusBarAppearanceUpdate()
                })
                break;
            default:
                break;
            }
//            UIView.animate(withDuration: 0.6, animations: {
//                self.menuView.backgroundColor = (self.folioReader.nightMode ? self.readerConfig.nightModeBackground : self.readerConfig.daysModeNavBackground)
//            })

        } else if segmentView.tag == 2 {

            self.folioReader.currentFont = FolioReaderFont(rawValue: index)!

        }  else if segmentView.tag == 3 {

            guard self.folioReader.currentScrollDirection != index else {
                return
            }

            self.folioReader.currentScrollDirection = index
        }
    }
    
    // MARK: - Font slider changed
    
    @objc func sliderValueChanged(_ sender: HADiscreteSlider) {
        guard
            (self.folioReader.readerCenter?.currentPage != nil),
            let fontSize = FolioReaderFontSize(rawValue: Int(sender.value)) else {
                return
        }
        
        self.folioReader.currentFontSize = fontSize
    }
    
    // MARK: - Gestures
    
    @objc func tapGesture() {
        dismiss()
        
        if (self.readerConfig.shouldHideNavigationOnTap == false) {
            self.folioReader.readerCenter?.showBars()
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer is UITapGestureRecognizer && touch.view == view {
            return true
        }
        return false
    }
    
    // MARK: - Status Bar
    
    override var prefersStatusBarHidden : Bool {
        return (self.readerConfig.shouldHideNavigationOnTap == true)
    }
    
    var hasTopNotch: Bool {
        if #available(iOS 13.0,  *) {
            return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0 > 20
        } else if #available(iOS 11.0,  *){
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
    
    @objc func didBtnChangeFontClick(_ sender: UIButton) {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: 200))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        self.popover = Popover(options: self.popoverOptions)
        self.popover.willShowHandler = {
          print("willShowHandler")
        }
        self.popover.didShowHandler = {
          print("didDismissHandler")
        }
        self.popover.willDismissHandler = {
          print("willDismissHandler")
        }
        self.popover.didDismissHandler = {
          print("didDismissHandler")
        }
        self.popover.show(tableView, fromView: self.btnChangeFont)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.statusBarStyle
    }
}

extension FolioReaderFontsMenu: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print((indexPath as NSIndexPath).row)
    self.folioReader.currentFont = FolioReaderFont(rawValue: (indexPath as NSIndexPath).row)!
    self.popover.dismiss()
  }
}

extension FolioReaderFontsMenu: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    return 4
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
    cell.textLabel?.text = self.texts[(indexPath as NSIndexPath).row]
    cell.textLabel?.font = UIFont(name: self.texts[(indexPath as NSIndexPath).row].lowercased(), size: 18.0)
    return cell
  }
}

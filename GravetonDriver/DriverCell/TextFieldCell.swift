//
//  TextFieldCell.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 4/3/23.
//

import UIKit

class TextFieldCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "TextFieldCell"
    
    let textField: CustomTextField = {
        
        let textField = CustomTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholderColor = .black
        textField.isHighlightedOnEdit = true
        textField.highlightedColor = .systemBlue
        
        // Setting up small placeholder
        textField.smallPlaceholderColor = .quaternaryLabel
        textField.smallPlaceholderFont = UIFont.systemFont(ofSize: 12)
        textField.smallPlaceholderPadding = 12
        textField.smallPlaceholderLeftOffset = 0
        
        textField.placeholderColor = .quaternaryLabel
        
        textField.separatorIsHidden = false
        textField.separatorLineViewColor = textField.smallPlaceholderColor
        textField.separatorLeftPadding = -8
        textField.separatorRightPadding = -8
        textField.font = UIFont.systemFont(ofSize: 18)
        
        return textField
    }()
    
    var placeHolderr: String? {
        
        didSet {
            
            guard let userInfo = placeHolderr else {return}
            textField.smallPlaceholderText = userInfo
            
            textField.placeholder = userInfo
        }
    }
    
    override init(frame:CGRect){
        super.init(frame: frame)

        let stackView = UIStackView(arrangedSubviews: [textField])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class CustomTextField: UITextField {
    
    private var isPlaceholderHidden = false
    
    public var errorColor: UIColor = #colorLiteral(red: 0.9046222586, green: 0.06288693374, blue: 0.1854852713, alpha: 1)
    
    public var errorMessage: String? {
        didSet {
            if errorMessage == nil || errorMessage!.isEmpty {
                smallPlaceholderLabel.text = smallPlaceholderText
                smallPlaceholderLabel.textColor = smallPlaceholderColor
                return
            }
            smallPlaceholderLabel.text = errorMessage
            smallPlaceholderLabel.textColor = errorColor
        }
    }
    
    public var smallPlaceholderFont: UIFont = UIFont.systemFont(ofSize: 12) {
        didSet {
            smallPlaceholderLabel.font = smallPlaceholderFont
        }
    }

    @IBInspectable public var smallPlaceholderText: String = "" {
        didSet {
            smallPlaceholderLabel.text = smallPlaceholderText
        }
    }
    
    ///
    @IBInspectable public var smallPlaceholderColor: UIColor = .lightGray {
        didSet {
            smallPlaceholderLabel.textColor = smallPlaceholderColor
        }
    }
    
    /// Width between textfield top and smallseparator top
    @IBInspectable public var smallPlaceholderPadding: CGFloat = 7
    
    @IBInspectable public var smallPlaceholderLeftOffset: CGFloat = 0
    
    /// Color of the main placeholder text
    @IBInspectable public var placeholderColor: UIColor = .gray {
        didSet {
            setPlaceholderColor(to: placeholderColor)
        }
    }
    
    /// Color of the separator line view
    @IBInspectable public var separatorLineViewColor: UIColor = .lightGray {
        didSet {
            separatorLineView.backgroundColor = separatorLineViewColor
        }
    }
    
    @IBInspectable public var separatorLeftPadding: CGFloat = 0
    @IBInspectable public var separatorRightPadding: CGFloat = 0
    @IBInspectable public var separatorBottomPadding: CGFloat = 0
    
    @IBInspectable public var separatorIsHidden: Bool = false {
        didSet {
            separatorLineView.isHidden = separatorIsHidden
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var borderColor: UIColor =  .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable public var textLeftOffst: CGFloat = 0 {
        didSet {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: textLeftOffst, height: frame.height))
            leftView = paddingView
            leftViewMode = .always
        }
    }

    @IBInspectable public var isHighlightedOnEdit: Bool = false
    @IBInspectable public var highlightedColor: UIColor = .red
    
    // MARK: - Views
    
    fileprivate lazy var smallPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = self.textColor
        label.font = self.smallPlaceholderFont
        label.textColor = self.smallPlaceholderColor
        return label
    }()
    
    fileprivate lazy var separatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = self.separatorLineViewColor
        view.isHidden = self.separatorIsHidden
        return view
    }()
    
    fileprivate var imageView: UIImageView?
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        clipsToBounds = false
        
        smallPlaceholderLabel.frame = CGRect(x: smallPlaceholderLeftOffset,y: -smallPlaceholderPadding, width: frame.width,height: smallPlaceholderFont.pointSize * 1.15)
        
        separatorLineView.frame = CGRect(x: separatorLeftPadding,y: frame.height - separatorBottomPadding,width: frame.width - separatorLeftPadding - separatorRightPadding,
                                         height: 1)
        
        hideSmallPlaceholder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup view
    
    fileprivate func setupView() {
        clipsToBounds = false
        
        setupObservers()
        setupSubviews()
    }
    
    fileprivate func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextDidEndEditing), name: UITextField.textDidEndEditingNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextDidBeginEditing), name: UITextField.textDidBeginEditingNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextChanged), name: UITextField.textDidChangeNotification, object: self)
    }
    
    fileprivate func setupSubviews() {
        addSubview(smallPlaceholderLabel)
        addSubview(separatorLineView)
    }
    
    // MARK: - TextField Editing Observer
    
    @objc func textFieldTextDidEndEditing(notification : NSNotification) {
        guard let text = text else { return }
        if errorMessage != nil && !errorMessage!.isEmpty {
            return
        }
        if text.isEmpty {
            hideSmallPlaceholder()
            setPlaceholderColor(to: placeholderColor)
        }
        if isHighlightedOnEdit {
            smallPlaceholderLabel.textColor = smallPlaceholderColor
            separatorLineView.backgroundColor = separatorLineViewColor
            imageView?.tintColor = smallPlaceholderColor
        }
    }
    
    @objc func textFieldTextDidBeginEditing(notification : NSNotification) {
        showSmallPlaceholder()
        setPlaceholderColor(to: .clear)
        errorMessage = nil
        if isHighlightedOnEdit {
            smallPlaceholderLabel.textColor = highlightedColor
            separatorLineView.backgroundColor = highlightedColor
            imageView?.tintColor = highlightedColor
        }
    }
    
    @objc func textFieldTextChanged(notifcation: NSNotification) {
        if !(errorMessage != nil && !errorMessage!.isEmpty) {
            smallPlaceholderLabel.text = smallPlaceholderText
            smallPlaceholderLabel.textColor = smallPlaceholderColor
            if isHighlightedOnEdit {
                smallPlaceholderLabel.textColor = highlightedColor
            }
        }
    }
    
    // MARK: - Animations
    
    fileprivate func hideSmallPlaceholder() {
        if !isPlaceholderHidden {
            self.isPlaceholderHidden = !self.isPlaceholderHidden
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                let isNegative: CGFloat = (self.smallPlaceholderPadding < 0) ? -1 : 1
                self.smallPlaceholderLabel.transform = CGAffineTransform(translationX: 0, y: self.smallPlaceholderLabel.frame.height * isNegative)
                self.smallPlaceholderLabel.alpha = 0
            })
        }
    }
    
    fileprivate func showSmallPlaceholder() {
        if isPlaceholderHidden {
            self.isPlaceholderHidden = !self.isPlaceholderHidden
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.smallPlaceholderLabel.transform = .identity
                self.smallPlaceholderLabel.alpha = 1
            })
        }
    }
    
    // MARK: - Helpers
    
    fileprivate func setPlaceholderColor(to: UIColor) {
        if placeholder == nil {
            placeholder = " "
        }
        attributedPlaceholder = NSAttributedString(string: placeholder!, attributes: [NSAttributedString.Key.foregroundColor: to])
    }

    // MSRK: - Public methods
    
    public func wrongInput() {
        smallPlaceholderLabel.textColor = errorColor
    }
    
}

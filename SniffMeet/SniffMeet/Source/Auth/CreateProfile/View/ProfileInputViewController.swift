//
//  ProfileInputView.swift
//  SniffMeet
//
//  Created by 배현진 on 11/10/24.
//

import UIKit

protocol ProfileInputViewable: AnyObject {
    var presenter: ProfileInputPresentable? { get set }
}

final class ProfileInputViewController: BaseViewController, ProfileInputViewable {
    var presenter: ProfileInputPresentable?

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Context.titleLabel
        label.textColor = SNMColor.mainNavy
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: .init(24), weight: .heavy)
        return label
    }()
    private var nameTextField: InputTextField = InputTextField(placeholder: Context.namePlaceholder)
    private var ageTextField: InputTextField = InputTextField(placeholder: Context.agePlaceholder)
    
    private var sexSelectionLabel: UILabel = {
        let label = UILabel()
        label.text = Context.sexLabel
        label.font = .systemFont(ofSize: .init(16), weight: .regular)
        return label
    }()
    
    private var sexSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: Context.sexArr)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    private var sexUponIntakeSelectionLabel: UILabel = {
        let label = UILabel()
        label.text = Context.sexUponIntakeLabel
        label.font = .systemFont(ofSize: .init(16), weight: .regular)
        return label
    }()
    private var sexUponIntakeSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: Context.sexUponIntakeArr)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    private var sizeSelectionLabel: UILabel = {
        let label = UILabel()
        label.text = Context.sizeLabel
        label.font = .systemFont(ofSize: .init(16), weight: .regular)
        return label
    }()
    private var sizeSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: Context.sizeArr)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    private var topbarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
        (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }

    private var keywordSelectionLabel: UILabel = {
        let label = UILabel()
        label.text = Context.keywordLabel
        label.font = .systemFont(ofSize: .init(16), weight: .regular)
        return label
    }()
    private var activeKeywordButton: UIButton = KeywordButton(title: Context.activeKeywordLabel)
    private var smartKeywordButton: UIButton = KeywordButton(title: Context.smartKeywordLabel)
    private var friendlyKeywordButton: UIButton = KeywordButton(title: Context.friendlyKeywordLabel)
    private var shyKeywordButton: UIButton = KeywordButton(title: Context.shyKeywordLabel)
    private var independentKeywordButton: UIButton = KeywordButton(title: Context.independentKeywordLabel)
    private var nextButton: UIButton = PrimaryButton(title: Context.nextBtnTitle)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateNextButtonState()
        hideKeyboardWhenTappedAround()
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)),
                                for: .editingChanged)
        ageTextField.addTarget(self, action: #selector(textFieldDidChange(_:)),
                               for: .editingChanged)
        setButtonAction()
    }
    
    func setButtonAction() {
        nextButton.addAction(UIAction { [weak self] _ in
            guard let name = self?.nameTextField.text,
                  let ageText = self?.ageTextField.text,
                  let age = Int(ageText) else { return }
            
            let dogInfo = DogDetailInfo(name: name,
                                        age: UInt8(age),
                                        size: .small,
                                        keywords: [.energetic])
            self?.presenter?.moveToProfileCreateView(with: dogInfo)
        }, for: .touchUpInside)
    }
    
    override func configureAttributes() {
        
    }
    override func configureHierachy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [scrollView, contentView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [titleLabel,
         nameTextField,
         ageTextField,
         sexSelectionLabel,
         sexSegmentedControl,
         sexUponIntakeSelectionLabel,
         sexUponIntakeSegmentedControl,
         sizeSelectionLabel,
         sizeSegmentedControl,
         keywordSelectionLabel,
         activeKeywordButton,
         smartKeywordButton,
         friendlyKeywordButton,
         shyKeywordButton,
         independentKeywordButton,
         nextButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        var height = view.safeAreaLayoutGuide.owningView?.bounds.height ?? view.bounds.height
        height -= topbarHeight
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo:
                                                    scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo:
                                                    scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo:
                                                    scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            contentView.heightAnchor.constraint(
                equalToConstant: max(Context.contentViewHeight, height - 100)),
            titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor,
                                            constant: Context.basicVerticalPadding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                constant: Context.horizontalPadding)
        ])
        
        configureTextFieldConstraints()
        configureSelectionViewConstraints()
        configureButtonConstraints()
    }
}

private extension ProfileInputViewController {
    enum Context {
        static let nextBtnTitle: String = "다음으로"
        static let titleLabel: String = "반가워요!\n당신의 반려견을 소개해주세요."
        static let namePlaceholder: String = "반려견 이름을 입력해주세요."
        static let agePlaceholder: String = "반려견 나이를 입력해주세요."
        static let sexLabel: String = "반려견의 성별을 선택해주세요."
        static let sexUponIntakeLabel: String = "반려견 중성화 여부를 입력해주세요."
        static let sizeLabel: String = "반려견의 크기를 선택해주세요."
        static let sexUponIntakeArr: [String] = ["완료", "미완료"]
        static let sexArr: [String] = ["남", "여"]
        static let sizeArr: [String] = ["소형", "중형", "대형"]
        static let keywordLabel: String = "반려견에 해당되는 키워드를 선택해주세요."
        static let activeKeywordLabel: String = "활발한"
        static let smartKeywordLabel: String = "똑똑한"
        static let friendlyKeywordLabel: String = "친화력 좋은"
        static let shyKeywordLabel: String = "소심한"
        static let independentKeywordLabel: String = "독립적인"
        static let horizontalPadding: CGFloat = 24
        static let smallVerticalPadding: CGFloat = 8
        static let basicVerticalPadding: CGFloat = 16
        static let largeVerticalPadding: CGFloat = 30
        static let contentViewHeight: CGFloat = 750
    }
}

extension ProfileInputViewController: UITextFieldDelegate {
    @objc private func textFieldDidChange(_ textField: UITextField) {
        updateNextButtonState()
    }

    private func updateNextButtonState() {
        let isNameFilled = !(nameTextField.text ?? "").isEmpty
        let isAgeFilled = !(ageTextField.text ?? "").isEmpty
        nextButton.isEnabled = isNameFilled && isAgeFilled
    }
    private func configureTextFieldConstraints() {
        NSLayoutConstraint.activate([
        nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                           constant: LayoutConstant.xlargeVerticalPadding),
        nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                               constant: Context.horizontalPadding),
        nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                constant: -Context.horizontalPadding),
        ageTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor,
                                          constant: Context.largeVerticalPadding),
        ageTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                              constant: Context.horizontalPadding),
        ageTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                               constant: -Context.horizontalPadding)
        ])
    }
    func configureSelectionViewConstraints() {
        NSLayoutConstraint.activate([
            sexSelectionLabel.topAnchor.constraint(equalTo: ageTextField.bottomAnchor,
                                                    constant: Context.largeVerticalPadding),
            sexSelectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                        constant: Context.horizontalPadding),

            sexSegmentedControl.topAnchor.constraint(equalTo: sexSelectionLabel.bottomAnchor,
                                                  constant: Context.basicVerticalPadding),
            sexSegmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                      constant: Context.horizontalPadding),
            sexSegmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                       constant: -Context.horizontalPadding),

            sexUponIntakeSelectionLabel.topAnchor.constraint(
                equalTo: sexSegmentedControl.bottomAnchor,
                constant: Context.largeVerticalPadding),
            sexUponIntakeSelectionLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Context.horizontalPadding),

            sexUponIntakeSegmentedControl.topAnchor.constraint(
                equalTo: sexUponIntakeSelectionLabel.bottomAnchor,
                constant: Context.basicVerticalPadding),
            sexUponIntakeSegmentedControl.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Context.horizontalPadding),
            sexUponIntakeSegmentedControl.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Context.horizontalPadding),

            sizeSelectionLabel.topAnchor.constraint(
                equalTo: sexUponIntakeSegmentedControl.bottomAnchor,
                constant: Context.largeVerticalPadding),
            sizeSelectionLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Context.horizontalPadding),

            sizeSegmentedControl.topAnchor.constraint(
                equalTo: sizeSelectionLabel.bottomAnchor,
                constant: Context.basicVerticalPadding),
            sizeSegmentedControl.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Context.horizontalPadding),
            sizeSegmentedControl.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Context.horizontalPadding)
        ])
    }
    func configureButtonConstraints() {
       NSLayoutConstraint.activate([
           keywordSelectionLabel.topAnchor.constraint(
               equalTo: sizeSegmentedControl.bottomAnchor,
               constant: Context.largeVerticalPadding),
           keywordSelectionLabel.leadingAnchor.constraint(
               equalTo: contentView.leadingAnchor,
               constant: Context.horizontalPadding),

           activeKeywordButton.topAnchor.constraint(
               equalTo: keywordSelectionLabel.bottomAnchor,
               constant: Context.basicVerticalPadding),
           activeKeywordButton.leadingAnchor.constraint(
               equalTo: contentView.leadingAnchor,
               constant: Context.horizontalPadding),

           smartKeywordButton.topAnchor.constraint(
               equalTo: keywordSelectionLabel.bottomAnchor,
               constant: Context.basicVerticalPadding),
           smartKeywordButton.leadingAnchor.constraint(
               equalTo: activeKeywordButton.trailingAnchor,
               constant: Context.smallVerticalPadding),

           friendlyKeywordButton.topAnchor.constraint(
               equalTo: keywordSelectionLabel.bottomAnchor,
               constant: Context.basicVerticalPadding),
           friendlyKeywordButton.leadingAnchor.constraint(
               equalTo: smartKeywordButton.trailingAnchor,
               constant: Context.smallVerticalPadding),

           shyKeywordButton.topAnchor.constraint(
               equalTo: keywordSelectionLabel.bottomAnchor,
               constant: Context.basicVerticalPadding),
           shyKeywordButton.leadingAnchor.constraint(
               equalTo: friendlyKeywordButton.trailingAnchor,
               constant: Context.smallVerticalPadding),

           independentKeywordButton.topAnchor.constraint(
               equalTo: keywordSelectionLabel.bottomAnchor,
               constant: Context.basicVerticalPadding),
           independentKeywordButton.leadingAnchor.constraint(
               equalTo: shyKeywordButton.trailingAnchor,
               constant: Context.smallVerticalPadding),

           nextButton.bottomAnchor.constraint(
               equalTo: contentView.bottomAnchor,
               constant: -32),
           nextButton.leadingAnchor.constraint(
               equalTo: contentView.leadingAnchor,
               constant: Context.horizontalPadding),
           nextButton.trailingAnchor.constraint(
               equalTo: contentView.trailingAnchor,
               constant: -Context.horizontalPadding),
           nextButton.heightAnchor.constraint(equalToConstant: 52)
       ])
   }
}

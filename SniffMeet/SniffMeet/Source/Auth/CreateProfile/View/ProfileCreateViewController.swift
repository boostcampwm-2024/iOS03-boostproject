//
//  ProfileSetupView.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/9/24.
//

import Combine
import PhotosUI
import UIKit

protocol ProfileCreateViewable: AnyObject {
    var presenter: ProfileCreatePresentable? { get set }
}

final class ProfileCreateViewController: BaseViewController, ProfileCreateViewable {
    var presenter: ProfileCreatePresentable?
    private var cancellables = Set<AnyCancellable>()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Context.mainTitle
        label.textColor = SNMColor.mainNavy
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        return label
    }()
    private var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ImagePlaceholder")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private var addPhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "photo"), for: .normal)
        button.backgroundColor = SNMColor.mainNavy
        button.setTitleColor(SNMColor.white, for: .normal)
        button.tintColor = SNMColor.white
        return button
    }()
    private var warningLabel: UILabel = {
        let label = UILabel()
        label.textColor = SNMColor.warningRed
        label.text = Context.warning
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    private var nicknameTextField: InputTextField = InputTextField(placeholder: Context.placeholder)
    private var submitButton = PrimaryButton(title: Context.submitBtnTitle)
    private var picker: PHPickerViewController = {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        return PHPickerViewController(configuration: configuration)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setSubviewsLayout()
        view.backgroundColor = SNMColor.white
        submitButton.isEnabled = false
        setDelegate()
        hideKeyboardWhenTappedAround()
        navigationController?.navigationBar.configureBackButton()
    }
    override func viewDidLayoutSubviews() {
        profileImageView.makeViewCircular()
        addPhotoButton.makeViewCircular()
    }
    override func bind() {
        addPhotoButton.publisher(event: .touchUpInside)
            .sink { [weak self] _ in
                guard let picker = self?.picker else { return }
                self?.present(picker, animated: true, completion: nil)
            }
            .store(in: &cancellables)
 
        submitButton.publisher(event: .touchUpInside)
            .debounce(for: .seconds(EventConstant.debounceInterval), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                print("이벤트 발생")
                guard let nickname = self?.nicknameTextField.text else { return }
                self?.presenter?.didTapSubmitButton(
                    nickname: nickname,
                    image: self?.profileImageView.image
                )
                self?.showSNMProgressToast()
            }
            .store(in: &cancellables)
    }
}

private extension ProfileCreateViewController {
    enum Context {
        static let submitBtnTitle: String = "등록 완료"
        static let placeholder: String = "닉네임을 입력해주세요."
        static let warning: String = "닉네임은 최대 8글자까지 입력할 수 있습니다."
        static let mainTitle: String = "마지막으로,\n반려견 사진과 닉네임을 등록해주세요."
        static let horizontalPadding: CGFloat = 24
        static let imageViewSize: CGFloat = 140
        static let addPhotoButtonSize: CGFloat = 44
    }
    enum TextFieldError: Error {
        case none               // 에러가 없는 경우
        case empty              // 아무것도 입력되지 않은 경우
        case exceededMaxLength  // 최대 글자 수를 초과한 경우
        case invalidFormat      // 포맷이 잘못된 경우 (예: 이메일 형식 등)
        case restrictedCharacter // 허용되지 않은 문자 포함
    }
    func setSubviewsLayout() {
        [titleLabel,
         profileImageView,
         addPhotoButton,
         warningLabel,
         nicknameTextField,
         submitButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                constant: Context.horizontalPadding),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: Context.imageViewSize),
            profileImageView.heightAnchor.constraint(equalToConstant: Context.imageViewSize),
            profileImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 80),
            addPhotoButton.widthAnchor.constraint(equalToConstant: Context.addPhotoButtonSize),
            addPhotoButton.heightAnchor.constraint(equalToConstant: Context.addPhotoButtonSize),
            addPhotoButton.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor,
                                                     constant: 10),
            addPhotoButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor),
            nicknameTextField.topAnchor.constraint(equalTo: profileImageView.bottomAnchor,
                                                   constant: 60),
            nicknameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                       constant: Context.horizontalPadding),
            nicknameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                        constant: -Context.horizontalPadding),
            warningLabel.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor,
                                              constant: 16),
            warningLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                  constant: 26),
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                  constant: Context.horizontalPadding),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                   constant: -Context.horizontalPadding),
            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32)
        ])
    }
    func setDelegate() {
        picker.delegate = self
        nicknameTextField.delegate = self
    }
}

extension ProfileCreateViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                guard let selectedImage = image as? UIImage else { return }
                Task { @MainActor [weak self] in
                    self?.profileImageView.image =  selectedImage
                }
            }
        }
    }
}

extension ProfileCreateViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let textCount = textField.text?.count else { return }
        submitButton.isEnabled = (textCount > 1 && textCount < 9 )
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let newLength = text.count + string.count - range.length
        let inputTextValid = newLength <= 15

        return inputTextValid
    }

}

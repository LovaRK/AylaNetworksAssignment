//
//  AlertView.swift
//  UPStoxHolding
//
//  Created by Apple on 07/06/23.
//

import UIKit

enum AlertType {
    case success
    case failure
}

class AlertView: UIView {
    
    static let instance = AlertView()
    
    private var messageTextViewHeightConstraint: NSLayoutConstraint?
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var alertView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor { traitCollection -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(white: 0.2, alpha: 1.0)
            default:
                return UIColor.white
            }
        }
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.textAlignment = .center
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        setupViewHierarchy()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViewHierarchy() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        addSubview(alertView)
        alertView.addSubview(titleLabel)
        alertView.addSubview(messageTextView)
        alertView.addSubview(doneButton)
        addSubview(imageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            alertView.centerXAnchor.constraint(equalTo: centerXAnchor),
            alertView.centerYAnchor.constraint(equalTo: centerYAnchor),
            alertView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 80),
            // Add this line in setupConstraints() method
            alertView.heightAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.height / 2),
            
            imageView.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
            imageView.bottomAnchor.constraint(equalTo: alertView.topAnchor, constant: 30),
            imageView.widthAnchor.constraint(equalToConstant: 60),
            imageView.heightAnchor.constraint(equalToConstant: 60),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10), // Adjust this value based on actual layout needs
            titleLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            
            messageTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            messageTextView.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 20),
            messageTextView.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -20),
            
            doneButton.topAnchor.constraint(equalTo: messageTextView.bottomAnchor, constant: 20),
            doneButton.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -20),
            doneButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Setting the initial height constraint for the messageTextView
            messageTextView.heightAnchor.constraint(equalToConstant: 0).with(priority: .defaultLow, isActive: true, storedIn: &messageTextViewHeightConstraint)
        ])
    }
    
    func showAlert(title: String, message: String, alertType: AlertType, in viewController: UIViewController?) {
        DispatchQueue.main.async {
            self.titleLabel.text = title
        
            self.messageTextView.text = message
            
            self.configureImageView(for: alertType)
            
            self.adjustMessageTextViewHeight()
            
            if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                keyWindow.addSubview(self)
            } else {
                viewController?.view.addSubview(self)
            }
            
            self.frame = UIScreen.main.bounds
            
            self.animateAlertPresentation()
        }
    }
    
    private func configureImageView(for alertType: AlertType) {
        imageView.image = UIImage(systemName: alertType == .success ? "checkmark.circle.fill" : "xmark.circle.fill")
        imageView.tintColor = alertType == .success ? .systemGreen : .systemRed
    }
    
    private func adjustMessageTextViewHeight() {
        // Layout all subviews first to get accurate measurements.
        alertView.layoutIfNeeded()

        // Define the total vertical padding inside the alert view.
        let topPadding: CGFloat = 20 // Space above title label
        let titleToMessageSpacing: CGFloat = 10 // Space between title label and message text view
        let messageToButtonSpacing: CGFloat = 20 // Space between message text view and done button
        let bottomPadding: CGFloat = 20 // Space below done button

        // Calculate total vertical padding
        let totalVerticalPadding = topPadding + titleToMessageSpacing + messageToButtonSpacing + bottomPadding

        // Determine the other components' combined height
        let otherComponentsCombinedHeight = titleLabel.frame.height + doneButton.frame.height

        // Calculate the maximum available height for the messageTextView
        let maxAvailableHeightForTextView = UIScreen.main.bounds.height / 2 - (otherComponentsCombinedHeight + totalVerticalPadding)

        // Determine the fitting size for the messageTextView content
        let fittingSize = messageTextView.sizeThatFits(CGSize(width: messageTextView.frame.width, height: CGFloat.infinity))
        let adjustedHeight = min(fittingSize.height, maxAvailableHeightForTextView)

        // Update the height constraint for the messageTextView
        messageTextViewHeightConstraint?.constant = adjustedHeight

        // Enable or disable scrolling based on whether the content fits
        messageTextView.isScrollEnabled = fittingSize.height > adjustedHeight

        // Update the layout to apply the changes
        alertView.layoutIfNeeded()
    }


    
    @objc private func dismissAlert() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    private func animateAlertPresentation() {
        self.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }
}

extension NSLayoutConstraint {
    @discardableResult
    func with(priority: UILayoutPriority, isActive: Bool, storedIn storage: inout NSLayoutConstraint?) -> NSLayoutConstraint {
        self.priority = priority
        self.isActive = isActive
        storage = self
        return self
    }
}


// Usage remains unchanged, but now the alertType determines the SF Symbol used:
// AlertView.instance.showAlert(title: "Success", message: "Your operation was successful.", alertType: .success, in: self)

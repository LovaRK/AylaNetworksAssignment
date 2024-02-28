//
//  CountryFactTableViewCell.swift
//  AylaNetworksAssignment
//
//  Created by MA1424 on 27/02/24.
//

import UIKit

class CountryFactTableViewCell: UITableViewCell {
    
    static let identifier = "CountryFactTableViewCell"
    var imageTask: URLSessionDataTask?

    private let factImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "defaultImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0 // Multi-line
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0 // Multi-line
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(factImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyConstraints() {
        let spacing: CGFloat = 8
        
        NSLayoutConstraint.activate([
            factImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: spacing),
            factImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: spacing),
            factImageView.widthAnchor.constraint(equalToConstant: 100),
            factImageView.heightAnchor.constraint(equalToConstant: 100),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: spacing),
            titleLabel.leadingAnchor.constraint(equalTo: factImageView.trailingAnchor, constant: spacing),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -spacing),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: spacing),
            descriptionLabel.leadingAnchor.constraint(equalTo: factImageView.trailingAnchor, constant: spacing),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -spacing),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -spacing)
        ])
    }
    
    public func configure(with model: CountryFact) {
            titleLabel.text = model.title ?? "No Title"
            descriptionLabel.text = model.description ?? "No Description"
            factImageView.image = nil
            if let imageUrl = model.imageHref, let url = URL(string: imageUrl) {
                factImageView.loadImage(from: url)
            } else {
                factImageView.image = UIImage(named: "defaultImage")
            }
        }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        factImageView.image = nil // Reset image
        titleLabel.text = nil // Reset title
        descriptionLabel.text = nil // Reset description
    }
}





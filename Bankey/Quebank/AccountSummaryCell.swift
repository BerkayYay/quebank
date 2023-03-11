//
//  AccountSummaryCell.swift
//  Bankey
//
//  Created by Berkay YAY on 23.02.2023.
//

import Foundation
import UIKit

enum AccountType: String, Codable {
    case Banking
    case CreditCard
    case Investment
}

class AccountSummaryCell: UITableViewCell{
    
    
    struct ViewModel {
        let accountType: AccountType
        let accountName: String
        let balance: Decimal
        
        var balanceAsAttributedString: NSAttributedString {
            return CurrencyFormatter().makeAttributedCurrency(balance)
        }
    }
    
    let viewModel: ViewModel? = nil
    
    let typeLabel = UILabel()
    let dividerView = UIView()
    let nameLabel = UILabel()
    
    let balanceStackView = UIStackView()
    let balanceLabel = UILabel()
    let balanceAmountLabel = UILabel()
    
    let chevronImageView = UIImageView()
    
    static let reuseID = "AccountScummaryCell"
    static let rowHeight: CGFloat = 112
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension AccountSummaryCell {
    private func setup(){
        
        //TypeLabel
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        typeLabel.adjustsFontSizeToFitWidth = true
        typeLabel.text = "Account Type"
        
        //DividerView
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        dividerView.backgroundColor = appColor
        
        // NameLabel
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.preferredFont(forTextStyle: .body)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.text = "Account Name"
        
        // BalanceStackView
        balanceStackView.translatesAutoresizingMaskIntoConstraints = false
        balanceStackView.axis = .vertical
        balanceStackView.spacing = 0
        
        // BalanceLabel
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        balanceLabel.font = UIFont.preferredFont(forTextStyle: .body)
        balanceLabel.textAlignment = .right
        balanceLabel.adjustsFontSizeToFitWidth = true
        balanceLabel.text = "Some Balance"
        
        // BalanceAmountLabel
        balanceAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        balanceAmountLabel.textAlignment = .right
        balanceAmountLabel.text = "$XXX,XXX.XX"
        
        // ChevronImageView
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        let chevronImage = UIImage(systemName: "chevron.right")!.withTintColor(appColor, renderingMode: .alwaysOriginal)
        chevronImageView.image = chevronImage
        
        contentView.addSubview(typeLabel)
        contentView.addSubview(dividerView)
        contentView.addSubview(nameLabel)
        
        balanceStackView.addArrangedSubview(balanceLabel)
        balanceStackView.addArrangedSubview(balanceAmountLabel)
        
        contentView.addSubview(balanceStackView)
        contentView.addSubview(chevronImageView)
    }
    
    private func layout(){
        
        // TypeLabel
        NSLayoutConstraint.activate([
            typeLabel.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 2),
            typeLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2)
        ])
        
        // DividerView
        NSLayoutConstraint.activate([
            dividerView.topAnchor.constraint(equalToSystemSpacingBelow: typeLabel.bottomAnchor, multiplier: 1),
            dividerView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            dividerView.heightAnchor.constraint(equalToConstant: 4),
            dividerView.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        // NameLabel
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalToSystemSpacingBelow: dividerView.bottomAnchor, multiplier: 2),
            nameLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2)
        ])
        
        // BalanceStackView
        NSLayoutConstraint.activate([
            balanceStackView.topAnchor.constraint(equalToSystemSpacingBelow: dividerView.bottomAnchor, multiplier: 0),
            balanceStackView.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 4),
            trailingAnchor.constraint(equalToSystemSpacingAfter: balanceStackView.trailingAnchor, multiplier: 4)
        ])
        
        // ChevronImageView
        NSLayoutConstraint.activate([
            chevronImageView.topAnchor.constraint(equalToSystemSpacingBelow: dividerView.bottomAnchor, multiplier: 1),
            trailingAnchor.constraint(equalToSystemSpacingAfter: chevronImageView.trailingAnchor, multiplier: 1)
        ])
    }
    
    private func makeFormattedBalance(dollars: String, cents: String) -> NSMutableAttributedString {
        let dollarSignAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .callout), .baselineOffset: 8]
        let dollarAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .title1)]
        let centAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .footnote), .baselineOffset: 8]
        
        let rootString = NSMutableAttributedString(string: "$", attributes: dollarSignAttributes)
        let dollarString = NSAttributedString(string: dollars, attributes: dollarAttributes)
        let centString = NSAttributedString(string: cents, attributes: centAttributes)
        
        rootString.append(dollarString)
        rootString.append(centString)
        
        return rootString
    }
}

extension AccountSummaryCell {
    func configure(with vm: ViewModel) {
        typeLabel.text = vm.accountType.rawValue
        nameLabel.text = vm.accountName
        balanceAmountLabel.attributedText = vm.balanceAsAttributedString
        
        switch vm.accountType {
        case .Banking:
            dividerView.backgroundColor = appColor
            balanceLabel.text = "Current Balance"
        case .CreditCard:
            dividerView.backgroundColor = .systemOrange
            balanceLabel.text = "Current Balance"
        case .Investment:
            dividerView.backgroundColor = .systemPurple
            balanceLabel.text = "Value"
        }
    }
}

//
//  CartItemCell.swift
//  OrbitMalaysia
//
//  Created by Martin Parker on 18/05/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import UIKit
protocol CartItemDelegate : class {
    func removeItem(item: Product)
    
}


class CartItemCell: UITableViewCell {
    
    //Outlet
    @IBOutlet weak var productImg: RoundedImageView!
    @IBOutlet weak var productTitleLbl: UILabel!
    @IBOutlet weak var removeItemBtn: UIButton!
    
    //Variable
    var product: Product!
    weak var delegate : CartItemDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func configureCell(item : Product, delegate: CartItemDelegate ){
        self.delegate = delegate
        self.product = item
        
        productTitleLbl.text = "\(item.name) -> \(item.price)"
        
        
    }
    
    @IBAction func removeItemClicked(_ sender: Any) {
        delegate?.removeItem(item: product)
    }
}

//
//  RentalDetailViewController.swift
//  TMWPIX
//
//  Created by Apple on 04/08/2022.
//

protocol delegate_Cpf_Verified {
    func check_and_openCPF_popup(_ success: Bool)
}

import Foundation
import UIKit

class RentalDetailViewController: TMWViewController {
    
    var delegate: delegate_Cpf_Verified?
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    
    var price = ""
    var hour = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if price != "" {
            lblTitle.text = "ALUGUE EST FILME \nA FAMILIA MITCHELL E A REVOLA DAS MAQUINAS ALUGUE E ASSISTA AGORA MESMO POR R$ \(price) O FILME ESTARA DISPONIVEL POR \(hour)"
        }
        if hour != "" {
            lblContent.text = "Termos:\nAo continuar, voice cliente TMWPIX concorda que o valor R$ \(price) sera adicionado na sua proxima cobranca ou fatura a pagar. Apos confirmacao do aluguel, o filme estara disponivel por \(hour.lowercased()) exatamente. Nao havera reembolso do valor ou extensao do tempo de disponibilidade em situacao alguma."
        }
    }
    
    
    @IBAction func viewDismissed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func HireTapped(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.check_and_openCPF_popup(true)
        }
        
        
//        let alert = UIAlertController(title: "Hire", message: "Film has been hired successfully", preferredStyle: UIAlertController.Style.alert)
//        
//        self.present(alert, animated: true, completion: nil)
        //dismiss(animated: true, completion: nil)
    }
    
#if TARGET_OS_IOS
    //======= Orientation Control ===========
    override var shouldAutorotate: Bool{
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .landscapeLeft
    }
    //======================================
#endif
    
   

}

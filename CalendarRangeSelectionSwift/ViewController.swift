//
//  ViewController.swift
//  CalendarRangeSelectionSwift
//
//  Created by Santhosh K on 27/06/24.
//

import UIKit
import Fastis

class ViewController: UIViewController {

    @IBOutlet weak var myview: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myview = self.setupCalendar(myview)
    }


}



extension ViewController {
    
    func setupCalendar(_ getView:UIView) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        getView.addSubview(containerView)
        
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: getView.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: getView.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: getView.frame.width),
            containerView.heightAnchor.constraint(equalToConstant: getView.frame.height)
        ])
        
        let fastisController = FastisController(mode: .range)
        fastisController.title = "Choose range"
        //  fastisController.initialValue =  self.currentValue as? FastisRange
        fastisController.minimumDate = Calendar.current.date(byAdding: .month, value: -2, to: Date())
        fastisController.maximumDate = Calendar.current.date(byAdding: .month, value: 3, to: Date())
        fastisController.allowToChooseNilDate = true
        //   fastisController.shortcuts = [.today, .lastWeek, .lastMonth]
        if let fromDate = UserDefaults.standard.value(forKey: "fromDate")  as? Date {
            if let toDate = UserDefaults.standard.value(forKey: "toDate") as? Date {
                fastisController.initialValue = FastisRange(from: fromDate, to: toDate)
            }
        }
        
        
        //Note - project changes for save at selection time at dismissHandler
//        self.dismissHandler?(.done(self.value))
        //529 line and 556 line
        
        
        fastisController.dismissHandler = { [weak self] action in
            switch action {
            case .done(let newValue):
                if  let newVV = newValue {
                    let fromDate = newVV.fromDate
                    let toDate = newVV.toDate
                    UserDefaults.standard.setValue(fromDate, forKey: "fromDate")
                    UserDefaults.standard.setValue(toDate, forKey: "toDate")
                    print("fromDate:\(fromDate), toDate:\(toDate)")
                }
            case .cancel:
                UserDefaults.standard.setValue(Date(), forKey: "fromDate")
                UserDefaults.standard.setValue(Date(), forKey: "toDate")
                print("Cancel")
            }
        }
        
        //         fastisController.present(above: self)
        add(fastisController, to: containerView)
        
        return containerView
    }
    
    private func add(_ child: UIViewController, to containerView: UIView) {
        // Add child view controller
        addChild(child)
        
        // Add child's view to the container view
        containerView.addSubview(child.view)
        
        // Configure child's view constraints
        child.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            child.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            child.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            child.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            child.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        // Notify the child view controller that it has been moved to a parent
        child.didMove(toParent: self)
    }
    
    
}

//
//  halfSheetView.swift
//  iOS_BLE
//
//  Created by Jonathan Lin on 2022/9/5.
//

import SwiftUI

extension View {
    
    //Binding Show Variable...
    func halfSheet<SheetView: View>(isPresented: Binding<Bool>,@ViewBuilder
        sheetView: @escaping () -> SheetView) -> some View{
        
        //bcz it will automatically use the swiftui frame size only...
        return self
            .background(
                HalfSheetHelper(sheetView: sheetView(),presented: isPresented)
            )
    }
}

//UIKit Integration...
struct HalfSheetHelper<SheetView: View>: UIViewControllerRepresentable{
    
    var sheetView: SheetView
    @Binding var presented: Bool
    
    let controller = UIViewController()
    
    func makeUIViewController(context: Context) -> UIViewController {
        
        controller.view.backgroundColor = .clear
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if presented{
            //presenting Model View...
            
            let sheetController = CustomHostingController(rootView: sheetView)
            
            uiViewController.present(sheetController, animated: true)
            
            //toogling the show State...
            DispatchQueue.main.async {
                self.presented.toggle()
            }
        }
    }
}
//Custom UIHostingController for halfSeet...
class CustomHostingController<Content: View>: UIHostingController<Content>{
    
    override func viewDidLoad() {
        
        //setting presertation controller properties...
        if let presentationController = presentationController as?
            UISheetPresentationController{
            
            presentationController.detents = [
                
                .medium(),
                .large()
            ]
            
            //to show grab protion...
            presentationController.prefersGrabberVisible = true
        }
    }
}


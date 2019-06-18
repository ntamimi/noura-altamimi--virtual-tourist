//
//  mapVC.swift
//  noura altamimi- virtual tourist
//
//  Created by noura tamimi on 15/06/2019.
//  Copyright © 2019 noura tamimi. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class mapVC: UIViewController,MKMapViewDelegate,NSFetchedResultsControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var fetchedController:NSFetchedResultsController<Pin>!
    var context:NSManagedObjectContext{
        return DataController.shared.viewContext
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
    }

    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedController=nil
    }
    func setupFetchedResultsController(){
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key:"creationDate",ascending:false)]
        fetchedController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedController.delegate=self
        do{
            try fetchedController.performFetch()
            updateMapView()
            
        } catch{
            fatalError("Error5")
        }
    }
    
    @IBAction func Longpress(_ sender: UILongPressGestureRecognizer) {
        if sender.state != .began {return}
        let touchPoint = sender.location(in: mapView)
        let pin = Pin(context: context)
        pin.coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        try?context.save()
        
    }
    func updateMapView(){
        guard let pins = fetchedController.fetchedObjects  else {
            return
        }
        for pin in pins {
            if mapView.annotations.contains(where:{pin.compare(to: $0.coordinate)}){continue}
            let annotation = MKPointAnnotation()
            annotation.coordinate = pin.coordinate
            mapView.addAnnotation(annotation)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let photo = segue.destination as! PhotosVC
       photo.pin=sender as! Pin
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let pin = fetchedController.fetchedObjects?.filter{
            $0.compare(to: view.annotation!.coordinate)}.first!
        performSegue(withIdentifier: "showPhoto", sender: pin)
        }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateMapView()
    }
}

//
//  photosVC.swift
//  noura altamimi- virtual tourist
//
//  Created by noura tamimi on 15/06/2019.
//  Copyright © 2019 noura tamimi. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class PhotosVC: UIViewController,NSFetchedResultsControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = collectionView.frame.width/3
        return CGSize(width: length,height: length)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    @IBOutlet weak var newCollectionButton: UIBarButtonItem!
    @IBOutlet weak var activityIndecator: UIActivityIndicatorView!
    @IBOutlet weak var noPhotoLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var pin : Pin!
    var fetchedController:NSFetchedResultsController<Photo>!
    var pageNumber=1
    var isDeletingall=false
    var context:NSManagedObjectContext{
        return DataController.shared.viewContext
    }
    var haveImage: Bool{
        return (fetchedController.fetchedObjects?.count ?? 0) != 0
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noPhotoLabel.isHidden=true
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedController=nil
    }
    func setupFetchedResultsController(){
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        fetchRequest.predicate=NSPredicate(format: "pin == %@", pin)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchedController=NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedController.delegate = self
        do{
            try fetchedController.performFetch()
            if haveImage{
                updateUI(processing:false)
            }
            else {
                newCollectionTapped(self)
            }
            
            
        } catch{
            fatalError("Error10")
        }
    }
    
    
    @IBAction func newCollectionTapped(_ sender: Any) {
        updateUI(processing:true)
        if haveImage{
            isDeletingall=true
            for photo in fetchedController.fetchedObjects!{
                context.delete(photo)
            }
            try? context.save()
            isDeletingall=false
        }
        
        FlickrAPI.getPhotosURl(with: pin.coordinate, pageNumber: pageNumber){
            (urls,error,message) in
            DispatchQueue.main.async{
                self.updateUI(processing:false)
                guard (error==nil) && (message==nil) else {
                    print ("error9")
                    let errorMessage = error?.localizedDescription ?? message
                    print(errorMessage ?? "")
                    
                    return
                }
                guard let urls=urls, !urls.isEmpty else{
                    self.noPhotoLabel.isHidden=false
                    return
                }
                for url in urls{
                    let photo = Photo(context:self.context)
                    photo.imageURL=url
                    photo.pin=self.pin
                }
                try?self.context.save()
            }
        }
        
        self.pageNumber += 1
    }
    func updateUI(processing:Bool){
        collectionView.isUserInteractionEnabled = !processing
        if processing{
            newCollectionButton.title=""
            activityIndecator.isHidden=false 
            activityIndecator.startAnimating()
        }
        else {
            activityIndecator.stopAnimating()
            activityIndecator.isHidden=true
            newCollectionButton.title="new Collection"
        }
    }
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        collectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedController.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as!photoCell
        let photo = fetchedController.object(at: indexPath)
        cell.image.setPhoto(photo)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          let photo = self.fetchedController.object(at: indexPath)
        let alert = UIAlertController(title:"what do want to do ?", message: "", preferredStyle: .alert)
        
        
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { action in
           
          
            self.context.delete(photo)
            try? self.context.save()
          
            }))

        alert.addAction(UIAlertAction(title: "Share", style: .default, handler: {
        action in
             let photo2 = self.fetchedController.object(at: indexPath).imageURL
            let activityController = UIActivityViewController(activityItems: [photo2] , applicationActivities: nil)
            activityController.completionWithItemsHandler = { _, success, _, error in
                if let Error = error {
                    let alert = UIAlertController(title: "Warning", message: Error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    return
                }
            
            }
            self.present(activityController, animated: true, completion: nil)
     
        }))
        
        self.present(alert, animated: true)
        
        
    
    
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if let new = newIndexPath, let old = indexPath, type == .move {
            collectionView.moveItem(at: old, to: new)
            return
        }
        
        if let indexPath = indexPath, type == .delete && !isDeletingall{
            collectionView.deleteItems(at: [indexPath])
            return
        }
        
        if let indexPath = indexPath, type == .insert {
            collectionView.insertItems(at: [indexPath])
            return
        }
        
        if type != .update {
            collectionView.reloadData()
        }
    }
}

//
//  FlickrAPI.swift
//  noura altamimi- virtual tourist
//
//  Created by noura tamimi on 15/06/2019.
//  Copyright © 2019 noura tamimi. All rights reserved.
//

import Foundation
import MapKit
struct FlickrAPI{
 
    static func getPhotosURl(with coordinate: CLLocationCoordinate2D, pageNumber: Int,completion: @escaping ([URL]?, Error?, String?)->()){
        let methodParameter = [
            "method":"flickr.photos.search",
            "api_key":"470b185e489df8c01c62d5daa21a16c5",
            "bbox":bboxString(for: coordinate),
            "safeSearch" :"1","extras":"url_m",
            "format":"json", "nojsoncallback":"1",
            "page":pageNumber, "per_page": 9] as [String : Any]
        
        let request = URLRequest(url: getURL(from : methodParameter))
        let task = URLSession.shared.dataTask(with: request){
            (data,respose,error)in guard (error==nil) else {
                completion(nil,error,nil)
                return
            }
            guard let statusCode = (respose as? HTTPURLResponse)?.statusCode,statusCode >= 200 && statusCode<=299 else {
                completion(nil,nil,"error100")
                 return
            }
            guard let data = data else {
                completion(nil,nil,"no data")
                return
            }
            guard let result = try? JSONSerialization.jsonObject(with: data, options: [])as![String:
                Any] else{
                completion(nil,nil,"could not parse")
                return
            }
            guard let stat = result["stat"] as? String, stat == "ok" else {
                completion(nil,nil,"error return from flickr API")
                return
            }
            
            guard let photosDictionary = result["photos"] as? [String:Any]else {
                completion(nil,nil,"cannot find key")
                return
            }
            guard let photoArray = photosDictionary["photo"] as? [[String:Any]] else{
            completion(nil,nil,"cannot find key in \(photosDictionary)")
            return
        }
            let photoURLs=photoArray.compactMap{
                photosDictionary -> URL? in
                guard let url = photosDictionary["url_m"]as? String else {return nil }
                return URL (string: url)
            }
            completion(photoURLs,nil,nil)
        }
        task.resume()
        
    }


static func bboxString(for coordinate:CLLocationCoordinate2D) -> String {
    let latitude = coordinate.latitude
    let longitude = coordinate.longitude
    let minlat=max(latitude - 0.01 , -90)
    let minlon=max(longitude-0.01,-180)
    let maxlat=min(latitude+0.01,90)
    let maxlong=min(longitude+0.01,180)
    return "\(minlon),\(minlat),\(maxlong),\(maxlat)"
}
    static func getURL(from parameters:[String:Any])->URL{
        var component = URLComponents()
        component.scheme="https"
        component.host="api.flickr.com"
        component.path="/services/rest"
    component.queryItems=[URLQueryItem]()
        for (key, value) in parameters{
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            component.queryItems!.append(queryItem)
        }
        return (component.url)!
    }
}


//
//  MovementPickVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 12/04/2024.
//

import Foundation
import Combine
import SwiftUI

struct MovementPickModel {

    let forward: Double

    

}


class MovementDataViewModel: ObservableObject {

    @Published var onScreenMovementFrameSize: Dimension = ZeroValue.dimension

    var staticPoint: PositionAsIosAxes = ZeroValue.iosLocation
    
    @Published var objectZeroOrigin = ZeroValue.iosLocation
    @Published var uniquePartNames: [String] = []

    
    @Published var uniqueCanvasNames: [String] = [
        PartTag.canvas.rawValue + PartTag.origin.rawValue,
        PartTag.canvas.rawValue + PartTag.corner.rawValue
    ]
    @Published var movementDictionaryForScreen: CornerDictionary = MovementDictionaryForScreenService.shared.movementDictionaryForScreen

    var movementType: Movement = .none
    
    var staticPointUpdate: PositionAsIosAxes = ZeroValue.iosLocation {
        didSet {
            movementImageData = getMovementImageData()
        }
    }

    
   var dataToCentreObjectZeroOrigin: AddOrPad = (
        addX: 0.0,
        addY: 0.0,
        padX: 0.0,
        padY: 0.0
    )
    
    
    var movementImageData: MovementImageData =
    MovementImageService.shared.movementImageData {
            didSet{
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.uniquePartNames = self.getUniquePartNamesFromObjectDictionary()//!
                    self.movementDictionaryForScreen = self.getMovementDictionaryForScreen()//!
                    self.objectZeroOrigin = self.getObjectZeroOrgin()//!
                    self.dataToCentreObjectZeroOrigin = self.getDataToCentreObjectZeroOrigin()
                    self.translateDictionaryToCentreObjectZeroOrigin()
                    self.translateStaticPointForCentreObjectZeroOrigin()
                    self.objectZeroOrigin = self.getObjectZeroOrgin()//!
                    self.addCanvasOriginToDictionary()
                    self.addCanvasCornerToDictionary()
                    self.onScreenMovementFrameSize = self.getObjectOnScreenFrameSize()//!
                    MovementDictionaryForScreenService.shared.setMovementDictionaryForScreen(self.movementDictionaryForScreen)
                }
//                uniquePartNames = getUniquePartNamesFromObjectDictionary()//!
//    
//    
//    
//                movementDictionaryForScreen = getMovementDictionaryForScreen()//!
//                objectZeroOrigin = getObjectZeroOrgin()//!
//    
//                dataToCentreObjectZeroOrigin = getDataToCentreObjectZeroOrigin()
//                translateDictionaryToCentreObjectZeroOrigin()
//    
//                translateStaticPointForCentreObjectZeroOrigin()
//    
//                objectZeroOrigin = getObjectZeroOrgin()//!
//    
//    
//                addCanvasOriginToDictionary()
//    
//                addCanvasCornerToDictionary()
//                onScreenMovementFrameSize = getObjectOnScreenFrameSize()//!
//    
//                MovementDictionaryForScreenService.shared.setMovementDictionaryForScreen(movementDictionaryForScreen)
    
            }
        }
    

    
    //DATA MANIPULATION
    var ensureInitialObjectAllOnScreen =
        // drag will not work if coordinates are negative
        // must be repeated as movement can make negative
        EnsureNoNegativePositions(
            fourCornerDic: [:],
            objectDimension: ZeroValue.dimension
        )
    
    private var cancellables: Set<AnyCancellable> = []
    
    //all data to display object and its movement
    var movementFourCornerPerKeyDic: CornerDictionary = [:]

    init(){
      
        
        //Initial build of movement data for image using a static image and default movement parameters

        
       MovementImageService.shared.$movementImageData
            .sink { [weak self] newData in
                self?.movementImageData = MovementImageService.shared.getMovementImageData()
                print("movment image data update")
            }
            .store(
                in: &cancellables
            )
        
        
        
        //Dictionary values refer to key which are handled differently in view
        //Part
        //Arc
        //Canvas: zero orgin and maximum position are static
        //Extract these names
        uniquePartNames = getUniquePartNamesFromObjectDictionary()
        
        //DATA MANIPULATION STARTS
        //All dictionary values dervied from data image must be positive
        movementDictionaryForScreen = getMovementDictionaryForScreen()
        
        //With all positive values find initial objectZeroOrigin
        objectZeroOrigin = getObjectZeroOrgin()
     
        //with objectZeroOrigin at center find its position
        dataToCentreObjectZeroOrigin = getDataToCentreObjectZeroOrigin()
      
        
       

        
        //To avoid manipulating View to make objectZeroOrigin static during movement edits
        //Effect in data
        translateDictionaryToCentreObjectZeroOrigin()
        objectZeroOrigin = getObjectZeroOrgin()
        
        addCanvasOriginToDictionary()
        addCanvasCornerToDictionary()
       
        translateStaticPointForCentreObjectZeroOrigin()
        
        onScreenMovementFrameSize = getObjectOnScreenFrameSize()
        
        MovementDictionaryForScreenService.shared.setMovementDictionaryForScreen(movementDictionaryForScreen)
        
        
        
       
    }
}
    


extension MovementDataViewModel {

    
    func  getMovementDictionaryForScreen ()
        -> CornerDictionary {
            ensureInitialObjectAllOnScreen = getMakeWholeObjectOnScreen()
        let dic =
            ensureInitialObjectAllOnScreen.getModifiedDictionary()
          
        return dic
    }
    
    
    func getMovementImageData() -> MovementImageData{
        
        movementImageData

    }

    
    func getObjectZeroOrgin()  -> PositionAsIosAxes{
        let dic = movementDictionaryForScreen
        let name = CreateNameFromIdAndPart(.id0, PartTag.origin).name
        let filteredDictionary =
        dic.filter { $0.key.contains(name) }
        let useAnyOfFour = 0
        guard let origin = filteredDictionary[name]?[useAnyOfFour] else {
            print(dic)
            fatalError()
        }

        return origin
    }
    

}
    


    
//MARK: Names and Dictionaries
extension MovementDataViewModel {
    
    func getPostTiltOneCornerPerKeyDic() -> PositionDictionary {
        movementImageData.objectImageData.postTiltObjectToOneCornerPerKeyDic
    }
    
    
    func getPostTiltObjectToPartFourCornerPerKeyDic() -> CornerDictionary {
        movementImageData.objectImageData.postTiltObjectToPartFourCornerPerKeyDic
    }

    
    func getUniquePartNamesFromObjectDictionary() -> [String] {
        let dic = getPostTiltObjectToPartFourCornerPerKeyDic()
      
        let names =
        Array(
            dic.keys
        ).filter {
            !(
                $0.contains(
                    PartTag.arcPoint.rawValue //UI manages differently from parts
                )  || $0.contains(
                    PartTag.origin.rawValue// ditto
                )  || $0.contains(
                    PartTag.staticPoint.rawValue// ditto
                ) //|| $0.contains(
                    //Part.stabiliser.rawValue// fixed wheel edits this
               // )
            ) }
      
        return names
    }
}


//MARK: Transform for Screen
extension MovementDataViewModel {
    func getMakeWholeObjectOnScreen()
        -> EnsureNoNegativePositions {
            let objectDimension: Dimension =
                getObjectDimension()
            let fourCornerDic: CornerDictionary =
            movementImageData.objectImageData
                    .postTiltObjectToPartFourCornerPerKeyDic
            
            return
                EnsureNoNegativePositions(
                    fourCornerDic: fourCornerDic,
                    objectDimension: objectDimension
                )
    }
    
    
    func getObjectOnScreenFrameSize ()
    -> Dimension {
        FourCornerDictionryTo(movementDictionaryForScreen).valueSize
    }


    func getObjectDimension ( )
        -> Dimension {
           
            let dim =
            movementImageData.objectImageData.objectDimension
        
            return dim
    }
    
    ///the data is orgainised so that no matter what edits occur the objectZero origin
    ///remains at the data center and hence the View center and hence
    ///as edits occur objectZero origin is static on the screen view
    ///This avoids the need to have View code which determines the objectZero screen origin position
    ///an manipulate the View to keep that point static
    func transformMovementDictionaryForScreenToCentreObjectZeroOrigin(){
        let addTouple = (x: dataToCentreObjectZeroOrigin.addX, y: dataToCentreObjectZeroOrigin.addY,z: 0.0)
        
        for (key, _) in movementDictionaryForScreen {
            if let value = movementDictionaryForScreen[key] {
                movementDictionaryForScreen[key] = CreateIosPosition.addToupleToArrayOfTouples(addTouple, value)
            }
        }
    }

}
    

//MARK: Movement Information
extension MovementDataViewModel {
    func getOffsetToKeepObjectOriginStaticInLengthOnScreen() -> Double{
            ensureInitialObjectAllOnScreen
                .getOffsetToKeepObjectOriginStaticInLengthOnScreen()
    }
    
    
    func getOffsetForObjectOrigin() -> PositionAsIosAxes {
        let oneCornerDic = ConvertFourCornerPerKeyToOne(fourCornerPerElement: movementDictionaryForScreen).oneCornerPerKey
        let minThenMax =
            CreateIosPosition
               .minMaxPosition(
                   oneCornerDic
                   )
        //the minimum values of the translated object is the offset for all part positions including origin
        return
            CreateIosPosition.negative(minThenMax[0])
        
        
    }
}

    
//MARK: Centre ObjectZeroOrigin

extension MovementDataViewModel {
    
    func getDictionaryMaxForScreenDictionary() -> PositionAsIosAxes{
        let dic = ConvertFourCornerPerKeyToOne(
            fourCornerPerElement: movementDictionaryForScreen
        ).oneCornerPerKey
        
        let minMax = CreateIosPosition.minMaxPosition(
            dic
        )
        let onlyMax = 1
        let max = minMax[onlyMax]
        
        return max
    }
    
    
    func getDataToCentreObjectZeroOrigin() -> AddOrPad{

        let max = getDictionaryMaxForScreenDictionary() //minMax[1]
        var padX = 0.0
        var padY = 0.0
        var addX = 0.0
        var addY = 0.0
        
        (
            addX,
            padX
        ) = getCorrections(
            max.x,
            objectZeroOrigin.x
        )
        (
            addY,
            padY
        ) = getCorrections(
            max.y,
            objectZeroOrigin.y
        )
      
        return (addX: addX, addY: addY, padX: padX, padY: padY )
        
        func getCorrections(
            _ max: Double,
            _ origin: Double
        ) -> (
            Double,
            Double
        ) {
            var pad = max
            var translate = 0.0
            switch (
                max,
                origin
            ) {
            case let (
                max,
                origin
            ) where max > 2 * origin:
                translate = max - 2 * origin
            case let (
                max,
                origin
            ) where max < 2 * origin:
                pad = 2 * origin
            case let (
                max,
                origin
            ) where max == origin:
                break
                //do nothing
            default:
                break
            }
            
            return (
                translate,
                pad
            )
        }
        
    }
    
    
    func getTranslationToCentreObjectZeroOrigin() -> PositionAsIosAxes {
        (dataToCentreObjectZeroOrigin.addX, y: dataToCentreObjectZeroOrigin.addY, z: 0.0)
    }
    
  
    func translateStaticPointForCentreObjectZeroOrigin(){
        let translation = getTranslationToCentreObjectZeroOrigin()
       staticPoint = CreateIosPosition.addTwoTouples(translation, staticPoint)
    }
    
    
    func translateDictionaryToCentreObjectZeroOrigin() {
        let translation = getTranslationToCentreObjectZeroOrigin()
                for (key, value) in movementDictionaryForScreen {
                    let currentValue = value
                    let newValue =
                        CreateIosPosition.addToupleToArrayOfTouples(translation, currentValue)
                    movementDictionaryForScreen[key] = newValue
                }
    }
    
    
    func addCanvasCornerToDictionary() {
        
        let canvasCornerName = uniqueCanvasNames[1]
        
        let origin = getCanvasOrigin()
        let data = dataToCentreObjectZeroOrigin
        let corner = (x: data.padX, y: data.padY, z: 0.0)
        let corners = CreateIosPosition.addToupleToArrayOfTouples(corner, origin)

        movementDictionaryForScreen[canvasCornerName] = corners
    }
    
    func getCanvasOrigin() -> [PositionAsIosAxes] {
        let size = 0.5
        return
            [(x: 0.0, y: 0.0, z: 0.0), (x: size, y: 0.0, z: 0.0), (x: size, y: size, z: 0.0), (x: 0.0, y: size, z: 0.0)]
    }
    
    
    func addCanvasOriginToDictionary() {
        let canvasOriginName = uniqueCanvasNames[0]

        movementDictionaryForScreen[canvasOriginName] = getCanvasOrigin()

    }
}

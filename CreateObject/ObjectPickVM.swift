//
//  ObjectPickVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 04/03/2023.
//

import Foundation
import Combine

struct ObjectPickModel {
    var currentObjectName: String
   
    var preTiltFourCornerPerKeyDic: CornerDictionary
    
    var loadedDictionary: PositionDictionary = [:]
        
    var angleUserEditedDic: AnglesDictionary
    
    var angleMinMaxDic: AngleMinMaxDictionary

    var currentObjectFrameSize: Dimension = ZeroValue.dimension
    
    var userEditedDic: UserEditedDictionaries?
    
    var defaultMinMaxDictionaries: DefaultMinMaxDimensionDictionary
    
    var movementImageData: ObjectImageData


    init(
        currentObjectName: String,
        userEditedDic: UserEditedDictionaries?,
        defaultMinMaxDictionaries: DefaultMinMaxDimensionDictionary,
        movementImageData: ObjectImageData
    ){
        self.userEditedDic = userEditedDic
        self.defaultMinMaxDictionaries = defaultMinMaxDictionaries
        self.currentObjectName = currentObjectName
        self.preTiltFourCornerPerKeyDic = movementImageData.preTiltObjectToPartFourCornerPerKeyDic
      
        angleUserEditedDic = userEditedDic?.angleUserEditedDic ?? [:]
        
        angleMinMaxDic = movementImageData.angleMinMaxDic

        self.movementImageData = movementImageData
    }
}
    

class ObjectPickViewModel: ObservableObject {
    @Published private var objectPickModel: ObjectPickModel
    
    var movementImageData: ObjectImageData
    
    @Published var userEditedSharedDics: UserEditedDictionaries
    
    let defaultMinMaxDimensionDic =
        DefaultMinMaxDimensionDictionary.shared
    
    let defaultMinMaxOriginDic =
        DefaultMinMaxOriginDictionary.shared
    
    var currentObjectType: ObjectTypes = .fixedWheelRearDrive

    var partDataSharedDic = DictionaryService.shared.partDataSharedDic
    
    var choiceOfEditForSide: SidesAffected = BilateralPartWithOnePropertyToChangeService.shared.choiceOfEditForSide
    
    var scopeOfEditForSide: SidesAffected = BilateralPartWithOnePropertyToChangeService.shared.scopeOfEditForSide
    
    var propertyToEdit: PartTag = BilateralPartWithOnePropertyToChangeService.shared.dimensionPropertyToEdit
   
    private var cancellables: Set<AnyCancellable> = []
    
    
    @Published var objectChainLabelsDefaultDic: ObjectChainLabelDictionary = [:]

    var ensureInitialObjectAllOnScreen =
        EnsureInitialObjectAllOnScreen(fourCornerDic: [:], oneCornerDic: [:], objectDimension: ZeroValue.dimension)
    
    init() {
        
        self.userEditedSharedDics = DictionaryService.shared.userEditedSharedDics
        
        movementImageData = MovementImageData(
            .fixedWheelRearDrive,
            nil
        ).objectImageData
        
        objectPickModel =
            ObjectPickModel(
                currentObjectName: currentObjectType.rawValue,
                userEditedDic: nil,
                defaultMinMaxDictionaries: defaultMinMaxDimensionDic,
                movementImageData: MovementImageData(.fixedWheelRearDrive, nil).objectImageData)
        
        DictionaryService.shared.$currentObjectType
            .sink { [weak self] newData in
                self?.currentObjectType = newData
            }
            .store(in: &self.cancellables)
        
        DictionaryService.shared.$userEditedSharedDics
            .sink { [weak self] newData in
                self?.userEditedSharedDics = newData
            }
            .store(in: &self.cancellables)
        
        DictionaryService.shared.$partDataSharedDic
            .sink { [weak self] newData in
                self?.partDataSharedDic = newData
            }
            .store(in: &self.cancellables)
        
        BilateralPartWithOnePropertyToChangeService.shared.$scopeOfEditForSide
            .sink { [weak self] newData in
                self?.scopeOfEditForSide = newData
            }
            .store(in: &self.cancellables)
        
        BilateralPartWithOnePropertyToChangeService.shared.$choiceOfEditForSide
            .sink { [weak self] newData in
                self?.choiceOfEditForSide = newData
            }
            .store(in: &self.cancellables)
        
        BilateralPartWithOnePropertyToChangeService.shared.$dimensionPropertyToEdit
            .sink { [weak self] newData in
                self?.propertyToEdit = newData
            }
            .store(in: &self.cancellables)
        
        ensureInitialObjectAllOnScreen = getMakeWholeObjectOnScreen()

    }
}


//MARK: RESET/MODIFY
extension ObjectPickViewModel {
    
    func resetObjectByCreatingFromName() {
        //DIMENSIONCHANGE
    
        DictionaryService.shared.dimensionUserEditedDicReseter()
        
        //ANGLECHANGE
        
        DictionaryService.shared.angleUserEditedDicReseter()
        
        
        DictionaryService.shared.partIdsUserEditedDicReseter()
        
        modifyObjectByCreatingFromName()
       
    }
    
    
    func modifyObjectByCreatingFromName(){
       // print("CALLED")
        
        movementImageData = MovementImageData(
            currentObjectType,
            userEditedSharedDics
        ).objectImageData
        
       objectChainLabelsDefaultDic = movementImageData.objectChainLabelsDefaultDic//update for new object

        createNewPickModel()
    }
    
    
    func pickNewObjectByCreatingFromName(){
        movementImageData = MovementImageData(
            currentObjectType,
            userEditedSharedDics
        ).objectImageData
        
        createNewPickModel()
    }
    
    
    func createNewPickModel() {
        DictionaryService.shared.partDataSharedDicModifier(movementImageData.partDataDic)
        
        objectPickModel =
            ObjectPickModel(
                currentObjectName: currentObjectType.rawValue,
                userEditedDic: userEditedSharedDics,
                defaultMinMaxDictionaries: defaultMinMaxDimensionDic,
                movementImageData: movementImageData)
        
        ensureInitialObjectAllOnScreen =
            getMakeWholeObjectOnScreen()
        
        setCurrentObjectFrameSize()
    }
}



//MARK: GET
extension ObjectPickViewModel {
    
    func getInitialSliderValue(
        _ part: Part,
        _ propertyToEdit: PartTag,
        _ sidesAffected: SidesAffected? = nil) -> Double {

        var value: Double? = nil
        if let partData = partDataSharedDic[part] {//parts edited out do not exist
            let idForLeftOrRight = choiceOfEditForSide == .right ? PartTag.id1: PartTag.id0
        
            var id: PartTag
            if let sideAsId = sidesAffected?.getOneId() {
                id = sideAsId
                
                //print(id)
            } else {
                id =  partData.id.one ?? idForLeftOrRight//two sources for id
            }
           
            
            switch propertyToEdit {
            case .height:
                let dimension = partData.dimension.returnValue(id)
                value = dimension.height
            case .width:
                let dimension = partData.dimension.returnValue(id)
                value = dimension.width
            case.length:
                let dimension = partData.dimension.returnValue(id)
                value = dimension.length
            case .xOrigin, .yOrigin:
                let name = CreateNameFromIdAndPart(id, part).name
                let offsetToOrigin = userEditedSharedDics.originOffsetUserEditedDic[name] ?? ZeroValue.iosLocation
                //let origin = partData.childOrigin.returnValue(id)
//                print("get \(origin)")
//                print(idForLeftOrRight)
//                print("")
                value = propertyToEdit == .xOrigin ?
                offsetToOrigin.x: offsetToOrigin.y
                
                //value = idForLeftOrRight == .id0 ? value: value.map{-$0}
                
            case .angle:
                value =
                    partData.angles.returnValue(id).x.converted(to: .degrees).value
                
                
            default:
                break
            }
          
            
        }
            let whenPartHasBeenRemovedAndValueNotUsed = 0.0
          //print (value)
            return value ?? whenPartHasBeenRemovedAndValueNotUsed
    }
    
    
    func getSidesPresentGivenPossibleUserEdit(_ partOrAssociatedPart: Part, _ caller: String = "caller not given") -> [SidesAffected] {
        

        let oneOrTwoId = userEditedSharedDics.partIdsUserEditedDic[partOrAssociatedPart] ?? OneOrTwoId(currentObjectType, partOrAssociatedPart).forPart
        

        guard let chainLabels = userEditedSharedDics.objectChainLabelsUserEditDic[currentObjectType] ?? movementImageData.objectChainLabelsDefaultDic[currentObjectType] else {
            fatalError()
        }
    
//        if caller == "bilateral edit" {
//              print ("\(partOrAssociatedPart.rawValue) \(part.rawValue) \(oneOrTwoId)  \(caller)")
//            print(chainLabels)
//              print("")
//        }
        
        var sidesPresent: [SidesAffected] = []
        //the part may be removed from both sides by user edit
        if chainLabels.contains(partOrAssociatedPart) {
            sidesPresent = oneOrTwoId.mapOneOrTwoToSide()
        } else {
            sidesPresent = [.none]
        }
//print(sidesPresent)
        let firstSidesPresentGivesSidesAffected = 0
        
       // print("getSidesPresentGivenPossibleUserEdit \(part)")
        BilateralPartWithOnePropertyToChangeService.shared.setBothOrLeftOrRightAsEditible(sidesPresent[firstSidesPresentGivesSidesAffected]
        ,"getSidesPresentGivenPossibleUserEdit"
        )
        
        return sidesPresent
    }
    
    
    func getSidesPresentGivenUserEditContainsLeft(_ part: Part, _ caller: String = "caller not given") -> Bool {
        
   //     print("left \(part)")
        return
        getSidesPresentGivenPossibleUserEdit(part,caller).contains(SidesAffected.left) ?
            true: false
    }
    
    
    func getSidesPresentGivenUserEditContainsRight(_ part: Part, _ caller: String = "caller not given") -> Bool {
   //     print("right \(part)")
        return
        getSidesPresentGivenPossibleUserEdit(part,caller).contains(SidesAffected.right) ?
            true: false
    }
    
    
    func getAllOriginNames()-> String{
        DictionaryInArrayOut().getAllOriginNamesAsString(getPostTiltOneCornerPerKeyDic())
    }
    
    
    func getAllOriginValues()-> String{
        DictionaryInArrayOut().getAllOriginValuesAsString(getPostTiltOneCornerPerKeyDic())
    }
    
    
    func getAngleDic()
    -> AnglesDictionary {
        //ANGLECHANGE
        //objectPickModel.angleUserEditedDic
        userEditedSharedDics.angleUserEditedDic
    }
    
    
    func getAngleMinMaxDic(_ part: Part)
    -> AngleMinMax {

    let partName =
        CreateNameFromIdAndPart(.id0, part).name
        
       // print(partName)
        
    return
        objectPickModel.angleMinMaxDic[partName] ?? ZeroValue.angleMinMax
    }
    
    
    func getCurrentObjectFrameSize() -> Dimension {
        objectPickModel.currentObjectFrameSize
    }
    
    
    func getCurrentObjectName() -> String{
        objectPickModel.currentObjectName
    }
    
    
    func getCurrentObjectType()
        -> ObjectTypes {
        currentObjectType
    }
    
    
    func geMinMax(
        _ part: Part,
        _ propertyToBeEdited: PartTag,
        _ callingFunc: String) -> (min: Double, max: Double) {
  // print("\(part) \(propertyToBeEdited)")
            var minMaxValue =
                (min: 0.0, max: 0.0)
            
           
            switch propertyToBeEdited {
//            case .angle:
//               let values =
//                PartDefaultAngle(part, currentObjectType).minMaxAngle
//                
//                minMaxValue =
//                    (min: values.min.value,
//                     max: values.max.value)
                
            case .height:
                let values =
                    defaultMinMaxDimensionDic.getDefault(
                        part,
                        currentObjectType)
                minMaxValue = (min: values.min.height,
                               max: values.max.height)
                
            case .length:
                let values =
                    defaultMinMaxDimensionDic.getDefault(
                        part,
                        currentObjectType)
                minMaxValue = (min: values.min.length,
                               max: values.max.length)
                
            case .width:
                let values =
                    defaultMinMaxDimensionDic.getDefault(
                        part,
                        currentObjectType)
                minMaxValue = (min: values.min.width,
                               max: values.max.width)
                
            case .xOrigin, .yOrigin, .zOrigin:
                let values =
                    defaultMinMaxOriginDic.getDefault(
                        part,
                        currentObjectType)
                minMaxValue = (min: values.min.x,
                               max: values.max.x)
               // print(minMaxValue)
            default: break
            }
            
            
       
        
        return minMaxValue
    }
    
//    func getInitialSliderValue(_ part: Part, _ id: PartTag) -> Double {
//        print(part)
//        print(id)
//        let objectType = getCurrentObjectType()
//        return 100.0
//    }
    
    
    func getPostTiltOneCornerPerKeyDic()
    -> PositionDictionary {
        objectPickModel.movementImageData.postTiltObjectToOneCornerPerKeyDic
    }
    
    
    func getPreTiltFourCornerPerKeyDic() -> CornerDictionary {
        objectPickModel.movementImageData.preTiltObjectToPartFourCornerPerKeyDic
    }
    
    
    func getPostTiltFourCornerPerKeyDic() -> CornerDictionary {
        objectPickModel.movementImageData.postTiltObjectToPartFourCornerPerKeyDic
    }
    
    
    func getObjectDictionaryFromSaved(_ entity: LocationEntity) -> [String]{
        let allOriginNames = entity.interOriginNames ?? ""
        let allOriginValues = entity.interOriginValues ?? ""

        let array =
            DictionaryInArrayOut().getNameValue(
                OriginStringInDictionaryOut(allOriginNames,allOriginValues).dictionary.filter({$0.key.contains(PartTag.corner.rawValue)})//, sender
                )
        return array
    }
    


    
    
    func getRelevantDictionary(
        _ forScreenOrMeasurment: DictionaryTypes,
        _ dictionaryVersion: DictionaryVersion = .useCurrent)
            -> CornerDictionary {
            var relevantDictionary: CornerDictionary = [:]

            switch dictionaryVersion {
            case .useCurrent:
                relevantDictionary = getPostTiltFourCornerPerKeyDic()
            case .useLoaded:
                relevantDictionary = getPostTiltFourCornerPerKeyDic()
            default:
                break
            }


        switch forScreenOrMeasurment {
        case .forScreen:
            relevantDictionary =
            getObjectDictionaryForScreen()
           
        default: break
        }
        return relevantDictionary
    }
    

    func getUniquePartNamesFromObjectDictionary() -> [String] {
     // GetUniqueNames(  getPostTiltFourCornerPerKeyDic()).forPart
       // Array(movementImageData.getUniquePartNamesFromObjectDictionary().keys)
        Array(getPostTiltFourCornerPerKeyDic().keys)
    }
    
    
    
    func getList (_  version: DictionaryVersion) -> [String] {
        var list: [String] = []
            switch version  {
            case .useCurrent:
                list =
                    DictionaryInArrayOut().getNameValue(
                        getPostTiltOneCornerPerKeyDic())
            case .useInitial:
                list =
                    DictionaryInArrayOut().getNameValue(
                        getPostTiltOneCornerPerKeyDic())
            case .useLoaded:
                list =
                    DictionaryInArrayOut().getNameValue(
                        objectPickModel.loadedDictionary)
            case .useDimension:
             
                list =
                    DictionaryInArrayOut().getNameValue(
                        objectPickModel.movementImageData.dimensionDic)
                    }
        return list
    }
    
    
    func getMaximumDimensionOfObject (
    _ dictionary: PositionDictionary)
        -> Double {
        movementImageData.maximumDimension
    }
    

    func getObjectDimension ( )
        -> Dimension {
            movementImageData.objectDimension
    }
}


//MARK: SET
extension ObjectPickViewModel {
    
    func setCurrentObjectFrameSize() {
        objectPickModel.currentObjectFrameSize = getObjectOnScreenFrameSize()
    }
    
    
    func setCurrentObjectName(_ objectName: String){
        objectPickModel.currentObjectName = objectName
        guard let objectType = ObjectTypes(rawValue: objectName) else {
            fatalError()
         }
        DictionaryService.shared.currentObjectType = objectType
    }
}


//unless the path is initially defined with only positive coordinates all of which are on screen
// touch is not detected even if the object is scaled and dragged within screen
//MARK: ENSURE DRAG
extension ObjectPickViewModel {
    
    
    func  getObjectDictionaryForScreen ()
    -> CornerDictionary {
        
        let dictionary =
         ensureInitialObjectAllOnScreen.getObjectDictionaryForScreen()
        
        return dictionary
    }
    
    func getOffsetToKeepObjectOriginStaticInLengthOnScreen() -> Double{
            ensureInitialObjectAllOnScreen
                .getOffsetToKeepObjectOriginStaticInLengthOnScreen()
    }
    
    
    func getMakeWholeObjectOnScreen()
        -> EnsureInitialObjectAllOnScreen {
            let objectDimension: Dimension =
                getObjectDimension()
            let fourCornerDic: CornerDictionary =
                objectPickModel.movementImageData
                    .postTiltObjectToPartFourCornerPerKeyDic
            let oneCornerDic: PositionDictionary =
                objectPickModel.movementImageData
                    .postTiltObjectToOneCornerPerKeyDic
            return
                EnsureInitialObjectAllOnScreen(
                fourCornerDic: fourCornerDic, oneCornerDic: oneCornerDic, objectDimension: objectDimension)
    }
    
    
    func getObjectOnScreenFrameSize ()
    -> Dimension {
        let frameSize =
          ensureInitialObjectAllOnScreen.getObjectOnScreenFrameSize()
        return frameSize
    }

}









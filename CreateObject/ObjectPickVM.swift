//
//  ObjectPickVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 04/03/2023.
//

import Foundation
import Combine

struct ObjectPickModel {
    var currentObjectName: String  //FixedWheelBase.Subtype.midDrive.rawValu
   
    var preTiltFourCornerPerKeyDic: CornerDictionary
    
    var loadedDictionary: PositionDictionary = [:]
    
    ///source of truth for the UI  (after absolute coordinates are transformed)
    //var postTiltFourCornerPerKeyDic: CornerDictionary
        
    var angleUserEditedDic: AnglesDictionary
    
    var angleMinMaxDic: AngleMinMaxDictionary

    var currentObjectFrameSize: Dimension = ZeroValue.dimension
    
    var userEditedDic: UserEditedDictionaries?
    var defaultDictionaries: DefaultMinMaxDimensionDictionary
    
    var objectImageData: ObjectImageData


    init(
        currentObjectName: String,
        userEditedDic: UserEditedDictionaries?,
        defaultDictionaries: DefaultMinMaxDimensionDictionary,
        objectImageData: ObjectImageData
    ){
        self.userEditedDic = userEditedDic
        self.defaultDictionaries = defaultDictionaries
        self.currentObjectName = currentObjectName
        self.preTiltFourCornerPerKeyDic = objectImageData.preTiltObjectToPartFourCornerPerKeyDic
      
        angleUserEditedDic = userEditedDic?.angleUserEditedDic ?? [:]
        angleMinMaxDic = objectImageData.angleMinMaxDic

        self.objectImageData = objectImageData
       
      
    }
}
    

class ObjectPickViewModel: ObservableObject {
    @Published private var objectPickModel: ObjectPickModel
    var objectImageData: ObjectImageData
    @Published var userEditedSharedDics: UserEditedDictionaries
    let defaultMinMaxDimensionDic = 
        DefaultMinMaxDimensionDictionary.shared
    let defaultMinMaxOriginDic =
        DefaultMinMaxOriginDictionary.shared
    var currentObjectType: ObjectTypes = .fixedWheelRearDrive
    var dimensionValueToEdit: PartTag = .length
    var partDataSharedDic = DictionaryService.shared.partDataSharedDic
    var choiceOfEditForSide: SidesAffected = BilateralPartWithOneValueToChangeService.shared.choiceOfEditForSide
    var scopeOfEditForSide: SidesAffected = BilateralPartWithOneValueToChangeService.shared.scopeOfEditForSide
    private var cancellables: Set<AnyCancellable> = []
    @Published var objectChainLabelsDefaultDic: ObjectChainLabelDictionary = [:]
    
    init() {
       
        self.userEditedSharedDics = DictionaryService.shared.userEditedSharedDics

        objectImageData =
            ObjectImageData(.fixedWheelRearDrive, nil)
 
        objectPickModel =
            ObjectPickModel(
            currentObjectName: currentObjectType.rawValue,
            userEditedDic: nil,
            defaultDictionaries: defaultMinMaxDimensionDic,
            objectImageData: ObjectImageData(.fixedWheelRearDrive, nil))

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
        
        DictionaryService.shared.$dimensionValueToEdit
            .sink { [weak self] newData in
                self?.dimensionValueToEdit = newData
            }
            .store(in: &self.cancellables)
        
        DictionaryService.shared.$partDataSharedDic
            .sink { [weak self] newData in
                self?.partDataSharedDic = newData
            }
            .store(in: &self.cancellables)
        
        BilateralPartWithOneValueToChangeService.shared.$scopeOfEditForSide
            .sink { [weak self] newData in
                self?.scopeOfEditForSide = newData
            }
            .store(in: &self.cancellables)
        
        BilateralPartWithOneValueToChangeService.shared.$choiceOfEditForSide
            .sink { [weak self] newData in
                self?.choiceOfEditForSide = newData
            }
            .store(in: &self.cancellables)
    }
}


//MARK: RESET/MODIFY
extension ObjectPickViewModel {
    
    func resetObjectByCreatingFromName() {
        //DIMENSIONCHANGE
    
        DictionaryService.shared.dimensionUserEditedDicReseter()
        
        //ANGLECHANGE
        
        DictionaryService.shared.angleUserEditedDicReseter()
        
        modifyObjectByCreatingFromName()
        //pickNewObjectByCreatingFromName()
    }
    
    
    func modifyObjectByCreatingFromName(){
        
        objectImageData =
            ObjectImageData(currentObjectType, userEditedSharedDics)
        
       objectChainLabelsDefaultDic = objectImageData.objectChainLabelsDefaultDic//update for new object

        createNewPickModel()
    }
    
    
    func pickNewObjectByCreatingFromName(){
        objectImageData =
            ObjectImageData(currentObjectType, userEditedSharedDics)
        
        createNewPickModel()
    }
    
    
    func createNewPickModel() {
        DictionaryService.shared.partDataSharedDicModifier(objectImageData.partDataDic)
        
        objectPickModel =
            ObjectPickModel(
                currentObjectName: currentObjectType.rawValue,
                userEditedDic: userEditedSharedDics,
                defaultDictionaries: defaultMinMaxDimensionDic,
                objectImageData: objectImageData)
        setCurrentObjectFrameSize()
    }
}



//MARK: GET
extension ObjectPickViewModel {
    
    func getInitialSliderValue(
        _ part: Part,
        _ editableProperty: PartTag) -> Double {
    
        var value: Double? = nil
        if let partData = partDataSharedDic[part] {//parts edited out do not exist
            let idForLeftOrRight = choiceOfEditForSide == .right ? PartTag.id1: PartTag.id0
        
            let id =  partData.id.one ?? idForLeftOrRight//two sources for id
            
            switch editableProperty {
            case .length, .width:
                let dimension = partData.dimension.returnValue(id)
                value = editableProperty == .length ?
                (dimension.length): (dimension.width)
                
            case .xOrigin, .yOrigin:
                let origin = partData.childOrigin.returnValue(id)
                print("get \(origin)")
                print(idForLeftOrRight)
                print("")
                value = editableProperty == .xOrigin ?
                    origin.x: origin.y
                
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
    
    
    func getSidesPresentGivenUserEdit(_ associatedPart: Part) -> [SidesAffected] {
        //sometimes partChain are represented by part other than their chainLabel
        let associatedPartDic: [Part: Part] = [
            .footSupport: .footSupportHangerLink]
        
        let part = associatedPartDic[associatedPart] ?? associatedPart
        print (part.rawValue)
        let oneOrTwoId = userEditedSharedDics.partIdsUserEditedDic[part] ?? OneOrTwoId(currentObjectType, part).forPart
        

        guard let chainLabels = userEditedSharedDics.objectChainLabelsUserEditDic[currentObjectType] ?? objectImageData.objectChainLabelsDefaultDic[currentObjectType] else {
            fatalError()
        }
        
        var sidesPresent: [SidesAffected] = []
        //the part may be removed from both sides by user edit
        if chainLabels.contains(part) {
            sidesPresent = oneOrTwoId.mapOneOrTwoToSide()
        } else {
            sidesPresent = [.none]
        }

        return sidesPresent
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

    var partName: String {
        let parts: [Parts] = [Part.objectOrigin, PartTag.id0, PartTag.stringLink, part, PartTag.id0, PartTag.stringLink, Part.sitOn, PartTag.id0]
       return
        CreateNameFromParts(parts ).name    }
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
        _ propertyToBeEdited: PartTag) -> (min: Double, max: Double) {
    
            var minMaxValue =
                (min: 0.0, max: 0.0)
            
           
            switch propertyToBeEdited {
            case .length, .width:
                let values =
                    defaultMinMaxDimensionDic.getDefault(
                        part,
                        currentObjectType)
                minMaxValue = (min: values.min.length,
                               max: values.max.length)
                
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
    ->PositionDictionary{
        objectPickModel.objectImageData.postTiltObjectToOneCornerPerKeyDic
    }
    
    
    func getPreTiltFourCornerPerKeyDic() -> CornerDictionary {
        objectPickModel.objectImageData.preTiltObjectToPartFourCornerPerKeyDic
    }
    
    
    func getPostTiltFourCornerPerKeyDic() -> CornerDictionary {
        objectPickModel.objectImageData.postTiltObjectToPartFourCornerPerKeyDic
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
    

    func getPartName (_ id: PartTag, _ part: Part) -> String {
        var name: String {
            let parts: [Parts] =
            [Part.objectOrigin, PartTag.id0, PartTag.stringLink, part , id, PartTag.stringLink, Part.sitOn, PartTag.id0]
           return
            CreateNameFromParts(parts ).name    }
        return name
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
      GetUniqueNames(  getPostTiltOneCornerPerKeyDic()).forPart
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
                        objectPickModel.objectImageData.dimensionDic)
                    }
        return list
    }
    
    
    func getMaximumDimensionOfObject (
    _ dictionary: PositionDictionary)
        -> Double {
        objectImageData.maximumDimension
    }
    

    func getObjectDimension (
        _ dictionary: PositionDictionary)
        -> Dimension {
            objectImageData.dimension
    }
}


//MARK: SET
extension ObjectPickViewModel {
    
    func setCurrentObjectFrameSize() {
        objectPickModel.currentObjectFrameSize = getScreenFrameSize()
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
    
    //MARK: DEVELOPMENT scale = 1
    ///objects larger than screen size behaviour not known
    func getObjectDictionaryForScreen ()
        -> CornerDictionary {

        let originOffset = getOriginOffsetWhenAllPositionValueArePositive()
        let objectDimension = getObjectDimensions()
        let maximumObjectDimension = getMaximumOfObject(objectDimension)
        let scale = Screen.smallestDimension / maximumObjectDimension
        let dictionary =
            makeAllPositionsPositive(
                objectPickModel.objectImageData
                    .postTiltObjectToPartFourCornerPerKeyDic,
                scale,
                originOffset
            )
            
            
//            DictionaryInArrayOut().getNameValue(currentDic
//            ).forEach{print($0)}
        
        return dictionary
            
            
            func getObjectDimensions() -> Dimension{
                let minThenMax =
                    getMinThenMax()
                return
                    (width: minThenMax[1].x - minThenMax[0].x,length: minThenMax[1].y - minThenMax[0].y )
            }
            
            
            func getMaximumOfObject(_ objectDimensions: Dimension)
                -> Double {
                    [objectDimensions.length, objectDimensions.width].max() ?? objectDimensions.length
            }
            
            
            func makeAllPositionsPositive(
                _ actualSize: CornerDictionary,
                _ scale: Double,
                _ offset: PositionAsIosAxes)
            -> CornerDictionary {
                let scaleFactor = scale/scale
                var postTiltObjectToPartFourCornerAllPositivePerKeyDic: CornerDictionary = [:]
                for item in actualSize {
                    var positivePositions: [PositionAsIosAxes] = []
                    for position in item.value {
                        positivePositions.append(
                        (x: (position.x + offset.x) * scaleFactor,
                         y: (position.y + offset.y) * scaleFactor,
                         z: (position.z * scaleFactor) )  )
                    }
                    postTiltObjectToPartFourCornerAllPositivePerKeyDic[item.key] = positivePositions
                }
                return postTiltObjectToPartFourCornerAllPositivePerKeyDic
            }
    }
    
    
    func getMinThenMax() -> [PositionAsIosAxes] {

        CreateIosPosition
           .minMaxPosition(
               objectPickModel.objectImageData
                   .postTiltObjectToOneCornerPerKeyDic
               )
    }
    
    
    func getOriginOffsetWhenAllPositionValueArePositive() -> PositionAsIosAxes{
        let minThenMax = getMinThenMax()
        return
            CreateIosPosition.negative(minThenMax[0])
    }

    
    func getOffsetToKeepObjectOriginStaticInLengthOnScreen() -> Double {
        let halfFrameHeight = getScreenFrameSize().length/2
        
        // objects are created with origin at 0,0
        // setting all part corner position value >= 0
        // determines the most negative corner position is translated to 0,0
        // so that translation is the transformed origin position
        let offSetOfOriginFromFrameTop = getOriginOffsetWhenAllPositionValueArePositive().y
        
        return halfFrameHeight - offSetOfOriginFromFrameTop
    }

    
    func getScreenFrameSize ()
        -> Dimension{
            
        let currentDic =  objectPickModel.objectImageData.postTiltObjectToPartFourCornerPerKeyDic
        let objectInitialDimension =
            getObjectDimension( ConvertFourCornerPerKeyToOne(
                fourCornerPerElement: currentDic).oneCornerPerKey)
            
        let objectDimensionWithLengthIncrease =
            (
            width: objectInitialDimension.width,length: objectInitialDimension.length)

        var frameSize: Dimension =
            (width: Screen.smallestDimension,
            length: Screen.smallestDimension
             )

        if objectDimensionWithLengthIncrease.length < objectDimensionWithLengthIncrease.width {
            frameSize =
            (width: Screen.smallestDimension,
            length: objectDimensionWithLengthIncrease.length
             )
        }
    
        if objectDimensionWithLengthIncrease.length > objectDimensionWithLengthIncrease.width {
            frameSize = (
                        width: objectDimensionWithLengthIncrease.width,
                        length: Screen.smallestDimension
                                 )
        }
            frameSize = objectDimensionWithLengthIncrease
           
        return frameSize
    }
    
}


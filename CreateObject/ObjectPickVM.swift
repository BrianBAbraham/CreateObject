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
    var defaultDictionaries: DefaultDictionaries
    
    var objectImageData: ObjectImageData


    init(
        currentObjectName: String,
        userEditedDic: UserEditedDictionaries?,
        defaultDictionaries: DefaultDictionaries,
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
    var userEditedDics: UserEditedDictionaries
    let defaultDics: DefaultDictionaries
    var currentObjectType: ObjectTypes = .fixedWheelRearDrive
    var dimensionDic: Part3DimensionDictionary
    var dimensionValueToEdit: PartTag = .length
    private var cancellables: Set<AnyCancellable> = []
    


    @Published var objectChainLabelsDefaultDic: ObjectChainLabelDictionary = [:]
    
    init() {
        self.defaultDics = DefaultDictionaries.shared
        self.userEditedDics = DataService.shared.userEditedSharedDic
        self.dimensionDic = DataService.shared.dimensionSharedDic
 
        objectImageData =
            ObjectImageData(.fixedWheelRearDrive, nil)
 
        objectPickModel =
            ObjectPickModel(
            currentObjectName: currentObjectType.rawValue,
            userEditedDic: nil,
            defaultDictionaries: defaultDics,
            objectImageData: ObjectImageData(.fixedWheelRearDrive, nil))

        dimensionDic = objectImageData.dimensionDic

        DataService.shared.$currentObjectType
            .sink { [weak self] newData in
                self?.currentObjectType = newData
            }
            .store(in: &self.cancellables)
                
        DataService.shared.$dimensionSharedDic
            .sink { [weak self] newData in
                self?.dimensionDic = newData
            }
            .store(in: &self.cancellables)

        DataService.shared.$userEditedSharedDic
            .sink { [weak self] newData in
                self?.userEditedDics = newData
            }
            .store(in: &self.cancellables)
        
        DataService.shared.$dimensionValueToEdit
            .sink { [weak self] newData in
                self?.dimensionValueToEdit = newData
            }
            .store(in: &self.cancellables)
    }
}


//MARK: RESET/MODIFY
extension ObjectPickViewModel {
    
    func resetObjectByCreatingFromName() {
        userEditedDics.dimensionUserEditedDic = [:]
        userEditedDics.angleUserEditedDic = [:]
        //modifyObjectByCreatingFromName()
        pickNewObjectByCreatingFromName()
    }
    
    
    func modifyObjectByCreatingFromName(){
        objectImageData =
            ObjectImageData(currentObjectType, userEditedDics)
        
        DataService.shared.objectChainLabelsDefaultDic = objectImageData.objectChainLabelsDefaultDic//update for new object
        
//        print("creating start")
//        print(objectImageData.objectChainLabelsDefaultDic)
//        print("creating end")
        
        createNewPickModel()
    }
    
    
    func pickNewObjectByCreatingFromName(){
        objectImageData =
            ObjectImageData(currentObjectType, userEditedDics)
        
        createNewPickModel()
    }
    
    
    func createNewPickModel() {
        objectPickModel =
            ObjectPickModel(
                currentObjectName: currentObjectType.rawValue,
                userEditedDic: userEditedDics,
                defaultDictionaries: defaultDics,
                objectImageData: objectImageData)
        setCurrentObjectFrameSize()
    }
}



//MARK: GET
extension ObjectPickViewModel {
    
    func getInitialSliderValue(_ id: PartTag, _ part: Part, _ dimensionValueToEdit: PartTag) -> Double {
//        print("initial")
//       print(dimensionValueToEdit)
//        print("")
        let name = getPartName(id, part)
        let dimension = objectImageData.dimensionDic[name] ?? ZeroValue.dimension3d

        return self.dimensionValueToEdit == .length ?
            (dimension.length): (dimension.width)
    }
    
    
    func getSidesPresentGivenUserEdit(_ part: Part) -> [Side] {
        let oneOrTwoId = userEditedDics.partIdsUserEditedDic[part] ?? OneOrTwoId(currentObjectType, part).forPart
        guard let chainLabels = userEditedDics.objectChainLabelsUserEditDic[currentObjectType] ?? objectImageData.objectChainLabelsDefaultDic[currentObjectType] else {
            fatalError()
        }
        if chainLabels.contains(part) {
            return oneOrTwoId.mapOneOrTwoToSide()
        } else {
            return [.none]
        }
    }
    
    
    func getAllOriginNames()-> String{
        DictionaryInArrayOut().getAllOriginNamesAsString(getPostTiltOneCornerPerKeyDic())
    }
    
    
    func getAllOriginValues()-> String{
        DictionaryInArrayOut().getAllOriginValuesAsString(getPostTiltOneCornerPerKeyDic())
    }
    
    
    func getAngleDic()
    -> AnglesDictionary {
        objectPickModel.angleUserEditedDic
    }
    
    
    func getAngleMinMaxDic(_ name: String)
    -> AngleMinMax {
        objectPickModel.angleMinMaxDic[name] ?? ZeroValue.angleMinMax
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
    
    func getDimensionMinMax(_ part: Part) -> (min: Double, max: Double) {
    
        let minMaxDimension = defaultDics.getDefault(part, currentObjectType)
        return (min: minMaxDimension.min.length, max: minMaxDimension.max.length)
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
        DataService.shared.currentObjectType = objectType
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

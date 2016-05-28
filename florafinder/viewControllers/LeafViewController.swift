//
//  LeafViewController.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 20/01/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

struct SearchState
{
    var selectedLeafEdge: LeafEdgeType?
    var selectedLeafShape: LeafShapeEnum?
    var selectedLeafDimension: LeafDimension?
    var selectedLeafForm: LeafFormationType?
    var selectedFlowerColor: FlowerColorType?
    var selectedFruitColor: FruitColorType?
}

class LeafViewController: UITableViewController, SelectorDelegate, MeasureLeafDelegate,  ImageSelectionViewDelegate
{
    //MARK: - Constants
    private let UNIT = "cm" // TODO - should be a configuration setting
    
    private let DEFAULT_CELL_MARGIN: CGFloat = 15
    private let DEFAULT_CELL_HEIGHT: CGFloat = 40
    
    let NO_SELECTION_INDICATOR = ""
    
    let TAG_SELECT_TEXTURE = "selectTexture"
    let LOOKUP_TITLE_TEXTURE = "Texture"
    
    let TAG_SELECT_LEAFCOLOR = "selectLeafColor"
    let LOOKUP_TITLE_LEAFCOLOR = "Leaf Color"
    
    // Section indexes
    let SECTION_LEAFSHAPE = 0
    let ROW_LEAFSHAPE = 1
    
    let SECTION_LEAFMEASURE = 1
    let ROW_LEAFMEASURE = 0

    let SECTION_LEAFEDGE = 2
    let ROW_LEAFEDGE = 1
    
    let SECTION_LEAFFORM = 3
    let ROW_LEAFFORM = 1

    let SECTION_FLOWER = 4
    let ROW_FLOWER_COLOR = 1
    
    let SECTION_FRUIT = 5
    let ROW_FRUIT_COLOR = 1

    let SECTION_LEAFSURFACE = 6
    let ROW_LEAFTEXTURE = 0
    
    let SECTION_BARK = 7
    let ROW_BARKTEXTURE = 0
    
    // MARK: - Outlets
    
    @IBOutlet weak var fruitCaretCell: TableViewCellWithCaret!
    @IBOutlet weak var flowerCaretCell: TableViewCellWithCaret!
    @IBOutlet weak var formCaretCell: TableViewCellWithCaret!
    @IBOutlet weak var edgeCaretCell: TableViewCellWithCaret!
    @IBOutlet weak var shapeCaretCell: TableViewCellWithCaret!
    
    // State for the TableViewCellWithCaret cells
    var caretCellStateUp: [Int: Bool]!
    var caretCellLabel: [Int: String]!
    var caretCellImage: [Int: UIImage?]!
    
    @IBOutlet weak var shapeImageSelectionView: LeafShapeImageSelectionView!
    @IBOutlet weak var fruitImageSelectionView: FruitImageSelectionView!
    @IBOutlet weak var flowerImageSelectionView: FlowerImageSelectionView!
    @IBOutlet weak var leafEdgeImageSelectionView: LeafEdgeImageSelectionView!
    @IBOutlet weak var leafformationImageSelectionView: FormationImageSelectionView!
    
    @IBOutlet weak var textureLabel: UILabel!
    @IBOutlet weak var leafMeasurement: UILabel!
    
    //MARK: - Initialisation and set up
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.registerNib(UINib(nibName: "TableViewCellWithCaret", bundle: nil), forCellReuseIdentifier: "caretCell")
        
        // Must set these defaults here, otherwise bad things will happen
        caretCellLabel = [SECTION_FRUIT: "Fruit",
                       SECTION_FLOWER: "Flower",
                       SECTION_LEAFEDGE: "Edge",
                       SECTION_LEAFFORM: "Form",
                       SECTION_LEAFSHAPE: "Shape"]
        
        shapeImageSelectionView.delegate = self
        leafformationImageSelectionView.delegate = self
        leafEdgeImageSelectionView.delegate = self
        flowerImageSelectionView.delegate = self
        fruitImageSelectionView.delegate = self
        
        //print("set shapeImageSelectionView.selectedItem")
        //shapeImageSelectionView.selectedItem = state?.selectedLeafShape
        
        reset()
    }

    func prepareForView(state: SearchState)
    {
        self.state = state
    }
    
    // MARK: - Properties
    
    var leafWidth: CGFloat = 0
    var leafLength: CGFloat = 0
    var state: SearchState?
    var selectedTextureType: LeafTextureType?
    
    //MARK: - Services
    
    //TODO: - these should be injected in
    
    var leafEdgeTypeService: LeafEdgeTypeProtocol
    {
        return ServiceFactory.shareInstance.leafEdgeTypeService
    }
    
    var leafTextureTypeService: LeafTextureTypeProtocol
    {
        return ServiceFactory.shareInstance.leafTextureTypeService
    }
    
    var leafFormationTypeService: LeafFormationTypeProtocol
    {
        return ServiceFactory.shareInstance.leafFormationTypeService
    }
    
    var fruitColorTypeService: FruitColorTypeProtocol
    {
        return ServiceFactory.shareInstance.fruitColorTypeService
    }
    
    var leafColorTypeService: LeafColorTypeProtocol
    {
        return ServiceFactory.shareInstance.leafColorTypeService
    }
    
    var flowerColorTypeService: FlowerColorTypeProtocol
    {
        return ServiceFactory.shareInstance.flowerColorTypeService
    }
    
    var floraService: FloraServiceProtocol
    {
        return ServiceFactory.shareInstance.floraService
    }
    
    var leafDimensionService: LeafDimensionProtocol
    {
        return ServiceFactory.shareInstance.leafDimensionService
    }
    
    //MARK: - Selectors
    
    func selector(selector: SelectorViewController, itemSelected:SelectorItem)
    {
        if (selector.tag == TAG_SELECT_TEXTURE)
        {
            textureLabel.text = itemSelected.title
            selectedTextureType = itemSelected.object as? LeafTextureType
        }
        performSearch()
    }

    private var leafTextureSelector: SelectorViewController
        {
            let dataSource = leafTextureTypeService.getAll()
            
            let selector = SelectorViewController(dataSource: dataSource, allowNilSelection: true, selectedIndex: 0, title: LOOKUP_TITLE_TEXTURE, delegate: self, tag: TAG_SELECT_TEXTURE, selectorItemBlock: { textureType in
                let item = SelectorItem(title: textureType.name, subTitle: nil, object: textureType)
                
                return item
            })
        
            selector.hasView = true
            
            return selector
    }
    

    //MARK: - Search
    
    var searchTerms: [SearchTerm]
    {
        var result = [SearchTerm]()
        
        if let term = leafEdgeSeachTerm { result.append(term) }
        if let term = leafDimensionSearchTerm { result.append(term) }
        if let term = leafTextureSearchTerm { result.append(term) }
        if let term = leafFormationSearchTerm { result.append(term) }
        if let term = fruitColorSearchTerm { result.append(term) }
        if let term = flowerColorSearchTerm { result.append(term) }
        if let term = leafShapeSearchTerm { result.append(term) }
        
        return result
    }
    
    /**
     Collects all the search filter from the view
    */
    func performSearch()
    {
        // Find the parent view controller - this is where the search results will be displayed
        if let searchController = self.parentViewController as? SearchViewController
        {
            if let results = floraService.performSearch(searchTerms)
            {
                searchController.searchResults = results
            }
        }        
    }
    
    var leafShapeSearchTerm: SearchTermLeafShape?
    {
        var term:SearchTermLeafShape?
    
        if let value = shapeImageSelectionView.selectedItem
        {
            term = SearchTermLeafShape(shape: value)
            term?.strict = true
        }
        return term
    }
    
    var leafEdgeSeachTerm: SearchTermByLookupType?
    {
        var term:SearchTermByLookupType?
        
        if let value = leafEdgeImageSelectionView.selectedItem
        {
            term = SearchTermByLeafEdge(leafEdgeType: value)
        }
    
        return term
    }

    var leafDimensionSearchTerm: SearchTermByDimension?
    {
        var term:SearchTermByDimension?
        
        if (leafWidth != 0 && leafLength != 0)
        {
            term = SearchTermByDimension(size:Measurement(width: Float(leafWidth), length: Float(leafLength)), leafDimensionService: self.leafDimensionService)
        }
        return term
    }
    
    var leafFormationSearchTerm: SearchTermByLookupType?
    {
        var term:SearchTermByLookupType?
        
        if let value =  leafformationImageSelectionView.selectedItem
        {
            term = SearchTermByLeafFormation(leafFormationType: value)
        }
        
        return term
    }

    var fruitColorSearchTerm: SearchTermByLookupType?
    {
        var term:SearchTermByLookupType?
        
        if let value = fruitImageSelectionView.selectedItem
        {
            term = SearchTermByFruitColor(fruitColorType: value)
        }
        return term
    }

    var flowerColorSearchTerm: SearchTermByLookupType?
    {
        var term:SearchTermByLookupType?
        
        if let value = flowerImageSelectionView.selectedItem
        {
            term = SearchTermByFlowerColor(flowerColorType: value)
        }
        return term
    }
    
    var leafTextureSearchTerm: SearchTermByLookupType?
    {
        var term:SearchTermByLookupType?
        
        if let value = selectedTextureType
        {
            term = SearchTermByLeafTexture(leafTextureType: value)
        }
        return term
    }

    //MARK: - Action handlers
    
//    @IBAction func handleSwitch(sender: UISwitch)
//    {
//        if (!leafEdgeSwitch.on)
//        {
//            leafEdgeImageSelectionView.clearSelection()
//        }
//        if (!leafFormSwitch.on)
//        {
//            leafformationImageSelectionView.clearSelection()
//        }
//        
//        if (!flowerSwitch.on)
//        {
//            flowerImageSelectionView.clearSelection()
//        }
//
//        if (!fruitSwitch.on)
//        {
//            fruitImageSelectionView.clearSelection()
//        }
//
////        if (!shapeSwitch.on)
////        {
////            shapeImageSelectionView.clearSelection()
////        }
//
//        resetTableCellMargins()
//        performSearch()
//    }
    
    //MARK: - Public functions
    
    /**
    Reset the search criteria. This will result in no matches being returned.
    */
    func reset()
    {

//        if let state = state?.selectedLeafShape
//        {
//            shapeImageSelectionView.selectedItem = state
//        }
//        else
//        {
//            shapeImageSelectionView.clearSelection()
//        }
//
        
        // deselect all the options
        shapeImageSelectionView.clearSelection()
        leafEdgeImageSelectionView.clearSelection()
        flowerImageSelectionView.clearSelection()
        fruitImageSelectionView.clearSelection()
        leafformationImageSelectionView.clearSelection()
        
        // mark all sections as collapsed
        caretCellStateUp = [SECTION_FRUIT: true,
                          SECTION_FLOWER: true,
                          SECTION_LEAFEDGE: true,
                          SECTION_LEAFFORM: true,
                          SECTION_LEAFSHAPE: true]
        
        caretCellImage = [SECTION_FRUIT: nil,
                        SECTION_FLOWER: nil,
                        SECTION_LEAFEDGE: nil,
                        SECTION_LEAFFORM: nil,
                        SECTION_LEAFSHAPE: nil]
        
        // Sort out the margins on cells, since some cells are dynamically hidden and screw things up
        self.tableView.beginUpdates()
        //resetTableCellMargins()
        self.tableView.endUpdates()
        
        textureLabel.text = NO_SELECTION_INDICATOR
        selectedTextureType = nil
        
        leafMeasurement.text = NO_SELECTION_INDICATOR
        textureLabel.text = NO_SELECTION_INDICATOR
        self.leafWidth = 0
        self.leafLength = 0
        
        // Re-do the search which will clear results
        performSearch()
    }

    //MARK: - Private functions
    
    private func transformLeafDimension(linearValue: Int) -> String
    {
        let steps = ["<1","1","1.5","2","2.5","3","4","5","6","7","8","9","10","15","20","25","40",">50"]
        return steps[linearValue]
    }
    
    private func resetTableCellMargins()
    {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    //MARK: - MeasureLeafDelegate
    func measureNotDefined() {
        leafMeasurement.text = "-"
        self.leafWidth = 0
        self.leafLength = 0
        performSearch()
    }
    
    func measureCompleted(width: CGFloat, length: CGFloat) {
        self.leafWidth = width
        self.leafLength = length
        leafMeasurement.text = String(format: "%.1f x %.1f cm", width, length)
        performSearch()
    }
    
    //MARK: - UITableView

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        
        if ([SECTION_LEAFSHAPE, SECTION_LEAFEDGE, SECTION_LEAFFORM, SECTION_FRUIT, SECTION_FLOWER].contains(indexPath.section) && indexPath.row == 0)
        {
            if let caretCell = tableView.dequeueReusableCellWithIdentifier("caretCell", forIndexPath: indexPath) as? TableViewCellWithCaret
            {
                caretCell.separatorLeftMargin(caretCellStateUp![indexPath.section]! ? 0 : DEFAULT_CELL_MARGIN)
                caretCell.label.text = caretCellLabel![indexPath.section]
                caretCell.setState(!caretCellStateUp![indexPath.section]!)
                caretCell.selectedImageView.image = caretCellImage![indexPath.section]!
                cell = caretCell
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        // Hide these sections titles for now - not using yet
        if (section == SECTION_BARK)
        {
            return ""
        }
        else
        {
            return super.tableView(tableView, titleForHeaderInSection: section)
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0.1
//        // Hide these sections for now - not using yet
//        if ([SECTION_BARK, SECTION_LEAFSHAPE].contains(section))
//        {
//            return 0.1
//        }
//        else
//        {
//            return super.tableView(tableView, heightForHeaderInSection: section)
//        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Hide these sections for now - not using yet
        if (section == SECTION_BARK)
        {
            return 0
        }
        else
        {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    
        var currentHeight = super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        let section = indexPath.section
        let row = indexPath.row
        
        if let state = caretCellStateUp![section]
        {
            if section == SECTION_LEAFSURFACE
            {
                return 0
            }
            else if section == SECTION_LEAFEDGE && row == ROW_LEAFEDGE
            {
                if (state) { leafEdgeImageSelectionView.clearSelection() }
                currentHeight = state ? 0 : leafEdgeImageSelectionView.contentSize.height
            }
            else if section == SECTION_LEAFFORM && row == ROW_LEAFFORM
            {
                if (state) { leafformationImageSelectionView.clearSelection() }
                currentHeight = state ? 0 : leafformationImageSelectionView.contentSize.height
            }
            else if section == SECTION_LEAFSHAPE && row == ROW_LEAFSHAPE
            {
                if (state) { shapeImageSelectionView.clearSelection() }
                currentHeight = state ? 0 : shapeImageSelectionView.contentSize.height
            }
            else if section == SECTION_FLOWER && row == ROW_FLOWER_COLOR
            {
                if (state) { flowerImageSelectionView.clearSelection() }
                currentHeight = state ? 0 : flowerImageSelectionView.contentSize.height
            }
            else if section == SECTION_FRUIT && row == ROW_FRUIT_COLOR
            {
                if (state) { fruitImageSelectionView.clearSelection() }
                currentHeight = state ? 0 : fruitImageSelectionView.contentSize.height
            }
        }

        return currentHeight
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if (indexPath.section == SECTION_LEAFSURFACE && indexPath.row == ROW_LEAFTEXTURE)
        {
            let selector = self.leafTextureSelector
            if (selectedTextureType != nil)
            {
                selector.selectedIndex = leafTextureTypeService.getAll().indexOf(selectedTextureType!)! + 1
            }
            self.navigationController?.pushViewController(selector, animated: true)
        }
        else if (indexPath.section == SECTION_LEAFMEASURE && indexPath.row == ROW_LEAFMEASURE)
        {
            let width = (self.leafWidth != 0) ? self.leafWidth : 2.5
            let length = (self.leafLength != 0) ? self.leafLength : 3.9
            
            let controller = MeasureLeafViewController(widthCM: width, heightCM: length, delegate: self)
            controller.view.frame = UIScreen.mainScreen().bounds
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else if ([SECTION_LEAFEDGE, SECTION_LEAFFORM, SECTION_LEAFSHAPE, SECTION_FLOWER, SECTION_FRUIT].contains(indexPath.section) && indexPath.row == 0)
        {
            caretCellStateUp![indexPath.section]! = !caretCellStateUp![indexPath.section]!
            if let caretCell = self.tableView(tableView, cellForRowAtIndexPath: indexPath) as? TableViewCellWithCaret
            {
                caretCell.setState(!caretCellStateUp![indexPath.section]!)
                //resetTableCellMargins()
                
                // need to reload cell to show the new caret icon
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
                
                performSearch()
            }
        }
    }
    
    //MARK: ImageSelectionView
    
    func imageSelectionView(imageSelectionView: ImageSelectionView, didSelectItem item: ImageSelectionData?)
    {
//        
//        if let _ = imageSelectionView as? LeafEdgeImageSelectionView
//        {
//            caretCellImage[SECTION_LEAFEDGE] = item?.image
//            caretCellStateUp[SECTION_LEAFEDGE] = true
//            
//            //tableView.reloadData()
////            let range = NSMakeRange(SECTION_LEAFEDGE, SECTION_LEAFEDGE + 2)
////            let sections = NSIndexSet(indexesInRange: range)
////            tableView.beginUpdates()
////            tableView.reloadSections(sections, withRowAnimation: UITableViewRowAnimation.None)
////            tableView.endUpdates()
//            let caretCellIndex = NSIndexPath(forRow: 0, inSection: SECTION_LEAFEDGE)
//            let imageSelectionViewIndex = NSIndexPath(forRow: 1, inSection: SECTION_LEAFEDGE)
//            tableView.reloadRowsAtIndexPaths([caretCellIndex, imageSelectionViewIndex], withRowAnimation: UITableViewRowAnimation.None)
//            tableView.reloadData()
//        }

        performSearch()
    }
        
//    func collectionView(collectionView: UICollectionView, didSelectFlower flowerColor: FlowerColorType?) {
//        
//        performSearch()
//    }
//    
//    func collectionView(collectionView: UICollectionView, didSelectFruit fruitColor: FruitColorType?) {
//        performSearch()
//    }
}
//
//  LeafViewController.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 20/01/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit


class LeafViewController: UITableViewController, SelectorDelegate, MeasureLeafDelegate,  ImageSelectionViewDelegate
{
    //MARK: - Constants
    private let UNIT = "cm" // TODO - should be a configuration setting
//    private let IMAGE_SELECTOR_CELL_HEIGHT: CGFloat = 130
//    private let IMAGE_SELECTOR_CELL_HEIGHT_NO_LABELS: CGFloat = 101
    
    private let DEFAULT_CELL_MARGIN: CGFloat = 15
    private let DEFAULT_CELL_HEIGHT: CGFloat = 40
    
    let NO_SELECTION_INDICATOR = ""
    
    let TAG_SELECT_TEXTURE = "selectTexture"
    let LOOKUP_TITLE_TEXTURE = "Texture"
    
    let TAG_SELECT_LEAFCOLOR = "selectLeafColor"
    let LOOKUP_TITLE_LEAFCOLOR = "Leaf Color"

    let TAG_SELECT_FRUITCOLOR = "selectFruitColor"
    let LOOKUP_TITLE_FRUITCOLOR = "Fruit Color"
    
    let TAG_SELECT_FLOWERCOLOR = "selectFlowerColor"
    let LOOKUP_TITLE_FLOWERCOLOR = "Flower Color"
    
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
    
    let EDGE_SELECTOR = "edge"
    let FORM_SELECTOR = "form"
    
//    let FLOWER_COLLECTION_VIEW = 0
//    let FRUIT_COLLECTION_VIEW = 1
    
    // MARK: - Outlets
    
    
    @IBOutlet weak var shapeSwitch: UISwitch!
    @IBOutlet weak var shapeSwitchCell: UITableViewCell!
    @IBOutlet weak var shapeImageSelectionView: LeafShapeImageSelectionView!
    
    
    @IBOutlet weak var fruitSwitch: UISwitch!
    @IBOutlet weak var fruitSwitchCell: UITableViewCell!
    @IBOutlet weak var fruitImageSelectionView: FruitImageSelectionView!
    
    @IBOutlet weak var flowerSwitch: UISwitch!
    @IBOutlet weak var flowerSwitchCell: UITableViewCell!
    @IBOutlet weak var flowerImageSelectionView: FlowerImageSelectionView!
    
    @IBOutlet weak var leafEdgeSwitch: UISwitch!
    @IBOutlet weak var leafEdgeSwitchCell: UITableViewCell!
    @IBOutlet weak var leafEdgeImageSelectionView: LeafEdgeImageSelectionView!
    
    @IBOutlet weak var leafFormSwitch: UISwitch!
    @IBOutlet weak var leafFormSwitchCell: UITableViewCell!
    @IBOutlet weak var leafformationImageSelectionView: FormationImageSelectionView!
    
    @IBOutlet weak var textureLabel: UILabel!
    @IBOutlet weak var leafMeasurement: UILabel!
    
    // MARK: - Properties
    
    var leafWidth: CGFloat = 0
    var leafLength: CGFloat = 0
    
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
    

    //MARK: - UIViewController
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        reset()
 
        shapeImageSelectionView.delegate = self
        leafformationImageSelectionView.delegate = self
        leafEdgeImageSelectionView.delegate = self
        flowerImageSelectionView.delegate = self
        fruitImageSelectionView.delegate = self
    }

    //MARK: - Search
    
    /**
     Collects all the search filter from the view
    */
    func performSearch()
    {
        // Find the parent view controller
        if let searchController = self.parentViewController as? SearchViewController
        {
            if let results = floraService.performSearch([leafEdgeSeachTerm, leafDimensionSearchTerm, leafTextureSearchTerm, leafFormationSearchTerm, fruitColorSearchTerm, flowerColorSearchTerm, leafShapeSearchTerm], strict: false)
            {
                searchController.searchResults = results
            }
        }        
    }
    
    var leafShapeSearchTerm: SearchTermByDimension?
    {
        var term:SearchTermByDimension?
        
        if (shapeSwitch.on)
        {
            if let value = shapeImageSelectionView.selectedItem
            {
                term = SearchTermByDimension(shape: value)
            }
        }
        return term
    }
    
    var leafEdgeSeachTerm: SearchTermByLookupType?
    {
        var term:SearchTermByLookupType?
        
        if (leafEdgeSwitch.on)
        {
            if let value = leafEdgeImageSelectionView.selectedItem
            {
                term = SearchTermByLeafEdge(leafEdgeType: value)
            }
        }
        return term
    }

    var leafDimensionSearchTerm: SearchTermByDimension?
    {
        var term:SearchTermByDimension?
        
        if (leafWidth != 0 && leafLength != 0)
        {
            term = SearchTermByDimension(size:Measurement(width: Float(leafWidth), length: Float(leafLength)), tolerance: 0.2)
            term?.leafDimensionService = leafDimensionService
        }
        return term
    }
    
    var leafFormationSearchTerm: SearchTermByLookupType?
    {
        var term:SearchTermByLookupType?
        
        if (leafFormSwitch.on)
        {
            if let value =  leafformationImageSelectionView.selectedItem
            {
                term = SearchTermByLeafFormation(leafFormationType: value)
            }
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
    
    @IBAction func handleSwitch(sender: UISwitch)
    {
        if (!leafEdgeSwitch.on)
        {
            leafEdgeImageSelectionView.clearSelection()
        }
        if (!leafFormSwitch.on)
        {
            leafformationImageSelectionView.clearSelection()
        }
        
        if (!flowerSwitch.on)
        {
            flowerImageSelectionView.clearSelection()
        }

        if (!fruitSwitch.on)
        {
            fruitImageSelectionView.clearSelection()
        }

        if (!shapeSwitch.on)
        {
            shapeImageSelectionView.clearSelection()
        }

        resetTableCellMargins()
        performSearch()
    }
    
    //MARK: - Public functions
    
    /**
    Reset the search criteria. This will result in no matches being returned.
    */
    func reset()
    {
        // reset all the underlying search items
        
        // close the optional sections
        leafEdgeSwitch.on = false
        leafFormSwitch.on = false
        fruitSwitch.on = false
        flowerSwitch.on = false
        shapeSwitch.on = false
        
        leafformationImageSelectionView.clearSelection()
        leafEdgeImageSelectionView.clearSelection()
        flowerImageSelectionView.clearSelection()
        fruitImageSelectionView.clearSelection()
        shapeImageSelectionView.clearSelection()
        
        // Sort out the margins on cells, since some cells are dynamically hidden and screw things up
        self.tableView.beginUpdates()
        resetTableCellMargins()
        self.tableView.endUpdates()
        
        textureLabel.text = NO_SELECTION_INDICATOR
        selectedTextureType = nil
        
//        fruitCollectionViewDelegate?.selectedFruitColorType = nil
//        flowerCollectionViewDelegate?.selectedFlowerColorType = nil
//        
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
        
        //leafSizeSwitchCell.separatorLeftMargin(leafSizeSwitch.on ? DEFAULT_CELL_MARGIN : 0)
        leafFormSwitchCell.separatorLeftMargin(leafFormSwitch.on ? DEFAULT_CELL_MARGIN : 0)
        leafEdgeSwitchCell.separatorLeftMargin(leafEdgeSwitch.on ? DEFAULT_CELL_MARGIN : 0)
        flowerSwitchCell.separatorLeftMargin(flowerSwitch.on ? DEFAULT_CELL_MARGIN : 0)
        fruitSwitchCell.separatorLeftMargin(fruitSwitch.on ? DEFAULT_CELL_MARGIN : 0)
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
        
        // Hide these sections for now - not using yet
        if (section == SECTION_BARK)
        {
            return 0.1
        }
        else
        {
            return super.tableView(tableView, heightForHeaderInSection: section)
        }
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
        
        if section == SECTION_LEAFSURFACE
        {
            return 0
        }
        else if section == SECTION_LEAFEDGE && row == ROW_LEAFEDGE
        {
            currentHeight = leafEdgeSwitch.on ? leafEdgeImageSelectionView.contentSize.height : 0
        }
        else if section == SECTION_LEAFFORM && row == ROW_LEAFFORM
        {
            currentHeight = leafFormSwitch.on ? leafformationImageSelectionView.contentSize.height : 0
        }
        else if section == SECTION_LEAFSHAPE && row == ROW_LEAFSHAPE
        {
            currentHeight = shapeSwitch.on ? shapeImageSelectionView.contentSize.height : 0
        }
        else if section == SECTION_FLOWER && row == ROW_FLOWER_COLOR
        {
            currentHeight = flowerSwitch.on ? flowerImageSelectionView.contentSize.height : 0
        }
        else if section == SECTION_FRUIT && row == ROW_FRUIT_COLOR
        {
            currentHeight = fruitSwitch.on ? fruitImageSelectionView.contentSize.height : 0
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
    }
    
    //MARK: ImageSelectionView
    
    func imageSelectionView(imageSelectionView: ImageSelectionView, didSelectItem: ImageSelectionData?)
    {
        performSearch()
    }
    
    func collectionView(collectionView: UICollectionView, didSelectFlower flowerColor: FlowerColorType?) {
        
        performSearch()
    }
    
    func collectionView(collectionView: UICollectionView, didSelectFruit fruitColor: FruitColorType?) {
        performSearch()
    }
}
'********** Copyright 2016 Roku Corp.  All Rights Reserved. **********

function init()
    m.sectionsMarkupList = m.top.findNode("SectionsMarkupList")
    m.keysMarkupList = m.top.findNode("KeysMarkupList")
	m.sectionsMarkupList.SetFocus(true)
	m.sectionsMarkupList.observeField("itemFocused", "onFocusChanged")
	m.sectionsMarkupList.observeField("itemSelected", "onSectionSelected")
	m.keysMarkupList.observeField("itemSelected", "onKeySelected")
	
	getAndSetData()
end function

function getAndSetData()
    m.sectionsData = fetchAllSectionsData()
    m.sectionsMarkupList.content = getContentFromSections(m.sectionsData)
end function

function getContentFromSections(sectionsData as object) as object
    print "getContentFromSections"
    data = CreateObject("roSGNode", "ContentNode")
    
     for each section in sectionsData
        print "getContentFromSections: section=";section
          dataItem = data.CreateChild("SimpleListItemData")
          dataItem.labelText = section
          dataItem.label2Text = ""
    end for
        
    return data
end function

function onFocusChanged() as void    
    print "onFocusChanged: Focus on item: " + stri(m.sectionsMarkupList.itemFocused)
    print "onFocusChanged: Focus on item: " + stri(m.sectionsMarkupList.itemUnfocused) + " lost"
    
    itemFocused = m.sectionsMarkupList.content.getChild(m.sectionsMarkupList.itemFocused)
    
    if itemFocused <> invalid and m.sectionsData <> invalid
       setKeysForSection(itemFocused.labelText)
    end if    
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
    handled = false
    if (m.sectionsMarkupList.hasFocus() = true) and (key = "right") and (press=true) and m.keysMarkupList.content <> invalid and m.keysMarkupList.content.getChildCount() > 0
        m.keysMarkupList.setFocus(true)
        m.sectionsMarkupList.setFocus(false)
        handled = true
    else if (m.keysMarkupList.hasFocus() = true) and (key = "left") and (press=true)
        m.keysMarkupList.setFocus(false)
        m.sectionsMarkupList.setFocus(true)
        handled = true
    endif
    return handled    
end function

function fetchAllSectionsData()
    print "fetchAllSectionsData"
     sectionsData = {}
     
     if m.registry = invalid
        m.registry = RegistryUtil()
     end if
     
     sections = m.registry.getSections()
    
     for each section in sections
        print "fetchAllSectionsData: section=";section
        sectionsData[section] = m.registry.readSection(section)
     end for
    
    return sectionsData
end function

function readKeysBySection(section as string, unFocus = false as boolean)
    m.sectionsData[section] = m.registry.readSection(section)
    m.keysMarkupList.content =  m.sectionsData[section]
    
    setKeysForSection(section, unFocus)
end function

function setKeysForSection(section as string, unFocus = false as boolean)
        data = CreateObject("roSGNode", "ContentNode")
        secValues = m.sectionsData[section]
        
        for each secValue in secValues
            'print "secValue=";secValue
            dataItem = data.CreateChild("SimpleListItemData")
            dataItem.labelText = secValue
            dataItem.label2Text = secValues[secValue]
            dataItem.section = section
        end for
        
        m.keysMarkupList.content = data
        
        if secValues.Count() = 0 and unFocus
            if (m.keysMarkupList.hasFocus() = true)
                m.keysMarkupList.setFocus(false)
                m.sectionsMarkupList.setFocus(true)
            end if
        end if
end function

function onKeySelected() as boolean
    print "onKeySelected"

    itemSelected = m.keysMarkupList.content.getChild(m.keysMarkupList.itemSelected)
    print "onKeySelected=labelText: ";itemSelected.labelText; ", section: ";itemSelected.section 
    
    if itemSelected <> invalid
         b = m.registry.delete(itemSelected.labelText, itemSelected.section)         
         print "onKeySelected=result=";b
         
         if b = true
            readKeysBySection(itemSelected.section, true)
            return true
         end if
    end if
    
    return false
end function 

function onSectionSelected() as boolean
    print "onSectionSelected"

    itemSelected = m.sectionsMarkupList.content.getChild(m.sectionsMarkupList.itemSelected)
    print "onSectionSelected=labelText: ";itemSelected.labelText 
    
    if itemSelected <> invalid
         b = m.registry.deleteSection(itemSelected.labelText)         
         print "onSectionSelected=result=";b
         
         if b = true
            m.sectionsMarkupList.content.removeChildIndex(m.sectionsMarkupList.itemSelected)
            return true
         end if
    end if
    
    return false
end function 

local MVXIVY_Utils = {}

function MVXIVY_Utils.addComboBoxItems(comboBox, items, defaultItem)
  for i, item in ipairs(items) do
    comboBox:addItem(item, i == defaultItem)
  end
end

function MVXIVY_Utils.useComboBoxFactory(comboBoxNamespace, localizeNamespace, UI)
  return function (options)
    local comboBox = UI:addComboBox(
      comboBoxNamespace .. options.name,
      getText(localizeNamespace .. options.label)
    )

    MVXIVY_Utils.addComboBoxItems(
      comboBox,
      options.items,
      options.defaultItem
    )

    if options.description then
       UI:addDescription(getText(localizeNamespace .. options.description))
    end

    return comboBox
  end
end

return MVXIVY_Utils
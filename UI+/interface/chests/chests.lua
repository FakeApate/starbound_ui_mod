require "/scripts/augments/item.lua"
-- Convert rarity to a number for easier comparison
local function rarityToNumber(rarity)
    local rarities = {
        ["Common"] = 0,
        ["Uncommon"] = 1,
        ["Rare"] = 2,
        ["Legendary"] = 3,
        ["Essential"] = 4
    }

    local res = rarities[rarity]
    if res then
        return res
    end
    return -1
end

-- Comparison function for sorting items
local function comparer(a, b)
    if a.rarity ~= b.rarity then
        return a.rarity > b.rarity
    elseif a.name ~= b.name then
        return a.name < b.name
    elseif a.count ~= b.count then
        return a.count > b.count
    end
    return false
end

-- Function to sort and merge items
function sortC(buttonName)
    local callerID = pane.containerEntityId()
    local itemBag = world.containerItems(callerID)
    local bag = {}

    -- Populate bag with items and their properties
    for k, v in pairs(itemBag) do
        local item = Item.new(v)
        table.insert(bag, {
            slot = k,
            name = v.name,
            count = v.count,
            rarity = rarityToNumber(item.config.rarity),
            raw = v
        })
    end

    -- Sort the bag
    table.sort(bag, comparer)

    -- Empty the container
    world.containerTakeAll(callerID)

    -- Add the sorted items back to the container
    for i = 1, #bag do
        world.containerAddItems(callerID, bag[i].raw)
    end
end

--[[
	Project			: LastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-23
	Purpose			: Handler for all quest-related functions.
]]--

local lastSeen, lastSeenNS = ...;
local L = lastSeenNS.L;
local select = select;

local itemName;
local itemRarity;
local itemID;
local itemType;
local itemIcon;

lastSeenNS.LogQuestLocation = function(questID, currentMap)
	if LastSeenQuestsDB[questID] then
		if LastSeenQuestsDB[questID]["location"] then
			if LastSeenQuestsDB[questID]["location"] ~= currentMap then
				LastSeenQuestsDB[questID]["location"] = currentMap;
			end
		else
			LastSeenQuestsDB[questID]["location"] = currentMap;
		end
	else
		LastSeenQuestsDB[questID] = {location = currentMap};
	end
end

lastSeenNS.QuestChoices = function(questID, itemLink, today)
	local questTitle = C_QuestLog.GetQuestInfo(questID);
	if LastSeenQuestsDB[questID] then
		if not LastSeenQuestsDB[questID]["title"] then
			LastSeenQuestsDB[questID]["title"] = questTitle;
		end
		if LastSeenQuestsDB[questID]["completed"] ~= today then
			LastSeenQuestsDB[questID]["completed"] = today;
		end
	else
		LastSeenQuestsDB[questID] = {title = questTitle, completed = today};
	end
	if itemLink then
		itemID, itemType, _, _, itemIcon = GetItemInfoInstant(itemLink);
		itemName, _, itemRarity = GetItemInfo(itemLink);
		
		if not itemID then return; -- DO NOTHING
		else
			if lastSeenNS.ignoredItemTypes[itemType] ~= nil then
				return;
			elseif lastSeenNS.ignoredItems[itemID] then
				return;
			elseif LastSeenIgnoredItemsDB[itemID] then
				return;
			end
			
			if itemRarity >= LastSeenSettingsCacheDB.rarity then -- Quest rewards should adhere to the same rarity standards as conventional loot.
				itemLink = select(2, GetItemInfo(itemID));
				LastSeenItemsDB[itemID] = {itemName = itemName, itemLink = itemLink, itemRarity = itemRarity, itemType = itemType, lootDate = today, source = questTitle, location = LastSeenQuestsDB[questID]["location"]};
			end
		end
	end
end
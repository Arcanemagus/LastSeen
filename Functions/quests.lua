--[[
	Project			: LastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-23
	Purpose			: Handler for all quest-related functions.
]]--

local lastSeen, lastSeenNS = ...;

local function QuestChoices(questID, today, currentMap)
	if lastSeenNS.LastSeenQuests[questID] then
		lastSeenNS.hasSeenQuest = true;
	end
	local numQuestChoices = GetNumQuestChoices();
	local numQuestRewards = GetNumQuestRewards();
	local i = 1;
	
	local questTitle = C_QuestLog.GetQuestInfo(questID);
	if numQuestChoices > 0 or numQuestRewards > 0 then
		repeat
			local chosenItemName, _, _, itemRarity, _ = GetQuestItemInfo("choice", i); -- The player chooses this item
			local rewardItemName, _, _, itemRarity, _ = GetQuestItemInfo("reward", i); -- An item that is given to the player as a reward (they do not choose it)
			if not lastseendb.itemstgdb[chosenItemName].itemName or not lastseendb.itemstgdb[rewardItemName] then
				lastseendb.itemstgdb[itemID] = {itemName = chosenItemName, itemLink = lastseendb:GetItemLink(chosenItemName), itemRarity = itemRarity, itemType = lastseendb:GetItemType(chosenItemName), lootDate = today, source = questTitle, location = currentMap};
			end
			if lastSeenNS.hasSeenQuest then
				if lastSeenNS.LastSeenQuests[questID].completed ~= today then
					lastSeenNS.LastSeenQuests[questID].completed = today;
				end
			else
				if chosenItemName ~= nil then
					lastSeenNS.LastSeenQuests[questID] = {title = questTitle, completed = today, rewards = {reward = chosenItemName}, location = currentMap};
				else
					lastSeenNS.LastSeenQuests[questID] = {title = questTitle, completed = today, rewards = {reward = rewardItemName}, location = currentMap};
				end
			end
			i = i + 1;
		until i > GetNumQuestChoices();
	else
		if lastSeenNS.LastSeenQuests[questID] then
			if lastSeenNS.LastSeenQuests[questID].completed ~= today then
				lastSeenNS.LastSeenQuests[questID].completed = today;
			end
		else
			lastSeenNS.LastSeenQuests[questID] = {title = questTitle, completed = today, rewards = 0, location = currentMap};
		end
	end
end

lastSeenNS:QuestChoices = QuestChoices(questID, today, currentMap);
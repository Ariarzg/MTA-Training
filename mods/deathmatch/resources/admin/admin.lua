addCommandHandler('setRank', function(player, command, account, group) 
    if not account or not group then 
        return outputChatBox('Syntax: /' .. command .. ' [account] [group]', player, 255, 255, 255)
    end

    -- ensure the account is valid
    local accountObj = getAccount(account)
    if not accountObj then 
        return outputChatBox('The specified account does not exist.', player, 255, 100, 100)
    end

    -- ensure the group is valid
    local groupObj = aclGetGroup(group)
    if not groupObj then 
        return outputChatBox('The specified group does not exist.', player, 255, 100, 100)
    end

    -- prefix the account name with 'user.' to be a valid object string
    local objectStr = 'user.' .. account

    -- remove user from all group
    local groups = aclGroupList()
    for _, removalGroup in pairs(groups) do 
        aclGroupRemoveObject(removalGroup, objectStr)
    end

    -- if the group is everyone -> return
    if group == 'Everyone' then 
        return outputChatBox('Successfully removed account "' .. account .. '" from all groups', player, 100, 255, 100)
    end

    -- add the account to the acl group using object string
    aclGroupAddObject(groupObj, objectStr)

    -- let the user know that we were successful
    return outputChatBox('Successfully added account "' .. account .. '" to group "' .. group .. '".', player, 100, 255, 100)
end, false, false)

-- ---------------------------------------------------------

addCommandHandler('setaclright', function(player, command, acl, right, access)
    if not acl or not right or not access then 
        return outputChatBox('Syntax: /' .. command .. ' [acl] [right] [access]', player, 255, 255, 255)
    end

    local aclObj = aclGet(acl)
    if not aclObj then 
        return outputChatBox('The specified ACL does not exist.', player, 255, 100, 100) 
    end

    local accessType = {['true'] = true, ['false'] = false}
    local accessBoolean = accessType[string.lower(access)]
    if accessBoolean == nil then 
        return outputChatBox('ACL access must be either TRUE or FALSE', player, 255, 100, 100) 
    end

    aclSetRight(aclObj, right, accessBoolean)

    return outputChatBox('Successfully updated the ACL right', player, 100, 255, 100)

end,false, false)
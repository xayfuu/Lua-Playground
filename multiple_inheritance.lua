local function lookup(key, parent_list)
    for i = 1, #parent_list do
        local v = parent_list[i][key]
        if v then return v end
    end
end

function createClass(...)
    local args = {...}
    local c = {}
    setmetatable(c, {__index = function(tabl, key)
                            local v = lookup(key, args)
                            tabl[key] = v
                            return v
                        end
                    }
                )
    c.__index = c

    function c:new(obj)
        obj = obj or {}
        setmetatable(obj, c)
        return obj
    end

    return c
end


Named = {}

function Named:getname()
    return self.name
end

function Named:setname(n)
    self.name = n
end

Account = {
    balance = 100
}

NamedAccount = createClass(Account, Named)
account = NamedAccount:new({name = "Paul"})
print(account:getname() .. ": " .. account.balance)

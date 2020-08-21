-- influence from http://nova-fusion.com/2011/06/30/lua-metatables-tutorial/


mt = {
    -- equal to python's __getitem__/__getattr__
    -- __index can be a function or another table to lookup in (prototyping)
    __index = function(t, key)
        if table[key] == nil then
            return 0
        else
            -- return lookup_table[key] -- infinite loop
            return table[key]
        end
    end,

    -- when trying to set a value in a table, and that value is not
    -- present in the table, then __newindex is called
    __newindex = function(t, key, value)
        if type(value) == "number" then
            -- rawset allows for setting some value in a table t
            -- without having to use __newindex (this is to avoid infinite
            -- loops when setting new values in tables)
            rawset(t, key, value * value)
            -- t[key] = value * value -- infinite loop because this effectively calls __newindex again
        else
            rawset(t, key, value)
        end
    end
}
t = setmetatable({}, mt)

print(t.foo)    -- 0 (normalerweise nil)
print(t.bar)    -- 0 (normalerweise nil)

t.foo = 4
print(t.foo)    -- 16
print(t["foo"]) -- 16

t.foo = 20
print(t.foo)    -- 20 (__newindex wurde nicht erneut aufgerufen --> unterschied zu __setattr__ in python)

t.bar = "not_a_number"
print(t.bar) -- "not_a_number"

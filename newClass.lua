--[[
    DOCS

    # Creating Classes

    class 'Animal' {
        constructor = function(self, name, type)
            self.name = name
            self.type = type
        end
    }

    # Instantiating

    local dog = new 'Animal'('Dog', 'Mammal')

    # Inheritance

    class 'Animal' {
        constructor = function(self, name, type)
            self.name = name
            self.type = type
        end,

        eat = function(self)
            print('Eating...')
        end
    }

    class 'Dog' : extends 'Animal' {
        constructor = function(self, name)
            self.name = name
        end
    }

    local dog = new 'Dog'('Bob')
    dog:eat() -- Eating...

    # Polymorphism

    class 'Animal' {
        constructor = function(self, name, type)
            self.name = name
            self.type = type
        end,

        speak = function(self)
            print('Hello, my name is ' .. self.name .. ' and I am a ' .. self.type .. '.')
        end
    }

    class 'Dog' : extends 'Animal' {
        constructor = function(self, name)
            self.name = name
        end,

        speak = function(self)
            print('Woof! My name is ' .. self.name .. '.')
        end
    }

    # Interfaces

    interface 'telePhone' {
        'call',
        'sendSMS',
        'receiveSMS'
    }

    ## Implements 

    class 'SmartPhone' : implements 'telePhone' {
        constructor = function(self, number)
            self.number = number
        end,

        call = function(self, number)
            print('Calling ' .. number .. ' from ' .. self.number .. '...')
        end,

        sendSMS = function(self, number, message)
            print('Sending SMS to ' .. number .. ' from ' .. self.number .. '...')
        end,

        receiveSMS = function(self, number, message)
            print('Received SMS from ' .. number .. ' to ' .. self.number .. '...')
        end
    }

    ## Multiple interfaces

    interface 'telePhone' {
        'call',
        'sendSMS',
        'receiveSMS'
    }

    interface 'smartPhone' {
        'touchScreen',
        'internet'
    }

    class 'SmartPhone' : implements ('telePhone', 'smartPhone') {
        constructor = function(self, number)
            self.number = number
        end,

        call = function(self, number)
            print('Calling ' .. number .. ' from ' .. self.number .. '...')
        end,

        sendSMS = function(self, number, message)
            print('Sending SMS to ' .. number .. ' from ' .. self.number .. '...')
        end,

        receiveSMS = function(self, number, message)
            print('Received SMS from ' .. number .. ' to ' .. self.number .. '...')
        end,

        touchScreen = function(self)
            print('Touching screen...')
        end,

        internet = function(self)
            print('Accessing internet...')
        end
    }

    ## Inheritance of interfaces

    interface 'telePhone' {
        'call',
        'sendSMS',
        'receiveSMS'
    }

    interface 'smartPhone' : extends 'telePhone' {
        'touchScreen',
        'internet'
    }

    # instanceOf

    local dog = new 'Animal'('Dog', 'Mammal')
    print(instanceOf(dog, 'Animal')) -- true

]]


local classes = {}
local interfaces = {}

local function table_copy(t, st)
    local newTbl = {}
    for k, v in pairs(t) do
        if (not newTbl[k]) then
            newTbl[k] = v
        end
    end
    if (st) then
        newTbl.super = st
        setmetatable(newTbl, {__index = newTbl.super })
    end
    return newTbl
end

local function table_implements(t, t2)
    local newTbl = {}
    for i, v in ipairs(t) do
        t[#t+1] = v
    end
    newTbl = table_copy(t)
    return newTbl
end

local function createClass(className, structure, superClass)
    if (classes[className]) then
        error('Class '..className..' already exists.', 2)
    end
    
    local newClass = structure
    newClass.__name = className

    if (superClass) then
        newClass.super = superClass
        setmetatable(newClass, {__index = superClass })
    end

    classes[className] = newClass
    return newClass
end

function interface(interfaceName)
    local newInterface = {}
    
    setmetatable(newInterface, {
        __call = function (self, ...)
            if (interfaces[interfaceName]) then
                error('Interface '..interfaceName..' already exists.', 2)
            end

            local newInstance = ...
            interfaces[interfaceName] = newInstance
            return newInstance
        end
    })

    newInterface.extends = function(self, superInterfaceName)
        return function(subInterface)
            local superInterface = interfaces[superInterfaceName]
            local newInstance = table_implements(subInterface, superInterface)

            if (interfaces[interfaceName]) then
                error('Interface '..interfaceName..' already exists.', 2)
            end

            interfaces[interfaceName] = newInstance
            return newInstance
        end
    end

    return newInterface
end

function class(className)
    local newClass = {}
    local modifiers = {
        extends = function(self, superClassName)
            return function(subClass)
                local superClass = classes[superClassName]
                local classCreated = createClass(className, subClass, superClass)
                return classCreated
            end
        end,

        implements = function(self, ...)
            local interfacesNames = {...}
            return function(subClass)
                local classCreated = createClass(className, subClass)

                for _, v in pairs(interfacesNames) do
                    if (not interfaces[v]) then
                        error('Interface '..v..' not found.', 2)
                    end

                    for _, method in pairs(interfaces[v]) do
                        if (not subClass[method]) then
                            error('Interface '..v..' not implemented, method '..method..' not found', 2)
                        end
                    end
                end

                return classCreated
            end
        end
    }

    setmetatable(newClass, {
        __index = function(self, key)
            if (modifiers[key]) then
                return modifiers[key]
            end

            if (classes[className]) then
                return classes[className][key]
            end

            error('Class '..className..' not found', 2)
        end,
        
        __call = function(self, ...)
            if (classes[className]) then
                error('Class '..className..' already exists.', 2)
            end

            local newInstance = createClass(className, ...)
            return newInstance
        end
    })

    return newClass
end

function new(className)
    return function(...)
        local class = classes[className]
        if (not class) then
            error('Class '..className..' not found.', 2)
        end

        local super = class.super
        local newObj = table_copy(class, super)
        if (newObj.constructor) then
            newObj:constructor(...)
        end

        return newObj
    end
end

function instanceOf(instance, className)
    local class = classes[className]
    if (not class) then
        error('Class ' .. className .. ' not found', 2)
    end

    if (instance.__name == className) then
        return true
    end

    return false
end
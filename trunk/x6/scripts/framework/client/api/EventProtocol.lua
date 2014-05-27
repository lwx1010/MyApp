
--[[--

Events are the principal way in which you create interactive applications. They are a way of
triggering responses in your program. For example, you can turn any display object into an
interactive object.

]]
local EventProtocol = {}

--[[--

Turn any object into an interactive object.

**Usage:**

    framework.client.api.EventProtocol.extend(object)

]]
function EventProtocol.extend(object)
    object.listeners = {}

    -- 是否锁定队列
    object._lockQueue = false

    -- 缓存的操作 {add,event,listener,owner}
    object._cacheOps = {}

    --[[--

    Adds a listener to the object’s list of listeners. When the named event occurs, the listener will be invoked and be supplied with a table representing the event.

    **Usage:**

        -- Create an object that listens to events
        local player = Player.new()
        framework.client.api.EventProtocol.extend(player)

        -- Setup listener
        local function onPlayerDead(event)
            -- event.name   == "PLAYER_DEAD"
            -- event.object == player
        end
        player:addEventListener("PLAYER_DEAD", onPlayerDead)

        -- Sometime later, create an event and dispatch it
        player:dispatchEvent({name = "PLAYER_DEAD"})

    ~~

    @param eventName
    String specifying the name of the event to listen for.

    @tparam function listener
    If the event's event.name matches this string, listener will be invoked.

    @return Nothing.

    ]]
    function object:addEventListener(eventName, listener, owner)
        if( not eventName or not listener ) then return end

        if( object._lockQueue ) then
            object._cacheOps[#object._cacheOps+1] = {true,eventName,listener,owner}
            return
        end

        eventName = string.upper(eventName)
        local t = object.listeners[eventName]
        if t == nil then
        	t= {}
            object.listeners[eventName] = t
            --setmetatable(object.listeners[eventName], {__mode = "kv"})
        end
        
        local l
        for i=1, #t do
        	l = t[i]
        	if l[1]==listener and l[2]==owner then
        		return 
        	end
        end
        
        t[#t+1] = {listener, owner}
    end

    --[[--

    Dispatches event to object. The event parameter must be a table with a name property which is a
    string identifying the type of event. Event include a object property to the event so that your listener can know which object
    received the event.

    **Syntax:**

        object:dispatchEvent(event)

    <br />

    @param event
    contains event properties

    ]]
    function object:dispatchEvent(event)
        event.name = string.upper(event.name)
        event.target = object
        local eventName = event.name
        if object.listeners[eventName] == nil then return end

        object._lockQueue = true

		local listener, owner, ret
        local t = object.listeners[eventName]
        for i = 1, #t do
            listener = t[i][1]
            owner = t[i][2]
            if( not owner ) then
            	ret = listener(event)
            else
            	ret = listener(owner, event)
            end
	        if ret == false then break end
        end

        object._lockQueue = false
        
        if( #object._cacheOps>0 ) then
        	local op
            for i=1, #object._cacheOps do
            	op = object._cacheOps[i]
                if( op[1] ) then
                    object:addEventListener(op[2], op[3], op[4])
                else
                    object:removeEventListener(op[2], op[3], op[4])
                end
            end
            object._cacheOps = {}
        end
    end

    --[[--

    Removes the specified listener from the object's list of listeners so that it no longer is
    notified of events corresponding to the specified event.

    **Syntax:**

        object:removeEventListener(eventName, listener)

    ]]
    function object:removeEventListener(eventName, listener, owner)
        if( not eventName or not listener ) then return end

        if( object._lockQueue ) then
            object._cacheOps[#object._cacheOps+1] = {false,eventName,listener,owner}
            return
        end

        eventName = string.upper(eventName)
        
        local t = object.listeners[eventName]
        if t == nil then return end
        
        local l
        for i=1, #t do
        	l = t[i]
        	if l[1]==listener and l[2]==owner then
        		table.remove(t, i)
        		break 
        	end
        end

        if #t == 0 then object.listeners[eventName] = nil end
    end

    --[[--

    Removes all listeners for specified event from the object's list of listeners.

    **Syntax:**

        object:removeAllEventListenersForEvent(eventName)

    ]]
    function object:removeAllEventListenersForEvent(eventName)
        object.listeners[string.upper(eventName)] = nil
    end

    --[[--

    Removes all listeners from the object's list of listeners.

    **Syntax:**

        object:removeAllEventListeners()

    ]]
    function object:removeAllEventListeners()
        object.listeners = {}
        object._cacheOps = {}
    end
    
    ---
    -- 是否有侦听器
    -- @function [parent=#framework.client.api.EventProtocol] hasListener
    -- @param self
    -- @param #string eventName 事件名字
    -- @return #boolean
    -- 
    function object:hasListener( eventName )
    	local t = object.listeners[string.upper(eventName)]
    	return t and #t>0
    end

    return object
end

return EventProtocol

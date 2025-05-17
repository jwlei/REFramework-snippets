-- @Author Carnwennan
-- Generic function to print details of any type in REFramework
local function printObjectDetails(typeName)
    local typeDefinition = sdk.find_type_definition(typeName)
    if not typeDefinition then 
        log.error("Could not find type: " .. typeName)
        return 
    end
    
    -- Print object name
    log.info("=== Object Details: " .. typeName .. " ===")
    
    -- List fields/attributes
    log.info("--- Fields ---")
    local fields = typeDefinition:get_fields()
    for i, field in ipairs(fields) do
        local fieldName = field:get_name()
        local fieldType = field:get_type()
        local typeName = fieldType and fieldType:get_full_name() or "unknown"
        local isStatic = field:is_static() and "static" or "instance"
        
        log.info(string.format("Field: %s (Type: %s, isStatic: %s)", fieldName, typeName, isStatic))
    end
    
    -- List methods with detailed parameter information
    log.info("--- Methods ---")
    local methods = typeDefinition:get_methods()
    for i, method in ipairs(methods) do
        local methodName = method:get_name()
        local returnType = method:get_return_type()
        local returnTypeName = returnType and returnType:get_full_name() or "void"
        local isStatic = method:is_static() and "static" or "instance"
        
        -- Get parameter information
        local numParams = method:get_num_params()
        local paramTypes = method:get_param_types()
        
        -- Build parameter string
        local paramString = ""
        if numParams > 0 then
            local params = {}
            for j = 1, numParams do
                local paramType = paramTypes[j]:get_full_name() or "unknown"
                table.insert(params, string.format("%s", paramType))
            end
            paramString = table.concat(params, ", ")
        end
        
        -- Print method information
		log.info(string.format("(%s) Method: %s(%s) → %s", isStatic, methodName, paramString, returnTypeName))
    end
    
    -- Print parent type if available
    local parentType = typeDefinition:get_parent_type()
    if parentType then
        log.info(string.format("Parent Type: %s", parentType:get_full_name()))
    else
        log.info("Parent Type: none")
    end
    
    log.info("=== End of Object Details ===")
end

-- Example of use
printObjectDetails("app.cHunterHealth")
local log_file = 'mysql.log'

local fh = io.open(log_file, "a+")

function read_query( packet )
    if string.byte(packet) == proxy.COM_QUERY then
        local query = string.sub(packet, 2)
--        fh:write( string.format("%s %6d	--	%s\n", 
--            os.date('%Y-%m-%d %H:%M:%S'), 
--            proxy.connection.server["thread_id"], 
--            query)) 
        fh:write( "sent:"..   query .. "\n")

        fh:flush()
        proxy.queries:append(1, string.char(proxy.COM_QUERY) .. query, {resultset_is_needed = true})

        return proxy.PROXY_SEND_QUERY
    end
    return
                                                       
end

function read_query_result(inj)
-- print ("lkjljk")
 fh:write("===BEGIN===\nquery: " .. (inj.query ) .. "##END\n")
-- fh:write("query-time: " .. (inj.query_time / 1000) .. "ms")
-- fh:write("response-time: " .. (inj.response_time / 1000) .. "ms")
-- if inj.id == 2 then
--
 local res = assert(inj.resultset)

 local row_count = 0
 if res.affected_rows then
    row_count = res.affected_rows
 else
    local num_cols = string.byte(res.raw, 1)
    if num_cols > 0 and num_cols < 255 then
      for row in inj.resultset.rows do
        row_count = row_count + 1
      end
    end
 end
 fh:write("rowcnt:" .. row_count  .. "\n")
 if res.query_status == proxy.MYSQLD_PACKET_ERR then
    fh:write("ERRORA_MSG:" .. res.raw:sub(10) .. "\n")
    
 end

 if nil ~= inj.resultset.rows then
   local num_cols = string.byte(res.raw, 1)
   local to_write = ""
   if num_cols > 0 and num_cols < 255 then
   fh:write("colcnti:" .. num_cols .. "\n")

    for row in inj.resultset.rows do
      to_write = ""
      for i = 1,num_cols,1 do
          to_write = to_write .. "|".. tostring(row[i])
 --         fh:write("" .. tostring(row[i]) .. "|")

      end
      fh:write("" .. to_write .. "\n")
    end  
   end
 end 
 fh:write("===END===\n")
 fh:flush()


end

-- MySQL Proxy script for development/debugging purposes
--
-- Written by Patrick Allaert <patrickallaert@php.net>
-- Copyright © 2009-2011 Libereco Technologies
-- Modified by Gang Han 
-- Copyright 
-- 
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.

function nowhere(query)

    local ind_tblname = string.find(string.upper(query), "WHERE")
    if  ( not ( ind_tblname  == nil))then
        query = string.sub(query,1,ind_tblname)
    end
    return query
end

function read_query( packet )
    if packet:byte() ~= proxy.COM_QUERY then
        return
    end
    local query = packet:sub(2)
    query = nowhere(query)
    proxy.queries:append(1, string.char(proxy.COM_QUERY) .. query, {resultset_is_needed = true}) 

    return proxy.PROXY_SEND_QUERY
end

function read_query_result (inj)
        local fn = 1
        local fields = inj.resultset.fields
        proxy.response.resultset = {fields = {}, rows = {}}
        while fields[fn] do
            table.insert(proxy.response.resultset.fields, {type = proxy.MYSQL_TYPE_STRING, name = fields[fn].name})
            fn = fn + 1
        end
        fn = fn - 1
        for row in inj.resultset.rows do
            for i = 1, fn do
--                    row[i]="TESTED"
                      row[i]=row[i]+50000
            end
            table.insert(proxy.response.resultset.rows, row )
        end
        proxy.response.type = proxy.MYSQLD_PACKET_OK
        return proxy.PROXY_SEND_RESULT
end

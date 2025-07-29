public sub OnEndRecordFixedHead

	'Importer.Field("node_id") = "H_" & Right("0000000000" & CStr(Importer.Field("Systemid")), 10)
	
	
	
end sub

public sub OnBeginRecordFixedHead

	if Importer.Field("equip_cl_1") <> "WTW" then
		Importer.WriteRecord = false
	end if

	if Importer.Field("d_operatio") = "Abandoned" or _
	   Importer.Field("d_operatio") = "Proposed"  or _
	   Importer.Field("d_operatio") = "Removed"  or _
	   Importer.Field("wic_status") = "DECOMISSIONED"  or _
	   Importer.Field("wic_status") = "REDUNDANT"  or _
	   Importer.Field("status") = "SOLD"  or _
	   Importer.Field("status") = "MOTHBALLED" then
		Importer.WriteRecord = false
	end if

end sub
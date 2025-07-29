public sub OnEndRecordReservoir

	'Importer.Field("node_id") = "H_" & Right("0000000000" & CStr(Importer.Field("Systemid")), 10)
	Importer.Field("node_id_flag") = ""
	Importer.Field("x_flag") = ""
	Importer.Field("y_flag") = ""
	
	
end sub

public sub OnBeginRecordReservoir

	if Importer.Field("equip_cl_1") <> "TWS" then
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
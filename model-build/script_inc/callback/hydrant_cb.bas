public sub OnEndRecordHydrant

	Importer.Field("construction_type_flag") = "AV"
	Importer.Field("valve_diameter_flag") = "AV"
	Importer.Field("diameter_flag") = "AV"
	Importer.Field("x_flag") = ""
	Importer.Field("y_flag") = ""
	
end sub

public sub OnBeginRecordHydrant

	if Importer.Field("d_operatio") = "Abandoned" or  Importer.Field("d_operatio") = "Proposed" then
		Importer.WriteRecord = false
	end if

end sub
public sub OnBeginRecordHydrant

	if Importer.Field("operation") = "Abandoned" Then							
    	Importer.WriteRecord = false
	end if

end sub

public sub OnBeginRecordPolygons

	if Importer.Field("type") <> "DMA" Then
		Importer.WriteRecord = false
	end if
    
end sub

public sub OnBeginRecordPipe

	if Importer.Field("operation") = "Abandoned" Then
		Importer.WriteRecord = false
	end if
    
end sub

public sub OnBeginRecordValve

	if Importer.Field("operation") = "Abandoned" Then
		Importer.WriteRecord = false
	end if
    
end sub
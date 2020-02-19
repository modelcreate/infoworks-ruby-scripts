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

	if Importer.Field("FUNCTION_") = "DRAIN" or _
	   Importer.Field("FUNCTION_") = "BLOWOFF" or _
	   Importer.Field("FUNCTION_") = "AIR RELEASE" Then
		Importer.WriteRecord = false
	end if
    
end sub
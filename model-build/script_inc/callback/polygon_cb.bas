public sub OnEndRecordPolygons

	Importer.Field("user_number_10") = Year(Date)
	Importer.Field("polygon_id_flag") = ""
	
end sub
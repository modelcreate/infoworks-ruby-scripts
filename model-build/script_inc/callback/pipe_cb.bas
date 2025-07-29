public sub OnEndRecordPipe
	
    diaToImport = DiameterToNum(Importer.Field("d_diameter"))
    If diaToImport <> "" Then
	    Importer.Field("diameter") =  diaToImport 
    End If

    yearLaid = left(Importer.Field("date_commi"), 4)
    If yearLaid = "0000" Then
        'Ogr2Ogr makes datetime to date and then reads date as 000-00-00 for blank
        Importer.Field("year") = ""
        Importer.Field("year_flag") = ""
    Else
        'How long till they change this and I have to fix it?
	    Importer.Field("year") =  yearLaid 
    End If

    material = GetMaterialForIW(Importer.Field("d_material")) 
    if Importer.Field("d_material") <> "" Then
        Importer.Field("material") =  material
    End If

    if diaToImport <> "" and (material = "PE" or _
    material = "MDPE" or _
    material = "HDPE" or _
    material = "HPPE") Then

        internalPeDia = GetPeInternalDia(diaToImport, Importer.Field("d_pressure"))

        If internalPeDia <> "" Then
            Importer.Field("diameter") =  internalPeDia
            Importer.Field("diameter_flag") =  "SD"
        End If

        
    End If
	
end sub

public sub OnBeginRecordPipe

	if Importer.Field("d_operatio") = "Abandoned" or _
      Importer.Field("d_operatio") = "Proposed" or _
      Importer.Field("d_type") = "Overflow" or _
      Importer.Field("d_type") = "Sludge" or _
      Importer.Field("d_type") = "Drain" then
		Importer.WriteRecord = false
	end if

end sub

Private Function GetMaterialForIW(material)
    Dim dict
    Set dict = CreateObject("Scripting.Dictionary")

    dict.Add "DI - Ductile Iron", "DI"
    dict.Add "CI - Cast Iron", "CI"
    dict.Add "DIL - Ductile Iron Lined", "DIL"
    dict.Add "CIL - Cast Iron Lined", "CIL"
    dict.Add "SI - Spun Iron", "SI"
    dict.Add "ST - Steel", "ST"
    dict.Add "GS - Galvanised Steel", "GS"
    dict.Add "CU - Copper", "CU"
    dict.Add "PB - Lead", "PB"
    dict.Add "AC - Asbestos Cement", "AC"
    dict.Add "PSC - Pre-Stressed Concrete", "PSC"
    dict.Add "GRP - Glass Reinforced Plastic", "GRP"
    dict.Add "uPVC - Unplasticised Poly Vinyl Chloride", "uPVC"
    dict.Add "PVCU - (Metric)", "PVCU"
    dict.Add "PVC - Polyvinyl Chloride", "PVC"
    dict.Add "POLY - Polyethylene", "PE"
    dict.Add "AK - Alkathene", "AK"
    dict.Add "MDPE - Medium Density Polyethylene", "MDPE"
    dict.Add "HDPE - High Density Polyethylene", "HDPE"
    dict.Add "HPPE - High Performance Polyethylene", "HPPE"
    dict.Add "FC - Fire Clay", "FC"
    dict.Add "HEP30", "PE"
    dict.Add "L", "Other"
    dict.Add "BR - Brick", "BR"
    dict.Add "MOPVC", "PVC"
    dict.Add "P", "Other"
    dict.Add "GI (Galvanised Iron)", "GI"
    dict.Add "PC", "Other"
    dict.Add "FAHDPE", "PE"
    dict.Add "IB", "Other"
    dict.Add "SPC-Steel/Plastic Composite", "Other"
    dict.Add "MAC - Masonry Regularly Coursed", "Other"
    dict.Add "MAC - Masonry Randomly Coursed", "Other"
    dict.Add "RC - Reinforced Concrete", "RC"
    dict.Add "CONC - Concrete", "CONC"
    dict.Add "Other", "Other"
    dict.Add "Unknown", "UNK"
    dict.Add "TPL - Thermo Pipe Liner", "TPL"
    dict.Add "Puritan", "PE"

    If dict.Exists(material) Then
        GetMaterialForIW = dict.Item(material)
    Else
        GetMaterialForIW = "LOOKUPFAIL"
    End If

End Function

Private Function DiameterToNum(dia)

    Dim postfix
    postfix = Right(dia, 2)

    Select Case postfix
        Case "mm"
            'strip mm
            DiameterToNum = Left(dia, Len(dia) - 2)

        Case "in"
            'Concert inch to mm
            DiameterToNum = InchToMM(dia)

        Case "wn","er"
          'Unkown or Other
            DiameterToNum = ""

        Case Else
            'Assume empty
            DiameterToNum = dia
    End Select

End Function


Private Function InchToMM(dia)

    Dim fraction
    fraction = 0
    Dim fractionPosition
    fractionPosition = InStr(dia, "/")

    Dim trimCount
    trimCount = 2

    If fractionPosition > 0 Then
        'Found Fraction
        Dim fractionString
        fractionString = Mid(dia, fractionPosition - 1, 3)
        Select Case fractionString
            Case "1/2"
                fraction = 0.5
            Case "1/4"
                fraction = 0.25
        End Select
        trimCount = 5
        
    End If

    Dim leftNumber
    leftNumber = Left(dia, Len(dia) - trimCount)
    
    Dim finalNumber
    If IsNumeric(leftNumber) Then
        finalNumber = CDbl(leftNumber)
    Else
        finalNumber = 0
    End If

    
    InchToMM = (finalNumber + fraction) * 25.4

End Function


Private Function GetPeInternalDia(dia, pressureRating)

    if dia < 90 or pressureRating = "16 Bar" or pressureRating =  "12 1/2 Bar" or pressureRating =   "12 Bar" Then
        GetPeInternalDia = Pe16Bar(dia)
    else
        GetPeInternalDia = Pe10Bar(dia)
    end if


End Function

Private Function Pe16Bar(dia)

    Dim dict
    Set dict = CreateObject("Scripting.Dictionary")

    dict.Add 20, 15.25
    dict.Add 25, 20.3
    dict.Add 32, 25.8
    dict.Add 50, 40.4
    dict.Add 63, 50.9
    dict.Add 90, 72.9
    dict.Add 110, 89.1
    dict.Add 125, 101.2
    dict.Add 160, 129.6
    dict.Add 180, 145.9
    dict.Add 225, 182.4
    dict.Add 250, 202.8
    dict.Add 280, 227.1
    dict.Add 315, 255.6
    dict.Add 355, 288.1
    dict.Add 400, 324.6
    dict.Add 450, 360.1
    dict.Add 500, 406.3
    dict.Add 560, 454.7
    dict.Add 630, 511.5


    If dict.Exists(Int(dia)) Then
        Pe16Bar = dict.Item(Int(dia))
    Else
        Pe16Bar = ""
    End If

End Function

Private Function Pe10Bar(dia)

    Dim dict
    Set dict = CreateObject("Scripting.Dictionary")

    dict.Add 90, 78.7
    dict.Add 110, 96.3
    dict.Add 125, 109.5
    dict.Add 160, 140.3
    dict.Add 180, 158
    dict.Add 225, 197.3
    dict.Add 250, 219.6
    dict.Add 280, 245.9
    dict.Add 315, 276.6
    dict.Add 355, 311.5
    dict.Add 400, 351.2
    dict.Add 450, 395.2
    dict.Add 500, 438.9
    dict.Add 560, 493.9
    dict.Add 630, 553.1

    If dict.Exists(Int(dia)) Then
        Pe10Bar = dict.Item(Int(dia))
    Else
        Pe10Bar = ""
    End If

End Function
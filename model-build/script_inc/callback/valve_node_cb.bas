public sub OnBeginRecordNode

	if Importer.Field("d_operatio") = "Abandoned" or  Importer.Field("d_operatio") = "Proposed" then
    	Importer.WriteRecord = false
	end if

end sub

public sub OnEndRecordNode

	diameter = DiameterToNum(Importer.Field("d_diameter"))
	Importer.Field("user_text_9") = diameter

    
    If Importer.Field("d_type") = "Pressure Reducing" or Importer.Field("d_type") = "Pressure Sustaining" Then
        Importer.Field("user_text_10") = "PLUG"
        Importer.Field("user_text_10_flag") = "AV"
    ElseIf Importer.Field("d_mechanis") = "Sluice" or Importer.Field("d_mechanis") = "Gate" Then
        Importer.Field("user_text_10") = "GATE"
        Importer.Field("user_text_10_flag") = "IG"
    Else
        Importer.Field("user_text_10") = "GATE"
        Importer.Field("user_text_10_flag") = "AV"
    End If

end sub


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
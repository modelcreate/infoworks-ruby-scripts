public sub OnBeginRecordNode

	if Importer.Field("d_operatio") = "Abandoned" or _
      Importer.Field("d_operatio") = "Proposed"  or _
      Importer.Field("d_type") = "Revenue"  or _
      Importer.Field("d_type") = "WET"  then
    	Importer.WriteRecord = false
	end if
	

end sub

public sub OnEndRecordNode

	diameter = DiameterToNum(Importer.Field("d_diameter"))
	Importer.Field("user_text_9") = diameter

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
        trimCount = 6
        
    End If


    InchToMM = (Left(dia, Len(dia) - trimCount) + fraction) * 25.4

End Function
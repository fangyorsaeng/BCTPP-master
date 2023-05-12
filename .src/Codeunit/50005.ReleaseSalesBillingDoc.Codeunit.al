Codeunit 50005 "Release Sales Billing Doc."
{
    TableNo = "Sales Billing Header";

    trigger OnRun()
    begin
        SalesBillingHeader.Copy(Rec);
        SalesBillingHeader.Status := SalesBillingHeader.Status::Released;
        SalesBillingHeader.Modify;
        Rec := SalesBillingHeader;
    end;

    var
        SalesBillingHeader: Record "Sales Billing Header";
        DocumentType: Option "Sales Billing","Sales Receipt";
        Text001: label 'Document Type: %1, Document No.: %2 already exists in Billing No.: %3.';
        DocumentNo: Code[20];
        aa: Code[10];
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];

    procedure Reopen(var Rec: Record "Sales Billing Header")
    begin
        SalesBillingHeader.Copy(Rec);
        SalesBillingHeader.Status := SalesBillingHeader.Status::Open;
        SalesBillingHeader.Modify;
        Rec := SalesBillingHeader;
    end;

    procedure CreateBillingLines(var CustLedgEntry: Record "Cust. Ledger Entry")
    var
        SalesBillingHeader: Record "Sales Billing Header";
        SalesBillingLine: Record "Sales Billing Line";
        VATEntry: Record "VAT Entry";
        BillingLedger: Record "Billing Ledger Entries";
    begin
        exit;
        /*
        if CustLedgEntry.Find('-') then
            repeat
                CustLedgEntry.Selected := false;
                CustLedgEntry.Modify;

                SalesBillingHeader.Get(DocumentType, DocumentNo);
                SalesBillingHeader.TestField("Bill-to Customer No.");
                SalesBillingHeader.TestField(Status, SalesBillingHeader.Status::Open);

                SalesBillingLine.Init;
                SalesBillingLine."Document Type" := DocumentType;
                SalesBillingLine."Document No." := DocumentNo;
                SalesBillingLine."Line No." := LastLineNo;
                SalesBillingLine."Bill-to Customer No." := SalesBillingHeader."Bill-to Customer No.";
                SalesBillingLine."Cust. Ledger Entry No." := CustLedgEntry."Entry No.";
                SalesBillingLine."Cust. Document Type" := CustLedgEntry."Document Type";
                SalesBillingLine."Cust. Document No." := CustLedgEntry."Document No.";
                SalesBillingLine."Cust. Description" := CustLedgEntry.Description;
                SalesBillingLine."Cust. Due Date" := CustLedgEntry."Due Date";
                SalesBillingLine."Cust. External Due Date" := CustLedgEntry."External Due Date";
                SalesBillingLine."Cust. Posting Date" := CustLedgEntry."Posting Date";

                CustLedgEntry.CalcFields("Original Amt. (LCY)", "Remaining Amt. (LCY)", "Billing Remaining Amt.");
                SalesBillingLine."Cust. Original Amount (LCY)" := CustLedgEntry."Original Amt. (LCY)";
                SalesBillingLine."Cust. Remaining Amt. (LCY)" := CustLedgEntry."Remaining Amt. (LCY)";

                VATEntry.Reset;
                VATEntry.SetFilter("Document Type", '%1', CustLedgEntry."Document Type");
                VATEntry.SetFilter("Document No.", '%1', CustLedgEntry."Document No.");
                if VATEntry.Find('-') then
                    repeat
                        SalesBillingLine."Cust. VAT Amount" -= VATEntry.Amount;
                    until VATEntry.Next = 0;

                if CustLedgEntry."Billing Remaining Amt." = 0 then
                    CustLedgEntry.TestField("Billing Remaining Amt.");

                SalesBillingLine."Amount (LCY)" := CustLedgEntry."Billing Remaining Amt.";
                SalesBillingLine.Insert;
                BillingLedger.Reset;
                BillingLedger.SetFilter("Transaction Type", '%1', BillingLedger."transaction type"::"Sales Billing");
                BillingLedger.SetFilter("Transaction Entry No.", '%1', CustLedgEntry."Entry No.");
                BillingLedger.SetFilter("Transaction Entry Type", '%1', BillingLedger."transaction entry type"::Application);
                BillingLedger.SetFilter("Transcation Document No.", '%1', DocumentNo);
                if not BillingLedger.Find('-') then begin
                    BillingLedger.Init;
                    BillingLedger."Entry No." := LastEntryNo;
                    BillingLedger."Transaction Type" := BillingLedger."transaction type"::"Sales Billing";
                    BillingLedger."Transaction Entry No." := CustLedgEntry."Entry No.";
                    BillingLedger."Transaction Entry Type" := BillingLedger."transaction entry type"::Application;
                    BillingLedger."Transcation Document No." := DocumentNo;
                    BillingLedger."Transaction Line No." := SalesBillingLine."Line No.";
                    BillingLedger."Amount (LCY)" := -SalesBillingLine."Amount (LCY)";
                    BillingLedger.Insert;
                end else
                    Error(Text001, CustLedgEntry."Document Type", CustLedgEntry."Document No.", SalesBillingLine."Document No.");
            until CustLedgEntry.Next = 0;
            */
    end;

    procedure CreateReceiptLines(var CustLedgEntry: Record "Cust. Ledger Entry")
    var
        SalesBillingHeader: Record "Sales Billing Header";
        SalesBillingLine: Record "Sales Billing Line";
        VATEntry: Record "VAT Entry";
        BillingLedger: Record "Billing Ledger Entries";
        GenJournalDoc: Enum "Gen. Journal Document Type";
    begin
        exit;
        /*
        if CustLedgEntry.Find('-') then
            repeat
                SalesBillingHeader.Get(DocumentType, DocumentNo);
                SalesBillingHeader.TestField("Bill-to Customer No.");
                SalesBillingHeader.TestField(Status, SalesBillingHeader.Status::Open);

                SalesBillingLine.Init;
                SalesBillingLine."Document Type" := DocumentType;
                SalesBillingLine."Document No." := DocumentNo;
                SalesBillingLine."Line No." := LastLineNo;
                SalesBillingLine."Bill-to Customer No." := SalesBillingHeader."Bill-to Customer No.";
                SalesBillingLine."Cust. Ledger Entry No." := CustLedgEntry."Entry No.";
                SalesBillingLine."Cust. Document Type" := CustLedgEntry."Document Type";
                SalesBillingLine."Cust. Document No." := CustLedgEntry."Document No.";
                SalesBillingLine."Cust. Description" := CustLedgEntry.Description;
                SalesBillingLine."Cust. Due Date" := CustLedgEntry."Due Date";
                SalesBillingLine."Cust. External Due Date" := CustLedgEntry."External Due Date";
                SalesBillingLine."Cust. Posting Date" := CustLedgEntry."Posting Date";

                CustLedgEntry.CalcFields("Original Amt. (LCY)", "Remaining Amt. (LCY)", "Receipt Remaining Amt.");
                SalesBillingLine."Cust. Original Amount (LCY)" := CustLedgEntry."Original Amt. (LCY)";
                SalesBillingLine."Cust. Remaining Amt. (LCY)" := CustLedgEntry."Remaining Amt. (LCY)";

                VATEntry.Reset;
                VATEntry.SetFilter("Document Type", '%1', CustLedgEntry."Document Type");
                VATEntry.SetFilter("Document No.", '%1', CustLedgEntry."Document No.");
                if VATEntry.Find('-') then
                    repeat
                        SalesBillingLine."Cust. VAT Amount" -= VATEntry.Amount;
                    until VATEntry.Next = 0;

                if CustLedgEntry."Receipt Remaining Amt." = 0 then
                    CustLedgEntry.TestField("Receipt Remaining Amt.");

                SalesBillingLine."Amount (LCY)" := CustLedgEntry."Receipt Remaining Amt.";
                SalesBillingLine.Insert;

                BillingLedger.Reset;
                BillingLedger.SetFilter("Transaction Type", '%1', BillingLedger."transaction type"::"Sales Receipt");
                BillingLedger.SetFilter("Transaction Entry No.", '%1', CustLedgEntry."Entry No.");
                BillingLedger.SetFilter("Transaction Entry Type", '%1', BillingLedger."transaction entry type"::Application);
                BillingLedger.SetFilter("Transcation Document No.", '%1', DocumentNo);
                if not BillingLedger.Find('-') then begin
                    BillingLedger.Init;
                    BillingLedger."Entry No." := LastEntryNo;
                    BillingLedger."Transaction Type" := BillingLedger."transaction type"::"Sales Receipt";
                    BillingLedger."Transaction Entry No." := CustLedgEntry."Entry No.";
                    BillingLedger."Transaction Entry Type" := BillingLedger."transaction entry type"::Application;
                    BillingLedger."Transcation Document No." := DocumentNo;
                    BillingLedger."Transaction Line No." := SalesBillingLine."Line No.";
                    BillingLedger."Amount (LCY)" := -SalesBillingLine."Amount (LCY)";
                    BillingLedger.Insert;
                end else
                    Error(Text001, CustLedgEntry."Document Type", CustLedgEntry."Document No.", SalesBillingLine."Document No.");
            until CustLedgEntry.Next = 0;
            */
    end;

    procedure SetProperties(pDocumentType: Option; pDocumentNo: Code[20])
    begin
        DocumentType := pDocumentType;
        DocumentNo := pDocumentNo;
    end;

    procedure LastLineNo(): Integer
    var
        SalesBillingLine: Record "Sales Billing Line";
    begin
        SalesBillingLine.Reset;
        SalesBillingLine.SetCurrentkey("Document Type", "Document No.", "Line No.");
        SalesBillingLine.SetRange("Document Type", DocumentType);
        SalesBillingLine.SetRange("Document No.", DocumentNo);
        if SalesBillingLine.Find('+') then
            exit(SalesBillingLine."Line No." + 10000);

        exit(10000);
    end;

    procedure LastEntryNo(): Integer
    var
        BillingLedger: Record "Billing Ledger Entries";
    begin
        BillingLedger.Reset;
        BillingLedger.SetCurrentkey("Entry No.");
        if BillingLedger.Find('+') then
            exit(BillingLedger."Entry No." + 1);

        exit(1);
    end;

    procedure SalesGetComment(DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Billing,Receipt,Shipment,"Return Receipt","Posted Invoice","Posted Credit Memo"; DocumentNo: Code[20]; var Text: array[100] of Text[80])
    var
        SalesCommentLine: Record "Sales Comment Line";
        LineNo: Integer;
    begin
        Clear(Text);
        LineNo := 1;
        case DocumentType of
            Documenttype::Billing:
                begin
                    SalesCommentLine.Reset;
                    SalesCommentLine.SetCurrentkey("Document Type", "No.", "Document Line No.", "Line No.");
                    SalesCommentLine.SetRange("Document Type", SalesCommentLine."Document Type");
                    SalesCommentLine.SetRange("No.", DocumentNo);
                    SalesCommentLine.SetRange("Document Line No.", 0);
                    if SalesCommentLine.Find('-') then
                        repeat
                            Text[LineNo] := SalesCommentLine.Comment;
                            LineNo += 1;
                        until SalesCommentLine.Next = 0;
                end;
        end;
    end;

    procedure NumberThaiText(TDecimal: Decimal) TText: Text[1024]
    var
        THigh: Decimal;
        TLow: Decimal;
    begin
        TDecimal := ROUND(TDecimal, 0.01);
        TLow := (TDecimal - ROUND(TDecimal, 1, '<')) * 100;
        if TLow < 1 then
            TLow := 0;
        THigh := ROUND(TDecimal, 1, '<');
        if THigh <> 0 then TText := ThaiInteger(THigh) + 'บาท';
        if TLow <> 0 then TText := TText + ThaiInteger(TLow) + 'สตางค์' else if THigh <> 0 then TText := TText + 'ถ้วน';
    end;

    procedure NumberEngText(TDecimal: Decimal) TText: Text[1024]
    var
        THigh: Decimal;
        TLow: Decimal;
        TText1: array[2] of Text[1024];
    begin
        TDecimal := ROUND(TDecimal, 0.01);
        InitTextVariable;
        EngInterger(TText1, TDecimal, '');
        TLow := (TDecimal - ROUND(TDecimal, 1, '<')) * 100;
        if TLow < 1 then
            TLow := 0;
        TText := StrSubstNo('%1 %2', TText1[1], TText1[2]);
    end;

    procedure EngInterger(var NoText: array[2] of Text[80]; No: Decimal; CurrencyCode: Code[10])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
        Text027: label 'HUNDRED';
        Text026: label 'ZERO';
        Text028: label 'AND';
    begin
        Clear(NoText);
        NoTextIndex := 1;
        NoText[1] := '';

        if No < 1 then
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text026)
        else begin
            for Exponent := 4 downto 1 do begin
                PrintExponent := false;
                Ones := No DIV Power(1000, Exponent - 1);
                Hundreds := Ones DIV 100;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;
                if Hundreds > 0 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text027);
                end;
                if Tens >= 2 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    if Ones > 0 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                end else
                    if (Tens * 10 + Ones) > 0 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                if PrintExponent and (Exponent > 1) then
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                No := No - (Hundreds * 100 + Tens * 10 + Ones) * Power(1000, Exponent - 1);
            end;
        end;

        if CurrencyCode = '' then begin
            if No = 0 then begin
                //AddToNoText(NoText,NoTextIndex,PrintExponent,'BAHT');
                AddToNoText(NoText, NoTextIndex, PrintExponent, '');

                // AddToNoText(NoText,NoTextIndex,PrintExponent,'ONLY ')   George 120914
            end
            else begin
                //AddToNoText(NoText,NoTextIndex,PrintExponent,'BAHT');
                AddToNoText(NoText, NoTextIndex, PrintExponent, '');

                AddToNoText(NoText, NoTextIndex, PrintExponent, Text028);
                AddToNoText(NoText, NoTextIndex, PrintExponent, '');
                Ones := No * 100;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;
                AddToNoText(NoText, NoTextIndex, PrintExponent, Format(No * 100) + '/100');
            end;
        end else begin
            if No = 0 then begin
                //AddToNoText(NoText,NoTextIndex,PrintExponent,'ONLY '); //Gerge 120914
                AddToNoText(NoText, NoTextIndex, PrintExponent, ''); //Gerge 120914
            end else begin
                AddToNoText(NoText, NoTextIndex, PrintExponent, Text028);
                AddToNoText(NoText, NoTextIndex, PrintExponent, Format(No * 100) + '/100');
            end;

        end
    end;

    procedure EngIntergerText(var NoText: array[2] of Text[80]; No: Decimal; CurrencyCode: Code[10])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
        Text027: label 'HUNDRED';
        Text026: label 'ZERO';
        Text028: label 'AND';
    begin
        Clear(NoText);
        NoTextIndex := 1;
        NoText[1] := '';

        if No < 1 then
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text026)
        else begin
            for Exponent := 4 downto 1 do begin
                PrintExponent := false;
                Ones := No DIV Power(1000, Exponent - 1);
                Hundreds := Ones DIV 100;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;
                if Hundreds > 0 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text027);
                end;
                if Tens >= 2 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    if Ones > 0 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                end else
                    if (Tens * 10 + Ones) > 0 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                if PrintExponent and (Exponent > 1) then
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                No := No - (Hundreds * 100 + Tens * 10 + Ones) * Power(1000, Exponent - 1);
            end;
        end;

        if No = 0 then begin
            AddToNoText(NoText, NoTextIndex, PrintExponent, CurrencyText(CurrencyCode, 1));
        end else begin
            No := No * 100;
            AddToNoText(NoText, NoTextIndex, PrintExponent, CurrencyText(CurrencyCode, 2));
            if (No > 10) and (No < 20) then begin
                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[No]);
                AddToNoText(NoText, NoTextIndex, PrintExponent, CurrencyText(CurrencyCode, 3));
            end else begin
                Tens := No DIV 10;
                Ones := No MOD 10;
                if Tens <> 0 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    if Ones <> 0 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, CurrencyText(CurrencyCode, 3));
                end else begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, CurrencyText(CurrencyCode, 3));
                end;
            end;
        end;
    end;

    procedure NumberEngTextCurrency(TDecimal: Decimal; Currency: Code[10]) TText: Text[1024]
    var
        THigh: Decimal;
        TLow: Decimal;
        TText1: array[2] of Text[1024];
    begin
        TDecimal := ROUND(TDecimal, 0.01);
        InitTextVariable;
        EngInterger(TText1, TDecimal, Currency);
        TLow := (TDecimal - ROUND(TDecimal, 1, '<')) * 100;
        if TLow < 1 then
            TLow := 0;
        TText := StrSubstNo('%1 %2', TText1[1], TText1[2]);
    end;

    procedure AmountText(xAmount: Decimal; BlankZero: Boolean; NegBlanket: Boolean): Text[30]
    var
        Text: Text[30];
        Negative: Boolean;
    begin
        Negative := xAmount < 0;
        xAmount := ROUND(Abs(xAmount), 0.01);
        Text := Format(xAmount, 0);
        if StrPos(Text, '.') = 0 then
            Text := Text + '.00'
        else begin
            if StrLen(CopyStr(Text, StrPos(Text, '.') + 1, 2)) < 2 then
                Text += '0';
        end;
        if BlankZero and (xAmount = 0) then
            Text := ''
        else begin
            if Negative then begin
                if NegBlanket then
                    Text := StrSubstNo('(%1)', Text)
                else
                    Text := StrSubstNo('-%1', Text);
            end else
                Text += StrSubstNo(' ', Text);
        end;
        exit(Text);
    end;

    procedure ThaiInteger(Number: Decimal) ThaiInt: Text[1024]
    var
        TNumber: Text[250];
        TTemp: Text[250];
        TPosition: Integer;
        I: Integer;
        NTemp: Text[250];
        PTemp: Text[250];
        ThaiTemp: Text[250];
        II: Integer;
    begin
        if Number <> 0 then begin
            ThaiInt := Format(Number, 0, 0);
            I := 0;
            repeat
                I := I + 1;
                if CopyStr(ThaiInt, I, 1) in ['0' .. '9'] then
                    TNumber := TNumber + CopyStr(ThaiInt, I, 1)
            until (StrLen(ThaiInt) <= I) or (CopyStr(ThaiInt, I, 1) = '.');

            ThaiInt := '';
            I := 0;
            repeat
                I := I + 1;
                TTemp := CopyStr(TNumber, StrLen(TNumber) - I + 1, 1);
                TPosition := I;
                PTemp := '';
                II := 0;
                if TPosition >= 7 then
                    repeat
                        if TPosition >= 7 then begin
                            TPosition := TPosition - 6;
                            II := 1;
                        end;
                    until TPosition < 7;

                case TTemp of
                    '1':
                        begin
                            case TPosition of
                                2:
                                    NTemp := '';
                                1:
                                    begin
                                        if I = 1 then
                                            if StrLen(TNumber) = 1 then
                                                NTemp := 'หนึ่ง'
                                            else
                                                NTemp := 'เอ็ด'
                                        else
                                            if StrLen(TNumber) = I then
                                                NTemp := 'หนึ่ง'
                                            else
                                                NTemp := 'เอ็ด'
                                    end;
                                else begin
                                    NTemp := 'หนึ่ง'
                                end;
                            end
                        end;
                    '2':
                        begin
                            case TPosition of
                                2:
                                    NTemp := 'ยี่';
                                else
                                    NTemp := 'สอง'
                            end
                        end;
                    '3':
                        NTemp := 'สาม';
                    '4':
                        NTemp := 'สี่';
                    '5':
                        NTemp := 'ห้า';
                    '6':
                        NTemp := 'หก';
                    '7':
                        NTemp := 'เจ็ด';
                    '8':
                        NTemp := 'แปด';
                    '9':
                        NTemp := 'เก้า';
                    '0':
                        NTemp := '';
                end;
                if TTemp <> '0' then
                    case TPosition of
                        2:
                            PTemp := 'สิบ';
                        3:
                            PTemp := 'ร้อย';
                        4:
                            PTemp := 'พัน';
                        5:
                            PTemp := 'หมื่น';
                        6:
                            PTemp := 'แสน';
                        1:
                            PTemp := 'ล้าน';
                    end;

                if I = 1 then
                    PTemp := ''
                else
                    if TPosition = 1 then
                        PTemp := 'ล้าน';
                ThaiTemp := NTemp + PTemp + ThaiTemp;
            until StrLen(TNumber) <= I;
            ThaiInt := ThaiTemp;
        end;
    end;

    procedure InitTextVariable()
    var
        Text032: label 'ONE';
        Text033: label 'TWO';
        Text034: label 'THREE';
        Text035: label 'FOUR';
        Text036: label 'FIVE';
        Text037: label 'SIX';
        Text038: label 'SEVEN';
        Text039: label 'EIGHT';
        Text040: label 'NINE';
        Text041: label 'TEN';
        Text042: label 'ELEVEN';
        Text043: label 'TWELVE';
        Text044: label 'THIRTEEN';
        Text045: label 'FOURTEEN';
        Text046: label 'FIFTEEN';
        Text047: label 'SIXTEEN';
        Text048: label 'SEVENTEEN';
        Text049: label 'EIGHTEEN';
        Text050: label 'NINETEEN';
        Text051: label 'TWENTY';
        Text052: label 'THIRTY';
        Text053: label 'FORTY';
        Text054: label 'FIFTY';
        Text055: label 'SIXTY';
        Text056: label 'SEVENTY';
        Text057: label 'EIGHTY';
        Text058: label 'NINETY';
        Text059: label 'THOUSAND';
        Text060: label 'MILLION';
        Text061: label 'BILLION';
        Text062: label 'G/L Account,Customer,Vendor,Bank Account';
        Text063: label 'Net Amount %1';
        Text064: label '%1 must not be %2 for %3 %4.';
        Text126: label 'SOON';
        Text127: label 'ROI';
        Text128: label '&';
        Text129: label '%1 results in a written number that is too long.';
        Text130: label ' is already applied to %1 %2 for customer %3.';
        Text131: label ' is already applied to %1 %2 for vendor %3.';
        Text132: label 'NUENG';
        Text133: label 'SAWNG';
        Text134: label 'SARM';
        Text135: label 'SI';
        Text136: label 'HA';
        Text137: label 'HOK';
        Text138: label 'CHED';
        Text139: label 'PAED';
        Text140: label 'KOW';
        Text141: label 'SIB';
        Text142: label 'SIB-ED';
        Text143: label 'SIB-SAWNG';
        Text144: label 'SIB-SARM';
        Text145: label 'SIB-SI';
        Text146: label 'SIB-HA';
        Text147: label 'SIB-HOK';
        Text148: label 'SIB-CHED';
        Text149: label 'SIB-PAED';
        Text150: label 'SIB-KOW';
        Text151: label 'YI-SIB';
        Text152: label 'SARM-SIB';
        Text153: label 'SI-SIB';
        Text154: label 'HA-SIB';
        Text155: label 'HOK-SIB';
        Text156: label 'CHED-SIB';
        Text157: label 'PAED-SIB';
        Text158: label 'KOW-SIB';
        Text159: label 'PHAN';
        Text160: label 'LAAN?';
        Text161: label 'PHAN-LAAN?';
    begin
        OnesText[1] := Text032;
        OnesText[2] := Text033;
        OnesText[3] := Text034;
        OnesText[4] := Text035;
        OnesText[5] := Text036;
        OnesText[6] := Text037;
        OnesText[7] := Text038;
        OnesText[8] := Text039;
        OnesText[9] := Text040;
        OnesText[10] := Text041;
        OnesText[11] := Text042;
        OnesText[12] := Text043;
        OnesText[13] := Text044;
        OnesText[14] := Text045;
        OnesText[15] := Text046;
        OnesText[16] := Text047;
        OnesText[17] := Text048;
        OnesText[18] := Text049;
        OnesText[19] := Text050;

        TensText[1] := '';
        TensText[2] := Text051;
        TensText[3] := Text052;
        TensText[4] := Text053;
        TensText[5] := Text054;
        TensText[6] := Text055;
        TensText[7] := Text056;
        TensText[8] := Text057;
        TensText[9] := Text058;

        ExponentText[1] := '';
        ExponentText[2] := Text059;
        ExponentText[3] := Text060;
        ExponentText[4] := Text061;
    end;

    procedure AddToNoText(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30])
    var
        Text029: label '%1 results in a written number that is too long.';
    begin
        PrintExponent := true;

        while StrLen(NoText[NoTextIndex] + ' ' + AddText) > MaxStrLen(NoText[1]) do begin
            NoTextIndex := NoTextIndex + 1;
            if NoTextIndex > ArrayLen(NoText) then
                Error(Text029, AddText);
        end;

        NoText[NoTextIndex] := DelChr(NoText[NoTextIndex] + ' ' + AddText, '<');
    end;

    procedure CurrencyText(Currency: Code[10]; Type: Integer): Text[50]
    begin
        if Type = 1 then begin
            if (Currency = 'THB') or (Currency = '') then
                exit('BAHT ONLY.')
            else
                exit('ONLY.');
        end else
            if Type = 2 then begin
                if (Currency = 'THB') or (Currency = '') then
                    exit('AND')
                else
                    exit('AND');
            end else
                if Type = 3 then begin
                    if (Currency = 'THB') or (Currency = '') then
                        exit('')
                    else
                        exit('');
                end;
    end;

    procedure ConvertToBaseUOM(p_cItemNo: Code[20]; p_cUOM: Code[20]; p_xQty: Decimal) xQty: Decimal
    var
        tblItemUOM: Record "Item Unit of Measure";
        xBaseQty: Decimal;
    begin
        //-------+----------------------------------------------------------------
        //  convert quantity to base unit of measure.
        //-------+----------------------------------------------------------------

        //-- get quantity of base unit of measure
        xQty := p_xQty;
        if tblItemUOM.Get(p_cItemNo, p_cUOM) then
            xBaseQty := tblItemUOM."Qty. per Unit of Measure";

        //-- convert to base unit of measure
        xQty := p_xQty * xBaseQty
    end;
}


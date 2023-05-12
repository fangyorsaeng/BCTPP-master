report 50014 "Sales Quote Template 1"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.src/ReportLaout/SalesQuoteT1.rdlc';
    PreviewMode = Normal;
    dataset
    {
        dataitem(SalesH; "Sales Header")
        {
            RequestFilterFields = "No.";
            DataItemTableView = where("Document Type" = filter(Quote));
            column(No_; "No.") { }
            column(Document_Date; "Document Date") { }
            column(Sell_to_Customer_No_; "Sell-to Customer No.") { }
            column(Sell_to_Customer_Name; "Sell-to Customer Name") { }
            column(Sell_to_Contact; "Sell-to Contact") { }
            column(Sell_to_Address; "Sell-to Address") { }
            column(Sell_to_Address_2; "Sell-to Address 2") { }
            column(Address_3; "Address 3") { }
            column(RE__Quotation_for; "RE: Quotation for") { }
            column(Remark_HD; "Remark HD") { }
            column(Drawing_and_Material; "Drawing and Material") { }
            column(YenBath; SalesSetup."Yen/Baht") { }
            column(SearchName; CustomerS."Search Name") { }
            column(CRRNCY_Initial_Die_Cost; "CRRNCY Initial Die Cost") { }
            column(CRRNCY_Price_Piece; "CRRNCY Price/Piece") { }
            column(Condition_1; "Condition 1") { }
            column(Condition_2; "Condition 2") { }
            column(Condition_3; "Condition 3") { }
            column(Condition_4; "Condition 4") { }
            column(Condition_5; "Condition 5") { }
            column(Condition_6; "Condition 6") { }
            column(Condition_7; "Condition 7") { }
            column(Condition_8; "Condition 8") { }
            column(Condition_9; "Condition 9") { }
            column(Condition_10; "Condition 10") { }
            column(AnnualText1; AnnualText[1]) { }
            column(AnnualText2; AnnualText[2]) { }
            column(AnnualText3; AnnualText[3]) { }
            column(AnnualText4; AnnualText[4]) { }
            column(Annualamount1; Annualamount[1]) { }
            column(Annualamount2; Annualamount[2]) { }
            column(Annualamount3; Annualamount[3]) { }
            column(Annualamount4; Annualamount[4]) { }
            column(PcsUnit1; PcsUnit[1]) { }
            column(PcsUnit2; PcsUnit[2]) { }
            column(PcsUnit3; PcsUnit[3]) { }
            column(PcsUnit4; PcsUnit[4]) { }
            column(rowTimming1; rowTimming[1]) { }
            column(rowTimming2; rowTimming[2]) { }
            column(rowTimming3; rowTimming[3]) { }
            column(rowTimming4; rowTimming[4]) { }
            column(ShowShipTo; ShowShipTo) { }
            column(ShipName; SalesH."Ship-to Name") { }
            column(ShipAddress; SalesH."Ship-to Address") { }
            column(ShipAddress2; SalesH."Ship-to Address 2") { }
            column(Template; Format(Template)) { }

            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                DataItemLinkReference = SalesH;
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");
                column(ItemNo; "No.") { }
                column(PartName; Description) { }
                column(Model; "Description 2") { }
                column(Quantity; Quantity) { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(Unit_Price; "Unit Price") { }
                column(UsageT; "Annual Usage Text") { }
                column(UsageA; "Annual Usage Amount") { }
            }


            trigger OnAfterGetRecord()
            begin
                SalesSetup.Get();
                // if "Ship-to Code" //
                CustomerS.Reset();
                if "Ship-to Code" <> '' then
                    CustomerS.SetRange("No.", "Ship-to Code")
                else
                    CustomerS.SetRange("No.", "Sell-to Customer No.");
                if CustomerS.Find('-') then;
                SalesLineUsage.Reset();
                SalesLineUsage.SetRange("Document No.", SalesH."No.");
                if SalesLineUsage.Find('-') then begin
                    repeat
                        case SalesLineUsage."Line No." of
                            1:
                                begin
                                    AnnualText[1] := SalesLineUsage."Annual Text";
                                    Annualamount[1] := SalesLineUsage."Annual Usage";
                                    PcsUnit[1] := SalesLineUsage.PricePerPcs;
                                    rowTimming[1] := SalesLineUsage."Raw Material Timing";
                                end;
                            2:
                                begin
                                    AnnualText[2] := SalesLineUsage."Annual Text";
                                    Annualamount[2] := SalesLineUsage."Annual Usage";
                                    PcsUnit[2] := SalesLineUsage.PricePerPcs;
                                    rowTimming[2] := SalesLineUsage."Raw Material Timing";
                                end;
                            3:
                                begin
                                    AnnualText[3] := SalesLineUsage."Annual Text";
                                    Annualamount[3] := SalesLineUsage."Annual Usage";
                                    PcsUnit[3] := SalesLineUsage.PricePerPcs;
                                    rowTimming[3] := SalesLineUsage."Raw Material Timing";
                                end;
                            4:
                                begin
                                    AnnualText[4] := SalesLineUsage."Annual Text";
                                    Annualamount[4] := SalesLineUsage."Annual Usage";
                                    PcsUnit[4] := SalesLineUsage.PricePerPcs;
                                    rowTimming[4] := SalesLineUsage."Raw Material Timing";
                                end;

                        end;
                    until SalesLineUsage.Next = 0;
                end;
            end;


        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Option)
                {
                    field(ShowShipTo; ShowShipTo)
                    {
                        ApplicationArea = all;
                    }
                    field(Template; Template)
                    {
                        Caption = 'Template';
                        ApplicationArea = all;
                    }
                }
            }
        }
    }
    var
        SalesLineUsage: Record "Sales Line Annual Usage";
        utility: Codeunit Utility;
        SalesSetup: Record "Sales & Receivables Setup";
        CustomerS: Record Customer;
        AnnualText: array[4] of Text[100];
        Annualamount: array[4] of Decimal;
        PcsUnit: array[4] of Decimal;
        rowTimming: array[4] of Text[100];
        ShowShipTo: Boolean;
        Template: Option Template1,Template2;
}
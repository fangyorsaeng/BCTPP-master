report 50005 "Temp PO2"
{
    Caption = 'Temporary Delivery Sheet.';
    DefaultLayout = RDLC;
    RDLCLayout = './.src/ReportLaout/TempPO2.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    PreviewMode = Normal;
    dataset
    {
        dataitem(Group1; Integer)
        {
            column(Groupx; Groupx) { }
            column(Number; Number) { }


            dataitem("Temporary DL Req."; "Temporary DL Req.")
            {
                RequestFilterFields = DLNo, "Supplier Code";
                column(No_; TDNo) { }
                column(Supplier_Code; "Supplier Code") { }
                column(Supplier_Name; "Supplier Name") { }
                column(Supplier_Address_1; "Supplier Address 1") { }
                column(Supplier_Address_2; "Supplier Address 2") { }
                column(Contact_Name; "Contact Name") { }
                column(Phone_No_; "Phone No.") { }
                column(Fax_No_; "Fax No.") { }
                column(Email; Email) { }
                column(Delivery_By; "Req By.") { }
                column(Delivery_Date; "Document Date") { }
                column(Ref__PONo_; "Ref. PONo.") { }
                column(Document_Date; "Document Date") { }
                column(Comp_Name; Company.Name) { }
                column(Comp_Add1; Company.Address) { }
                column(Comp_Add2; Company."Address 2") { }
                column(Comp_phone; Company."Phone No.") { }
                column(Comp_FaxNo; Company."Fax No.") { }
                column(Box_1; "Box 1") { }
                column(Box_2; "Box 2") { }
                column(Cover_1; "Cover 1") { }
                column(Cover_2; "Cover 2") { }
                column(Box_1_Color; BoxCol1) { }
                column(Box_2_Color; BoxCol2) { }
                column(Cover_1_Color; CoverCol1) { }
                column(Cover_2_Color; CoverCol2) { }
                column(Plastic_Pallet; "Plastic Pallet") { }
                column(Wood_Pallet; "Wood Pallet") { }
                column(Group; format(Group)) { }
                column(Note; Note) { }
                column(Total; Total) { }
                column(DateShiped; DateShiped) { }
                column(Supplier; Supplier) { }
                column(processA; processA) { }
                column(GroupP; Groupx) { }
                dataitem(Integer; Integer)
                {
                    column(Item_No_; 'SHELF(F)') { }
                    column(Description; Model) { }
                    column(Qty; 0) { }
                    column(Lot_No_; LotAtt) { }
                    column(Box; 0) { }
                    column(Line_No_; 0) { }
                    column(TotalAmount; TotalAmount) { }
                    column(RowS; RowS) { }
                    trigger OnPreDataItem()
                    var
                        TempL: Record "Temporary DL Req. Line";
                    begin
                        SetRange(Number, 1, 1);

                    end;

                    trigger OnAfterGetRecord()
                    var
                        TempL: Record "Temporary DL Req. Line";
                    begin
                        RowS += 1;
                        TempL.Reset();
                        TempL.SetRange("Document No.", "Temporary DL Req.".DLNo);
                        if TempL.Find('-') then begin
                            repeat
                                TotalAmount += TempL.Quantity;
                            until TempL.Next = 0;
                        end;
                    end;
                }
                trigger OnPreDataItem()
                begin
                    TotalAmount := 0;
                    RowS := 0;
                end;

                trigger OnAfterGetRecord()
                begin
                    if Group = 'PD2_W2' then begin
                        BoxCol1 := 'Green';
                        BoxCol2 := 'White';
                        CoverCol1 := 'Green';
                        CoverCol2 := 'White';

                    end
                    else
                        if Group = 'PD2_W1' then begin
                            BoxCol1 := 'Orange';
                            BoxCol2 := 'Gray';
                            CoverCol1 := 'Blue';
                            CoverCol2 := 'Green';
                        end;
                    CountList := 0;
                    ItemS.Reset();
                    TempDL.Reset();
                    TempDL.SetRange("Document No.", "Temporary DL Req.".DLNo);
                    TempDL.SetFilter("Part No.", '<>%1', '');
                    if TempDL.Find('-') then begin
                        ItemS.Get(TempDL."Part No.");
                        if ItemS.Find('-') then begin
                            Model := ItemS."Description 2";
                            PartName := ItemS."No.";
                        end;
                        repeat
                            CountList += 1;
                        until TempDL.Next = 0;
                    end;
                    if CountList = 0 then
                        CountList := 1;
                    LotAtt := 'Refer attached file. No.1-' + Format(CountList);
                    processA := '';
                    if Group = 'PD2_W1' then begin
                        Model := 'UA-AS3001-002' + gCRLF + 'UA-AS3001-001';
                        processA := Process;
                    end;
                    if Group = 'PD2_W2' then begin
                        Model := 'UA-AS3001-002' + gCRLF + 'UA-AS3001-001';
                        processA := Process;
                    end;

                end;
            }
            trigger OnPreDataItem()
            begin
                SetRange(Number, 1, 2);
            end;

            trigger OnAfterGetRecord()
            begin
                Groupx := '';
                // if GroupP = GroupP::Original then
                //     Groupx := 'Original';
                // if GroupP = GroupP::Copy then
                //     Groupx := 'Copy';
                if Number = 1 then
                    Groupx := 'Original'
                else
                    if Number = 2 then
                        Groupx := 'Copy';


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
                    field(GroupP; GroupP)
                    {
                        ApplicationArea = all;
                    }
                }
            }
        }
    }
    trigger OnPreReport()
    begin
        Company.get();
        gCRLF[1] := 10;
        gCRLF[2] := 13;
    end;

    var
        Company: Record "Company Information";
        TotalAmount: Decimal;
        RowS: Integer;
        BoxCol1: Text;
        BoxCol2: Text;
        CoverCol1: Text;
        CoverCol2: Text;
        LotAtt: Text[200];
        Model: Text[200];
        gCRLF: text;
        PartName: Text[200];
        ItemS: Record Item;
        TempDL: Record "Temporary DL Req. Line";
        CountList: Integer;
        processA: Text[200];
        Groupx: Text[100];
        GroupP: Option ,Original,Copy;
}
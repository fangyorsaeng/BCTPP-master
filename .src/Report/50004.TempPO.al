report 50004 "Temp PO"
{
    Caption = 'Temporary Delivery Sheet.';
    DefaultLayout = RDLC;
    RDLCLayout = './.src/ReportLaout/TempPO.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    PreviewMode = Normal;
    dataset
    {
        dataitem(Integer; Integer)
        {
            column(Number; Number) { }
            column(GroupTx; GroupTx) { }
            dataitem("Temporary DL Req."; "Temporary DL Req.")
            {
                RequestFilterFields = TDNo, "Supplier Code";
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
                column(CountA; CountA) { }

                dataitem("Temporary DL Req. Line"; "Temporary DL Req. Line")
                {
                    DataItemLink = "Document No." = FIELD(DLNo);
                    column(Item_No_; "Part No.") { }
                    column(Description; "Part Name") { }
                    column(Qty; Quantity) { }
                    column(Lot_No_; "Lot No.") { }
                    column(Box; Box) { }
                    column(Line_No_; "Line No.") { }
                    column(TotalAmount; TotalAmount) { }
                    column(RowS; RowS) { }
                    trigger OnAfterGetRecord()
                    begin
                        TotalAmount += Quantity;
                        RowS += 1;
                    end;
                }
                trigger OnPreDataItem()
                begin
                    TotalAmount := 0;
                    RowS := 0;
                end;

                trigger OnAfterGetRecord()
                begin
                    CountA := 0;
                    TempDL.Reset();
                    TempDL.SetRange("Document No.", "Temporary DL Req.".DLNo);
                    if TempDL.Find('-') then begin
                        repeat
                            CountA += 1;
                        until TempDL.Next = 0;
                    end;
                end;


            }
            trigger OnPreDataItem()
            begin
                SetRange(Number, 1, 2);
            end;

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then
                    GroupTx := 'Original';
                if Number = 2 then
                    GroupTx := 'Copy';
            end;
        }
        ///Group
    }
    trigger OnPreReport()
    begin
        Company.get();
    end;

    var
        Company: Record "Company Information";
        TotalAmount: Decimal;
        RowS: Integer;
        GroupTx: Text[20];
        CountA: Integer;
        TempDL: Record "Temporary DL Req. Line";
}
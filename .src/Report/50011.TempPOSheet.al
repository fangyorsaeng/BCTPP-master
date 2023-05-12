report 50011 "Temp. PO Sheet"
{
    Caption = 'Temporary PO Sheet.';
    DefaultLayout = RDLC;
    RDLCLayout = './.src/ReportLaout/TempPOSheet.rdlc';
    // UsageCategory = ReportsAndAnalysis;
    //  ApplicationArea = all;
    PreviewMode = Normal;
    dataset
    {
        dataitem("Temporary DL Req."; "Temporary DL Req.")
        {
            RequestFilterFields = DLNo, "Supplier Code";
            column(DLNo; DLNo) { }
            column(Document_Date; "Document Date") { }
            column(Req_By_; "Req By.") { }
            column(Box_1; "Box 1") { }
            column(Box_2; "Box 2") { }
            column(Cover_1; "Cover 1") { }
            column(Cover_2; "Cover 2") { }
            column(Box_1_Color; BoxCol1) { }
            column(Box_2_Color; BoxCol2) { }
            column(Cover_1_Color; CoverCol1) { }
            column(Cover_2_Color; CoverCol2) { }
            column(Palletx; Palletx) { }
            column(Plastic_Pallet; "Plastic Pallet") { }
            column(Wood_Pallet; "Wood Pallet") { }
            column(Group; format(Group)) { }
            column(Note; Note) { }
            column(Total; Total) { }
            column(GroupP; Groupx) { }
            column(PalletQ; PalletQ) { }
            trigger OnAfterGetRecord()
            begin
                if Group = 'PD2_W2' then begin
                    BoxCol1 := 'กล่องสีเขียว  = ';//'Green';
                    BoxCol2 := 'กล่องเปล่า สีขาว = ';//'White';
                    CoverCol1 := 'ฝาสีเขียว = ';//'Green';
                    CoverCol2 := 'ฝาสีขาว = ';//'White';
                    Groupx := 'W2';

                end
                else
                    if Group = 'PD2_W1' then begin
                        BoxCol1 := 'กล่องสีส้ม  = ';//'Green';
                        BoxCol2 := 'กล่องเปล่า เทา = ';//'White';
                        CoverCol1 := 'ฝาสีน้ำเงิน = ';//'Green';
                        CoverCol2 := 'ฝาสีเขียว = ';//'White';
                        Groupx := 'W1';
                        // BoxCol1 := 'Orange = ';
                        // BoxCol2 := 'Gray = ';
                        // CoverCol1 := 'Blue = ';
                        // CoverCol2 := 'Green';
                    end;
                Palletx := '';
                if "Plastic Pallet" > 0 then begin
                    Palletx := 'พาเลทพลาสติก';
                    PalletQ := "Plastic Pallet";
                end;

                if "Wood Pallet" > 0 then begin
                    Palletx := 'พาเลทไม้';
                    PalletQ := "Wood Pallet";
                end;
            end;

            trigger OnPreDataItem()
            begin


            end;
        }
    }
    var
        Total1: Decimal;
        Groupx: Text[10];
        BoxCol1: Text;
        BoxCol2: Text;
        CoverCol1: Text;
        CoverCol2: Text;
        Palletx: Text[30];
        PalletQ: Integer;
}
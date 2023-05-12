report 50024 "Import Excel SalesOrder"
{
    Caption = 'Import Excel for Sales Order';
    ProcessingOnly = true;
    dataset
    {

    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(option)
                {
                    field(PDSelect; PDSelect)
                    {
                        ApplicationArea = all;
                        Visible = false;
                    }
                }
            }
        }
        trigger OnQueryClosePage(CloseAction: Action): Boolean
        begin
            // if PDSelect<>'' then

            IF CloseAction = ACTION::OK THEN BEGIN
                ServerFileName := FileMgt.UploadFile(Text006, ExcelExtensionTok);
                IF ServerFileName = '' THEN
                    EXIT(FALSE);
                //SheetName:='sheet1';

                SheetName := ExcelBuf.SelectSheetsName(ServerFileName);
                IF SheetName = '' THEN
                    EXIT(FALSE);

            END;
        end;

    }
    var
        utility: Codeunit Utility;
        ExcelBuf: Record "Excel Buffer";
        ServerFileName: Text;
        SheetName: Text;
        TotalRows: Integer;
        CountRows: Integer;
        TotalColumns: Integer;
        FileMgt: Codeunit "File Management";
        X: Integer;
        TRow: Integer;
        Text006: Label 'Import Excel File';
        ExcelExtensionTok: Label '.xlsx';
        Scanner: Record Scanner;
        PDSelect: Option PD1,PD2,PD3,PD4,PD5,SGA,OTH;
        SDocNo: Code[20];

    trigger OnPreReport()
    begin
        ExcelBuf.DELETEALL;
        ExcelBuf.LOCKTABLE;
        ExcelBuf.OpenBook(ServerFileName, SheetName);
        ExcelBuf.ReadSheet;
        GetLastRowandColumn;
        //TotalRows
        TRow := 0;
        // TSaleOrder.RESET;
        // IF TSaleOrder.FINDLAST THEN BEGIN
        //      TRow := TSaleOrder.EntryNo; END;
        Scanner.Reset();
        Scanner.SetRange(SUserID, UserId);
        if Scanner.Find('-') then
            Scanner.DeleteAll();
        //Message(format(TotalRows));
        FOR X := 1 TO TotalRows DO
            InsertData(X);

        ExcelBuf.DELETEALL;
        UpdateToSalesOrder();

        // exit;
        Scanner.Reset();
        Scanner.SetRange(SUserID, UserId);
        if Scanner.Find('-') then
            Scanner.DeleteAll();
    end;

    procedure setDoc(xDoc: Code[20])
    begin
        SDocNo := xDoc;
    end;

    procedure InsertData(RowNo: Integer)
    var
        Qty: Integer;
        run: Integer;
        Rows: Integer;
        ItemS: Record Item;
        SaleScan: Record Scanner;
        PartNo: Code[30];
        UnitPrice: Decimal;
        PDate: Date;
    begin
        PartNo := format(GetValueAtCell(RowNo, 1));
        if RowNo = 1 then exit;
        if PartNo = '' then exit;
        if SDocNo = '' then exit;

        ItemS.Reset();
        ItemS.SetRange("No.", PartNo);
        if ItemS.Find('-') then begin



            Qty := 1;
            run := 1;
            UnitPrice := 0;

            if Evaluate(Qty, Format(GetValueAtCell(RowNo, 2))) then;
            // Evaluate(Qty, Format(GetValueAtCell(RowNo, 12)));            
            if Evaluate(UnitPrice, Format(GetValueAtCell(RowNo, 4))) then;
            //   Evaluate(UnitPrice, Format(GetValueAtCell(RowNo, 17)));
            if Evaluate(PDate, GetValueAtCell(RowNo, 3)) then;

            SaleScan.Reset();
            SaleScan.Init();
            SaleScan.EntryNo := RowNo;
            SaleScan.Validate("Part No.", PartNo);
            SaleScan.Quantity := Qty;
            SaleScan.Price := UnitPrice;
            SaleScan.Unit := Format(GetValueAtCell(RowNo, 5));
            SaleScan.SDate := PDate;
            SaleScan.SUserID := UserId;
            SaleScan.SType := 'ORDER';
            SaleScan.RefNo := SDocNo;
            SaleScan.Insert();
        end;
    end;

    procedure UpdateToSalesOrder()
    var
        LineNo: Integer;
        SalesH: Record "Sales Header";
        SalesL: Record "Sales Line";
    begin
        LineNo := 0;
        if SDocNo = '' then exit;
        SalesH.Reset();
        SalesH.SetRange("No.", SDocNo);
        SalesH.SetRange("Document Type", SalesH."Document Type"::Order);
        SalesH.SetRange(Status, SalesH.Status::Open);
        if SalesH.Find('-') then begin

            SalesL.Reset();
            SalesL.SetCurrentKey("Document No.", "Line No.");
            SalesL.SetRange("Document No.", SalesH."No.");
            if SalesL.FindLast() then
                LineNo := SalesL."Line No.";

            Scanner.Reset();
            Scanner.SetRange(SUserID, UserId);
            Scanner.SetRange(RefNo, SDocNo);
            Scanner.SetRange(SType, 'ORDER');
            if Scanner.Find('-') then begin
                repeat
                    LineNo := LineNo + 10000;
                    SalesL.Reset();
                    SalesL.Init();
                    SalesL."Document No." := SDocNo;
                    SalesL."Document Type" := SalesL."Document Type"::Order;
                    SalesL."Line No." := LineNo;
                    SalesL.Type := SalesL.Type::Item;
                    SalesL.Validate("No.", Scanner."Part No.");
                    SalesL.Validate(Quantity, Scanner.Quantity);
                    SalesL.Validate("Planned Delivery Date", Scanner.SDate);
                    if Scanner.Unit <> '' then
                        SalesL.Validate("Unit of Measure Code", Scanner.Unit);
                    if Scanner.Price > 0 then
                        SalesL.Validate("Unit Price", Scanner.Price);
                    SalesL.Insert();
                until Scanner.Next = 0;
            end;
        end;


    end;

    procedure GetLastRowandColumn()
    begin
        ExcelBuf.SETRANGE("Row No.", 1);
        TotalColumns := ExcelBuf.COUNT;

        ExcelBuf.RESET;
        IF ExcelBuf.FINDLAST THEN
            TotalRows := ExcelBuf."Row No.";
    end;

    procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    var
        ExcelBuf1: Record "Excel Buffer";
    begin
        IF ExcelBuf1.GET(RowNo, ColNo) THEN BEGIN
            EXIT(ExcelBuf1."Cell Value as Text");
        END ELSE BEGIN
            //EVALUATE(ExcelBuf1,"Cell Value as Text");
        END;
    end;


}
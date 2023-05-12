report 50025 "Import Excel Forecasts"
{
    Caption = 'Import Excel Forecasts';
    ProcessingOnly = true;
    Permissions = tabledata "Production Forecast Entry" = ridm;
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
        SDocNo: Code[50];

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

    procedure setDoc(xDoc: Code[50])
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
            //   if Evaluate(UnitPrice, Format(GetValueAtCell(RowNo, 4))) then;
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
            SaleScan.SType := 'FORECAST';
            SaleScan.RefNo := SDocNo;
            SaleScan.Insert();
        end;
    end;

    procedure UpdateToSalesOrder()
    var
        LineNo: Integer;
        ProForeL: Record "Production Forecast Entry";
        ProForeLDelete: Record "Production Forecast Entry";
    begin
        LineNo := 0;
        if SDocNo = '' then exit;

        ProForeL.Reset();
        if ProForeL.FindLast() then
            LineNo := ProForeL."Entry No.";

        Scanner.Reset();
        Scanner.SetRange(SUserID, UserId);
        Scanner.SetRange(RefNo, SDocNo);
        Scanner.SetRange(SType, 'FORECAST');
        if Scanner.Find('-') then begin
            repeat
                LineNo := LineNo + 1;

                ProForeLDelete.Reset();
                ProForeLDelete.SetRange("Forecast Date", Scanner.SDate);
                ProForeLDelete.SetRange("Item No.", Scanner."Part No.");
                ProForeLDelete.SetRange("Production Forecast Name", SDocNo);
                if ProForeLDelete.Find('-') then
                    ProForeLDelete.Delete();

                ProForeL.Reset();
                ProForeL.Init();
                ProForeL."Entry No." := LineNo;
                ProForeL."Production Forecast Name" := SDocNo;
                ProForeL.Validate("Item No.", Scanner."Part No.");
                ProForeL.Validate("Forecast Quantity", Scanner.Quantity);
                ProForeL."Forecast Quantity (Base)" := Scanner.Quantity;
                ProForeL."Qty. per Unit of Measure" := 1;
                ProForeL.Validate("Forecast Date", Scanner.SDate);
                ProForeL.Insert();
            until Scanner.Next = 0;
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